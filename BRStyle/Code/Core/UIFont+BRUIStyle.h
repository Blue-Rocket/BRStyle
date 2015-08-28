//
//  UIFont+BRUIStyle.h
//  BRStyle
//
//  Created by Matt on 28/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Enumeration of CSS font constant and relative keywords.
 */
typedef enum : int {
	
	/** Normal font weight. */
	BRUIStyleCSSFontWeightNormal = 400,
	
	/** Bold font weight. */
	BRUIStyleCSSFontWeightBold = 700,
	
	/** Relative bolder font weight. */
	BRUIStyleCSSFontWeightBolder = -900,
	
	/** Relative lighter font weight. */
	BRUIStyleCSSFontWeightLighter = -1100,
	
} BRUIStyleCSSFontWeight;

/**
 Utilities for dealing with fonts.
 */
@interface UIFont (BRUIStyle)

/**
 Convert a CSS weight value from a UIFont weight value.
 
 @param fontWeight A UIFont weight value, e.g. something between -1 and 1.
 @return The equivalent CSS font weight value.
 */
+ (BRUIStyleCSSFontWeight)uiStyleCSSFontWeightForFontWeight:(CGFloat)fontWeight;

/**
 Convert a UIFont weight value from a CSS weight value.
 
 @param fontWeight A weight constant. Relative weight values are not supported.
 @return The equivalent UIFont font weight value.
 */
+ (CGFloat)fontWeightForUIStyleCSSFontWeight:(BRUIStyleCSSFontWeight)weight;

/**
 Get a version of the receiver with the weight adjusted to a CSS weight value.
 
 @param weight A CSS weight value.
 @return A matching UIFont instance.
 */
- (UIFont *)fontWithUIStyleCSSFontWeight:(BRUIStyleCSSFontWeight)weight;

/**
 Get the receiver's CSS weight value.
 
 @return The CSS weight value.
 */
- (BRUIStyleCSSFontWeight)uiStyleCSSFontWeight;

@end
