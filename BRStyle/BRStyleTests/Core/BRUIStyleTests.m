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

@end
