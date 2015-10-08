//
//  UIBarButtonItem_BRUIStyleTests.m
//  BRStyle
//
//  Created by Matt on 8/10/15.
//  Copyright © 2015 Blue Rocket, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "UIBarButtonItem+BRUIStyle.h"

@interface TestBarButtonItem : UIBarButtonItem {
	NSMutableArray *stateChanges;
}
@property (nonatomic, readonly) NSArray *stateChanges;
@end

@implementation TestBarButtonItem

@synthesize stateChanges;

- (void)stateDidChange {
	if ( !stateChanges ) {
		stateChanges = [[NSMutableArray alloc] initWithCapacity:4];
	}
	// NOTE: UIBarButtonItem calls setEnabled:YES on init!
	
	[stateChanges addObject:@((self.enabled ? UIControlStateNormal : UIControlStateDisabled)
	 | (self.dangerous ? BRUIStyleControlStateDangerous : UIControlStateNormal))];
}

@end


@interface UIBarButtonItem_BRUIStyleTests : XCTestCase

@end

@implementation UIBarButtonItem_BRUIStyleTests

- (void)setUp {
	[super setUp];
	[BRUIStyle defaultStyle]; // load defaults
	
	// now clear UIControl defaults
	[UIBarButtonItem removeAllDefaultUiStyles];
	
}

- (IBAction)takeAction:(id)sender {
	
}

- (void)testNormalState {
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	assertThatBool(b.enabled, isTrue());
}

- (void)testDisabledState {
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	assertThatBool(b.enabled, isTrue());
	
	b.enabled = NO;
	assertThatBool(b.enabled, isFalse());
}

- (void)testDangerousState {
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	assertThatBool(b.dangerous, isFalse());
	
	b.dangerous = YES;
	assertThatBool(b.dangerous, isTrue());
}

- (void)testDangerousAndDisabledState {
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	b.dangerous = YES;
	b.enabled = NO;
	assertThatBool(b.dangerous, isTrue());
	assertThatBool(b.enabled, isFalse());
}

- (void)testGlobalDefaultStyles {
	BRUIStyle *n = [BRUIStyle new];
	BRUIStyle *d = [BRUIStyle new];
	BRUIStyle *x = [BRUIStyle new];
	[UIBarButtonItem setDefaultUiStyle:n forState:UIControlStateNormal];
	[UIBarButtonItem setDefaultUiStyle:d forState:UIControlStateDisabled];
	[UIBarButtonItem setDefaultUiStyle:x forState:BRUIStyleControlStateDangerous];
	assertThat([UIBarButtonItem defaultUiStyleForState:UIControlStateNormal], sameInstance(n));
	assertThat([UIBarButtonItem defaultUiStyleForState:UIControlStateDisabled], sameInstance(d));
	assertThat([UIBarButtonItem defaultUiStyleForState:BRUIStyleControlStateDangerous], sameInstance(x));
}

- (void)testStyleForDefaultState {
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	assertThatBool([b uiStyleForState:UIControlStateNormal].defaultStyle, isTrue());
	assertThatBool([b uiStyleForState:UIControlStateDisabled].defaultStyle, isTrue());
	assertThatBool([b uiStyleForState:BRUIStyleControlStateDangerous].defaultStyle, isTrue());
}

- (void)testStyleForNormalState {
	BRUIStyle *n = [BRUIStyle new];
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	[b setUiStyle:n forState:UIControlStateNormal];
	assertThat([b uiStyleForState:UIControlStateNormal], sameInstance(n));
	
	// all other states fall back to Normal state if available!
	assertThat([b uiStyleForState:UIControlStateDisabled], sameInstance(n));
	assertThat([b uiStyleForState:BRUIStyleControlStateDangerous], sameInstance(n));
}

- (void)testStyleForCombinedStates {
	BRUIStyle *n = [BRUIStyle new];
	BRUIStyle *d = [BRUIStyle new];
	BRUIStyle *x = [BRUIStyle new];
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	[b setUiStyle:n forState:UIControlStateNormal];
	[b setUiStyle:d forState:UIControlStateDisabled];
	[b setUiStyle:x forState:BRUIStyleControlStateDangerous];
	
	// order is disabled, dangerous, highlighted, selected
	assertThat([b uiStyleForState:(BRUIStyleControlStateDangerous|UIControlStateHighlighted)], sameInstance(x));
	assertThat([b uiStyleForState:(BRUIStyleControlStateDangerous|UIControlStateDisabled)], sameInstance(d));
}

- (void)testStyleForCombinedStyleState {
	BRUIStyle *xh = [BRUIStyle new];
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	[b setUiStyle:xh forState:(BRUIStyleControlStateDangerous|UIControlStateHighlighted)];
	
	assertThat([b uiStyleForState:(BRUIStyleControlStateDangerous|UIControlStateHighlighted)], sameInstance(xh));
	assertThatBool([b uiStyleForState:(UIControlStateHighlighted)].defaultStyle, isTrue());
	assertThatBool([b uiStyleForState:(BRUIStyleControlStateDangerous)].defaultStyle, isTrue());
}

- (void)testGlobalDefaultForCombinedStates {
	BRUIStyle *n = [BRUIStyle new];
	BRUIStyle *d = [BRUIStyle new];
	BRUIStyle *x = [BRUIStyle new];
	[UIBarButtonItem setDefaultUiStyle:n forState:UIControlStateNormal];
	[UIBarButtonItem setDefaultUiStyle:d forState:UIControlStateDisabled];
	[UIBarButtonItem setDefaultUiStyle:x forState:BRUIStyleControlStateDangerous];
	
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	
	// order is disabled, dangerous, highlighted, selected
	assertThat([b uiStyleForState:(BRUIStyleControlStateDangerous|UIControlStateHighlighted)], sameInstance(x));
	assertThat([b uiStyleForState:(BRUIStyleControlStateDangerous|UIControlStateDisabled)], sameInstance(d));
}

- (void)testStyleForDefaultNormalState {
	BRUIStyle *defaultNormal = [BRUIStyle new];
	[UIBarButtonItem setDefaultUiStyle:defaultNormal forState:UIControlStateNormal];
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	assertThat([b uiStyleForState:UIControlStateNormal], sameInstance(defaultNormal));
	
	// all other states fall back to Normal state if available!
	assertThat([b uiStyleForState:UIControlStateHighlighted], sameInstance(defaultNormal));
	assertThat([b uiStyleForState:UIControlStateSelected], sameInstance(defaultNormal));
	assertThat([b uiStyleForState:UIControlStateDisabled], sameInstance(defaultNormal));
	assertThat([b uiStyleForState:BRUIStyleControlStateDangerous], sameInstance(defaultNormal));
}

- (void)testStyleForDefaultDangerousState {
	BRUIStyle *defaultDangerous = [BRUIStyle new];
	[UIBarButtonItem setDefaultUiStyle:defaultDangerous forState:BRUIStyleControlStateDangerous];
	BRUIStyle *n = [BRUIStyle new];
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	[b setUiStyle:n forState:UIControlStateNormal];
	assertThat([b uiStyleForState:BRUIStyleControlStateDangerous], sameInstance(defaultDangerous));
	
	// all other states fall back to Normal state if available!
	assertThat([b uiStyleForState:UIControlStateNormal], sameInstance(n));
	assertThat([b uiStyleForState:UIControlStateHighlighted], sameInstance(n));
	assertThat([b uiStyleForState:UIControlStateSelected], sameInstance(n));
	assertThat([b uiStyleForState:UIControlStateDisabled], sameInstance(n));
}

- (void)testStateDidChangeEnabled {
	TestBarButtonItem *b = [[TestBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	assertThatBool(b.enabled, isTrue());
	b.enabled = NO;
	assertThat(b.stateChanges, contains(@(UIControlStateNormal), @(UIControlStateDisabled), nil));
}

- (void)testStateDidChangeDangerous {
	TestBarButtonItem *b = [[TestBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	b.dangerous = YES;
	assertThat(b.stateChanges, contains(@(UIControlStateNormal), @(BRUIStyleControlStateDangerous), nil));
}

- (void)testStateDidChangeDangerousAndDisabled {
	TestBarButtonItem *b = [[TestBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeAction:)];
	b.dangerous = YES;
	b.enabled = NO;
	assertThat(b.stateChanges, contains(@(UIControlStateNormal), @(BRUIStyleControlStateDangerous), @(BRUIStyleControlStateDangerous|UIControlStateDisabled), nil));
}

@end
