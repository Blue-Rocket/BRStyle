//
//  SimpleTableViewCell.m
//  BRStyleSampler
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import "SimpleTableViewCell.h"

#import <BRStyle/UIView+BRUIStyle.h>

@implementation SimpleTableViewCell

@dynamic uiStyle;

- (void)uiStyleDidChange:(BRUIStyle *)style {
	self.titleLabel.font = style.fonts.listFont;
	self.titleLabel.textColor = style.colors.textColor;
	self.captionLabel.font = style.fonts.listCaptionFont;
	self.captionLabel.textColor = style.colors.captionColor;
}

@end
