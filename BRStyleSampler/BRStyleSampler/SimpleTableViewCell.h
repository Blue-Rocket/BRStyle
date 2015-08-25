//
//  SimpleTableViewCell.h
//  BRStyleSampler
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BRStyle/BRUIStylishHost.h>

@interface SimpleTableViewCell : UITableViewCell <BRUIStylishHost>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *captionLabel;
@property (nonatomic, strong) IBOutlet UIView *otherView;

@end
