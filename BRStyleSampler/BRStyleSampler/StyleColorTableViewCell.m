//
//  StyleColorTableViewCell.m
//  BRStyleSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "StyleColorTableViewCell.h"

#import "ColorSwatchView.h"

@implementation StyleColorTableViewCell

- (ColorSwatchView *)colorSwatch {
	return (ColorSwatchView *)self.otherView;
}

- (void)setColorSwatch:(ColorSwatchView *)colorSwatch {
	self.otherView = colorSwatch;
}

@end
