//
//  UIButton+BRUIStylishHost.m
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIButton+BRUIStylishHost.h"

#import "UIView+BRUIStyle.h"

@implementation UIButton (BRUIStylishHost)

@dynamic uiStyle;

- (void)uiStyleDidChange:(BRUIStyle *)style {
	const BOOL inverse = ([self nearestAncestorViewOfType:[UINavigationBar class]] != nil || [self nearestAncestorViewOfType:[UIToolbar class]] != nil);
	self.titleLabel.font = style.fonts.actionFont;
	BRUIStyleControlStateColorSettings *controlSettings = (inverse ? style.colors.inverseControlSettings : style.colors.controlSettings);
	[self setTitleColor:controlSettings.normalColorSettings.actionColor forState:UIControlStateNormal];
	[self setTitleColor:controlSettings.highlightedColorSettings.actionColor forState:UIControlStateHighlighted];
	[self setTitleColor:controlSettings.selectedColorSettings.actionColor forState:UIControlStateSelected];
	[self setTitleColor:controlSettings.disabledColorSettings.actionColor forState:UIControlStateDisabled];
}

@end
