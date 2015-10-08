//
//  UIButton+BRUIStylishHost.m
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIButton+BRUIStylishHost.h"

#import "UIControl+BRUIStyle.h"
#import "UIView+BRUIStyle.h"

@implementation UIButton (BRUIStylishHost)

@dynamic uiStyle;

- (void)uiStyleDidChange:(BRUIStyle *)style {
	self.titleLabel.font = style.fonts.actionFont;
	[self setTitleColor:style.controls.actionColor forState:UIControlStateNormal];
	[self setTitleShadowColor:style.controls.textShadow.shadowColor forState:UIControlStateNormal];
	if ( [style isDefaultStyle] ) {
		// look for more specific style
		for ( NSNumber *stateValue in @[@(UIControlStateNormal), @(UIControlStateDisabled), @(UIControlStateHighlighted), @(UIControlStateSelected), @(BRUIStyleControlStateDangerous)] ) {
			UIControlState state = [stateValue unsignedIntegerValue];
			BRUIStyle *s = [self uiStyleForState:state];
			if ( s && ![s isDefaultStyle] && s.controls.actionColor && s.fonts.actionFont ) {
				[self setTitleColor:s.controls.actionColor forState:state];
				[self setTitleShadowColor:s.controls.textShadow.shadowColor forState:state];
			}
		}
	}
}

@end
