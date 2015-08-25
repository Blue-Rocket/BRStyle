//
//  UIBarButtonItem+BRUIStyle.h
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRUIStyle.h"

@interface UIBarButtonItem (BRUIStyle)

/** A BRUIStyle object to use. If not configured, the global default style will be returned. */
@property (nonatomic, strong, null_resettable) IBOutlet BRUIStyle *uiStyle;

@end
