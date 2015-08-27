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

+ (UInt32)rgbaHexIntegerForColor:(UIColor *)color {
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
		} else {
			fonts = [other.fonts copy];
			colors = [other.colors copy];
		}
	}
	return self;
}

- (NSString *)debugDescription {
	return [NSString stringWithFormat:@"BRUIStyle{colors=%@; fonts = %@}", [colors debugDescription], [fonts debugDescription]];
}

#pragma mark - Dictionary representation

+ (instancetype)styleWithDictionary:(NSDictionary *)dictionary {
	return [[self alloc] initWithDictionaryRepresentation:dictionary];
}

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionary {
	if ( (self = [super init]) ) {
		fonts = [[BRUIStyleFontSettings alloc] initWithDictionaryRepresentation:dictionary[@"fonts"]];
		colors = [[BRUIStyleColorSettings alloc] initWithDictionaryRepresentation:dictionary[@"colors"]];
	}
	return self;
}

- (NSDictionary *)dictionaryRepresentation {
	return @{@"fonts" : (fonts ? [fonts dictionaryRepresentation] : [NSNull null]),
			 @"colors" : (colors ? [colors dictionaryRepresentation] : [NSNull null])};
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
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:fonts forKey:NSStringFromSelector(@selector(fonts))];
	[coder encodeObject:colors forKey:NSStringFromSelector(@selector(fonts))];
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

@end

#pragma BRMutableUIStyle support

@implementation BRMutableUIStyle

@dynamic fonts;
@dynamic colors;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionary {
	if ( (self = [super initWithDictionaryRepresentation:dictionary]) ) {
		fonts = [fonts mutableCopy];
		colors = [colors mutableCopy];
	}
	return self;
}

- (void)setFonts:(BRMutableUIStyleFontSettings * __nonnull)theFonts {
	fonts = theFonts;
}

- (void)setColors:(BRMutableUIStyleColorSettings * __nonnull)theColors {
	colors = theColors;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[BRUIStyle allocWithZone:zone] initWithUIStyle:self];
}

@end
