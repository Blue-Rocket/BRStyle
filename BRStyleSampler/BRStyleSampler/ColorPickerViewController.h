//
//  ColorPickerViewController.h
//  MenuSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerViewControllerDelegate;

@interface ColorPickerViewController : UIViewController

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, weak) id<ColorPickerViewControllerDelegate> delegate;

@end

@protocol ColorPickerViewControllerDelegate <NSObject>

- (void)colorPickerDidPickColor:(ColorPickerViewController *)picker;

@end
