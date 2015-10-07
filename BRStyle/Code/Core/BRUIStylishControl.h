//
//  BRUIStylishControl.h
//  BRStyle
//
//  Created by Matt on 8/10/15.
//  Copyright © 2015 Blue Rocket, Inc. All rights reserved.
//

#import "BRUIStyle.h"

extern const UIControlState BRUIStyleControlStateDangerous;

NS_ASSUME_NONNULL_BEGIN

/**
 API for objects that act like controls, with style settings based on a UIControlState.
 */
@protocol BRUIStylishControl <NSObject>

/** Manage theBRUIStyleControlStateDangerous state flag. */
@property(nonatomic, getter=isDangerous) IBInspectable BOOL dangerous;

/**
 Get a style for a control state. If a style is not defined for the given state, then the style configured
 for the @c UIControlStateNormal state should be returned. If no state is configured for the @c UIControlStateNormal
 state, then the global default style should be returned.
 
 @param state The control state.
 
 @return The style associated with the given control state, or the defalut style if nothing specific configured.
 */
- (BRUIStyle *)uiStyleForState:(UIControlState)state;

/**
 Set a style to use for a specific control state.
 
 @param style The style to use.
 @param state The control state to apply the style settings to.
 */
- (void)setUiStyle:(nullable BRUIStyle *)style forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

@optional

/**
 Notify the receiver that the control state has been updated.
 */
- (void)stateDidChange;

@end

NS_ASSUME_NONNULL_END
