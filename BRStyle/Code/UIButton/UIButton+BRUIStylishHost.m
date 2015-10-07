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
	self.titleLabel.font = style.fonts.actionFont;
	[self setTitleColor:style.controls.actionColor forState:UIControlStateNormal];
}

@end
