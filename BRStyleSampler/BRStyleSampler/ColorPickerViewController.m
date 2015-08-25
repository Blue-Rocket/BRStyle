//
//  ColorPickerViewController.m
//  MenuSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "ColorPickerViewController.h"

#import <Color-Picker-for-iOS/HRColorPickerView.h>
#import <Color-Picker-for-iOS/HRBrightnessSlider.h>
#import "ColorSwatchAlphaView.h"
#import "ColorSwatchView.h"

@interface ColorPickerViewController ()
@property (strong, nonatomic) IBOutlet HRColorPickerView *pickerView;
@property (strong, nonatomic) IBOutlet ColorSwatchAlphaView *alphaHoverView;
@property (strong, nonatomic) IBOutlet UISlider *alphaSlider;
@end

@implementation ColorPickerViewController {
	UIColor *color;
}

@synthesize color;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.alphaHoverView.alpha = 0;
	self.pickerView.brightnessSlider.brightnessLowerLimit = @0;
	[self updateToColor:color];
}

- (void)updateToColor:(UIColor *)c {
	self.pickerView.color = c;
	self.alphaHoverView.color = c;
	CGFloat r, g, b, a;
	[color getRed:&r green:&g blue:&b alpha:&a];
	if ( self.alphaSlider && ABS(self.alphaSlider.value - a) > 0.1 ) {
		self.alphaSlider.value = a;
	}
}

- (void)setColor:(UIColor *)c {
	if ( c != color ) {
		color = c;
		[self updateToColor:c];
	}
}

- (void)hideAlphaHover {
	if ( self.alphaHoverView.alpha < 1 ) {
		return;
	}
	[UIView animateWithDuration:0.3 animations:^{
		self.alphaHoverView.alpha = 0;
	}];
}

- (IBAction)alphaChanged:(UISlider *)sender {
	[ColorPickerViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAlphaHover) object:nil];
	self.color = [color colorWithAlphaComponent:sender.value];
	[self.delegate colorPickerDidPickColor:self];
	[self performSelector:@selector(hideAlphaHover) withObject:nil afterDelay:2];
	if ( self.alphaHoverView.alpha < 1 ) {
		[UIView animateWithDuration:0.3 animations:^{
			self.alphaHoverView.alpha = 1;
		}];
	}
}

- (IBAction)colorChanged:(HRColorPickerView *)sender {
	[ColorPickerViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAlphaHover) object:nil];
	UIColor *newColor = sender.color;
	newColor = [newColor colorWithAlphaComponent:self.alphaSlider.value];
	self.color = newColor;
	[self.delegate colorPickerDidPickColor:self];
	[self performSelector:@selector(hideAlphaHover) withObject:nil afterDelay:2];
}

@end
