//
//  UIBarButtonItem+BRUIStylishHost.m
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIBarButtonItem+BRUIStylishHost.h"

#import "UIBarButtonItem+BRUIStyle.h"

@implementation UIBarButtonItem (BRUIStylishHost)

@dynamic uiStyle;

- (void)uiStyleDidChange:(BRUIStyle *)style {
	if ( [style isDefaultStyle] ) {
		// look for more specific style
		for ( NSNumber *stateValue in @[@(UIControlStateNormal), @(UIControlStateDisabled), @(BRUIStyleControlStateDangerous)] ) {
			UIControlState state = [stateValue unsignedIntegerValue];
			BRUIStyle *s = [self uiStyleForState:state];
			if ( s && ![s isDefaultStyle] && s.controls.actionColor && s.fonts.actionFont ) {
				[self setTitleTextAttributes:@{
											   NSForegroundColorAttributeName: s.controls.actionColor,
											   NSFontAttributeName: s.fonts.actionFont,
											   }
									forState:state];
			}
		}
	} else {
		[self setTitleTextAttributes:@{
									   NSForegroundColorAttributeName: style.controls.actionColor,
									   NSFontAttributeName: style.fonts.actionFont,
									   }
							forState:UIControlStateNormal];
	}
}

@end
