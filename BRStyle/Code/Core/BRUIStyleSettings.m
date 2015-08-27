//
//  BRUIStyleSettings.m
//  BRStyle
//
//  Created by Matt on 26/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRUIStyleSettings.h"

#import "BRUIStyle.h"
#import <objc/objc-runtime.h>

id dynamicSettingGetterIMP(id self, SEL _cmd);
void dynamicSettingSetterIMP(id self, SEL _cmd, id value);

static NSString * SettingNameForSelector(BOOL mutable, SEL aSEL, BOOL *setter) {
	NSString *settingName = NSStringFromSelector(aSEL);
	BOOL set = NO;
	if ( mutable && [settingName hasPrefix:@"set"] && [settingName hasSuffix:@":"] ) {
		set = YES;
		// turn name like "setFooBar:" into "fooBar"
		settingName = [[[settingName substringWithRange:NSMakeRange(3, 1)] lowercaseString] stringByAppendingString:[settingName substringWithRange:NSMakeRange(4, [settingName length] - 5)]];
	}
	if ( setter ) {
		*setter = set;
	}
	return settingName;
}

@interface BRUIStyleSettings ()
@property (nonatomic, readonly) NSDictionary *settings;
@end

@implementation BRUIStyleSettings {
	NSDictionary *settings;
}

+ (NSDictionary *)defaultSettings {
	return nil;
}

+ (NSArray *)supportedSettingNames {
	return nil;
}

+ (BOOL)mutable {
	return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
	BOOL setter = NO;
	NSString *settingName = SettingNameForSelector([self mutable], aSEL, &setter);
	if ( [[self supportedSettingNames] containsObject:settingName] ) {
		IMP meth = (setter ? (IMP)dynamicSettingSetterIMP : (IMP)dynamicSettingGetterIMP);
		class_addMethod([self class], aSEL, meth,
						(setter ? "v@:@" : "@@:"));
		return YES;
	}
	return [super resolveInstanceMethod:aSEL];
}

- (id)init {
	return [self initWithSettings:[[self class] defaultSettings]];
}

- (id)initWithSettings:(NSDictionary *)theSettings {
	if ( (self = [super init]) ) {
		settings = theSettings;
	}
	return self;
}

- (NSDictionary *)settings {
	return settings;
}

- (NSString *)debugDescription {
	return [settings debugDescription];
}

#pragma mark - Dictionary representation

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionary {
	NSMutableDictionary *decoded = [[[self class] defaultSettings] mutableCopy];
	[[[self class] supportedSettingNames] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *key = obj;
		id value = dictionary[key];
		if ( !value ) {
			return;
		}
		id result = nil;
		BOOL nullValue = [value isKindOfClass:[NSNull class]];
		if ( [key hasSuffix:@"Color"] && nullValue != YES ) {
			// colors assumed to be #rgba format
			unsigned long long colorInteger = 0;
			NSScanner *scanner = [[NSScanner alloc] initWithString:value];
			[scanner scanString:@"#" intoString:NULL];
			[scanner scanHexLongLong:&colorInteger];
			result = [BRUIStyle colorWithRGBAInteger:(UInt32)colorInteger];
		} else if ( [value isKindOfClass:[NSDictionary class]] ) {
			if ( [key hasSuffix:@"Font"] ) {
				result = [UIFont fontWithName:value[@"name"] size:[value[@"size"] floatValue]];
			} else if ( [key hasSuffix:@"ColorSettings"] ) {
				NSMutableDictionary *ccDefaults = [[NSMutableDictionary alloc] initWithCapacity:8];
				BRUIStyleControlColorSettings *ccSettings = decoded[key];
				if ( ccSettings ) {
					[ccDefaults addEntriesFromDictionary:[ccSettings dictionaryRepresentation]];
				}
				[ccDefaults addEntriesFromDictionary:value];
				result = [[BRUIStyleControlColorSettings alloc] initWithDictionaryRepresentation:ccDefaults];
			} else if ( [key hasSuffix:@"ontrolSettings"] ) {
				NSMutableDictionary *csDefaults = [[NSMutableDictionary alloc] initWithCapacity:8];
				BRUIStyleControlStateColorSettings *csSettings = decoded[key];
				if ( csSettings ) {
					[csDefaults addEntriesFromDictionary:[csSettings dictionaryRepresentation]];
				}
				[csDefaults addEntriesFromDictionary:value];
				result = [[BRUIStyleControlStateColorSettings alloc] initWithDictionaryRepresentation:csDefaults];
			}
		}
		if ( result ) {
			decoded[key] = result;
		} else if ( nullValue ) {
			[decoded removeObjectForKey:key];
		}
	}];
	return [self initWithSettings:decoded];
}

- (NSDictionary *)dictionaryRepresentation {
	NSMutableDictionary *encoded = [[NSMutableDictionary alloc] initWithCapacity:16];
	[[[self class] supportedSettingNames] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *key = obj;
		id value = settings[key];
		id result = nil;
		if ( [value isKindOfClass:[UIColor class]] ) {
			char hexStr[20];
			sprintf(hexStr,"#%08lx", (unsigned long)[BRUIStyle rgbaHexIntegerForColor:value]);
			result = [[NSString alloc] initWithUTF8String:hexStr];
		} else if ( [value isKindOfClass:[UIFont class]] ) {
			result = @{ @"name" : [value fontName], @"size" : @([value pointSize])};
		} else if ( [value respondsToSelector:@selector(dictionaryRepresentation)] ) {
			result = [value dictionaryRepresentation];
		}
		encoded[key] = (result ? result : [NSNull null]);
	}];
	return encoded;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
	NSMutableDictionary *decodedSettings = [[NSMutableDictionary alloc] initWithCapacity:16];
	NSSet *allowedSettings = [[NSSet alloc] initWithArray:@[[UIColor class],
															[BRUIStyleControlColorSettings class],
															[BRUIStyleControlStateColorSettings class]]];
	[[[self class] supportedSettingNames] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *key = obj;
		id value = nil;
		if ( [key hasSuffix:@"Font"] ) {
			value = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:[key stringByAppendingString:@"Name"]]
									size:[decoder decodeFloatForKey:[key stringByAppendingString:@"Size"]]];
		} else {
			value = [decoder decodeObjectOfClasses:allowedSettings forKey:key];
		}
		if ( value ) {
			decodedSettings[key] = value;
		}
	}];
	
	self = [self initWithSettings:decodedSettings];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[self.settings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		NSString *settingName = key;
		if ( [obj isKindOfClass:[UIFont class]] ) {
			UIFont *f = obj;
			[coder encodeObject:f.fontName forKey:[settingName stringByAppendingString:@"Name"]];
			[coder encodeFloat:f.pointSize forKey:[settingName stringByAppendingString:@"Size"]];
		} else {
			[coder encodeObject:obj forKey:settingName];
		}
	}];
}

@end

#pragma mark -

@implementation BRUIStyleFontSettings

@dynamic actionFont;
@dynamic formFont;
@dynamic navigationFont;
@dynamic alertHeadlineFont;
@dynamic alertFont;

@dynamic heroFont;
@dynamic headlineFont;
@dynamic secondaryHeadlineFont;
@dynamic textFont;
@dynamic captionFont;

@dynamic listFont;
@dynamic listSecondaryFont;
@dynamic listCaptionFont;

+ (NSArray *)supportedSettingNames {
	static dispatch_once_t fontSettingNamesToken;
	static NSArray *keys;
	dispatch_once(&fontSettingNamesToken, ^{
		keys = @[
				 NSStringFromSelector(@selector(actionFont)),
				 
				 NSStringFromSelector(@selector(formFont)),
				 NSStringFromSelector(@selector(navigationFont)),
				 NSStringFromSelector(@selector(alertHeadlineFont)),
				 NSStringFromSelector(@selector(alertFont)),
				 
				 NSStringFromSelector(@selector(heroFont)),
				 NSStringFromSelector(@selector(headlineFont)),
				 NSStringFromSelector(@selector(secondaryHeadlineFont)),
				 NSStringFromSelector(@selector(textFont)),
				 NSStringFromSelector(@selector(captionFont)),
				 
				 NSStringFromSelector(@selector(listFont)),
				 NSStringFromSelector(@selector(listSecondaryFont)),
				 NSStringFromSelector(@selector(listCaptionFont)),
				 ];
	});
	return keys;
}

+ (NSDictionary *)defaultSettings {
	NSMutableDictionary *defaults = [[NSMutableDictionary alloc] initWithCapacity:16];
	defaults[NSStringFromSelector(@selector(actionFont))] = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
	
	defaults[NSStringFromSelector(@selector(formFont))] =  [UIFont fontWithName:@"GillSans-Light" size:17];
	defaults[NSStringFromSelector(@selector(navigationFont))] =  [UIFont fontWithName:@"GillSans" size:21];
	defaults[NSStringFromSelector(@selector(alertHeadlineFont))] =  [UIFont fontWithName:@"GillSans" size:24];
	defaults[NSStringFromSelector(@selector(alertFont))] =  [UIFont fontWithName:@"GillSans-Light" size:16];
	
	defaults[NSStringFromSelector(@selector(heroFont))] =  [UIFont fontWithName:@"GillSans-Bold" size:21];
	defaults[NSStringFromSelector(@selector(headlineFont))] =  [UIFont fontWithName:@"GillSans-Bold" size:17];
	defaults[NSStringFromSelector(@selector(secondaryHeadlineFont))] =  [UIFont fontWithName:@"GillSans-Light" size:15];
	defaults[NSStringFromSelector(@selector(textFont))] =  [UIFont fontWithName:@"GillSans-Light" size:15];
	defaults[NSStringFromSelector(@selector(captionFont))] =  [UIFont fontWithName:@"GillSans" size:15];
	
	defaults[NSStringFromSelector(@selector(listFont))] =  [UIFont fontWithName:@"GillSans" size:17];
	defaults[NSStringFromSelector(@selector(listSecondaryFont))] =  [UIFont fontWithName:@"GillSans-Light" size:15];
	defaults[NSStringFromSelector(@selector(listCaptionFont))] =  [UIFont fontWithName:@"GillSans" size:15];
	return [defaults copy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [[[BRMutableUIStyleFontSettings class] allocWithZone:zone] initWithSettings:[self.settings mutableCopy]];
}

@end

@implementation BRMutableUIStyleFontSettings

@dynamic actionFont;
@dynamic formFont;
@dynamic navigationFont;
@dynamic alertHeadlineFont;
@dynamic alertFont;

@dynamic heroFont;
@dynamic headlineFont;
@dynamic secondaryHeadlineFont;
@dynamic textFont;
@dynamic captionFont;

@dynamic listFont;
@dynamic listSecondaryFont;
@dynamic listCaptionFont;

- (id)init {
	self = [self initWithSettings:[[[self class] defaultSettings] mutableCopy]];
	return self;
}

+ (BOOL)mutable {
	return YES;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[[BRUIStyleFontSettings class] allocWithZone:zone] initWithSettings:[self.settings copy]];
}

@end

#pragma mark -

@implementation BRUIStyleControlColorSettings

@dynamic actionColor;
@dynamic borderColor;
@dynamic glossColor;
@dynamic shadowColor;

+ (NSArray *)supportedSettingNames {
	static dispatch_once_t controlColorSettingNamesToken;
	static NSArray *keys;
	dispatch_once(&controlColorSettingNamesToken, ^{
		keys = @[
				 NSStringFromSelector(@selector(actionColor)),
				 NSStringFromSelector(@selector(borderColor)),
				 NSStringFromSelector(@selector(glossColor)),
				 NSStringFromSelector(@selector(shadowColor)),
				 ];
	});
	return keys;
}

+ (NSDictionary *)defaultSettings {
	NSMutableDictionary *defaults = [[NSMutableDictionary alloc] initWithCapacity:4];
	defaults[NSStringFromSelector(@selector(actionColor))] = [BRUIStyle colorWithRGBInteger:0x1247b8];
	defaults[NSStringFromSelector(@selector(borderColor))] = [BRUIStyle colorWithRGBInteger:0xCACACA];
	defaults[NSStringFromSelector(@selector(glossColor))] = [[UIColor whiteColor] colorWithAlphaComponent:0.66];
	defaults[NSStringFromSelector(@selector(shadowColor))] = [BRUIStyle colorWithRGBAInteger:0x5555557F];
	return [defaults copy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [[[BRMutableUIStyleControlColorSettings class] allocWithZone:zone] initWithSettings:[self.settings mutableCopy]];
}

@end

#pragma mark -

@implementation BRMutableUIStyleControlColorSettings

@dynamic actionColor;
@dynamic borderColor;
@dynamic glossColor;
@dynamic shadowColor;

- (id)init {
	self = [self initWithSettings:[[[self class] defaultSettings] mutableCopy]];
	return self;
}

+ (BOOL)mutable {
	return YES;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[[BRUIStyleControlColorSettings class] allocWithZone:zone] initWithSettings:[self.settings copy]];
}

@end

#pragma mark -

@implementation BRUIStyleControlStateColorSettings

@dynamic normalColorSettings;
@dynamic highlightedColorSettings;
@dynamic selectedColorSettings;
@dynamic disabledColorSettings;
@dynamic dangerousColorSettings;

+ (NSArray *)supportedSettingNames {
	static dispatch_once_t controlStateColorSettingNamesToken;
	static NSArray *keys;
	dispatch_once(&controlStateColorSettingNamesToken, ^{
		keys = @[
				 NSStringFromSelector(@selector(normalColorSettings)),
				 NSStringFromSelector(@selector(highlightedColorSettings)),
				 NSStringFromSelector(@selector(selectedColorSettings)),
				 NSStringFromSelector(@selector(disabledColorSettings)),
				 NSStringFromSelector(@selector(dangerousColorSettings)),
				 ];
	});
	return keys;
}

+ (NSDictionary *)defaultSettings {
	BOOL mutable = [[self class] mutable];
	NSMutableDictionary *defaults = [[NSMutableDictionary alloc] initWithCapacity:4];
	
	// normal settings
	BRMutableUIStyleControlColorSettings *controlColorSettings = [BRMutableUIStyleControlColorSettings new];
	controlColorSettings.actionColor = [BRUIStyle colorWithRGBInteger:0x555555];
	controlColorSettings.borderColor = [BRUIStyle colorWithRGBInteger:0xCACACA];
	controlColorSettings.glossColor = [[UIColor whiteColor] colorWithAlphaComponent:0.66];
	controlColorSettings.shadowColor = nil;
	defaults[NSStringFromSelector(@selector(normalColorSettings))] = (mutable ? controlColorSettings : [controlColorSettings copy]);

	// highlighted settings
	BRMutableUIStyleControlColorSettings *highlightedControlColorSettings = [controlColorSettings mutableCopy];
	highlightedControlColorSettings.actionColor = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 0.5];
	highlightedControlColorSettings.shadowColor = [BRUIStyle colorWithRGBAInteger:0x5555557F];
	defaults[NSStringFromSelector(@selector(highlightedColorSettings))] = (mutable ? highlightedControlColorSettings : [highlightedControlColorSettings copy]);

	// selected settings
	BRMutableUIStyleControlColorSettings *selectedControlColorSettings = [controlColorSettings mutableCopy];
	selectedControlColorSettings.actionColor = [BRUIStyle colorWithRGBInteger:0x1247b8];
	defaults[NSStringFromSelector(@selector(selectedColorSettings))] = (mutable ? selectedControlColorSettings : [selectedControlColorSettings copy]);

	// disabled settings
	BRMutableUIStyleControlColorSettings *disabledControlColorSettings = [controlColorSettings mutableCopy];
	disabledControlColorSettings.actionColor = [BRUIStyle colorWithRGBInteger:0xCACACA];
	defaults[NSStringFromSelector(@selector(disabledColorSettings))] = (mutable ? disabledControlColorSettings : [disabledControlColorSettings copy]);

	// dangerous settings
	BRMutableUIStyleControlColorSettings *dangerousControlColorSettings = [controlColorSettings mutableCopy];
	dangerousControlColorSettings.actionColor = [BRUIStyle colorWithRGBInteger:0xEB2D38];
	defaults[NSStringFromSelector(@selector(dangerousColorSettings))] = (mutable ? dangerousControlColorSettings : [dangerousControlColorSettings copy]);
	
	return [defaults copy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [[[BRMutableUIStyleControlStateColorSettings class] allocWithZone:zone] initWithSettings:[self.settings mutableCopy]];
}

@end

#pragma mark -

@implementation BRMutableUIStyleControlStateColorSettings

@dynamic normalColorSettings;
@dynamic highlightedColorSettings;
@dynamic selectedColorSettings;
@dynamic disabledColorSettings;
@dynamic dangerousColorSettings;

- (id)init {
	self = [self initWithSettings:[[[self class] defaultSettings] mutableCopy]];
	return self;
}

+ (BOOL)mutable {
	return YES;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[[BRUIStyleControlStateColorSettings class] allocWithZone:zone] initWithSettings:[self.settings copy]];
}

@end

#pragma mark -

@implementation BRUIStyleColorSettings

@dynamic primaryColor;
@dynamic secondaryColor;
@dynamic backgroundColor;
@dynamic separatorColor;

@dynamic heroColor;
@dynamic headlineColor;
@dynamic secondaryHeadlineColor;
@dynamic textColor;
@dynamic captionColor;

@dynamic formColor;
@dynamic placeholderColor;
@dynamic navigationColor;
@dynamic alertHeadlineColor;
@dynamic alertColor;
@dynamic alertBackgroundColor;

@dynamic controlSettings;
@dynamic inverseControlSettings;

+ (NSArray *)supportedSettingNames {
	static dispatch_once_t controlColorSettingNamesToken;
	static NSArray *keys;
	dispatch_once(&controlColorSettingNamesToken, ^{
		keys = @[
				 NSStringFromSelector(@selector(primaryColor)),
				 NSStringFromSelector(@selector(secondaryColor)),
				 NSStringFromSelector(@selector(backgroundColor)),
				 NSStringFromSelector(@selector(separatorColor)),

				 NSStringFromSelector(@selector(heroColor)),
				 NSStringFromSelector(@selector(headlineColor)),
				 NSStringFromSelector(@selector(secondaryHeadlineColor)),
				 NSStringFromSelector(@selector(textColor)),
				 NSStringFromSelector(@selector(captionColor)),
				 
				 NSStringFromSelector(@selector(formColor)),
				 NSStringFromSelector(@selector(placeholderColor)),
				 NSStringFromSelector(@selector(navigationColor)),
				 NSStringFromSelector(@selector(alertHeadlineColor)),
				 NSStringFromSelector(@selector(alertColor)),
				 NSStringFromSelector(@selector(alertBackgroundColor)),
				 
				 NSStringFromSelector(@selector(controlSettings)),
				 NSStringFromSelector(@selector(inverseControlSettings)),
				 ];
	});
	return keys;
}

+ (NSDictionary *)defaultSettings {
	NSMutableDictionary *defaults = [[NSMutableDictionary alloc] initWithCapacity:4];
	UIColor *primaryColor = [BRUIStyle colorWithRGBInteger:0x1247b8];
	defaults[NSStringFromSelector(@selector(primaryColor))] = primaryColor;
	defaults[NSStringFromSelector(@selector(secondaryColor))] = [BRUIStyle colorWithRGBInteger:0xCACACA];
	defaults[NSStringFromSelector(@selector(backgroundColor))] = [BRUIStyle colorWithRGBInteger:0xfafafa];
	defaults[NSStringFromSelector(@selector(separatorColor))] = [BRUIStyle colorWithRGBInteger:0xe1e1e1];

	UIColor *textColor = [BRUIStyle colorWithRGBInteger:0x1a1a1a];
	defaults[NSStringFromSelector(@selector(heroColor))] = textColor;
	defaults[NSStringFromSelector(@selector(headlineColor))] = textColor;
	defaults[NSStringFromSelector(@selector(secondaryHeadlineColor))] = textColor;
	defaults[NSStringFromSelector(@selector(textColor))] = textColor;
	defaults[NSStringFromSelector(@selector(captionColor))] = [UIColor lightGrayColor];
	
	
	defaults[NSStringFromSelector(@selector(formColor))] = textColor;
	defaults[NSStringFromSelector(@selector(placeholderColor))] = [UIColor lightGrayColor];
	defaults[NSStringFromSelector(@selector(navigationColor))] = primaryColor;
	defaults[NSStringFromSelector(@selector(alertHeadlineColor))] = textColor;
	defaults[NSStringFromSelector(@selector(alertColor))] = [UIColor lightGrayColor];
	defaults[NSStringFromSelector(@selector(alertBackgroundColor))] = [UIColor lightGrayColor];
	
	BOOL mutable = [[self class] mutable];
	
	// normal control settings
	BRMutableUIStyleControlStateColorSettings *controlSettings = [BRMutableUIStyleControlStateColorSettings new];
	defaults[NSStringFromSelector(@selector(controlSettings))] = (mutable ? controlSettings : [controlSettings copy]);

	// inverse control settings
	BRMutableUIStyleControlStateColorSettings *inverseControlSettings = [controlSettings mutableCopy];
	
	// normal settings
	BRMutableUIStyleControlColorSettings *controlColorSettings = [inverseControlSettings.normalColorSettings mutableCopy];
	controlColorSettings.actionColor = [UIColor whiteColor];
	controlColorSettings.borderColor = [BRUIStyle colorWithRGBInteger:0x264891];
	controlColorSettings.glossColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
	inverseControlSettings.normalColorSettings = controlColorSettings;
	
	// highlighted settings
	BRMutableUIStyleControlColorSettings *highlightedControlColorSettings = [controlColorSettings mutableCopy];
	highlightedControlColorSettings.actionColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
	inverseControlSettings.highlightedColorSettings = highlightedControlColorSettings;
	
	defaults[NSStringFromSelector(@selector(inverseControlSettings))] = (mutable ? inverseControlSettings : [inverseControlSettings copy]);

	return [defaults copy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [[[BRMutableUIStyleColorSettings class] allocWithZone:zone] initWithSettings:[self.settings mutableCopy]];
}

@end

#pragma mark -

@implementation BRMutableUIStyleColorSettings

@dynamic primaryColor;
@dynamic secondaryColor;
@dynamic backgroundColor;
@dynamic separatorColor;

@dynamic heroColor;
@dynamic headlineColor;
@dynamic secondaryHeadlineColor;
@dynamic textColor;
@dynamic captionColor;

@dynamic formColor;
@dynamic placeholderColor;
@dynamic navigationColor;
@dynamic alertHeadlineColor;
@dynamic alertColor;
@dynamic alertBackgroundColor;

@dynamic controlSettings;
@dynamic inverseControlSettings;

- (id)init {
	self = [self initWithSettings:[[[self class] defaultSettings] mutableCopy]];
	return self;
}

+ (BOOL)mutable {
	return YES;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[[BRUIStyleColorSettings class] allocWithZone:zone] initWithSettings:[self.settings copy]];
}

@end

#pragma mark - Utilities

id dynamicSettingGetterIMP(id self, SEL _cmd) {
	BRUIStyleSettings *me = self;
	return me.settings[NSStringFromSelector(_cmd)];
}

void dynamicSettingSetterIMP(id self, SEL _cmd, id value) {
	// assume setter only called on Mutable variations
	NSMutableDictionary *settings = (NSMutableDictionary *)((BRUIStyleSettings *)self).settings;
	NSString *settingName = SettingNameForSelector(YES, _cmd, NULL);
	[self willChangeValueForKey:settingName];
	if ( value == nil ) {
		[settings removeObjectForKey:settingName];
	} else {
		settings[settingName] = value;
	}
	[self didChangeValueForKey:settingName];
}
