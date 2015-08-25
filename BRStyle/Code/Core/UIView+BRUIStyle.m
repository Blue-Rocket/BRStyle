//
//  UIView+BRUIStyle.m
//  BRStyle
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIView+BRUIStyle.h"

#import <objc/runtime.h>
#import "BRUIStylishHost.h"
#import "BRUIStyleObserver.h"

static IMP original_willMoveToWindow;//(id, SEL, UIWindow *);

void bruistyle_willMoveToWindow(id self, SEL _cmd, UIWindow * window) {
	((void(*)(id,SEL,UIWindow *))original_willMoveToWindow)(self, _cmd, window);
	if ( ![self conformsToProtocol:@protocol(BRUIStylishHost)] ) {
		return;
	}
	[self uiStyleDidChange:[self uiStyle]];
	[BRUIStyleObserver addStyleObservation:self];
}

@implementation UIView (BRUIStyle)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		SEL originalSelector = @selector(willMoveToWindow:);
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		original_willMoveToWindow = method_setImplementation(originalMethod, (IMP)bruistyle_willMoveToWindow);
	});
}

- (BRUIStyle *)uiStyle {
	BRUIStyle *style = objc_getAssociatedObject(self, @selector(uiStyle));
	
	// if this view doesn't define a custom style, search the responder chain for the closest defined style
	UIResponder *responder = self;
	while ( !style && [responder nextResponder] ) {
		responder = [responder nextResponder];
		if ( [responder respondsToSelector:@selector(uiStyle)] ) {
			style = [(id)responder uiStyle];
		}
	}
	if ( !style ) {
		style = [BRUIStyle defaultStyle];
	}
	return style;
}

- (void)setUiStyle:(BRUIStyle *)style {
	objc_setAssociatedObject(self, @selector(uiStyle), style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if ( [self respondsToSelector:@selector(uiStyleDidChange:)] ) {
		[(id<BRUIStylishHost>)self uiStyleDidChange:style];
	}
}

- (id)nearestAncestorViewOfType:(Class)clazz {
	UIView *v = self;
	while ( v != nil ) {
		if ( [v isKindOfClass:clazz] ) {
			return v;
		}
		v = v.superview;
	}
	return nil;
}

- (UIViewController *)nearestViewControllerInResponderChain {
	UIResponder *responder = [self nextResponder];
	while ( responder != nil && ![responder isKindOfClass:[UIViewController class]] ) {
		responder = [responder nextResponder];
	}
	if ( responder == nil ) {
		responder = self.window.rootViewController;
	}
	return (UIViewController *)responder;
}

@end
