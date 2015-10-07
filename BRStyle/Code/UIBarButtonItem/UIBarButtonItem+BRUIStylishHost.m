//
//  UIBarButtonItem+BRUIStylishHost.m
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIBarButtonItem+BRUIStylishHost.h"

#import "UIBarButtonItem+BRUIStyle.h"

@implementation UIBarButtonItem (BRUIStylishHost)

@dynamic uiStyle;

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self setTitleTextAttributes:@{
								   NSForegroundColorAttributeName: style.controls.actionColor,
								   NSFontAttributeName: style.fonts.actionFont,
								   }
						forState:UIControlStateNormal];
}

@end
