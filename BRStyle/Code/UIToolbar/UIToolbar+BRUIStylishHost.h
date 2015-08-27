//
//  UIToolbar+BRUIStylishHost.h
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BRUIStylishHost.h"

/**
 Turn all UIToolbar objects into stylish hosts, appling a tint color based on
 @c inverseControlSettings.normalColorSettings.actionColor and a bar tint color 
 based on @c navigationColor.
 */
@interface UIToolbar (BRUIStylishHost) <BRUIStylishHost>

@end
