//
//  RestKitDataMapper.h
//  BRStyleSampler
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

@class RKObjectMapping;

@interface RestKitDataMapper : NSObject

/**
 Initialize with a RestKit mapping configuration.
 
 @param mapping The mapping to use.
 */
- (instancetype)initWithObjectMapping:(RKObjectMapping *)mapping;

- (id)performMappingWithSourceObject:(id)sourceObject error:(NSError *__autoreleasing *)error;

- (id)performEncodingWithObject:(id)domainObject error:(NSError *__autoreleasing *)error;

@end
