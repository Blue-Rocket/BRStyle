//
//  BRUIStyleObserver.h
//  BRStyle
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@interface BRUIStyleObserver : NSObject

@property (nonatomic, assign) __unsafe_unretained id host;
@property (nonatomic, strong) id updateObserver;

@end
