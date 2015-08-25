//
//  ColorSwatchAlphaView.m
//  MenuSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "ColorSwatchAlphaView.h"

#import "ColorSwatchView.h"

@interface ColorSwatchAlphaView ()
@property (nonatomic, strong) IBOutlet ColorSwatchView *swatchView;
@property (nonatomic, strong) IBOutlet UILabel *alphaValueLabel;
@end

@implementation ColorSwatchAlphaView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if ( (self = [super initWithFrame:frame]) ) {
		[self setup];
	}
	return self;
}

- (void)setup {
	self.backgroundColor = [UIColor whiteColor];
	self.layer.borderWidth = 1;
	self.layer.borderColor = [UIColor darkGrayColor].CGColor;
	self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
	self.layer.shadowOpacity = 0.4;
	self.layer.shadowOffset = CGSizeMake(0, 1);
	self.layer.shadowRadius = 4;
}

- (void)setColor:(UIColor *)color {
	self.swatchView.color = color;
	CGFloat r, g, b, a;
	[color getRed:&r green:&g blue:&b alpha:&a];
	self.alphaValueLabel.text = [NSString stringWithFormat:@"%d%%", (int)roundf(a * 100)];
}

- (UIColor *)color {
	return self.swatchView.color;
}

@end
