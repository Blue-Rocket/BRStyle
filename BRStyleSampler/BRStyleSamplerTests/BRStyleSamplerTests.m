//
//  BRStyleSamplerTests.m
//  BRStyleSamplerTests
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import <BRStyle/BRStyle.h>
#import "StyleController.h"

@interface BRStyleSamplerTests : XCTestCase

@end

@implementation BRStyleSamplerTests {
	BRMutableUIStyle *style;
	StyleController *controller;
}

- (void)setUp {
	[super setUp];
	style = [[BRUIStyle defaultStyle] mutableCopy];
	controller = [[StyleController alloc] initWithStyle:style];
}

- (void)testSectionCount {
	assertThatInteger([controller numberOfSections], equalToInteger(3));
}

- (void)testColorsSectionTitle {
	assertThat([controller titleForSection:0], equalTo(@"Colors"));
}

- (void)testColorsSectionCount {
	assertThatInteger([controller numberOfItemsInSection:0], equalToInteger(12));
}

- (void)testColorsSectionItemTitle {
	assertThat([controller titleForStyleItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]], equalTo(@"Background Color"));
}

- (void)testColorsSectionItemValue {
	UIColor *val = [controller styleItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
	assertThat(style.colors.backgroundColor, sameInstance(val));
}

- (void)testFontsSectionTitle {
	assertThat([controller titleForSection:1], equalTo(@"Fonts"));
}

- (void)testFontsSectionCount {
	assertThatInteger([controller numberOfItemsInSection:2], equalToInteger(5));
}

- (void)testFontsSectionItemTitle {
	assertThat([controller titleForStyleItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]], equalTo(@"Action Font"));
}

- (void)testFontsSectionItemValue {
	UIFont *val = [controller styleItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
	assertThat(style.fonts.actionFont, sameInstance(val));
}


@end
