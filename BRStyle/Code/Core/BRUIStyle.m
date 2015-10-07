//
//  BRUIStyle.m
//  BRStyle
//
//  Created by Matt on 21/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRUIStyle.h"

NSString * const BRStyleNotificationUIStyleDidChange = @"BRUIStyleDidChange";

static BRUIStyle *DefaultStyle;

@implementation BRUIStyle {
	@protected
	BRUIStyleFontSettings *fonts;
	BRUIStyleColorSettings *colors;
	BRUIStyleControlSettings *controls;
}

+ (instancetype)defaultStyle {
	if ( !DefaultStyle ) {
		[self setDefaultStyle:[[BRUIStyle alloc] initWithUIStyle:nil]];
	}
	return DefaultStyle;
}

+ (void)setDefaultStyle:(BRUIStyle *)style {
	if ( !style ) {
		return;
	}
	if ( ![NSThread isMainThread] ) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[BRUIStyle setDefaultStyle:style];
		});
		return;
	}
	BRUIStyle *newStyle = [style copy];
	DefaultStyle = newStyle;
	[[NSNotificationCenter defaultCenter] postNotificationName:BRStyleNotificationUIStyleDidChange object:newStyle];
}

+ (UIColor *)colorWithRGBInteger:(UInt32)integer {
	return [UIColor colorWithRed:(((integer >> 16) & 0xFF) / 255.0f)
						   green:(((integer >> 8) & 0xFF) / 255.0f)
							blue:((integer & 0xFF) / 255.0f)
						   alpha:1.0];
}

+ (UIColor *)colorWithRGBAInteger:(UInt32)integer {
	return [UIColor colorWithRed:(((integer >> 24) & 0xFF) / 255.0f)
						   green:(((integer >> 16) & 0xFF) / 255.0f)
							blue:(((integer >> 8) & 0xFF) / 255.0f)
						   alpha:((integer & 0xFF) / 255.0f)];
}

+ (UInt32)rgbIntegerForColor:(UIColor *)color {
	CGFloat r, g, b, a;
	if ( [color getRed:&r green:&g blue:&b alpha:&a] ) {
		return (
				(((UInt32)roundf(r * 255.0f)) << 16)
				| (((UInt32)roundf(g * 255.0f)) << 8)
				| ((UInt32)roundf(b * 255.0f))
				);
	}
	return 0;
}

+ (UInt32)rgbaIntegerForColor:(UIColor *)color {
	CGFloat r, g, b, a;
	if ( [color getRed:&r green:&g blue:&b alpha:&a] ) {
		return (
				(((UInt32)roundf(r * 255.0f)) << 24)
				| (((UInt32)roundf(g * 255.0f)) << 16)
				| (((UInt32)roundf(b * 255.0f)) << 8)
				| ((UInt32)roundf(a * 255.0f))
				);
	}
	return 0;
}

#pragma mark - Memory management

- (instancetype)init {
	return [self initWithUIStyle:nil];
}

- (instancetype)initWithUIStyle:(BRUIStyle *)other {
	if ( (self = [super init]) ) {
		if ( other == nil ) {
			fonts = [BRUIStyleFontSettings new];
			colors = [BRUIStyleColorSettings new];
			controls = [BRUIStyleControlSettings new];
		} else {
			fonts = [other.fonts copy];
			colors = [other.colors copy];
			controls = [other.controls copy];
		}
	}
	return self;
}

- (NSString *)debugDescription {
	return [NSString stringWithFormat:@"BRUIStyle{colors=%@; fonts = %@; controls = %@}",
			[colors debugDescription], [fonts debugDescription], [controls debugDescription]];
}

#pragma mark - Serialization

+ (BRUIStyle *)styleWithJSONResource:(NSString *)resourceName inBundle:(nullable NSBundle *)bundle {
	NSBundle *bundleToUse = (bundle ? bundle : [NSBundle mainBundle]);
	NSString *jsonPath = [bundleToUse pathForResource:resourceName ofType:nil];
	BRUIStyle *style = nil;
	if ( [jsonPath length] > 0 ) {
		NSInputStream *input = [NSInputStream inputStreamWithFileAtPath:jsonPath];
		[input open];
		NSError *error = nil;
		NSDictionary *dict = [NSJSONSerialization JSONObjectWithStream:input options:0 error:&error];
		if ( error ) {
			NSLog(@"Error reading BRUIStyle from %@: %@", jsonPath, [error localizedDescription]);
		} else {
			style = [BRUIStyle styleWithDictionary:dict];
		}
		[input close];
	}
	return style;
}

+ (NSDictionary<NSString *, BRUIStyle *> *)stylesWithJSONResource:(NSString *)resourceName inBundle:(NSBundle *)bundle {
	NSBundle *bundleToUse = (bundle ? bundle : [NSBundle mainBundle]);
	NSString *jsonPath = [bundleToUse pathForResource:resourceName ofType:nil];
	NSDictionary<NSString *, BRUIStyle *> *styles = nil;
	if ( [jsonPath length] > 0 ) {
		NSInputStream *input = [NSInputStream inputStreamWithFileAtPath:jsonPath];
		[input open];
		NSError *error = nil;
		NSDictionary *dict = [NSJSONSerialization JSONObjectWithStream:input options:0 error:&error];
		if ( error ) {
			NSLog(@"Error reading BRUIStyle set from %@: %@", jsonPath, [error localizedDescription]);
		} else {
			NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:dict.count];
			[result enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
				if ( !([key isKindOfClass:[NSString class]] && [obj isKindOfClass:[NSDictionary class]]) ) {
					return;
				}
				BRUIStyle *style = [BRUIStyle styleWithDictionary:obj];
				if ( style ) {
					result[key] = style;
				}
			}];
			if ( result.count > 0 ) {
				styles = [result copy];
			}
		}
		[input close];
	}
	return styles;
}

+ (BRUIStyle *)styleWithDictionary:(NSDictionary *)dictionary {
	return [[self alloc] initWithDictionaryRepresentation:dictionary];
}

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionary {
	if ( (self = [super init]) ) {
		fonts = [[BRUIStyleFontSettings alloc] initWithDictionaryRepresentation:dictionary[@"fonts"]];
		colors = [[BRUIStyleColorSettings alloc] initWithDictionaryRepresentation:dictionary[@"colors"]];
		controls = [[BRUIStyleControlSettings alloc] initWithDictionaryRepresentation:dictionary[@"controls"]];
	}
	return self;
}

- (NSDictionary *)dictionaryRepresentation {
	return @{@"fonts" : (fonts ? [fonts dictionaryRepresentation] : [NSNull null]),
			 @"colors" : (colors ? [colors dictionaryRepresentation] : [NSNull null]),
			 @"controls" : (controls ? [controls dictionaryRepresentation] : [NSNull null])};
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [[[BRMutableUIStyle class] allocWithZone:zone] initWithUIStyle:self];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [self init];
	if ( !self ) {
		return nil;
	}
	fonts = [decoder decodeObjectOfClass:[BRUIStyleFontSettings class] forKey:NSStringFromSelector(@selector(fonts))];
	colors = [decoder decodeObjectOfClass:[BRUIStyleColorSettings class] forKey:NSStringFromSelector(@selector(colors))];
	controls = [decoder decodeObjectOfClass:[BRUIStyleControlSettings class] forKey:NSStringFromSelector(@selector(controls))];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:fonts forKey:NSStringFromSelector(@selector(fonts))];
	[coder encodeObject:colors forKey:NSStringFromSelector(@selector(fonts))];
	[coder encodeObject:controls forKey:NSStringFromSelector(@selector(controls))];
}

#pragma mark - Helpers

- (BOOL)isDefaultStyle {
	return (self == DefaultStyle);
}

- (BRUIStyleFontSettings *)fonts {
	return (fonts || self.defaultStyle ? fonts : [BRUIStyle defaultStyle].fonts);
}

- (BRUIStyleColorSettings *)colors {
	return (colors || self.defaultStyle ? colors : [BRUIStyle defaultStyle].colors);
}

- (BRUIStyleControlSettings *)controls {
	return (controls || self.defaultStyle ? controls : [BRUIStyle defaultStyle].controls);
}

@end

#pragma BRMutableUIStyle support

@implementation BRMutableUIStyle

@dynamic fonts;
@dynamic colors;

- (instancetype)initWithUIStyle:(BRUIStyle *)other {
	if ( (self = [super initWithUIStyle:other]) ) {
		fonts = [fonts mutableCopy];
		colors = [colors mutableCopy];
		controls = [controls mutableCopy];
	}
	return self;
}

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionary {
	if ( (self = [super initWithDictionaryRepresentation:dictionary]) ) {
		fonts = [fonts mutableCopy];
		colors = [colors mutableCopy];
		controls = [controls mutableCopy];
	}
	return self;
}

- (void)setFonts:(BRMutableUIStyleFontSettings * __nonnull)theFonts {
	fonts = theFonts;
}

- (void)setColors:(BRMutableUIStyleColorSettings * __nonnull)theColors {
	colors = theColors;
}

- (void)setControls:(BRMutableUIStyleControlSettings * __nonnull)theControls {
	controls = theControls;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[BRUIStyle allocWithZone:zone] initWithUIStyle:self];
}

@end
