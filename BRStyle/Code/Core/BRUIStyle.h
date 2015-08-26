//
//  BRUIStyle.h
//  BRStyle
//
//  Created by Matt on 21/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRUIStyleSettings.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A notification sent when the default BRUIStyle instance changes. The sender will be the 
 new BRUIStyle instance.
 */
extern NSString * const BRStyleNotificationUIStyleDidChange;

/**
 Encapsulation of style attributes used for drawing BR UI components.
 */
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

/** The font style settings. */
@property (nonatomic, readonly) BRUIStyleFontSettings *fonts;

/** The color style settings. */
@property (nonatomic, readonly) BRUIStyleColorSettings *colors;

@end

#pragma mark - Mutable support

@interface BRMutableUIStyle : BRUIStyle

/** The font style settings. */
@property (nonatomic, readwrite) BRMutableUIStyleFontSettings *fonts;

/** The color style settings. */
@property (nonatomic, readwrite) BRMutableUIStyleColorSettings *colors;

@end

NS_ASSUME_NONNULL_END
