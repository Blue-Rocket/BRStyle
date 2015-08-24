//
//  BRUIStyle.m
//  BRStyle
//
//  Created by Matt on 21/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRUIStyle.h"

NSString * const BRNotificationUIStyleDidChange = @"BRUIStyleDidChange";

static BRUIStyle *DefaultStyle;

@interface BRUIStyle ()
@property (nonatomic, readwrite) IBInspectable UIColor *appPrimaryColor;
@property (nonatomic, readwrite) IBInspectable UIColor *appBodyColor;
@property (nonatomic, readwrite) IBInspectable UIColor *appSeparatorColor;

@property (nonatomic, readwrite) IBInspectable UIColor *inverseAppPrimaryColor;

@property (nonatomic, readwrite) IBInspectable UIColor *textColor;
@property (nonatomic, readwrite) IBInspectable UIColor *textShadowColor;
@property (nonatomic, readwrite) IBInspectable UIColor *secondaryColor;
@property (nonatomic, readwrite) IBInspectable UIColor *captionColor;

@property (nonatomic, readwrite) IBInspectable UIColor *inverseTextColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseTextShadowColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseSecondaryColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseCaptionColor;

@property (nonatomic, readwrite) IBInspectable UIColor *controlTextColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlBorderColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlBorderGlossColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlHighlightedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlHighlightedShadowColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlSelectedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlDisabledColor;

@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlTextColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlBorderColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlBorderGlossColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlHighlightedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlHighlightedShadowColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlSelectedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlDisabledColor;

@property (nonatomic, strong, readwrite) IBInspectable UIFont *uiFont;
@property (nonatomic, strong, readwrite) IBInspectable UIFont *uiBoldFont;

@property (nonatomic, readwrite) IBInspectable UIFont *bodyFont;
@property (nonatomic, readwrite) IBInspectable UIFont *titleFont;
@property (nonatomic, readwrite) IBInspectable UIFont *heroFont;
@property (nonatomic, readwrite) IBInspectable UIFont *headlineFont;
@property (nonatomic, readwrite) IBInspectable UIFont *secondaryFont;
@property (nonatomic, readwrite) IBInspectable UIFont *captionFont;

@property (nonatomic, readwrite) IBInspectable UIFont *listFont;
@property (nonatomic, readwrite) IBInspectable UIFont *listSecondaryFont;
@property (nonatomic, readwrite) IBInspectable UIFont *listCaptionFont;

@property (nonatomic, readwrite) IBInspectable UIFont *alertBodyFont;
@property (nonatomic, readwrite) IBInspectable UIFont *alertHeadlineFont;
@end

@implementation BRUIStyle {
	UIColor *appPrimaryColor;
	UIColor *appBodyColor;
	UIColor *appSeparatorColor;
	
	UIColor *inverseAppPrimaryColor;
	
	UIColor *textColor;
	UIColor *textShadowColor;
	UIColor *secondaryColor;
	UIColor *captionColor;
	
	UIColor *inverseTextColor;
	UIColor *inverseTextShadowColor;
	UIColor *inverseSecondaryColor;
	UIColor *inverseCaptionColor;

	UIColor *controlTextColor;
	UIColor *controlBorderColor;
	UIColor *controlBorderGlossColor;
	UIColor *controlHighlightedColor;
	UIColor *controlHighlightedShadowColor;
	UIColor *controlSelectedColor;
	UIColor *controlDisabledColor;
	UIColor *controlDangerColor;

	UIColor *inverseControlTextColor;
	UIColor *inverseControlBorderColor;
	UIColor *inverseControlBorderGlossColor;
	UIColor *inverseControlHighlightedColor;
	UIColor *inverseControlHighlightedShadowColor;
	UIColor *inverseControlSelectedColor;
	UIColor *inverseControlDisabledColor;

	UIFont *uiFont;
	UIFont *uiBoldFont;

	UIFont *bodyFont;
	UIFont *titleFont;
	UIFont *heroFont;
	UIFont *headlineFont;
	UIFont *secondaryFont;
	UIFont *captionFont;
	
	UIFont *listFont;
	UIFont *listSecondaryFont;
	UIFont *listCaptionFont;
	
	UIFont *alertBodyFont;
	UIFont *alertHeadlineFont;
}

@synthesize appPrimaryColor, inverseAppPrimaryColor;
@synthesize appBodyColor, appSeparatorColor;

@synthesize textColor, inverseTextColor;
@synthesize secondaryColor, inverseSecondaryColor;
@synthesize captionColor, inverseCaptionColor;
@synthesize textShadowColor, inverseTextShadowColor;

@synthesize controlTextColor, inverseControlTextColor;
@synthesize controlBorderColor, inverseControlBorderColor;
@synthesize controlBorderGlossColor, inverseControlBorderGlossColor;
@synthesize controlHighlightedColor, inverseControlHighlightedColor;
@synthesize controlHighlightedShadowColor, inverseControlHighlightedShadowColor;
@synthesize controlSelectedColor, inverseControlSelectedColor;
@synthesize controlDisabledColor, inverseControlDisabledColor;
@dynamic controlDangerColor;

@synthesize uiFont, uiBoldFont;
@synthesize bodyFont, titleFont;
@synthesize heroFont, headlineFont, secondaryFont, captionFont;
@synthesize listFont, listSecondaryFont, listCaptionFont;
@synthesize alertBodyFont, alertHeadlineFont;

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
	[[NSNotificationCenter defaultCenter] postNotificationName:BRNotificationUIStyleDidChange object:newStyle];
}

+ (UIColor *)colorWithRGBHexInteger:(UInt32)integer {
	return [UIColor colorWithRed:(((integer >> 16) & 0xFF) / 255.0f)
						   green:(((integer >> 8) & 0xFF) / 255.0f)
							blue:((integer & 0xFF) / 255.0f)
						   alpha:1.0];
}

+ (UIColor *)colorWithRGBAHexInteger:(UInt32)integer {
	return [UIColor colorWithRed:(((integer >> 24) & 0xFF) / 255.0f)
						   green:(((integer >> 16) & 0xFF) / 255.0f)
							blue:(((integer >> 8) & 0xFF) / 255.0f)
						   alpha:((integer & 0xFF) / 255.0f)];
}

+ (UInt32)rgbHexIntegerForColor:(UIColor *)color {
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

- (id)init {
	return [self initWithUIStyle:nil];
}

- (id)initWithUIStyle:(BRUIStyle *)other {
	if ( (self = [super init]) ) {
		if ( other == nil ) {
			// apply defaults
			// TODO: load from environment resource
			appPrimaryColor = [BRUIStyle colorWithRGBHexInteger:0x1247b8];
			appBodyColor = [BRUIStyle colorWithRGBHexInteger:0xfafafa];
			appSeparatorColor = [BRUIStyle colorWithRGBHexInteger:0xe1e1e1];
			
			inverseAppPrimaryColor = [UIColor whiteColor];
			
			textColor = [BRUIStyle colorWithRGBHexInteger:0x1a1a1a];
			textShadowColor = [BRUIStyle colorWithRGBAHexInteger:0xCACACA7F];
			secondaryColor = textColor;
			captionColor = [UIColor lightGrayColor];
			
			inverseTextColor = [UIColor whiteColor];
			inverseTextShadowColor = textShadowColor;
			inverseSecondaryColor = inverseTextColor;
			inverseCaptionColor = inverseTextColor;
			
			controlTextColor = [BRUIStyle colorWithRGBHexInteger:0x555555];
			controlBorderColor = [BRUIStyle colorWithRGBHexInteger:0xCACACA];
			controlBorderGlossColor = [[UIColor whiteColor] colorWithAlphaComponent:0.66];
			controlHighlightedColor = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 0.5];
			controlHighlightedShadowColor = [controlTextColor colorWithAlphaComponent: 0.5];
			controlSelectedColor = appPrimaryColor;
			controlDisabledColor = controlBorderColor;
			controlDangerColor = [BRUIStyle colorWithRGBHexInteger:0xEB2D38];
			
			inverseControlTextColor = [UIColor whiteColor];
			inverseControlBorderColor = [BRUIStyle colorWithRGBHexInteger:0x264891];
			inverseControlBorderGlossColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
			inverseControlHighlightedColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
			inverseControlHighlightedShadowColor = controlHighlightedShadowColor;
			inverseControlSelectedColor = controlSelectedColor;
			inverseControlDisabledColor = controlBorderColor;
			
			uiFont = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
			uiBoldFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
			
			bodyFont = [UIFont fontWithName:@"GillSans-Light" size:15];
			titleFont = [UIFont fontWithName:@"GillSans" size:21];
			heroFont = [UIFont fontWithName:@"GillSans-Bold" size:21];
			headlineFont = [UIFont fontWithName:@"GillSans-Bold" size:17];
			secondaryFont = [UIFont fontWithName:@"GillSans-Light" size:15];
			captionFont = [UIFont fontWithName:@"GillSans" size:15];
			
			listFont = [UIFont fontWithName:@"GillSans" size:17];
			listSecondaryFont = [UIFont fontWithName:@"GillSans-Light" size:15];
			listCaptionFont = [UIFont fontWithName:@"GillSans" size:15];
			
			alertBodyFont = [UIFont fontWithName:@"GillSans-Light" size:16];
			alertHeadlineFont = [UIFont fontWithName:@"GillSans" size:24];
		} else {
			appPrimaryColor = other.appPrimaryColor;
			appBodyColor = other.appBodyColor;
			appSeparatorColor = other.appSeparatorColor;
			
			inverseAppPrimaryColor = other.inverseAppPrimaryColor;
			
			textColor = other.textColor;
			textShadowColor = other.textShadowColor;
			secondaryColor = other.secondaryColor;
			captionColor = other.captionColor;
			
			inverseTextColor = other.inverseTextColor;
			inverseTextShadowColor = other.inverseTextShadowColor;
			inverseSecondaryColor = other.inverseSecondaryColor;
			inverseCaptionColor = other.inverseCaptionColor;
			
			controlTextColor = other.controlTextColor;
			controlBorderColor = other.controlBorderColor;
			controlBorderGlossColor = other.controlBorderGlossColor;
			controlHighlightedColor = other.controlHighlightedColor;
			controlHighlightedShadowColor = other.controlHighlightedShadowColor;
			controlSelectedColor = other.controlSelectedColor;
			controlDisabledColor = other.controlDisabledColor;
			controlDangerColor = other.controlDangerColor;

			inverseControlTextColor = other.inverseControlTextColor;
			inverseControlBorderColor = other.inverseControlBorderColor;
			inverseControlBorderGlossColor = other.inverseControlBorderGlossColor;
			inverseControlHighlightedColor = other.inverseControlHighlightedColor;
			inverseControlHighlightedShadowColor = other.inverseControlHighlightedShadowColor;
			inverseControlSelectedColor = other.inverseControlSelectedColor;
			inverseControlDisabledColor = other.inverseControlDisabledColor;
			
			uiFont = other.uiFont;
			uiBoldFont = other.uiBoldFont;
			
			bodyFont = other.bodyFont;
			titleFont = other.titleFont;
			heroFont = other.heroFont;
			headlineFont = other.headlineFont;
			secondaryFont = other.secondaryFont;
			captionFont = other.captionFont;
			
			listFont = other.listFont;
			listSecondaryFont = other.listSecondaryFont;
			listCaptionFont = other.listCaptionFont;
			
			alertBodyFont = other.alertBodyFont;
			alertHeadlineFont = other.alertHeadlineFont;
		}
	}
	return self;
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
	appPrimaryColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(appPrimaryColor))];
	appBodyColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(appBodyColor))];
	appSeparatorColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(appSeparatorColor))];

	inverseAppPrimaryColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseAppPrimaryColor))];

	textColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(textColor))];
	textShadowColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(textShadowColor))];
	[decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(secondaryColor))];
	[decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(captionColor))];
	
	inverseTextColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseTextColor))];
	inverseTextShadowColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseTextShadowColor))];
	[decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseSecondaryColor))];
	[decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseCaptionColor))];
	
	controlTextColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlTextColor))];
	controlBorderColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlBorderColor))];
	controlBorderGlossColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlBorderGlossColor))];
	controlHighlightedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlHighlightedColor))];
	controlHighlightedShadowColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlHighlightedShadowColor))];
	controlSelectedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlSelectedColor))];
	controlDisabledColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlDisabledColor))];
	controlDangerColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlDangerColor))];

	inverseControlTextColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlTextColor))];
	inverseControlBorderColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlBorderColor))];
	inverseControlBorderGlossColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlBorderGlossColor))];
	inverseControlHighlightedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlHighlightedColor))];
	inverseControlHighlightedShadowColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlHighlightedShadowColor))];
	inverseControlSelectedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlSelectedColor))];
	inverseControlDisabledColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlDisabledColor))];
	
	uiFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"uiFontName"] size:[decoder decodeFloatForKey:@"uiFontSize"]];
	uiBoldFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"uiBoldFontName"] size:[decoder decodeFloatForKey:@"uiBoldFontSize"]];
	
	bodyFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"bodyFontName"] size:[decoder decodeFloatForKey:@"bodyFontSize"]];
	titleFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"titleFontName"] size:[decoder decodeFloatForKey:@"titleFontSize"]];
	heroFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"heroFontName"] size:[decoder decodeFloatForKey:@"heroFontSize"]];;
	headlineFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"headlineFontName"] size:[decoder decodeFloatForKey:@"headlineFontSize"]];;
	secondaryFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"secondaryFontName"] size:[decoder decodeFloatForKey:@"secondaryFontSize"]];;
	captionFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"captionFontName"] size:[decoder decodeFloatForKey:@"captionFontSize"]];;
	
	listFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"listFontName"] size:[decoder decodeFloatForKey:@"listFontSize"]];;
	listSecondaryFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"listSecondaryFontName"] size:[decoder decodeFloatForKey:@"listSecondaryFontSize"]];;
	listCaptionFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"listCaptionFontName"] size:[decoder decodeFloatForKey:@"listCaptionFontSize"]];;
	
	alertBodyFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"alertBodyFontName"] size:[decoder decodeFloatForKey:@"alertBodyFontSize"]];;
	alertHeadlineFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"alertHeadlineFontName"] size:[decoder decodeFloatForKey:@"alertHeadlineFontSize"]];;
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:appPrimaryColor forKey:NSStringFromSelector(@selector(appPrimaryColor))];
	[coder encodeObject:appBodyColor forKey:NSStringFromSelector(@selector(appBodyColor))];
	[coder encodeObject:appSeparatorColor forKey:NSStringFromSelector(@selector(appSeparatorColor))];
	
	[coder encodeObject:inverseAppPrimaryColor forKey:NSStringFromSelector(@selector(inverseAppPrimaryColor))];
	
	[coder encodeObject:textColor forKey:NSStringFromSelector(@selector(textColor))];
	[coder encodeObject:textShadowColor forKey:NSStringFromSelector(@selector(textShadowColor))];
	[coder encodeObject:secondaryColor forKey:NSStringFromSelector(@selector(secondaryColor))];
	[coder encodeObject:captionColor forKey:NSStringFromSelector(@selector(captionColor))];
	
	[coder encodeObject:inverseTextColor forKey:NSStringFromSelector(@selector(inverseTextColor))];
	[coder encodeObject:inverseTextShadowColor forKey:NSStringFromSelector(@selector(inverseTextShadowColor))];
	[coder encodeObject:inverseSecondaryColor forKey:NSStringFromSelector(@selector(inverseSecondaryColor))];
	[coder encodeObject:inverseCaptionColor forKey:NSStringFromSelector(@selector(inverseCaptionColor))];
	
	[coder encodeObject:controlTextColor forKey:NSStringFromSelector(@selector(controlTextColor))];
	[coder encodeObject:controlBorderColor forKey:NSStringFromSelector(@selector(controlBorderColor))];
	[coder encodeObject:controlBorderGlossColor forKey:NSStringFromSelector(@selector(controlBorderGlossColor))];
	[coder encodeObject:controlHighlightedColor forKey:NSStringFromSelector(@selector(controlHighlightedColor))];
	[coder encodeObject:controlHighlightedShadowColor forKey:NSStringFromSelector(@selector(controlHighlightedShadowColor))];
	[coder encodeObject:controlSelectedColor forKey:NSStringFromSelector(@selector(controlSelectedColor))];
	[coder encodeObject:controlDisabledColor forKey:NSStringFromSelector(@selector(controlDisabledColor))];
	[coder encodeObject:controlDangerColor forKey:NSStringFromSelector(@selector(controlDangerColor))];
	
	[coder encodeObject:inverseControlTextColor forKey:NSStringFromSelector(@selector(inverseControlTextColor))];
	[coder encodeObject:inverseControlBorderColor forKey:NSStringFromSelector(@selector(inverseControlBorderColor))];
	[coder encodeObject:inverseControlBorderGlossColor forKey:NSStringFromSelector(@selector(inverseControlBorderGlossColor))];
	[coder encodeObject:inverseControlHighlightedColor forKey:NSStringFromSelector(@selector(inverseControlHighlightedColor))];
	[coder encodeObject:inverseControlHighlightedShadowColor forKey:NSStringFromSelector(@selector(inverseControlHighlightedShadowColor))];
	[coder encodeObject:inverseControlSelectedColor forKey:NSStringFromSelector(@selector(inverseControlSelectedColor))];
	[coder encodeObject:inverseControlDisabledColor forKey:NSStringFromSelector(@selector(inverseControlDisabledColor))];
	
	[coder encodeObject:uiFont.fontName forKey:@"uiFontName"];
	[coder encodeFloat:uiFont.pointSize forKey:@"uiFontSize"];
	[coder encodeObject:uiBoldFont.fontName forKey:@"uiBoldFontName"];
	[coder encodeFloat:uiBoldFont.pointSize forKey:@"uiBoldFontSize"];

	[coder encodeObject:bodyFont.fontName forKey:@"bodyFontName"];
	[coder encodeFloat:bodyFont.pointSize forKey:@"bodyFontSize"];
	[coder encodeObject:titleFont.fontName forKey:@"titleFontName"];
	[coder encodeFloat:titleFont.pointSize forKey:@"titleFontSize"];
	[coder encodeObject:heroFont.fontName forKey:@"heroFontName"];
	[coder encodeFloat:heroFont.pointSize forKey:@"heroFontSize"];
	[coder encodeObject:headlineFont.fontName forKey:@"headlineFontName"];
	[coder encodeFloat:headlineFont.pointSize forKey:@"headlineFontSize"];
	[coder encodeObject:secondaryFont.fontName forKey:@"secondaryFontName"];
	[coder encodeFloat:secondaryFont.pointSize forKey:@"secondaryFontSize"];
	[coder encodeObject:captionFont.fontName forKey:@"captionFontName"];
	[coder encodeFloat:captionFont.pointSize forKey:@"captionFontSize"];
	
	[coder encodeObject:listFont.fontName forKey:@"listFontName"];
	[coder encodeFloat:listFont.pointSize forKey:@"listFontSize"];;
	[coder encodeObject:listSecondaryFont.fontName forKey:@"listSecondaryFontName"];
	[coder encodeFloat:listSecondaryFont.pointSize forKey:@"listSecondaryFontSize"];
	[coder encodeObject:listCaptionFont.fontName forKey:@"listCaptionFontName"];
	[coder encodeFloat:listCaptionFont.pointSize forKey:@"listCaptionFontSize"];
	
	[coder encodeObject:alertBodyFont.fontName forKey:@"alertBodyFontName"];
	[coder encodeFloat:alertBodyFont.pointSize forKey:@"alertBodyFontSize"];
	[coder encodeObject:alertHeadlineFont.fontName forKey:@"alertHeadlineFontName"];
	[coder encodeFloat:alertHeadlineFont.pointSize forKey:@"alertHeadlineFontSize"];
}

#pragma mark - Helpers

- (BOOL)isDefaultStyle {
	return (self == DefaultStyle);
}

#pragma mark - Structural

- (UIColor *)appPrimaryColor {
	return (appPrimaryColor || self.defaultStyle ? appPrimaryColor : [BRUIStyle defaultStyle].appPrimaryColor);
}

- (UIColor *)appBodyColor {
	return (appBodyColor || self.defaultStyle ? appBodyColor : [BRUIStyle defaultStyle].appBodyColor);
}

- (UIColor *)appSeparatorColor {
	return (appSeparatorColor || self.defaultStyle ? appSeparatorColor : [BRUIStyle defaultStyle].appSeparatorColor);
}

- (UIColor *)inverseAppPrimaryColor {
	return (inverseAppPrimaryColor || self.defaultStyle ? inverseAppPrimaryColor : [BRUIStyle defaultStyle].inverseAppPrimaryColor);
}

#pragma mark - Text

- (UIColor *)textColor {
	return (textColor || self.defaultStyle ? textColor : [BRUIStyle defaultStyle].textColor);
}

- (UIColor *)textShadowColor {
	return (textShadowColor || self.defaultStyle ? textShadowColor : [BRUIStyle defaultStyle].textShadowColor);
}

- (UIColor *)secondaryColor {
	return (secondaryColor || self.defaultStyle ? secondaryColor : [BRUIStyle defaultStyle].secondaryColor);
}

- (UIColor *)captionColor {
	return (captionColor || self.defaultStyle ? captionColor : [BRUIStyle defaultStyle].captionColor);
}

- (UIColor *)inverseTextColor {
	return (inverseTextColor || self.defaultStyle ? inverseTextColor : [BRUIStyle defaultStyle].inverseTextColor);
}

- (UIColor *)inverseTextShadowColor {
	return (inverseTextShadowColor || self.defaultStyle ? inverseTextShadowColor : [BRUIStyle defaultStyle].inverseTextShadowColor);
}

- (UIColor *)inverseSecondaryColor {
	return (inverseSecondaryColor || self.defaultStyle ? inverseSecondaryColor : [BRUIStyle defaultStyle].inverseSecondaryColor);
}

- (UIColor *)inverseCaptionColor {
	return (inverseCaptionColor || self.defaultStyle ? inverseCaptionColor : [BRUIStyle defaultStyle].inverseCaptionColor);
}

#pragma mark - Controls

- (UIColor *)controlTextColor {
	return (controlTextColor || self.defaultStyle ? controlTextColor : [BRUIStyle defaultStyle].controlTextColor);
}

- (UIColor *)controlBorderColor {
	return (controlBorderColor || self.defaultStyle ? controlBorderColor : [BRUIStyle defaultStyle].controlBorderColor);
}

- (UIColor *)controlBorderGlossColor {
	return (controlBorderGlossColor || self.defaultStyle ? controlBorderGlossColor : [BRUIStyle defaultStyle].controlBorderGlossColor);
}

- (UIColor *)controlHighlightedColor {
	return (controlHighlightedColor || self.defaultStyle ? controlHighlightedColor : [BRUIStyle defaultStyle].controlHighlightedColor);
}

- (UIColor *)controlHighlightedShadowColor {
	return (controlHighlightedShadowColor || self.defaultStyle ? controlHighlightedShadowColor : [BRUIStyle defaultStyle].controlHighlightedShadowColor);
}

- (UIColor *)controlSelectedColor {
	return (controlSelectedColor || self.defaultStyle ? controlSelectedColor : [BRUIStyle defaultStyle].controlSelectedColor);
}

- (UIColor *)controlDisabledColor {
	return (controlDisabledColor || self.defaultStyle ? controlDisabledColor : [BRUIStyle defaultStyle].controlDisabledColor);
}

- (UIColor *)controlDangerColor {
	return (controlDangerColor || self.defaultStyle ? controlDangerColor : [BRUIStyle defaultStyle].controlDangerColor);
}

- (UIColor *)inverseControlTextColor {
	return (inverseControlTextColor || self.defaultStyle ? inverseControlTextColor : [BRUIStyle defaultStyle].inverseControlTextColor);
}

- (UIColor *)inverseControlBorderColor {
	return (inverseControlBorderColor || self.defaultStyle ? inverseControlBorderColor : [BRUIStyle defaultStyle].inverseControlBorderColor);
}

- (UIColor *)inverseControlBorderGlossColor {
	return (inverseControlBorderGlossColor || self.defaultStyle ? inverseControlBorderGlossColor : [BRUIStyle defaultStyle].inverseControlBorderGlossColor);
}

- (UIColor *)inverseControlHighlightedColor {
	return (inverseControlHighlightedColor || self.defaultStyle ? inverseControlHighlightedColor : [BRUIStyle defaultStyle].inverseControlHighlightedColor);
}

- (UIColor *)inverseControlHighlightedShadowColor {
	return (inverseControlHighlightedShadowColor || self.defaultStyle ? inverseControlHighlightedShadowColor : [BRUIStyle defaultStyle].inverseControlHighlightedShadowColor);
}

- (UIColor *)inverseControlSelectedColor {
	return (inverseControlSelectedColor || self.defaultStyle ? inverseControlSelectedColor : [BRUIStyle defaultStyle].inverseControlSelectedColor);
}

- (UIColor *)inverseControlDisabledColor {
	return (inverseControlDisabledColor || self.defaultStyle ? inverseControlDisabledColor : [BRUIStyle defaultStyle].inverseControlDisabledColor);
}

#pragma mark - Fonts

- (UIFont *)uiFont {
	return (uiFont || self.defaultStyle ? uiFont : [BRUIStyle defaultStyle].uiFont);
}

- (UIFont *)uiBoldFont {
	return (uiBoldFont || self.defaultStyle ? uiBoldFont : [BRUIStyle defaultStyle].uiBoldFont);
}

- (UIFont *)heroFont {
	return (heroFont || self.defaultStyle ? heroFont : [BRUIStyle defaultStyle].heroFont);
}

- (UIFont *)headlineFont {
	return (headlineFont || self.defaultStyle ? headlineFont : [BRUIStyle defaultStyle].headlineFont);
}

- (UIFont *)secondaryFont {
	return (secondaryFont || self.defaultStyle ? secondaryFont : [BRUIStyle defaultStyle].secondaryFont);
}

- (UIFont *)captionFont {
	return (captionFont || self.defaultStyle ? captionFont : [BRUIStyle defaultStyle].captionFont);
}

- (UIFont *)listFont {
	return (listFont || self.defaultStyle ? listFont : [BRUIStyle defaultStyle].listFont);
}

- (UIFont *)listSecondaryFont {
	return (listSecondaryFont || self.defaultStyle ? listSecondaryFont : [BRUIStyle defaultStyle].listSecondaryFont);
}

- (UIFont *)listCaptionFont {
	return (listCaptionFont || self.defaultStyle ? listCaptionFont : [BRUIStyle defaultStyle].listCaptionFont);
}

- (UIFont *)alertBodyFont {
	return (alertBodyFont || self.defaultStyle ? alertBodyFont : [BRUIStyle defaultStyle].alertBodyFont);
}

- (UIFont *)alertHeadlineFont {
	return (alertHeadlineFont || self.defaultStyle ? alertHeadlineFont : [BRUIStyle defaultStyle].alertHeadlineFont);
}

@end

#pragma BRMutableUIStyle support

@implementation BRMutableUIStyle

@dynamic appPrimaryColor, inverseAppPrimaryColor;
@dynamic appBodyColor, appSeparatorColor;

@dynamic textColor, inverseTextColor;
@dynamic secondaryColor, inverseSecondaryColor;
@dynamic captionColor, inverseCaptionColor;
@dynamic textShadowColor, inverseTextShadowColor;

@dynamic controlTextColor, inverseControlTextColor;
@dynamic controlBorderColor, inverseControlBorderColor;
@dynamic controlBorderGlossColor, inverseControlBorderGlossColor;
@dynamic controlHighlightedColor, inverseControlHighlightedColor;
@dynamic controlHighlightedShadowColor, inverseControlHighlightedShadowColor;
@dynamic controlSelectedColor, inverseControlSelectedColor;
@dynamic controlDisabledColor, inverseControlDisabledColor;
@dynamic controlDangerColor;

@dynamic uiFont, uiBoldFont;
@dynamic bodyFont, titleFont;
@dynamic heroFont;
@dynamic headlineFont;
@dynamic secondaryFont;
@dynamic captionFont;

@dynamic listFont;
@dynamic listSecondaryFont;
@dynamic listCaptionFont;

@dynamic alertBodyFont;
@dynamic alertHeadlineFont;

- (id)copyWithZone:(NSZone *)zone {
	return [[BRUIStyle allocWithZone:zone] initWithUIStyle:self];
}

@end