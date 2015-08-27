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
	assertThat(result, hasCountOf(13));
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

- (void)testControlColorDictionaryRepresentation {
	BRUIStyleControlColorSettings *settings = [BRUIStyleControlColorSettings new];
	NSDictionary *result = [settings dictionaryRepresentation];
	assertThat(result, hasCountOf(5));
	assertThat(result[@"actionColor"], equalToIgnoringCase(@"#1247b8ff"));
	assertThat(result[@"shadowColor"], equalToIgnoringCase(@"#5555557F"));
}

- (void)testControlColorInitWithDictionary {
	NSDictionary *dict = @{ @"actionColor" : @"#1247b8ff", @"glossColor" : @"#1247B8FF", @"shadowColor" : [NSNull null] };
	BRUIStyleControlColorSettings *settings = [[BRUIStyleControlColorSettings alloc] initWithDictionaryRepresentation:dict];
	assertThatUnsignedInt([BRUIStyle rgbaIntegerForColor:settings.actionColor], equalToUnsignedInt(0x1247b8ff));
	assertThatUnsignedInt([BRUIStyle rgbaIntegerForColor:settings.glossColor], equalToUnsignedInt(0x1247b8ff));
	assertThat(settings.shadowColor, nilValue());
}

#pragma mark -

- (void)testControlStateColorDictionaryRepresentation {
	BRUIStyleControlStateColorSettings *settings = [BRUIStyleControlStateColorSettings new];
	NSDictionary *result = [settings dictionaryRepresentation];
	assertThat(result, hasCountOf(5));
	NSDictionary *normalColorSettings = result[@"normalColorSettings"];
	assertThat(normalColorSettings, instanceOf([NSDictionary class]));
	assertThat(normalColorSettings, hasCountOf(5));
	assertThat(normalColorSettings[@"actionColor"], equalToIgnoringCase(@"#555555FF"));
	assertThat(normalColorSettings[@"borderColor"], equalToIgnoringCase(@"#CACACAFF"));
	assertThat(normalColorSettings[@"glossColor"], equalToIgnoringCase(@"#FFFFFFA8"));
	assertThat(normalColorSettings[@"shadowColor"], isA([NSNull class]));
}

- (void)testControlStateColorInitWithDictionary {
	NSDictionary *dict = @{ @"normalColorSettings" : @{ @"actionColor" : @"#1247b8ff", @"glossColor" : [NSNull null] } };
	BRUIStyleControlStateColorSettings *settings = [[BRUIStyleControlStateColorSettings alloc] initWithDictionaryRepresentation:dict];
	BRUIStyleControlColorSettings *normalSettings = settings.normalColorSettings;
	assertThat(normalSettings, notNilValue());
	assertThatUnsignedInt([BRUIStyle rgbaIntegerForColor:normalSettings.actionColor], equalToUnsignedInt(0x1247b8ff));
	assertThat(normalSettings.glossColor, nilValue());
	assertThat(normalSettings.shadowColor, nilValue());
}

@end
