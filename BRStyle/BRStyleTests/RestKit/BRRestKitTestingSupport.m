//
//  BRRestKitTestingSupport.m
//  BRStyle
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRRestKitTestingSupport.h"

#import <RestKit/RestKit.h>

static NSBundle *fixtureBundle = nil;

@implementation BRRestKitTestingSupport

+ (NSBundle *)fixtureBundle
{
	NSAssert(fixtureBundle != nil, @"Bundle for fixture has not been set. Use setFixtureBundle: to set it.");
	return fixtureBundle;
}

+ (void)setFixtureBundle:(NSBundle *)bundle
{
	NSAssert(bundle != nil, @"Bundle for fixture cannot be nil.");
	fixtureBundle = bundle;
}

+ (NSData *)dataWithContentsOfFixture:(NSString *)fixtureName
{
	NSString *resourcePath = [[self fixtureBundle] pathForResource:fixtureName ofType:nil];
	if (! resourcePath) {
		RKLogWarning(@"Failed to locate Fixture named '%@' in bundle %@: File Not Found.", fixtureName, [self fixtureBundle]);
		return nil;
	}
	
	return [NSData dataWithContentsOfFile:resourcePath];
}

+ (NSString *)MIMETypeForFixture:(NSString *)fixtureName
{
	NSString *resourcePath = [[self fixtureBundle] pathForResource:fixtureName ofType:nil];
	if (resourcePath) {
		return RKMIMETypeFromPathExtension(resourcePath);
	}
	
	return nil;
}

+ (id)parsedObjectWithContentsOfFixture:(NSString *)fixtureName
{
	NSError *error = nil;
	NSData *resourceContents = [self dataWithContentsOfFixture:fixtureName];
	NSAssert(resourceContents, @"Failed to read fixture named '%@'", fixtureName);
	NSString *MIMEType = [self MIMETypeForFixture:fixtureName];
	NSAssert(MIMEType, @"Failed to determine MIME type of fixture named '%@'", fixtureName);
	
	id object = [RKMIMETypeSerialization objectFromData:resourceContents MIMEType:MIMEType error:&error];
	NSAssert(object, @"Failed to parse fixture name '%@' in bundle %@. Error: %@", fixtureName, [self fixtureBundle], [error localizedDescription]);
	return object;
}

@end
