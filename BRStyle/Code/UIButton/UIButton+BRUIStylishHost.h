//
//  UIButton+BRUIStylishHost.h
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRUIStyle.h"
#import "BRUIStylishHost.h"

/**
 Turn all UIButton objects into stylish hosts, appling title font and color based on
 the @c colors.controlSettings. If the button is contained within a @c UIToolbar or
 a @c UINavigationBar then @c colors.inverseControlSettings will be used instead.
 */
@interface UIButton (BRUIStylishHost) <BRUIStylishHost>

@end
