//
//  StyleExportViewController.m
//  MenuSampler
//
//  Created by Matt on 3/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "StyleExportViewController.h"

#import <BRCocoaLumberjack/BRCocoaLumberjack.h>
#import <BRStyle/BRStyle.h>
#import "RestKitDataMapper.h"

@interface StyleExportViewController () <BRUIStylish>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@end

@implementation StyleExportViewController

@dynamic uiStyle;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	BRUIStyle *style = self.uiStyle;
	NSString *json = [self jsonForStyle:style];
	self.textView.text = json;
}

- (NSString *)jsonForStyle:(BRUIStyle *)style {
	static RestKitDataMapper *mapper;
	if ( !mapper ) {
		mapper = [[RestKitDataMapper alloc] initWithObjectMapping:[BRUIStyleMappingRestKit uiStyleMapping]];
	}
	
	NSError *error = nil;
	NSDictionary *dict = [mapper performEncodingWithObject:style error:&error];
	if ( error ) {
		log4Error(@"Error mapping JSON: %@", [error localizedDescription]);
		return nil;
	}
	NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
	if ( error ) {
		log4Error(@"Error encoding JSON: %@", [error localizedDescription]);
		return nil;
	}
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
