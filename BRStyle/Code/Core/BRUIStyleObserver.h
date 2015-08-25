//
//  BRUIStyleObserver.h
//  BRStyle
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@protocol BRUIStylishHost;

@interface BRUIStyleObserver : NSObject

@property (nonatomic, assign) __unsafe_unretained id host;
@property (nonatomic, strong) id updateObserver;

/**
 Add a style observer to an object.
 
 @param host The object to notify of style changes.
 */
+ (void)addStyleObservation:(id<BRUIStylishHost>)host;

@end
