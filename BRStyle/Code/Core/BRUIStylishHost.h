//
//  BRUIStylishHost.h
//  BRStyle
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRUIStyle;

/**
 API for objects that host a @c BRUIStyle instance and are interested in changes at runtime.
 */
@protocol BRUIStylishHost <NSObject>

@optional

/**
 Sent to the receiver if the @c BRUIStyle object associated with the receiver has changed.
 */
- (void)uiStyleDidChange:(BRUIStyle *)style;

@end
