//
//  UINavigationBar+BRUIStylishHost.m
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import "UINavigationBar+BRUIStylishHost.h"

#import "UIView+BRUIStyle.h"

@implementation UINavigationBar (BRUIStylishHost)

@dynamic uiStyle;

- (void)uiStyleDidChange:(BRUIStyle *)style {
	self.tintColor = style.controls.actionColor;
	self.barTintColor = style.colors.navigationColor;
	[self setTitleTextAttributes:@{
								  NSForegroundColorAttributeName: style.controls.actionColor,
								  NSFontAttributeName: style.fonts.navigationFont,
								  }];
}

@end
