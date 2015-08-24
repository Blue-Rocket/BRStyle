//
//  BRUIStyleMappingRestKit.h
//  BRStyle
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <RestKit/ObjectMapping.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Support for mapping BRUIStyle data to native objects via RestKit.
 */
@interface BRUIStyleMappingRestKit : NSObject

/**
 Get an object mapping suitable for mapping data into BRUIStyle instances.
 
 @return The object mapping.
 */
+ (RKObjectMapping *)uiStyleMapping;

@end

NS_ASSUME_NONNULL_END
