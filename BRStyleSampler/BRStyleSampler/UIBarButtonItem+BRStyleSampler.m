//
//  UIBarButtonItem+BRStyleSampler.m
//  BRStyleSampler
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import "UIBarButtonItem+BRStyleSampler.h"

#import <BRStyle/UIBarButtonItem+BRUIStyle.h>

@implementation UIBarButtonItem (BRStyleSampler)

@dynamic uiStyle;

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self setTitleTextAttributes:@{
								   NSForegroundColorAttributeName: style.inverseControlTextColor,
								   NSFontAttributeName: style.uiFont,
								   }
						forState:UIControlStateNormal];
}

@end
