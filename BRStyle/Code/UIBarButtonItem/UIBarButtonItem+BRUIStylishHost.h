//
//  UIBarButtonItem+BRUIStylishHost.h
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRUIStyle.h"
#import "BRUIStylishHost.h"

/**
 Turn all UIBarButtonItem objects into stylish hosts, appling title text attributes based on 
 the @c inverseControlSettings.normalColorSettings.actionColor color and @c actionFont.
 */
@interface UIBarButtonItem (BRUIStylishHost) <BRUIStylishHost>

@end
