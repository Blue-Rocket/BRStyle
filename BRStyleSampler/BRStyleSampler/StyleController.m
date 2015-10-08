//
//  StyleController.m
//  BRStyleSampler
//
//  Created by Matt on 27/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import "StyleController.h"

#import <BRStyle/Core.h>

@implementation StyleController {
	BRMutableUIStyle *style;
}

@synthesize style;

- (instancetype)initWithStyle:(BRMutableUIStyle *)theStyle {
	if ( (self = [super init]) ) {
		style = theStyle;
	}
	return self;
}

#pragma mark - Public API

- (NSString *)titleForSection:(NSInteger)section {
	NSArray *titles = [self sectionTitles];
	if ( section < titles.count ) {
		return titles[section];
	}
	return @"???";
}

- (NSInteger)numberOfSections {
	return [self sectionTitles].count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	switch ( section ) {
		case 0:
			return [self colorProperties].count;
		
		case 1:
			return [self fontProperties].count;
			
		case 2:
			return [self controlProperties].count;
	}
	return 0;
}

- (NSString *)styleItemKeyPathForIndexPath:(NSIndexPath *)indexPath {
	NSString *keyPath = nil;
	switch ( indexPath.section ) {
		case 0:
			keyPath = [@"colors." stringByAppendingString:[self colorProperties][indexPath.row]];
			break;
			
		case 1:
			keyPath = [@"fonts." stringByAppendingString:[self fontProperties][indexPath.row]];
			break;
			
		case 2:
			keyPath = [@"controls." stringByAppendingString:[self controlProperties][indexPath.row]];
			break;
	}
	return keyPath;
}

- (id)styleItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *keyPath = [self styleItemKeyPathForIndexPath:indexPath];
	return [style valueForKeyPath:keyPath];
}

- (NSString *)titleForStyleItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *keyPath = [self styleItemKeyPathForIndexPath:indexPath];
	NSString *settingName = [keyPath substringFromIndex:([keyPath rangeOfString:@"." options:NSBackwardsSearch].location + 1)];
	return [self displayNameForStyleName:settingName];
}

#pragma mark - Utilities

- (NSArray *)sectionTitles {
	static NSArray *titles;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		titles = @[@"Colors", @"Fonts", @"Control Colors"];
	});
	return titles;
}

- (NSDictionary *)propertyKeys {
	static NSDictionary *keys;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		keys = [[BRUIStyle defaultStyle] dictionaryRepresentation];
	});
	return keys;
}

- (NSArray *)colorProperties {
	static NSArray *props;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *keys = [self propertyKeys];
		NSArray *colors = [[keys[@"colors"] allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH %@", @"Color"]];
		props = [colors sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	});
	return props;
}

- (NSArray *)fontProperties {
	static NSArray *props;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *keys = [self propertyKeys];
		NSArray *fonts = [keys[@"fonts"] allKeys];
		props = [fonts sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	});
	return props;
}

- (NSArray *)controlProperties {
	static NSArray *props;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *keys = [self propertyKeys];
		NSArray *colors = [[keys[@"controls"] allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH %@", @"Color"]];
		props = [colors sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	});
	return props;
}

- (NSString *)displayNameForStyleName:(NSString *)name {
	// turn names like mySuperColor into "My Super Color"
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


@end
