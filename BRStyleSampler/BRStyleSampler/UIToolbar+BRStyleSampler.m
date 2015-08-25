//
//  UIToolbar+BRStyleSampler.m
//  BRStyleSampler
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import "UIToolbar+BRStyleSampler.h"

#import <BRStyle/UIView+BRUIStyle.h>

@implementation UIToolbar (BRStyleSampler)

@dynamic uiStyle;

- (void)uiStyleDidChange:(BRUIStyle *)style {
	self.tintColor = style.inverseAppPrimaryColor;
	self.barTintColor = style.appPrimaryColor;
}

@end
