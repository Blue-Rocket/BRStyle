//
//  UIToolbar+BRStyleSampler.h
//  BRStyleSampler
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BRStyle/BRUIStyle.h>
#import <BRStyle/BRUIStylishHost.h>

/**
 Extension of UIToolbar to apply BRUIStyle attributes.
 */
@interface UIToolbar (BRStyleSampler) <BRUIStylish, BRUIStylishHost>

@end
