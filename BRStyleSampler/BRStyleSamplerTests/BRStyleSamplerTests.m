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
	assertThatInteger([controller numberOfSections], equalToInteger(7));
}

- (void)testColorsSectionTitle {
	assertThat([controller titleForSection:0], equalTo(@"Colors"));
}

- (void)testColorsSectionCount {
	assertThatInteger([controller numberOfItemsInSection:0], equalToInteger(15));
}

- (void)testColorsSectionItemTitle {
	assertThat([controller titleForStyleItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]], equalTo(@"Alert Background Color"));
}

- (void)testColorsSectionItemValue {
	UIColor *val = [controller styleItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
	assertThat(style.colors.alertBackgroundColor, sameInstance(val));
}

- (void)testFontsSectionTitle {
	assertThat([controller titleForSection:6], equalTo(@"Fonts"));
}

- (void)testFontsSectionCount {
	assertThatInteger([controller numberOfItemsInSection:6], equalToInteger(13));
}

- (void)testFontsSectionItemTitle {
	assertThat([controller titleForStyleItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:6]], equalTo(@"Action Font"));
}

- (void)testFontsSectionItemValue {
	UIFont *val = [controller styleItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:6]];
	assertThat(style.fonts.actionFont, sameInstance(val));
}


@end
