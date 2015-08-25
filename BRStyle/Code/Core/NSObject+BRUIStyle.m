//
//  NSObject+BRUIStyle.m
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "NSObject+BRUIStyle.h"

#import <objc/runtime.h>
#import "BRUIStyle.h"
#import "BRUIStylishHost.h"
#import "BRUIStyleObserver.h"

static IMP original_awakeFromNib;//(id, SEL);

static void bruistyle_awakeFromNib(id self, SEL _cmd) {
	((void(*)(id,SEL))original_awakeFromNib)(self, _cmd);
	if ( ![self conformsToProtocol:@protocol(BRUIStylishHost)] ) {
		return;
	}
	if ( [self respondsToSelector:@selector(uiStyleDidChange:)] ) {
		[self uiStyleDidChange:[self uiStyle]];
		[BRUIStyleObserver addStyleObservation:self];
	}
}

@implementation NSObject (BRUIStyle)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		SEL originalSelector = @selector(awakeFromNib);
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		original_awakeFromNib = method_setImplementation(originalMethod, (IMP)bruistyle_awakeFromNib);
	});
}

@end
