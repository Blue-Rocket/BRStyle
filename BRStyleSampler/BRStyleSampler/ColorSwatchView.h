//
//  ColorSwatchView.h
//  MenuSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

/**
 Render a color as a swatch. Configure a color to fill the contents of this view with
 that color. Alpha values in the color will "show through" to a gray checkerboard 
 pattern, commonly used in image editors.
 */
@interface ColorSwatchView : UIView

@property (nonatomic, strong) UIColor *color;

@end
