//
//  BRUIStyleTests.m
//  BRStyle
//
//  Created by Matt on 27/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRUIStyle.h"

@interface BRUIStyleTests : XCTestCase

@end

@implementation BRUIStyleTests

- (void)testColorIntegerEncode {
	UIColor *color = [UIColor colorWithRed:0.2 green:0.4 blue:0.6 alpha:0.5];
	assertThatUnsignedInt([BRUIStyle rgbIntegerForColor:color], equalToUnsignedInt(0x336699));
	assertThatUnsignedInt([BRUIStyle rgbaHexIntegerForColor:color], equalToUnsignedInt(0x33669980));
}

- (void)testColorRGBIntegerDecode {
	UIColor *color = [BRUIStyle colorWithRGBInteger:0x336699];
	CGFloat r, g, b, a;
	[color getRed:&r green:&g blue:&b alpha:&a];
	assertThatFloat(r, closeTo(0.2, 0.01));
	assertThatFloat(g, closeTo(0.4, 0.01));
	assertThatFloat(b, closeTo(0.6, 0.01));
	assertThatFloat(a, closeTo(1, 0.01));
}

- (void)testColorRGBAIntegerDecode {
	UIColor *color = [BRUIStyle colorWithRGBAInteger:0x33669980];
	CGFloat r, g, b, a;
	[color getRed:&r green:&g blue:&b alpha:&a];
	assertThatFloat(r, closeTo(0.2, 0.01));
	assertThatFloat(g, closeTo(0.4, 0.01));
	assertThatFloat(b, closeTo(0.6, 0.01));
	assertThatFloat(a, closeTo(0.5, 0.01));
}

#pragma mark - 

- (void)testStyleCopy {
	BRUIStyle *style = [BRUIStyle new];
	BRUIStyle *copy = [style copy];
	assertThat(copy, sameInstance(style));
}

- (void)testStyleMutableCopy {
	BRUIStyle *style = [BRUIStyle new];
	BRUIStyleColorSettings *colors = style.colors;
	BRMutableUIStyle *copy = [style mutableCopy];
	assertThat(copy, isNot(sameInstance(style)));
	assertThat(copy, isA([BRMutableUIStyle class]));
	
	// change a value
	BRMutableUIStyleColorSettings *newColors = [colors mutableCopy];
	newColors.primaryColor = [UIColor magentaColor];
	copy.colors = newColors;
	BRUIStyleColorSettings *setColors = copy.colors;
	assertThat(setColors, sameInstance(newColors));
	assertThat(style.colors, sameInstance(colors));
}

#pragma  mark - 

- (void)testGetDefaultStyle {
	BRUIStyle *style = [BRUIStyle defaultStyle];
	assertThat(style, notNilValue());
	assertThatBool(style.defaultStyle, isTrue());
}

- (void)testSetDefaultStyleMutableIsCopied {
	BRUIStyle *style = [BRUIStyle defaultStyle];
	BRMutableUIStyle *newStyle = [style mutableCopy];
	[BRUIStyle setDefaultStyle:newStyle];
	assertThatBool(style.defaultStyle, isFalse());
	assertThatBool(newStyle.defaultStyle, isFalse()); // mutable newStyle should have been copied!
	BRUIStyle *copiedNewStyle = [BRUIStyle defaultStyle];
	assertThat(copiedNewStyle, isA([BRUIStyle class]));
	assertThat(copiedNewStyle, isNot(sameInstance(newStyle)));
	assertThatBool(copiedNewStyle.defaultStyle, isTrue());
}

- (void)testSetDefaultStyle {
	BRUIStyle *style = [BRUIStyle defaultStyle];
	BRUIStyle *newStyle = [[style mutableCopy] copy]; // get mutable copy, then immutable because setDefaultStyle: copies the style
	[BRUIStyle setDefaultStyle:newStyle];
	assertThatBool(style.defaultStyle, isFalse());
	assertThatBool(newStyle.defaultStyle, isTrue());
}

#pragma mark - 

- (void)testDictionaryRepresentation {
	NSDictionary *dict = [[BRUIStyle defaultStyle] dictionaryRepresentation];
	assertThat(dict, hasCountOf(2));
	assertThat(dict[@"colors"], instanceOf([NSDictionary class]));
	assertThat(dict[@"fonts"], instanceOf([NSDictionary class]));
}

- (void)testInitWithDictionary {
	NSDictionary *dict = @{ @"colors" : @{ @"primaryColor" : @"#ff0000ff", @"backgroundColor" : [NSNull null] },
							@"fonts" : @{ @"actionFont" : @{ @"name" : @"Helvetica-Regular", @"size" : @12 } } };
	BRUIStyle *style = [BRUIStyle styleWithDictionary:dict];
	BRUIStyleColorSettings *colors = style.colors;
	assertThat(colors, notNilValue());
	assertThatUnsignedInt([BRUIStyle rgbaHexIntegerForColor:colors.primaryColor], equalToUnsignedInt(0xff0000ff));
	assertThat(colors.backgroundColor, nilValue());
}

- (void)testLoadFromJSON {
	BRUIStyle *style = [BRUIStyle styleWithJSONResource:@"style.json" inBundle:[NSBundle bundleForClass:[BRUIStyle class]]];
	BRUIStyleColorSettings *colors = style.colors;
	assertThat(colors, notNilValue());
	assertThatUnsignedInt([BRUIStyle rgbaHexIntegerForColor:colors.primaryColor], equalToUnsignedInt(0xff0000ff));
	assertThat(colors.backgroundColor, nilValue());
}

- (void)foo {
	BRMutableUIStyle *mutableStyle = [BRMutableUIStyle new];
	BRMutableUIStyleColorSettings *colors = [BRMutableUIStyleColorSettings new];
	colors.primaryColor = [UIColor blueColor];
	BRMutableUIStyleFontSettings *fonts = [BRMutableUIStyleFontSettings new];
	fonts.actionFont = [UIFont systemFontOfSize:15];
	[BRUIStyle setDefaultStyle:mutableStyle];
}

@end
