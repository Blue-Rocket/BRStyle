//
//  UIViewController+BRUIStyle.h
//  BRStyle
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRUIStyle.h"

/**
 Extension to UIViewController to allow for stylish objects.
 
 This extension will hook into the @c viewDidLoad method and for any UIViewController that also
 conforms to @c BRUIStylishHost will have their style automatically updated, as well as when
 global style changes are made.
 */
@interface UIViewController (BRUIStyle)

/** A BRUIStyle object to use. If not configured, the global default style will be returned. */
@property (nonatomic, strong, null_resettable) IBOutlet BRUIStyle *uiStyle;

@end
