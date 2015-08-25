//
//  BRUIStyleObserver.m
//  BRStyle
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRUIStyleObserver.h"

#import <objc/runtime.h>
#import "BRUIStyle.h"
#import "BRUIStylishHost.h"

static void *BRUIStyleObserverKey = &BRUIStyleObserverKey;

@implementation BRUIStyleObserver

- (void)dealloc {
	if ( _updateObserver ) {
		[[NSNotificationCenter defaultCenter] removeObserver:_updateObserver];
	}
}

+ (void)addStyleObservation:(id<BRUIStylishHost>)host {
	BRUIStyleObserver *obs = objc_getAssociatedObject(host, BRUIStyleObserverKey);
	if ( !obs ) {
		obs = [BRUIStyleObserver new];
		obs.host = host;
		objc_setAssociatedObject(host, BRUIStyleObserverKey, obs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	if ( !obs.updateObserver ) {
		__weak id weakSelf = host;
		obs.updateObserver = [[NSNotificationCenter defaultCenter] addObserverForName:BRNotificationUIStyleDidChange object:nil queue:nil usingBlock:^(NSNotification *note) {
			BRUIStyle *myStyle = [weakSelf uiStyle];
			if ( myStyle.defaultStyle ) {
				[(id<BRUIStylishHost>)weakSelf uiStyleDidChange:myStyle];
			}
		}];
	}
}

@end
