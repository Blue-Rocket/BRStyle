//
//  BRUIStyleObserver.h
//  BRStyle
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@protocol BRUIStylishHost;

/**
 An internal object used to observe changes to @c BRUIStylishHost objects.
 */
@interface BRUIStyleObserver : NSObject

@property (nonatomic, strong) id updateObserver;

/**
 Add a style observer to an object.
 
 @param host The object to notify of style changes.
 */
+ (void)addStyleObservation:(id<BRUIStylishHost>)host;

/**
 Test if an observer is already set up for a given host.
 
 @param host The host to test.
 
 @return @c YES if observation is already in place.
 */
+ (BOOL)isObservingStyleInHost:(id<BRUIStylishHost>)host;

@end
