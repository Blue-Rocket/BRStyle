//
//  BRUIStyleSettings.m
//  BRStyle
//
//  Created by Matt on 26/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRUIStyleSettings.h"

#import "BRUIStyle.h"
#import <objc/runtime.h>

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

- (NSMutableDictionary *)mutableSettingsWithZone:(NSZone *)zone {
	NSMutableDictionary *dict = [[NSMutableDictionary allocWithZone:zone] initWithDictionary:self.settings];
	NSMutableDictionary *mutated = [[NSMutableDictionary allocWithZone:zone] init];
	[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if ( [obj conformsToProtocol:@protocol(NSMutableCopying)] ) {
			mutated[key] = [obj mutableCopy];
		}
	}];
	[dict addEntriesFromDictionary:mutated];
	return dict;
}

- (NSString *)debugDescription {
	return [settings debugDescription];
}

#pragma mark - Dictionary representation

- (nullable UIColor *)parseColor:(nullable NSString *)value {
	if ( [value length] < 1 ) {
		return nil;
	}
	// colors assumed to be #rgba format
	unsigned long long colorInteger = 0;
	NSScanner *scanner = [[NSScanner alloc] initWithString:value];
	[scanner scanString:@"#" intoString:NULL];
	[scanner scanHexLongLong:&colorInteger];
	return [BRUIStyle colorWithRGBAInteger:(UInt32)colorInteger];
}

/**
 Parse an array of two floats into a CGSize.
 
 @param value An array of two float number values.
 
 @return The parsed CGSize, or @c nil if @c value is not parsable.
 */
- (CGSize)parseCGSize:(nullable id)value {
	CGSize result = CGSizeZero;
	if ( [value isKindOfClass:[NSArray class]] ) {
		NSArray *array = value;
		if ( array.count > 1 ) {
			result.width = [array[0] floatValue];
			result.height = [array [1] floatValue];
		}
	}
	return result;
}

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
			result = [self parseColor:value];
		} else if ( [value isKindOfClass:[NSDictionary class]] ) {
			if ( [key hasSuffix:@"Font"] ) {
				// if no name provided, use system font
				if ( value[@"name"] ) {
					result = [UIFont fontWithName:value[@"name"] size:[value[@"size"] floatValue]];
				} else {
					result = [UIFont systemFontOfSize:[value[@"size"] floatValue]];
				}
			} else if ( [key hasSuffix:@"hadow"] ) {
				UIColor *color = value[@"color"];
				if ( color ) {
					CGSize offset = [self parseCGSize:value[@"offset"]];
					CGFloat blurRadius = [value[@"blurRadius"] floatValue];
					NSShadow *shadow = [[NSShadow alloc] init];
					shadow.shadowOffset = offset;
					shadow.shadowBlurRadius = blurRadius;
					shadow.shadowColor = color;
					result = shadow;
				}
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

+ (BOOL)isSystemFont:(UIFont *)font {
	static NSString *systemFontFamilyName;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		systemFontFamilyName = [[UIFont systemFontOfSize:12] familyName];
	});
	return [[font familyName] isEqualToString:systemFontFamilyName];
}

+ (NSString *)stringValueForColor:(UIColor *)color {
	char hexStr[20];
	sprintf(hexStr,"#%08lx", (unsigned long)[BRUIStyle rgbaIntegerForColor:color]);
	return [[NSString alloc] initWithUTF8String:hexStr];
}

- (NSDictionary *)dictionaryRepresentation {
	NSMutableDictionary *encoded = [[NSMutableDictionary alloc] initWithCapacity:16];
	[[[self class] supportedSettingNames] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *key = obj;
		id value = settings[key];
		id result = nil;
		if ( [value isKindOfClass:[UIColor class]] ) {
			result = [BRUIStyleSettings stringValueForColor:value];
		} else if ( [value isKindOfClass:[UIFont class]] ) {
			if ( [BRUIStyleFontSettings isSystemFont:value] ) {
				result = @{ @"size" : @([value pointSize])};
			} else {
				result = @{ @"name" : [value fontName], @"size" : @([value pointSize])};
			}
		} else if ( [value isKindOfClass:[NSShadow class]] ) {
			NSShadow *shadow = value;
			result = @{ @"color" : [BRUIStyleSettings stringValueForColor:shadow.shadowColor],
						@"offset" : @[@(shadow.shadowOffset.width), @(shadow.shadowOffset.height)],
						@"blurRadius" : @(shadow.shadowBlurRadius) };
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
	NSSet *allowedSettings = [NSSet setWithObjects:[UIColor class], [NSShadow class], [BRUIStyleControlSettings class], nil];
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
	
	defaults[NSStringFromSelector(@selector(heroFont))] =  [UIFont fontWithName:@"GillSans-Bold" size:21];
	defaults[NSStringFromSelector(@selector(headlineFont))] =  [UIFont fontWithName:@"GillSans-Bold" size:17];
	defaults[NSStringFromSelector(@selector(secondaryHeadlineFont))] =  [UIFont fontWithName:@"GillSans-Light" size:15];
	defaults[NSStringFromSelector(@selector(textFont))] =  [UIFont fontWithName:@"GillSans-Light" size:13];
	defaults[NSStringFromSelector(@selector(captionFont))] =  [UIFont fontWithName:@"GillSans" size:15];
	
	defaults[NSStringFromSelector(@selector(listFont))] =  [UIFont fontWithName:@"GillSans" size:17];
	defaults[NSStringFromSelector(@selector(listSecondaryFont))] =  [UIFont fontWithName:@"GillSans-Light" size:15];
	defaults[NSStringFromSelector(@selector(listCaptionFont))] =  [UIFont fontWithName:@"GillSans" size:15];
	return [defaults copy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [[[BRMutableUIStyleFontSettings class] allocWithZone:zone] initWithSettings:[self mutableSettingsWithZone:zone]];
}

@end

@implementation BRMutableUIStyleFontSettings

@dynamic actionFont;
@dynamic formFont;
@dynamic navigationFont;

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

@implementation BRUIStyleControlSettings

@dynamic actionColor;
@dynamic borderColor;
@dynamic fillColor;
@dynamic glossColor;
@dynamic shadowColor;
@dynamic shadow;
@dynamic textShadow;

+ (NSArray *)supportedSettingNames {
	static dispatch_once_t controlColorSettingNamesToken;
	static NSArray *keys;
	dispatch_once(&controlColorSettingNamesToken, ^{
		keys = @[
				 NSStringFromSelector(@selector(actionColor)),
				 NSStringFromSelector(@selector(borderColor)),
				 NSStringFromSelector(@selector(fillColor)),
				 NSStringFromSelector(@selector(glossColor)),
				 NSStringFromSelector(@selector(shadowColor)),
				 NSStringFromSelector(@selector(shadow)),
				 NSStringFromSelector(@selector(textShadow)),
				 ];
	});
	return keys;
}

+ (NSDictionary *)defaultSettings {
	NSMutableDictionary *defaults = [[NSMutableDictionary alloc] initWithCapacity:4];
	defaults[NSStringFromSelector(@selector(actionColor))] = [BRUIStyle colorWithRGBInteger:0x555555];
	defaults[NSStringFromSelector(@selector(borderColor))] = [BRUIStyle colorWithRGBInteger:0xCACACA];
	defaults[NSStringFromSelector(@selector(fillColor))] = [UIColor clearColor];
	defaults[NSStringFromSelector(@selector(glossColor))] = [[UIColor whiteColor] colorWithAlphaComponent:0.66];
	return [defaults copy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [[[BRMutableUIStyleControlSettings class] allocWithZone:zone] initWithSettings:[self mutableSettingsWithZone:zone]];
}

@end

#pragma mark -

@implementation BRMutableUIStyleControlSettings

@dynamic actionColor;
@dynamic borderColor;
@dynamic fillColor;
@dynamic glossColor;
@dynamic shadowColor;
@dynamic shadow;
@dynamic textShadow;

- (id)init {
	self = [self initWithSettings:[[[self class] defaultSettings] mutableCopy]];
	return self;
}

+ (BOOL)mutable {
	return YES;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[[BRUIStyleControlSettings class] allocWithZone:zone] initWithSettings:[self.settings copy]];
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
	
	return [defaults copy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [[[BRMutableUIStyleColorSettings class] allocWithZone:zone] initWithSettings:[self mutableSettingsWithZone:zone]];
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
