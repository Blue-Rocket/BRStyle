//
//  UIControl+BRUIStyle.h
//  BRStyle
//
//  Created by Matt on 8/10/15.
//  Copyright © 2015 Blue Rocket, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BRUIStylishControl.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Extension to UIControl to support setting styles for each control state.
 */
@interface UIControl (BRUIStyle) <BRUIStylishControl>

/**
 Get a key name value for a given control state. This key can be used when encoding styles into JSON representations.
 
 @param state The control state.
 
 @return The key name. Multiple states will be returned as a delimited string using a pipe character (@c |) as the delimiter.
 */
+ (NSString *)keyNameForControlState:(UIControlState)state;

/**
 Get a control state for a key name.
 
 @param name The key name to get the corresponding state value for. The name can be a combination of states by delimiting each state with a pipe character (@c |).
 
 @return The state value, or list of values.
 */
+ (UIControlState)controlStateForKeyName:(NSString *)name;

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

@end

NS_ASSUME_NONNULL_END
