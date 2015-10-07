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

- (void)testFontMutableCopy {
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

- (void)testFontDictionaryRepresentation {
	BRMutableUIStyleFontSettings *settings = [BRMutableUIStyleFontSettings new];
	settings.heroFont = [UIFont systemFontOfSize:24];
	NSDictionary *result = [settings dictionaryRepresentation];
	assertThat(result, hasCountOf(11));
	assertThat(result[@"actionFont"], instanceOf([NSDictionary class]));
	assertThat(result[@"actionFont"], equalTo(@{@"name" : @"AvenirNext-Medium", @"size" : @15}));
	assertThat(result[@"heroFont"], instanceOf([NSDictionary class]));
	assertThat(result[@"heroFont"], equalTo(@{@"size" : @24}));
}

- (void)testFontInitWithDictionary {
	NSDictionary *dict = @{ @"actionFont" : @{@"name" : @"AvenirNext-Regular", @"size" : @12},
							@"heroFont" : @{@"size" : @24} };
	BRUIStyleFontSettings *settings = [[BRUIStyleFontSettings alloc] initWithDictionaryRepresentation:dict];
	assertThat(settings.actionFont, equalTo([UIFont fontWithName:@"AvenirNext-Regular" size:12]));
	assertThat(settings.heroFont, equalTo([UIFont systemFontOfSize:24]));
}

#pragma mark -

- (void)testColorsMutableCopy {
	BRUIStyleColorSettings *settings = [BRUIStyleColorSettings new];
	BRMutableUIStyleColorSettings *copy = [settings mutableCopy];
	assertThat(copy, isNot(sameInstance(settings)));
	assertThat(copy, isA([BRMutableUIStyleColorSettings class]));
}

#pragma mark -

- (void)testControlColorGetters {
	BRUIStyleControlSettings *settings = [BRUIStyleControlSettings new];
	assertThat(settings.actionColor, notNilValue());
	assertThat(settings.borderColor, notNilValue());
	assertThat(settings.glossColor, notNilValue());
	assertThat(settings.shadowColor, nilValue());
	assertThat(settings.shadow, nilValue());
	assertThat(settings.textShadow, nilValue());
}

- (void)testControlColorCopy {
	BRUIStyleControlSettings *settings = [BRUIStyleControlSettings new];
	BRUIStyleControlSettings *copy = [settings copy];
	assertThat(copy, sameInstance(settings));
}

- (void)testControlColorMutableCopy {
	BRUIStyleControlSettings *settings = [BRUIStyleControlSettings new];
	BRMutableUIStyleControlSettings *copy = [settings mutableCopy];
	assertThat(copy, isNot(sameInstance(settings)));
	assertThat(copy, isA([BRMutableUIStyleControlSettings class]));
	
	// change a value
	UIColor *origValue = copy.actionColor;
	UIColor *newValue = [UIColor colorWithWhite:0.1 alpha:0.123];
	assertThat(newValue, isNot(sameInstance(origValue)));
	copy.actionColor = newValue;
	UIColor *setValue = copy.actionColor;
	assertThat(setValue, sameInstance(newValue));
	assertThat(settings.actionColor, sameInstance(origValue));
}

- (void)testControlColorDictionaryRepresentation {
	BRMutableUIStyleControlSettings *settings = [[BRUIStyleControlSettings new] mutableCopy];
	NSShadow *shadow = [NSShadow new];
	shadow.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	shadow.shadowOffset = CGSizeMake(1,2);
	shadow.shadowBlurRadius = 1;
	settings.shadow = shadow;
	settings.textShadow = shadow;
	NSDictionary *result = [settings dictionaryRepresentation];
	assertThat(result, hasCountOf(7));
	assertThat(result[@"actionColor"], equalToIgnoringCase(@"#555555ff"));
	assertThat(result[@"shadowColor"], equalTo([NSNull null]));
	assertThat(result[@"shadow"], instanceOf([NSDictionary class]));
	assertThat(result[@"shadow"][@"color"], equalToIgnoringCase(@"#00000033"));
	assertThat(result[@"shadow"][@"offset"], hasCountOf(2));
	assertThat(result[@"shadow"][@"offset"][0], equalTo(@1));
	assertThat(result[@"shadow"][@"offset"][1], equalTo(@2));
	assertThat(result[@"shadow"][@"blurRadius"], equalTo(@1));
}

- (void)testControlColorInitWithDictionary {
	NSDictionary *dict = @{ @"actionColor" : @"#1247b8ff", @"glossColor" : @"#1247B8FF", @"shadowColor" : [NSNull null],
							@"shadow" : @{@"color" : @"#00000033", @"offset" : @[@1, @2], @"blurRadius" : @1} };
	BRUIStyleControlSettings *settings = [[BRUIStyleControlSettings alloc] initWithDictionaryRepresentation:dict];
	assertThatUnsignedInt([BRUIStyle rgbaIntegerForColor:settings.actionColor], equalToUnsignedInt(0x1247b8ff));
	assertThatUnsignedInt([BRUIStyle rgbaIntegerForColor:settings.glossColor], equalToUnsignedInt(0x1247b8ff));
	assertThat(settings.shadowColor, nilValue());
}

@end
