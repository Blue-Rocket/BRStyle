//
//  UIViewController+BRUIStyle.m
//  BRStyle
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIViewController+BRUIStyle.h"

#import <objc/runtime.h>
#import "BRUIStylishHost.h"
#import "BRUIStyleObserver.h"

static IMP original_viewDidLoad;//(id, SEL);

void bruistyle_viewDidLoad(id self, SEL _cmd) {
	((void(*)(id,SEL))original_viewDidLoad)(self, _cmd);
	if ( ![self conformsToProtocol:@protocol(BRUIStylishHost)] ) {
		return;
	}
	[self uiStyleDidChange:[self uiStyle]];
	[BRUIStyleObserver addStyleObservation:self];
}

@implementation UIViewController (BRUIStyle)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		SEL originalSelector = @selector(viewDidLoad);
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		original_viewDidLoad = method_setImplementation(originalMethod, (IMP)bruistyle_viewDidLoad);
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

@end
