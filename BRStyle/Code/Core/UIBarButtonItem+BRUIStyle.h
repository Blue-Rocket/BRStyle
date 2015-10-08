//
//  UIBarButtonItem+BRUIStyle.h
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRUIStyle.h"
#import "BRUIStylishControl.h"

/**
 Extension to UIBarButtonItem to allow for stylish objects.
 
 This extension will hook into the @c initWithTitle:style:target:action: method and for any subclass that 
 conforms to @c BRUIStylishHost will have their style automatically updated, as well as when global style 
 changes are made.
 */
@interface UIBarButtonItem (BRUIStyle) <BRUIStylishControl>

/** A BRUIStyle object to use. If not configured, the global default style will be returned. */
@property (nonatomic, strong, null_resettable) IBOutlet BRUIStyle *uiStyle;

/**
 Register a default style to use for a specific state. If a style is not set specifically on a UIControl
 then @c uiStyleForState: will return the registered default style, if available.
 
 @param style The style to register.
 @param state The state.
 */
+ (void)setDefaultUiStyle:(nullable BRUIStyle *)style forState:(UIControlState)state;

/**
 Get a previously registered default style for a given state.
 
 @param state The state.
 
 @return The registered style, or @c nil if none registered.
 */
+ (nullable BRUIStyle *)defaultUiStyleForState:(UIControlState)state;

/**
 Remove all registered default styles for all states.
 */
+ (void)removeAllDefaultUiStyles;

@end
