//
//  BRUIStyleMappingRestKitTests.m
//  BRStyle
//
//  Created by Matt on 3/08/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRUIStyleMappingRestKit.h"
#import "BRRestKitTestingMapper.h"
#import "BRRestKitTestingSupport.h"
#import "BRUIStyle.h"

@interface BRUIStyleMappingRestKitTests : XCTestCase

@end

@implementation BRUIStyleMappingRestKitTests

- (void)setUp {
	[super setUp];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	[BRRestKitTestingSupport setFixtureBundle:bundle];
}

- (void)testParseUIStyle {
	BRMutableUIStyle *style = [BRMutableUIStyle new];
	[[BRRestKitTestingMapper testForMapping:[BRUIStyleMappingRestKit uiStyleMapping]
								   sourceObject:[BRRestKitTestingSupport parsedObjectWithContentsOfFixture:@"uistyle.json"]
							  destinationObject:style]
	 performMapping];
	assertThat(style.appPrimaryColor, equalTo([BRUIStyle colorWithRGBAHexInteger:0xfd1122FF]));
	assertThat(style.uiFont, equalTo([UIFont fontWithName:@"HelveticaNeue-UltraLight" size:17]));
}


- (void)testEncodeUIStyle {
	BRUIStyle *style = [BRUIStyle defaultStyle];
	NSMutableDictionary *dict = [NSMutableDictionary new];
	[[BRRestKitTestingMapper testForMapping:[BRUIStyleMappingRestKit uiStyleMapping]
								   sourceObject:style
							  destinationObject:dict]
	 performMapping];
	assertThat(dict[@"appPrimaryColor"], equalTo(@0x1247b8ff));
	assertThat(dict[@"textShadowColor"], equalTo(@0xCACACA7F));
	assertThat(dict[@"uiFont"], equalTo(@{@"name" :@"AvenirNext-Medium", @"size":@15}));
}

@end
