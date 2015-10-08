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
#import "UIControl+BRUIStyle.h"

@interface BRUIStyleTests : XCTestCase

@end

@implementation BRUIStyleTests

- (void)testColorIntegerEncode {
	UIColor *color = [UIColor colorWithRed:0.2 green:0.4 blue:0.6 alpha:0.5];
	assertThatUnsignedInt([BRUIStyle rgbIntegerForColor:color], equalToUnsignedInt(0x336699));
	assertThatUnsignedInt([BRUIStyle rgbaIntegerForColor:color], equalToUnsignedInt(0x33669980));
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

- (void)testStyleMutableProperties {
	BRUIStyle *style = [BRUIStyle new];
	BRUIStyle *copy = [style mutableCopy];
	assertThat(copy, isNot(sameInstance(style)));
	assertThat(copy, isA([BRMutableUIStyle class]));
	assertThat(copy.fonts, isA([BRMutableUIStyleFontSettings class]));
	assertThat(copy.colors, isA([BRMutableUIStyleColorSettings class]));
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
	assertThat(dict, hasCountOf(3));
	assertThat(dict[@"colors"], instanceOf([NSDictionary class]));
	assertThat(dict[@"fonts"], instanceOf([NSDictionary class]));
	assertThat(dict[@"controls"], instanceOf([NSDictionary class]));
}

- (void)testInitWithDictionary {
	NSDictionary *dict = @{ @"colors" : @{ @"primaryColor" : @"#ff0000ff", @"backgroundColor" : [NSNull null] },
							@"fonts" : @{ @"actionFont" : @{ @"name" : @"Helvetica-Regular", @"size" : @12 } } };
	BRUIStyle *style = [BRUIStyle styleWithDictionary:dict];
	BRUIStyleColorSettings *colors = style.colors;
	assertThat(colors, notNilValue());
	assertThatUnsignedInt([BRUIStyle rgbaIntegerForColor:colors.primaryColor], equalToUnsignedInt(0xff0000ff));
	assertThat(colors.backgroundColor, nilValue());
}

- (void)testLoadFromJSON {
	BRUIStyle *style = [BRUIStyle styleWithJSONResource:@"style.json" inBundle:[NSBundle bundleForClass:[BRUIStyle class]]];
	BRUIStyleColorSettings *colors = style.colors;
	assertThat(colors, notNilValue());
	assertThatUnsignedInt([BRUIStyle rgbaIntegerForColor:colors.primaryColor], equalToUnsignedInt(0xff0000ff));
	assertThat(colors.backgroundColor, nilValue());
}

- (void)testLoadSetsFromJSON {
	NSDictionary<NSString *, BRUIStyle *> *styles = [BRUIStyle stylesWithJSONResource:@"styles.json" inBundle:[NSBundle bundleForClass:[BRUIStyle class]]];
	assertThat(styles, hasCountOf(4));
	assertThat([styles allKeys], containsInAnyOrder(@"default", @"controls-highlighted", @"controls-dangerous", @"controls-dangerous|highlighted", nil));
	
	[styles enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, BRUIStyle * _Nonnull obj, BOOL * _Nonnull stop) {
		assertThat(obj, isA([BRUIStyle class]));
	}];
	
	// verify a few individual settings
	BRUIStyle *defaultStyle = styles[@"default"];
	assertThatUnsignedInteger([BRUIStyle rgbaIntegerForColor:defaultStyle.controls.actionColor], equalToUnsignedInteger(0x0000ccff));
	
	BRUIStyle *dangerousStyle = styles[@"controls-dangerous"];
	assertThatUnsignedInteger([BRUIStyle rgbaIntegerForColor:dangerousStyle.controls.actionColor], equalToUnsignedInteger(0xcc0000ff));
	
	BRUIStyle *dangerousHighlightedStyle = styles[@"controls-dangerous|highlighted"];
	assertThatUnsignedInteger([BRUIStyle rgbaIntegerForColor:dangerousHighlightedStyle.controls.fillColor], equalToUnsignedInteger(0xcc000033));
}

- (void)testRegisterDefaultsSetsFromJSON {
	NSDictionary<NSString *, BRUIStyle *> *styles = [BRUIStyle registerDefaultStylesWithJSONResource:@"styles.json" inBundle:[NSBundle bundleForClass:[BRUIStyle class]]];
	
	assertThat(styles, hasCountOf(4));
	assertThat([styles allKeys], containsInAnyOrder(@"default", @"controls-highlighted", @"controls-dangerous", @"controls-dangerous|highlighted", nil));

	// verify a few individual settings
	BRUIStyle *defaultStyle = [BRUIStyle defaultStyle];
	assertThat(styles[@"default"], sameInstance(defaultStyle));
	assertThatUnsignedInteger([BRUIStyle rgbaIntegerForColor:defaultStyle.controls.actionColor], equalToUnsignedInteger(0x0000ccff));
	assertThatUnsignedInteger([BRUIStyle rgbaIntegerForColor:defaultStyle.controls.glossColor], equalToUnsignedInteger(0xffffff33));
	
	BRUIStyle *dangerousStyle = [UIControl defaultUiStyleForState:BRUIStyleControlStateDangerous];
	assertThat(dangerousStyle, notNilValue());
	assertThat(dangerousStyle, sameInstance(styles[@"controls-dangerous"]));
	assertThatUnsignedInteger([BRUIStyle rgbaIntegerForColor:dangerousStyle.controls.actionColor], equalToUnsignedInteger(0xcc0000ff));
	assertThat(dangerousStyle.controls.glossColor,
							  describedAs(@"Should inherit gloss from default style", equalTo(defaultStyle.controls.glossColor), nil));
	
	BRUIStyle *dangerousHighlightedStyle = [UIControl defaultUiStyleForState:(BRUIStyleControlStateDangerous|UIControlStateHighlighted)];
	assertThat(dangerousHighlightedStyle, notNilValue());
	assertThat(dangerousHighlightedStyle, sameInstance(styles[@"controls-dangerous|highlighted"]));
	assertThatUnsignedInteger([BRUIStyle rgbaIntegerForColor:dangerousHighlightedStyle.controls.actionColor], equalToUnsignedInteger(0xcc0000ff));
	assertThat(dangerousHighlightedStyle.controls.glossColor,
							  describedAs(@"Should inherit gloss from default style", equalTo(defaultStyle.controls.glossColor), nil));
}

@end
