//
//  ColorSwatchView.m
//  MenuSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "ColorSwatchView.h"

static const CGFloat kCheckerboardSquareSize = 5;

@implementation ColorSwatchView {
	UIColor *color;
	CALayer *colorLayer;
}

@synthesize color;

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
	self.opaque = NO;
	self.backgroundColor = [self checkerboardColor];
	
	CALayer *cLayer = [CALayer new];
	cLayer.opaque = NO;
	cLayer.backgroundColor = [UIColor clearColor].CGColor;
	[self.layer addSublayer:cLayer];
	[colorLayer removeFromSuperlayer];
	colorLayer = cLayer;
	
	self.layer.borderColor = [UIColor darkGrayColor].CGColor;
	self.layer.borderWidth = 1.0;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	colorLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (UIColor *)checkerboardColor {
	static UIColor *pat;
	if ( !pat ) {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kCheckerboardSquareSize * 2, kCheckerboardSquareSize * 2), NO, [UIScreen mainScreen].scale);
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		[[UIColor lightGrayColor] setFill];
		CGContextFillRect(ctx, CGRectMake(0, 0, kCheckerboardSquareSize, kCheckerboardSquareSize));
		CGContextFillRect(ctx, CGRectMake(kCheckerboardSquareSize, kCheckerboardSquareSize, kCheckerboardSquareSize, kCheckerboardSquareSize));
		UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
		pat = [UIColor colorWithPatternImage:img];
		UIGraphicsEndImageContext();
	}
	return pat;
}

- (void)setColor:(UIColor *)c {
	if ( c != color ) {
		[self willChangeValueForKey:@"color"];
		color = c;
		colorLayer.backgroundColor = color.CGColor;
		[self didChangeValueForKey:@"color"];
	}
}

@end
