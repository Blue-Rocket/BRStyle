//
//  NSObject+BRUIStyle.h
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

/**
 Extension to NSObject to hook into NIB loading of stylish objects.
 
 Any object that conforms to @c BRUIStylishHost will have their style automatically
 updated when loaded from a NIB, as well as when global style changes are made.
 */
@interface NSObject (BRUIStyle)

@end
