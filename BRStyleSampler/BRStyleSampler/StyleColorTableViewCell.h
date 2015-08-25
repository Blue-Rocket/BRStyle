//
//  StyleColorTableViewCell.h
//  BRStyleSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "SimpleTableViewCell.h"

@class ColorSwatchView;

@interface StyleColorTableViewCell : SimpleTableViewCell
@property (strong, nonatomic) IBOutlet ColorSwatchView *colorSwatch;
@end
