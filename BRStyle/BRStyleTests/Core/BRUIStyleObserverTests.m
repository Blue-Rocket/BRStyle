//
//  BRUIStyleObserverTests.m
//  BRStyle
//
//  Created by Matt on 11/09/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRUIStyleObserver.h"
#import "BRUIStylishHost.h"

@interface BRUIStyleObserverTestHost : NSObject <BRUIStylishHost> {
	BRUIStyle *uiStyle;
	NSMutableArray *changes;
}

@property (nonatomic, strong, readonly) NSArray *changes;
@property (nonatomic, strong, readonly) NSString *flag;
@property (nonatomic, strong ,readonly) NSMutableDictionary *flagDictionary;

@end

@implementation BRUIStyleObserverTestHost

@synthesize changes;

- (instancetype)init {
	if ( (self = [super init]) ) {
		changes = [[NSMutableArray alloc] initWithCapacity:2];
	}
	return self;
}

- (instancetype)initWithFlag:(NSString *)flag dictionary:(NSMutableDictionary *)flagDictionary {
	if ( (self = [self init] ) ) {
		_flag = flag;
		_flagDictionary = flagDictionary;
	}
	return self;
}

- (void)dealloc {
	_flagDictionary[_flag] = @YES;
}

- (void)setUiStyle:(BRUIStyle * __nullable)style {
	uiStyle = style;
}

- (BRUIStyle *)uiStyle {
	return (uiStyle ? uiStyle : [BRUIStyle defaultStyle]);
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[changes addObject:style];
}

@end

@interface BRUIStyleObserverTests : XCTestCase

@end

@implementation BRUIStyleObserverTests

- (void)testObserveInitialDefaultStyleChange {
	[BRUIStyle setDefaultStyle:nil];
	
	// when defaultStyle is called for the first time, all observers should be notified
	BRUIStyleObserverTestHost *host = [BRUIStyleObserverTestHost new];
	[BRUIStyleObserver addStyleObservation:host];
	
	[self expectationForNotification:BRStyleNotificationUIStyleDidChange object:nil handler:^BOOL(NSNotification * _Nonnull notification) {
		return ([notification.object isKindOfClass:[BRUIStyle class]]);
	}];
	BRUIStyle *original = [BRUIStyle defaultStyle];
	[self waitForExpectationsWithTimeout:1 handler:nil];

	assertThat(host.changes, hasCountOf(1));
	assertThat(host.changes, contains(original, nil));
}

- (void)testObserveStyleChange {
	BRUIStyle *original = [BRUIStyle defaultStyle];

	BRUIStyleObserverTestHost *host = [BRUIStyleObserverTestHost new];
	[BRUIStyleObserver addStyleObservation:host];
	
	BRUIStyle *newStyle = [[original mutableCopy] copy]; // get a non-mutable copy
	[BRUIStyle setDefaultStyle:newStyle];
	
	assertThat(host.changes, hasCountOf(1));
	assertThat(host.changes, contains(newStyle, nil));
}

- (void)doObservationForRelease:(NSString *)flag dict:(NSMutableDictionary *)dict style:(BRUIStyle *)style {
	BRUIStyleObserverTestHost *host = [[BRUIStyleObserverTestHost alloc] initWithFlag:flag dictionary:dict];
	[BRUIStyleObserver addStyleObservation:host];
	BRUIStyle *newStyle = [[style mutableCopy] copy]; // get a non-mutable copy
	[BRUIStyle setDefaultStyle:newStyle];
	
	assertThat(host.changes, hasCountOf(1));
	assertThat(host.changes, contains(newStyle, nil));
}

/**
 Verify that a stylish host is properly released, i.e. we don't have a retain cycle between the observer and the host.
 */
- (void)testObserverReleased {
	BRUIStyle *original = [BRUIStyle defaultStyle];
	NSMutableDictionary *releaseFlags = [[NSMutableDictionary alloc] initWithCapacity:2];
	[self doObservationForRelease:@"test" dict:releaseFlags style:original];
	assertThat(releaseFlags, hasCountOf(1));
	assertThat(releaseFlags[@"test"], equalTo(@YES));
}

@end
