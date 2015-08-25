//
//  GlobalStyleController.m
//  MenuSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "GlobalStyleController.h"

#import <MAObjCRuntime/MARTNSObject.h>
#import <MAObjCRuntime/RTProperty.h>
#import "ColorPickerViewController.h"
#import "ColorSwatchView.h"
#import "StyleColorTableViewCell.h"
#import "StyleExportViewController.h"

static NSString * const kColorCellIdentifier = @"ColorCell";
static NSString * const kEditColorSegue = @"EditColor";
static NSString * const kExportStyleSegue = @"ExportStyle";

@interface GlobalStyleController () <ColorPickerViewControllerDelegate>

@end

@implementation GlobalStyleController {
	BRMutableUIStyle *uiStyle;
	NSString *selectedStyleName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	uiStyle = [[BRUIStyle defaultStyle] mutableCopy];
}

- (NSArray *)colorStylePropertyNames {
	static NSArray *names;
	if ( !names ) {
		NSMutableArray *colors = [NSMutableArray new];
		for ( RTProperty *prop in [[BRUIStyle class] rt_properties] ) {
			if ( [prop.name hasSuffix:@"Color"] ) {
				[colors addObject:[prop.name substringToIndex:(prop.name.length - 5)]];
			}
		}
		[colors sortUsingSelector:@selector(caseInsensitiveCompare:)];
		names = [colors copy];
	}
	return names;
}

- (UIColor *)colorForName:(NSString *)colorName inStyle:(BRUIStyle *)style {
	return [style valueForKeyPath:[colorName stringByAppendingString:@"Color"]];
}

- (void)setColor:(UIColor *)color forName:(NSString *)colorName inStyle:(BRMutableUIStyle *)style {
	[style setValue:color forKeyPath:[colorName stringByAppendingString:@"Color"]];
	[BRUIStyle setDefaultStyle:style];
}

- (NSString *)displayNameForStyleName:(NSString *)name {
	static NSRegularExpression *regex;
	if ( !regex ) {
		regex = [NSRegularExpression regularExpressionWithPattern:@"(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])" options:0 error:nil];
	}
	NSMutableArray *components = [NSMutableArray new];
	__block NSUInteger idx = 0;
	[regex enumerateMatchesInString:name options:0 range:NSMakeRange(0, [name length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		NSRange compRange = NSMakeRange(idx, [result range].location - idx);
		[components addObject:[[name substringWithRange:compRange] capitalizedString]];
		idx += compRange.length;
	}];
	if ( idx < name.length ) {
		[components addObject:[[name substringFromIndex:idx] capitalizedString]];
	}
	return [components componentsJoinedByString:@" "];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch ( section ) {
		case 0:
			return @"Color";
	}
	return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self colorStylePropertyNames] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
 
	if ( indexPath.section == 0 ) {
		// color section
		NSString *colorName = [self colorStylePropertyNames][indexPath.row];
		StyleColorTableViewCell *colorCell = [tableView dequeueReusableCellWithIdentifier:kColorCellIdentifier forIndexPath:indexPath];
		colorCell.titleLabel.text = [self displayNameForStyleName:colorName];
		colorCell.colorSwatch.color = [self colorForName:colorName inStyle:[BRUIStyle defaultStyle]];
		cell = colorCell;
	}
	
    // Configure the cell...
    
    return cell;
}

#pragma mark - ColorPickerViewControllerDelegate

- (void)colorPickerDidPickColor:(ColorPickerViewController *)picker {
	if ( selectedStyleName ) {
		[self setColor:picker.color forName:selectedStyleName inStyle:uiStyle];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[self colorStylePropertyNames] indexOfObject:selectedStyleName] inSection:0];
		StyleColorTableViewCell *cell = (StyleColorTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
		cell.colorSwatch.color = picker.color;
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
		NSString *colorName = [self colorStylePropertyNames][indexPath.row];
		selectedStyleName = colorName;
		ColorPickerViewController *dest = segue.destinationViewController;
		StyleColorTableViewCell *cell = (StyleColorTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
		dest.color = cell.colorSwatch.color;
		dest.delegate = self;
	} else if ( [segue.identifier isEqualToString:kExportStyleSegue] ) {
		StyleExportViewController *export = segue.destinationViewController;
		export.uiStyle = [uiStyle copy];
	}
}

@end
