//
//  UIBarButtonItem+BRUIStyle.m
//  BRStyle
//
//  Created by Matt on 25/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIBarButtonItem+BRUIStyle.h"

#import <objc/runtime.h>
#import "BRUIStylishHost.h"
#import "BRUIStyleObserver.h"

static IMP original_initWithTitleStyleTargetAction;//(id, SEL, NSString *, UIBarButtonItemStyle, id, SEL);

static id bruistyle_initWithTitleStyleTargetAction(id self, SEL _cmd, NSString *title, UIBarButtonItemStyle style, id target, SEL action) {
	self = ((id(*)(id,SEL,NSString *, UIBarButtonItemStyle, id, SEL))original_initWithTitleStyleTargetAction)(self, _cmd, title, style, target, action);
	if ( ![self conformsToProtocol:@protocol(BRUIStylishHost)] ) {
		return self;
	}
	if ( [self respondsToSelector:@selector(uiStyleDidChange:)] ) {
		[self uiStyleDidChange:[self uiStyle]];
		[BRUIStyleObserver addStyleObservation:self];
	}
	return self;
}

@implementation UIBarButtonItem (BRUIStyle)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];		
		SEL originalSelector = @selector(initWithTitle:style:target:action:);
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		original_initWithTitleStyleTargetAction = method_setImplementation(originalMethod, (IMP)bruistyle_initWithTitleStyleTargetAction);
	});
}

- (BRUIStyle *)uiStyle {
	BRUIStyle *style = objc_getAssociatedObject(self, @selector(uiStyle));
	if ( !style ) {
		style = [BRUIStyle defaultStyle];
	}
	return style;
}

- (void)setUiStyle:(BRUIStyle *)style {
	objc_setAssociatedObject(self, @selector(uiStyle), style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if ( [self respondsToSelector:@selector(uiStyleDidChange:)] ) {
		[(id<BRUIStylishHost>)self uiStyleDidChange:[self uiStyle]];
	}
}

@end
