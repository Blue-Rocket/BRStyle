//
//  ShowcaseViewControllerTableViewController.m
//  BRStyleSampler
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import "ShowcaseViewController.h"

@interface ShowcaseViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bottomBarItem;

@end

@implementation ShowcaseViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarItems:@[self.bottomBarItem] animated:animated];
	[self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarItems:nil animated:animated];
	[self.navigationController setToolbarHidden:YES animated:animated];
}

@end
