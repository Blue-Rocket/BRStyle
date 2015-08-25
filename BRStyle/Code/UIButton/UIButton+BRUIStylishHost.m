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
	self.titleLabel.font = style.uiFont;
	[self setTitleColor:(inverse ? style.inverseControlTextColor : style.controlTextColor) forState:UIControlStateNormal];
	[self setTitleColor:(inverse ? style.inverseControlSelectedColor : style.controlSelectedColor) forState:UIControlStateSelected];
}

@end
