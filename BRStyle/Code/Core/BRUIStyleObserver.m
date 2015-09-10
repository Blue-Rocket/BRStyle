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

- (id)initWithHost:(id<BRUIStylishHost>)host {
	if ( (self = [super init]) ) {
		__weak id<BRUIStylishHost> myHost = host;
		_updateObserver = [[NSNotificationCenter defaultCenter] addObserverForName:BRStyleNotificationUIStyleDidChange object:nil queue:nil usingBlock:^(NSNotification *note) {
			BRUIStyle *myStyle = [myHost uiStyle];
			if ( myStyle.defaultStyle ) {
				[myHost uiStyleDidChange:note.object];
			}
		}];
	}
	return self;
}

- (void)dealloc {
	if ( _updateObserver ) {
		[[NSNotificationCenter defaultCenter] removeObserver:_updateObserver];
	}
}

+ (void)addStyleObservation:(id<BRUIStylishHost>)host {
	BRUIStyleObserver *obs = objc_getAssociatedObject(host, BRUIStyleObserverKey);
	if ( !obs ) {
		obs = [[BRUIStyleObserver alloc] initWithHost:host];
		objc_setAssociatedObject(host, BRUIStyleObserverKey, obs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

@end
