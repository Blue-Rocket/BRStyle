//
//  BRUIStyleAppearanceLoaderTests.m
//  BRStyle
//
//  Created by Matt on 1/06/16.
//  Copyright © 2016 Blue Rocket, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRUIStyle.h"
#import "BRUIStylish.h"
#import "BRUIStylishControl.h"
#import "BRUIStyleAppearanceLoader.h"
#import "UIControl+BRUIStyle.h"
#import "UIView+BRUIStyle.h"

@interface AppearanceCustomClass : UIView <BRUIStylish>
@end

@interface AppearanceCustomControl : UIControl <BRUIStylishControl>
@end

@interface BRUIStyleAppearanceLoaderTests : XCTestCase
@end

@implementation BRUIStyleAppearanceLoaderTests

- (void)testSetupAppearanceStylesForStylishObjects {
	BRUIStyleAppearanceLoader *loader = [BRUIStyleAppearanceLoader new];
	NSDictionary<NSString *, BRUIStyle *> *styles = [BRUIStyle registerDefaultStylesWithJSONResource:@"appearances.json" inBundle:[NSBundle bundleForClass:[BRUIStyle class]]];
	
	[loader setupAppearanceStyles:styles];

	AppearanceCustomClass *proxy;
 
	proxy = [AppearanceCustomClass appearance];
	assertThat(proxy.uiStyle, sameInstance(styles[@"AppearanceCustomClass"]));

	proxy = [AppearanceCustomClass appearanceWhenContainedIn:[UITableViewCell class], nil];
	assertThat(proxy.uiStyle, sameInstance(styles[@"UITableViewCell/AppearanceCustomClass"]));
	
	proxy = [AppearanceCustomClass appearanceWhenContainedIn:[UITableViewCell class], [UITableViewController class], nil];
	assertThat(proxy.uiStyle, sameInstance(styles[@"UITableViewController/UITableViewCell/AppearanceCustomClass"]));
}

- (void)testSetupAppearanceStylesForStylishControls {
	BRUIStyleAppearanceLoader *loader = [BRUIStyleAppearanceLoader new];
	NSDictionary<NSString *, BRUIStyle *> *styles = [BRUIStyle registerDefaultStylesWithJSONResource:@"appearances.json" inBundle:[NSBundle bundleForClass:[BRUIStyle class]]];
	
	[loader setupAppearanceStyles:styles];
	
	AppearanceCustomControl *controlProxy;
	
	controlProxy = [AppearanceCustomControl appearance];
	assertThat([controlProxy uiStyleForState:UIControlStateHighlighted],
			   sameInstance(styles[@"AppearanceCustomControl-highlighted"]));
	
	controlProxy = [AppearanceCustomControl appearance];
	assertThat([controlProxy uiStyleForState:UIControlStateHighlighted|UIControlStateSelected],
			   sameInstance(styles[@"AppearanceCustomControl-highlighted|selected"]));
	
	controlProxy = [AppearanceCustomControl appearanceWhenContainedIn:[UITableViewCell class], nil];
	assertThat([controlProxy uiStyleForState:UIControlStateHighlighted],
			   sameInstance(styles[@"UITableViewCell/AppearanceCustomControl-highlighted"]));
	
	controlProxy = [AppearanceCustomControl appearanceWhenContainedIn:[UITableViewCell class], [UITableViewController class], nil];
	assertThat([controlProxy uiStyleForState:UIControlStateHighlighted],
			   sameInstance(styles[@"UITableViewController/UITableViewCell/AppearanceCustomControl-highlighted"]));
}

@end

@implementation AppearanceCustomClass
@dynamic uiStyle;
@end

@implementation AppearanceCustomControl
@dynamic dangerous;
@end
