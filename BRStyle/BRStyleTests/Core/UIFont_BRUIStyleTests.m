//
//  UIFont_BRUIStyleTests.m
//  BRStyle
//
//  Created by Matt on 28/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "UIFont+BRUIStyle.h"

@interface UIFont_BRUIStyleTests : XCTestCase

@end

@implementation UIFont_BRUIStyleTests

- (void)testConvertFontWeightsToCSSWeights {
	BRUIStyleCSSFontWeight w;
	
	w = [UIFont uiStyleCSSFontWeightForFontWeight:-1];
	assertThatInt(w, equalToInt(100));

	w = [UIFont uiStyleCSSFontWeightForFontWeight:-0.75];
	assertThatInt(w, equalToInt(200));
	
	w = [UIFont uiStyleCSSFontWeightForFontWeight:-0.5];
	assertThatInt(w, equalToInt(300));
	
	w = [UIFont uiStyleCSSFontWeightForFontWeight:-0.25];
	assertThatInt(w, equalToInt(400));
	
	w = [UIFont uiStyleCSSFontWeightForFontWeight:0];
	assertThatInt(w, equalToInt(500));
	
	w = [UIFont uiStyleCSSFontWeightForFontWeight:0.25];
	assertThatInt(w, equalToInt(600));
	
	w = [UIFont uiStyleCSSFontWeightForFontWeight:0.50];
	assertThatInt(w, equalToInt(700));
	
	w = [UIFont uiStyleCSSFontWeightForFontWeight:0.75];
	assertThatInt(w, equalToInt(800));
	
	w = [UIFont uiStyleCSSFontWeightForFontWeight:1];
	assertThatInt(w, equalToInt(900));
}

- (void)testConvertCSSWeightsToFontWeights {
	CGFloat w;
	
	w = [UIFont fontWeightForUIStyleCSSFontWeight:100];
	assertThatFloat(w, closeTo(-1.0, 0.001));
	
	w = [UIFont fontWeightForUIStyleCSSFontWeight:200];
	assertThatFloat(w, closeTo(-0.75, 0.001));
	
	w = [UIFont fontWeightForUIStyleCSSFontWeight:300];
	assertThatFloat(w, closeTo(-0.5, 0.001));
	
	w = [UIFont fontWeightForUIStyleCSSFontWeight:400];
	assertThatFloat(w, closeTo(-0.25, 0.001));
	
	w = [UIFont fontWeightForUIStyleCSSFontWeight:500];
	assertThatFloat(w, closeTo(0, 0.001));
	
	w = [UIFont fontWeightForUIStyleCSSFontWeight:600];
	assertThatFloat(w, closeTo(0.25, 0.001));
	
	w = [UIFont fontWeightForUIStyleCSSFontWeight:700];
	assertThatFloat(w, closeTo(0.5, 0.001));
	
	w = [UIFont fontWeightForUIStyleCSSFontWeight:800];
	assertThatFloat(w, closeTo(0.75, 0.001));
	
	w = [UIFont fontWeightForUIStyleCSSFontWeight:900];
	assertThatFloat(w, closeTo(1.0, 0.001));
}

- (void)testQueryCSSFontWeightsForSystemFonts {
	UIFont *f;
	
	f = [UIFont systemFontOfSize:12];
	assertThatInt([f uiStyleCSSFontWeight], equalToInt(400));
	
	f = [UIFont boldSystemFontOfSize:12];
	assertThatInt([f uiStyleCSSFontWeight], greaterThanOrEqualTo(@500)); // varies per OS
}

- (void)testQueryCSSFontWeightForHelveticaNeue {
	UIFont *f;
	
	f = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12];
	assertThatInt([f uiStyleCSSFontWeight], equalToInt(100));
	
	f = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12];
	assertThatInt([f uiStyleCSSFontWeight], equalToInt(200));
	
	f = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
	assertThatInt([f uiStyleCSSFontWeight], equalToInt(300));
	
	f = [UIFont fontWithName:@"HelveticaNeue" size:12];
	assertThatInt([f uiStyleCSSFontWeight], equalToInt(400));
	
	f = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
	assertThatInt([f uiStyleCSSFontWeight], equalToInt(500));
	
	f = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
	assertThatInt([f uiStyleCSSFontWeight], equalToInt(700));

	f = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12];
	assertThatInt([f uiStyleCSSFontWeight], equalToInt(700));
	
	f = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:12];
	assertThatInt([f uiStyleCSSFontWeight], equalToInt(900));
}

@end
