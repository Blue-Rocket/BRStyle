//
//  UIView+BRUIStyle.h
//  BRStyle
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRUIStyle.h"

@interface UIView (BRUIStyle)

/** A BRUIStyle object to use. If not configured, the global default style will be returned. */
@property (nonatomic, strong, null_resettable) IBOutlet BRUIStyle *uiStyle;

/**
 Find the nearest superview of the receiver that is a specific class.
 
 @param clazz The class of the view to look for.
 @return The found ancestor view, or @c nil if not found.
 */
- (nullable id)nearestAncestorViewOfType:(__nonnull Class)clazz;

/**
 Find the nearest view controller in the receiver's responder chain.
 
 @return The nearest view controller in the responder chain, or @c nil if not found.
 */
- (nullable UIViewController *)nearestViewControllerInResponderChain;

@end
