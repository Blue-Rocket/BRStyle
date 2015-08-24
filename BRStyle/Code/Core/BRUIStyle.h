//
//  BRUIStyle.h
//  BRStyle
//
//  Created by Matt on 21/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A notification sent when the default BRUIStyle instance changes. The sender will be the 
 new BRUIStyle instance.
 */
extern NSString * const BRNotificationUIStyleDidChange;

/**
 Encapsulation of style attributes used for drawing BR UI components.
 */
IB_DESIGNABLE
@interface BRUIStyle : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

///-------------------------------
/// @name Utilities
///-------------------------------

/**
 Create a @c UIColor instance from a 32-bit RGB hex value.
 
 @param integer The color as a 32-bit RGB hex value. Only the last 24 bits are used.
 @return The color object.
 */
+ (UIColor *)colorWithRGBHexInteger:(UInt32)integer;

/**
 Create a @c UIColor instance from a 32-bit RGBA hex value.
 
 @param integer The color as a 32-bit RGBA hex value.
 @return The color object.
 */
+ (UIColor *)colorWithRGBAHexInteger:(UInt32)integer;

/**
 Create a 32-bit RGB hex value from a @c UIColor instance.
 
 @param color The color to convert.
 @return integer The color as a 32-bit RGB hex value. Only the last 24 bits are used.
 */
+ (UInt32)rgbHexIntegerForColor:(UIColor *)color;

/**
 Create a 32-bit RGBA hex value from a @c UIColor instance.
 
 @param color The color to convert.
 @return integer The color as a 32-bit RGBA hex value.
 */
+ (UInt32)rgbaHexIntegerForColor:(UIColor *)color;

///-------------------------------
/// @name Default support
///-------------------------------

/**
 Get a global shared style instance.
 
 @return A shared global default style instance.
 */
+ (instancetype)defaultStyle;

/**
 Set the global shared style instance.
 
 @param style The new style to set.
 */
+ (void)setDefaultStyle:(BRUIStyle *)style;

/**
 Test if this style represents the default style.
 */
@property (nonatomic, readonly, getter=isDefaultStyle) BOOL defaultStyle;

///-------------------------------
/// @name Structural color styles
///-------------------------------

@property (nonatomic, readonly) UIColor *appPrimaryColor;
@property (nonatomic, readonly) UIColor *appBodyColor;
@property (nonatomic, readonly) UIColor *appSeparatorColor;

@property (nonatomic, readonly) UIColor *inverseAppPrimaryColor;

///-------------------------------
/// @name Text color styles
///-------------------------------

@property (nonatomic, readonly) UIColor *textColor;
@property (nonatomic, readonly) UIColor *textShadowColor;
@property (nonatomic, readonly) UIColor *secondaryColor;
@property (nonatomic, readonly) UIColor *captionColor;

@property (nonatomic, readonly) UIColor *inverseTextColor;
@property (nonatomic, readonly) UIColor *inverseTextShadowColor;
@property (nonatomic, readonly) UIColor *inverseSecondaryColor;
@property (nonatomic, readonly) UIColor *inverseCaptionColor;

///-------------------------------
/// @name Control color styles
///-------------------------------

@property (nonatomic, readonly) UIColor *controlTextColor;
@property (nonatomic, readonly) UIColor *controlBorderColor;
@property (nonatomic, readonly) UIColor *controlBorderGlossColor;
@property (nonatomic, readonly) UIColor *controlHighlightedColor;
@property (nonatomic, readonly) UIColor *controlHighlightedShadowColor;
@property (nonatomic, readonly) UIColor *controlSelectedColor;
@property (nonatomic, readonly) UIColor *controlDisabledColor;
@property (nonatomic, readonly) UIColor *controlDangerColor;

@property (nonatomic, readonly) UIColor *inverseControlTextColor;
@property (nonatomic, readonly) UIColor *inverseControlBorderColor;
@property (nonatomic, readonly) UIColor *inverseControlBorderGlossColor;
@property (nonatomic, readonly) UIColor *inverseControlHighlightedColor;
@property (nonatomic, readonly) UIColor *inverseControlHighlightedShadowColor;
@property (nonatomic, readonly) UIColor *inverseControlSelectedColor;
@property (nonatomic, readonly) UIColor *inverseControlDisabledColor;

///-------------------------------
/// @name Font styles
///-------------------------------

@property (nonatomic, readonly) UIFont *uiFont;
@property (nonatomic, readonly) UIFont *uiBoldFont;

///-------------------------------
/// @name Structural font styles
///-------------------------------

@property (nonatomic, readonly) UIFont *bodyFont;
@property (nonatomic, readonly) UIFont *titleFont;
@property (nonatomic, readonly) UIFont *heroFont;
@property (nonatomic, readonly) UIFont *headlineFont;
@property (nonatomic, readonly) UIFont *secondaryFont;
@property (nonatomic, readonly) UIFont *captionFont;

@property (nonatomic, readonly) UIFont *listFont;
@property (nonatomic, readonly) UIFont *listSecondaryFont;
@property (nonatomic, readonly) UIFont *listCaptionFont;

@property (nonatomic, readonly) UIFont *alertBodyFont;
@property (nonatomic, readonly) UIFont *alertHeadlineFont;

@end

@interface BRMutableUIStyle : BRUIStyle

///-------------------------------
/// @name Structural color styles
///-------------------------------

@property (nonatomic, readwrite) UIColor *appPrimaryColor;
@property (nonatomic, readwrite) UIColor *appBodyColor;
@property (nonatomic, readwrite) UIColor *appSeparatorColor;

@property (nonatomic, readwrite) UIColor *inverseAppPrimaryColor;

///-------------------------------
/// @name Text color styles
///-------------------------------

@property (nonatomic, readwrite) UIColor *textColor;
@property (nonatomic, readwrite) UIColor *textShadowColor;
@property (nonatomic, readwrite) UIColor *secondaryColor;
@property (nonatomic, readwrite) UIColor *captionColor;

@property (nonatomic, readwrite) UIColor *inverseTextColor;
@property (nonatomic, readwrite) UIColor *inverseTextShadowColor;
@property (nonatomic, readwrite) UIColor *inverseSecondaryColor;
@property (nonatomic, readwrite) UIColor *inverseCaptionColor;

///-------------------------------
/// @name Control color styles
///-------------------------------

@property (nonatomic, readwrite) UIColor *controlTextColor;
@property (nonatomic, readwrite) UIColor *controlBorderColor;
@property (nonatomic, readwrite) UIColor *controlBorderGlossColor;
@property (nonatomic, readwrite) UIColor *controlHighlightedColor;
@property (nonatomic, readwrite) UIColor *controlHighlightedShadowColor;
@property (nonatomic, readwrite) UIColor *controlSelectedColor;
@property (nonatomic, readwrite) UIColor *controlDisabledColor;
@property (nonatomic, readwrite) UIColor *controlDangerColor;

@property (nonatomic, readwrite) UIColor *inverseControlTextColor;
@property (nonatomic, readwrite) UIColor *inverseControlBorderColor;
@property (nonatomic, readwrite) UIColor *inverseControlBorderGlossColor;
@property (nonatomic, readwrite) UIColor *inverseControlHighlightedColor;
@property (nonatomic, readwrite) UIColor *inverseControlHighlightedShadowColor;
@property (nonatomic, readwrite) UIColor *inverseControlSelectedColor;
@property (nonatomic, readwrite) UIColor *inverseControlDisabledColor;

///-------------------------------
/// @name UI font styles
///-------------------------------

@property (nonatomic, readwrite) UIFont *uiFont;
@property (nonatomic, readwrite) UIFont *uiBoldFont;

///-------------------------------
/// @name Structural font styles
///-------------------------------

@property (nonatomic, readwrite) UIFont *bodyFont;
@property (nonatomic, readwrite) UIFont *titleFont;
@property (nonatomic, readwrite) UIFont *heroFont;
@property (nonatomic, readwrite) UIFont *headlineFont;
@property (nonatomic, readwrite) UIFont *secondaryFont;
@property (nonatomic, readwrite) UIFont *captionFont;

@property (nonatomic, readwrite) UIFont *listFont;
@property (nonatomic, readwrite) UIFont *listSecondaryFont;
@property (nonatomic, readwrite) UIFont *listCaptionFont;

@property (nonatomic, readwrite) UIFont *alertBodyFont;
@property (nonatomic, readwrite) UIFont *alertHeadlineFont;

@end

/**
 A protocol for objects that support styling via BRUIStylish to conform to.
 */
@protocol BRUIStylish <NSObject>

/** A BRUIStyle object to use. If not configured, the global default style should be returned. */
@property (nonatomic, strong, null_resettable) IBOutlet BRUIStyle *uiStyle;

@end

NS_ASSUME_NONNULL_END
