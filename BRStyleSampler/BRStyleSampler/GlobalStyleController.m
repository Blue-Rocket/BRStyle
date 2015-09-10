//
//  GlobalStyleController.m
//  MenuSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "GlobalStyleController.h"

#import "ColorPickerViewController.h"
#import "ColorSwatchView.h"
#import "StyleColorTableViewCell.h"
#import "StyleController.h"
#import "StyleExportViewController.h"

static NSString * const kColorCellIdentifier = @"ColorCell";
static NSString * const kFontCellIdentifier = @"FontCell";
static NSString * const kEditColorSegue = @"EditColor";
static NSString * const kExportStyleSegue = @"ExportStyle";

@interface GlobalStyleController () <ColorPickerViewControllerDelegate>

@end

@implementation GlobalStyleController {
	StyleController *controller;
	NSIndexPath *selectedStyleIndexPath;
	NSString *selectedStyleKeyPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	controller = [[StyleController alloc] initWithStyle:[[BRUIStyle defaultStyle] mutableCopy]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [controller numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [controller titleForSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [controller numberOfItemsInSection:section];
}

static const NSInteger kFontSection = 6;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
 
	NSString *displayName = [controller titleForStyleItemAtIndexPath:indexPath];
	
	if ( indexPath.section == kFontSection ) {
		// font section
		UITableViewCell *fontCell = [tableView dequeueReusableCellWithIdentifier:kFontCellIdentifier forIndexPath:indexPath];
		fontCell.textLabel.font = [controller styleItemAtIndexPath:indexPath];
		fontCell.textLabel.text = displayName;
		fontCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ @ %d pt", [fontCell.textLabel.font fontName], (int)fontCell.textLabel.font.pointSize];
		fontCell.detailTextLabel.textColor = [UIColor lightGrayColor];
		fontCell.detailTextLabel.font = [UIFont systemFontOfSize:10];
		cell = fontCell;
	} else {
		// color section
		StyleColorTableViewCell *colorCell = [tableView dequeueReusableCellWithIdentifier:kColorCellIdentifier forIndexPath:indexPath];
		colorCell.titleLabel.text = displayName;
		colorCell.colorSwatch.color = [controller styleItemAtIndexPath:indexPath];
		cell = colorCell;
	}
    
    return cell;
}

#pragma mark - ColorPickerViewControllerDelegate

- (void)colorPickerDidPickColor:(ColorPickerViewController *)picker {
	if ( selectedStyleIndexPath ) {
		[controller.style setValue:picker.color forKeyPath:selectedStyleKeyPath];
		StyleColorTableViewCell *cell = (StyleColorTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedStyleIndexPath];
		cell.colorSwatch.color = picker.color;
		[BRUIStyle setDefaultStyle:controller.style];
	}
}

#pragma mark - Actions

- (IBAction)exportStyle:(id)sender {
	[self performSegueWithIdentifier:kExportStyleSegue sender:sender];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ( [segue.identifier isEqualToString:kEditColorSegue] ) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		selectedStyleIndexPath = indexPath;
		selectedStyleKeyPath = [controller styleItemKeyPathForIndexPath:indexPath];;
		ColorPickerViewController *dest = segue.destinationViewController;
		StyleColorTableViewCell *cell = (StyleColorTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
		dest.color = cell.colorSwatch.color;
		dest.delegate = self;
	} else if ( [segue.identifier isEqualToString:kExportStyleSegue] ) {
		StyleExportViewController *export = segue.destinationViewController;
		export.uiStyle = [controller.style copy];
	}
}

@end
