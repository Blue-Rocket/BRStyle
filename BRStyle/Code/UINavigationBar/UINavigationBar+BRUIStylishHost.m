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
	self.tintColor = style.colors.inverseControlSettings.normalColorSettings.actionColor;
	self.barTintColor = style.colors.navigationColor;
	[self setTitleTextAttributes:@{
								  NSForegroundColorAttributeName: style.colors.inverseControlSettings.normalColorSettings.actionColor,
								  NSFontAttributeName: style.fonts.navigationFont,
								  }];
}

@end
