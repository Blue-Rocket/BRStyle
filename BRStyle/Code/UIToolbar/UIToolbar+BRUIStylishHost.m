//
//  UIToolbar+BRUIStylishHost.m
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import "UIToolbar+BRUIStylishHost.h"

#import "UIView+BRUIStyle.h"

@implementation UIToolbar (BRUIStylishHost)

@dynamic uiStyle;

- (void)uiStyleDidChange:(BRUIStyle *)style {
	self.tintColor = style.inverseAppPrimaryColor;
	self.barTintColor = style.appPrimaryColor;
}

@end
