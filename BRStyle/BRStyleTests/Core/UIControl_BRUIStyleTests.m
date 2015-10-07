//
//  UIControl_BRUIStyleTests.m
//  BRStyle
//
//  Created by Matt on 8/10/15.
//  Copyright © 2015 Blue Rocket, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "UIControl+BRUIStyle.h"

@interface UIControl_BRUIStyleTests : XCTestCase

@end

@implementation UIControl_BRUIStyleTests

- (void)setUp {
	[super setUp];
	[UIControl setDefaultUiStyle:nil forState:UIControlStateNormal];
	[UIControl setDefaultUiStyle:nil forState:UIControlStateHighlighted];
	[UIControl setDefaultUiStyle:nil forState:UIControlStateSelected];
	[UIControl setDefaultUiStyle:nil forState:UIControlStateDisabled];
	[UIControl setDefaultUiStyle:nil forState:BRUIStyleControlStateDangerous];

}

- (void)testKeyNameForState {
	assertThat([UIControl keyNameForControlState:UIControlStateNormal], equalTo(@"normal"));
	assertThat([UIControl keyNameForControlState:UIControlStateHighlighted], equalTo(@"highlighted"));
	assertThat([UIControl keyNameForControlState:UIControlStateSelected], equalTo(@"selected"));
	assertThat([UIControl keyNameForControlState:UIControlStateDisabled], equalTo(@"disabled"));
	assertThat([UIControl keyNameForControlState:BRUIStyleControlStateDangerous], equalTo(@"dangerous"));
}

- (void)testStateForKeyName {
	assertThatUnsignedInteger([UIControl controlStateForKeyName:@"normal"], equalToUnsignedInteger(UIControlStateNormal));
	assertThatUnsignedInteger([UIControl controlStateForKeyName:@"highlighted"], equalToUnsignedInteger(UIControlStateHighlighted));
	assertThatUnsignedInteger([UIControl controlStateForKeyName:@"selected"], equalToUnsignedInteger(UIControlStateSelected));
	assertThatUnsignedInteger([UIControl controlStateForKeyName:@"disabled"], equalToUnsignedInteger(UIControlStateDisabled));
	assertThatUnsignedInteger([UIControl controlStateForKeyName:@"dangerous"], equalToUnsignedInteger(BRUIStyleControlStateDangerous));
}

- (void)testNormalState {
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	assertThatUnsignedInteger(c.state & UIControlStateNormal, equalToUnsignedInteger(UIControlStateNormal));
}

- (void)testDisabledState {
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	assertThatBool(c.enabled, isTrue());
	assertThatUnsignedInteger(c.state & UIControlStateDisabled, equalToUnsignedInteger(0));
	
	c.enabled = NO;
	assertThatUnsignedInteger(c.state & UIControlStateDisabled, equalToUnsignedInteger(UIControlStateDisabled));
}

- (void)testHighlightedState {
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	assertThatBool(c.highlighted, isFalse());
	assertThatUnsignedInteger(c.highlighted & UIControlStateHighlighted, equalToUnsignedInteger(0));
	
	c.highlighted = YES;
	assertThatUnsignedInteger(c.state & UIControlStateHighlighted, equalToUnsignedInteger(UIControlStateHighlighted));
}

- (void)testSelectedState {
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	assertThatBool(c.selected, isFalse());
	assertThatUnsignedInteger(c.selected & UIControlStateSelected, equalToUnsignedInteger(0));
	
	c.selected = YES;
	assertThatUnsignedInteger(c.state & UIControlStateSelected, equalToUnsignedInteger(UIControlStateSelected));
}

- (void)testSelectedAndHighlightedState {
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	c.selected = YES;
	c.highlighted = YES;
	assertThatUnsignedInteger(c.state & UIControlStateSelected, equalToUnsignedInteger(UIControlStateSelected));
	assertThatUnsignedInteger(c.state & UIControlStateHighlighted, equalToUnsignedInteger(UIControlStateHighlighted));
}

- (void)testDangerousState {
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	assertThatBool(c.dangerous, isFalse());
	assertThatUnsignedInteger(c.state & BRUIStyleControlStateDangerous, equalToUnsignedInteger(0));
	
	c.dangerous = YES;
	assertThatBool(c.dangerous, isTrue());
	assertThatUnsignedInteger(c.state & BRUIStyleControlStateDangerous, equalToUnsignedInteger(BRUIStyleControlStateDangerous));
}

- (void)testDangerousAndHighlightedState {
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	c.dangerous = YES;
	c.highlighted = YES;
	assertThatBool(c.dangerous, isTrue());
	assertThatBool(c.highlighted, isTrue());
	assertThatUnsignedInteger(c.state & BRUIStyleControlStateDangerous, equalToUnsignedInteger(BRUIStyleControlStateDangerous));
	assertThatUnsignedInteger(c.state & UIControlStateHighlighted, equalToUnsignedInteger(UIControlStateHighlighted));
}

- (void)testGlobalDefaultStyles {
	BRUIStyle *n = [BRUIStyle new];
	BRUIStyle *h = [BRUIStyle new];
	BRUIStyle *s = [BRUIStyle new];
	BRUIStyle *d = [BRUIStyle new];
	BRUIStyle *x = [BRUIStyle new];
	[UIControl setDefaultUiStyle:n forState:UIControlStateNormal];
	[UIControl setDefaultUiStyle:h forState:UIControlStateHighlighted];
	[UIControl setDefaultUiStyle:s forState:UIControlStateSelected];
	[UIControl setDefaultUiStyle:d forState:UIControlStateDisabled];
	[UIControl setDefaultUiStyle:x forState:BRUIStyleControlStateDangerous];
	assertThat([UIControl defaultUiStyleForState:UIControlStateNormal], sameInstance(n));
	assertThat([UIControl defaultUiStyleForState:UIControlStateHighlighted], sameInstance(h));
	assertThat([UIControl defaultUiStyleForState:UIControlStateSelected], sameInstance(s));
	assertThat([UIControl defaultUiStyleForState:UIControlStateDisabled], sameInstance(d));
	assertThat([UIControl defaultUiStyleForState:BRUIStyleControlStateDangerous], sameInstance(x));
}

- (void)testStyleForDefaultState {
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	assertThatBool([c uiStyleForState:UIControlStateNormal].defaultStyle, isTrue());
	assertThatBool([c uiStyleForState:UIControlStateHighlighted].defaultStyle, isTrue());
	assertThatBool([c uiStyleForState:UIControlStateSelected].defaultStyle, isTrue());
	assertThatBool([c uiStyleForState:UIControlStateDisabled].defaultStyle, isTrue());
	assertThatBool([c uiStyleForState:BRUIStyleControlStateDangerous].defaultStyle, isTrue());
}

- (void)testStyleForNormalState {
	BRUIStyle *n = [BRUIStyle new];
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	[c setUiStyle:n forState:UIControlStateNormal];
	assertThat([c uiStyleForState:UIControlStateNormal], sameInstance(n));
	
	// all other states fall back to Normal state if available!
	assertThat([c uiStyleForState:UIControlStateHighlighted], sameInstance(n));
	assertThat([c uiStyleForState:UIControlStateSelected], sameInstance(n));
	assertThat([c uiStyleForState:UIControlStateDisabled], sameInstance(n));
	assertThat([c uiStyleForState:BRUIStyleControlStateDangerous], sameInstance(n));
}


- (void)testStyleForDefaultNormalState {
	BRUIStyle *defaultNormal = [BRUIStyle new];
	[UIControl setDefaultUiStyle:defaultNormal forState:UIControlStateNormal];
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	assertThat([c uiStyleForState:UIControlStateNormal], sameInstance(defaultNormal));
	
	// all other states fall back to Normal state if available!
	assertThat([c uiStyleForState:UIControlStateHighlighted], sameInstance(defaultNormal));
	assertThat([c uiStyleForState:UIControlStateSelected], sameInstance(defaultNormal));
	assertThat([c uiStyleForState:UIControlStateDisabled], sameInstance(defaultNormal));
	assertThat([c uiStyleForState:BRUIStyleControlStateDangerous], sameInstance(defaultNormal));
}

- (void)testStyleForDefaultDangerousState {
	BRUIStyle *defaultDangerous = [BRUIStyle new];
	[UIControl setDefaultUiStyle:defaultDangerous forState:BRUIStyleControlStateDangerous];
	BRUIStyle *n = [BRUIStyle new];
	UIControl *c = [[UIControl alloc] initWithFrame:CGRectZero];
	[c setUiStyle:n forState:UIControlStateNormal];
	assertThat([c uiStyleForState:BRUIStyleControlStateDangerous], sameInstance(defaultDangerous));
	
	// all other states fall back to Normal state if available!
	assertThat([c uiStyleForState:UIControlStateNormal], sameInstance(n));
	assertThat([c uiStyleForState:UIControlStateHighlighted], sameInstance(n));
	assertThat([c uiStyleForState:UIControlStateSelected], sameInstance(n));
	assertThat([c uiStyleForState:UIControlStateDisabled], sameInstance(n));
}

@end
