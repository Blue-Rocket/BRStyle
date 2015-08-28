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

- (void)testWeightNormalVariation {
	UIFont *f = [UIFont fontWithName:@"HelveticaNeue" size:12];
	
	assertThat([f fontWithUIStyleCSSFontWeight:100].fontName, equalTo(@"HelveticaNeue-UltraLight"));

	assertThat([f fontWithUIStyleCSSFontWeight:200].fontName, equalTo(@"HelveticaNeue-Thin"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:300].fontName, equalTo(@"HelveticaNeue-Light"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:400], sameInstance(f));
	
	assertThat([f fontWithUIStyleCSSFontWeight:500].fontName, equalTo(@"HelveticaNeue-Medium"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:600].fontName, equalTo(@"HelveticaNeue-Medium"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:700].fontName, equalTo(@"HelveticaNeue-Bold"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:800].fontName, equalTo(@"HelveticaNeue-Bold"));
	
	// the following should return -Bold, NOT -CondensedBlack
	assertThat([f fontWithUIStyleCSSFontWeight:900].fontName, equalTo(@"HelveticaNeue-Bold"));
}

- (void)testWeightItalicVariation {
	UIFont *f = [UIFont fontWithName:@"HelveticaNeue-Italic" size:12];
	
	assertThat([f fontWithUIStyleCSSFontWeight:100].fontName, equalTo(@"HelveticaNeue-UltraLightItalic"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:200].fontName, equalTo(@"HelveticaNeue-ThinItalic"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:300].fontName, equalTo(@"HelveticaNeue-LightItalic"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:400], sameInstance(f));
	
	assertThat([f fontWithUIStyleCSSFontWeight:500].fontName, equalTo(@"HelveticaNeue-MediumItalic"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:600].fontName, equalTo(@"HelveticaNeue-MediumItalic"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:700].fontName, equalTo(@"HelveticaNeue-BoldItalic"));
	
	assertThat([f fontWithUIStyleCSSFontWeight:800].fontName, equalTo(@"HelveticaNeue-BoldItalic"));
	
	// the following should return -Bold, NOT -CondensedBlack
	assertThat([f fontWithUIStyleCSSFontWeight:900].fontName, equalTo(@"HelveticaNeue-BoldItalic"));
}

- (void)testWeightCondensedVariation {
	UIFont *f = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12];
	
	assertThat([f fontWithUIStyleCSSFontWeight:100], sameInstance(f));
	
	assertThat([f fontWithUIStyleCSSFontWeight:200], sameInstance(f));
	
	assertThat([f fontWithUIStyleCSSFontWeight:300], sameInstance(f));
	
	assertThat([f fontWithUIStyleCSSFontWeight:400], sameInstance(f));
	
	assertThat([f fontWithUIStyleCSSFontWeight:500], sameInstance(f));
	
	assertThat([f fontWithUIStyleCSSFontWeight:600], sameInstance(f));
	
	assertThat([f fontWithUIStyleCSSFontWeight:700], sameInstance(f));
	
	assertThat([f fontWithUIStyleCSSFontWeight:800], sameInstance(f));
	
	assertThat([f fontWithUIStyleCSSFontWeight:900].fontName, equalTo(@"HelveticaNeue-CondensedBlack"));
}

@end
