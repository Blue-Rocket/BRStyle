//
//  BRRestKitTestingSupport.h
//  BRStyle
//
//  Adapted from RestKit's RKTestFixture.
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@interface BRRestKitTestingSupport : NSObject

/**
 Returns the NSBundle object designated as the source location for unit testing fixture data.
 
 @return The NSBundle object designated as the source location for unit testing fixture data
 or nil if none has been configured.
 */
+ (NSBundle *)fixtureBundle;

/**
 Designates the specified NSBundle object as the source location for unit testing fixture data.
 
 @param bundle The new fixture NSBundle object.
 */
+ (void)setFixtureBundle:(NSBundle *)bundle;

/**
 Creates and returns a data object by reading every byte from the fixture identified by the specified file name.
 
 @param fixtureName The name of the resource file.
 @return A data object by reading every byte from the fixture file.
 */
+ (NSData *)dataWithContentsOfFixture:(NSString *)fixtureName;

/**
 Returns the MIME Type for the fixture identified by the specified name.
 
 @param fixtureName The name of the fixture file.
 @return The MIME Type for the resource file or nil if the file could not be located.
 */
+ (NSString *)MIMETypeForFixture:(NSString *)fixtureName;

/**
 Creates and returns an object representation of the data from the fixture identified by the specified file name by reading the data as a string and parsing it using a parser appropriate for the MIME Type of the file.
 
 @param fixtureName The name of the resource file.
 @return A new image object for the specified file, or nil if the method could not initialize the image from the specified file.
 @see `RKMIMETypeSerialization`
 */
+ (id)parsedObjectWithContentsOfFixture:(NSString *)fixtureName;

@end
