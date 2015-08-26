//
//  BRUIStyleMappingRestKitTests.m
//  BRStyle
//
//  Created by Matt on 3/08/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRUIStyle.h"

@interface BRUIStyleSettingsTests : XCTestCase

@end

@implementation BRUIStyleSettingsTests

- (void)testFontGetters {
	BRUIStyleFontSettings *settings = [BRUIStyleFontSettings new];
	assertThat(settings.actionFont, notNilValue());
	assertThat(settings.formFont, notNilValue());
	assertThat(settings.navigationFont, notNilValue());
	assertThat(settings.alertHeadlineFont, notNilValue());
	assertThat(settings.alertFont, notNilValue());
		
	assertThat(settings.heroFont, notNilValue());
	assertThat(settings.headlineFont, notNilValue());
	assertThat(settings.secondaryHeadlineFont, notNilValue());
	assertThat(settings.textFont, notNilValue());
	assertThat(settings.captionFont, notNilValue());
		
	assertThat(settings.listFont, notNilValue());
	assertThat(settings.listSecondaryFont, notNilValue());
	assertThat(settings.listCaptionFont, notNilValue());
}

- (void)testFontCopy {
	BRUIStyleFontSettings *settings = [BRUIStyleFontSettings new];
	BRUIStyleFontSettings *copy = [settings copy];
	assertThat(copy, sameInstance(settings));
}

- (void)testMutableCopy {
	BRUIStyleFontSettings *settings = [BRUIStyleFontSettings new];
	BRMutableUIStyleFontSettings *copy = [settings mutableCopy];
	assertThat(copy, isNot(sameInstance(settings)));
	assertThat(copy, isA([BRMutableUIStyleFontSettings class]));
	
	// change a value
	UIFont *actionFont = copy.actionFont;
	UIFont *newActionFont = [UIFont boldSystemFontOfSize:123];
	assertThat(newActionFont, isNot(sameInstance(actionFont)));
	copy.actionFont = newActionFont;
	UIFont *setActionFont = copy.actionFont;
	assertThat(setActionFont, sameInstance(newActionFont));
	assertThat(settings.actionFont, sameInstance(actionFont));
}

- (void)testControlColorGetters {
	BRUIStyleControlColorSettings *settings = [BRUIStyleControlColorSettings new];
	assertThat(settings.actionColor, notNilValue());
	assertThat(settings.borderColor, notNilValue());
	assertThat(settings.glossColor, notNilValue());
	assertThat(settings.shadowColor, notNilValue());
}

- (void)testControlColorCopy {
	BRUIStyleControlColorSettings *settings = [BRUIStyleControlColorSettings new];
	BRUIStyleControlColorSettings *copy = [settings copy];
	assertThat(copy, sameInstance(settings));
}

- (void)testControlColorMutableCopy {
	BRUIStyleControlColorSettings *settings = [BRUIStyleControlColorSettings new];
	BRMutableUIStyleControlColorSettings *copy = [settings mutableCopy];
	assertThat(copy, isNot(sameInstance(settings)));
	assertThat(copy, isA([BRMutableUIStyleControlColorSettings class]));
	
	// change a value
	UIColor *origValue = copy.actionColor;
	UIColor *newValue = [UIColor colorWithWhite:0.1 alpha:0.123];
	assertThat(newValue, isNot(sameInstance(origValue)));
	copy.actionColor = newValue;
	UIColor *setValue = copy.actionColor;
	assertThat(setValue, sameInstance(newValue));
	assertThat(settings.actionColor, sameInstance(origValue));
}

@end
