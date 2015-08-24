//
//  BRUIStyleObserver.m
//  BRStyle
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRUIStyleObserver.h"

@implementation BRUIStyleObserver

- (void)dealloc {
	if ( _updateObserver ) {
		[[NSNotificationCenter defaultCenter] removeObserver:_updateObserver];
	}
}

@end
