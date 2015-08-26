//
//  BRUIStylish.h
//  BRStyle
//
//  Created by Matt on 26/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRUIStyle.h"

/**
 A protocol for objects that support styling via BRUIStyle to conform to.
 */
@protocol BRUIStylish <NSObject>

/** A BRUIStyle object to use. If not configured, the global default style should be returned. */
@property (nonatomic, strong, null_resettable) IBOutlet BRUIStyle *uiStyle;

@end
