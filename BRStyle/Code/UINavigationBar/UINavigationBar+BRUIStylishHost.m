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
	self.tintColor = style.inverseAppPrimaryColor;
	self.barTintColor = style.appPrimaryColor;
	[self setTitleTextAttributes:@{
								  NSForegroundColorAttributeName: style.inverseTextColor,
								  NSFontAttributeName: style.titleFont,
								  }];
}

@end