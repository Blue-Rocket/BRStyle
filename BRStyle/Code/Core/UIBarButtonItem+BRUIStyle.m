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
#import "UIControl+BRUIStyle.h"

static IMP original_initWithTitleStyleTargetAction;//(id, SEL, NSString *, UIBarButtonItemStyle, id, SEL);
static id bruistyle_initWithTitleStyleTargetAction(id self, SEL _cmd, NSString *title, UIBarButtonItemStyle style, id target, SEL action);
static IMP original_setEnabled;//(id, SEL, BOOL);
static void bruistyle_setEnabled(id self, SEL _cmd, BOOL);

static NSMutableDictionary<NSNumber *, BRUIStyle *> *DefaultStateStyles;

@implementation UIBarButtonItem (BRUIStyle)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];		
		SEL originalSelector = @selector(initWithTitle:style:target:action:);
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		original_initWithTitleStyleTargetAction = method_setImplementation(originalMethod, (IMP)bruistyle_initWithTitleStyleTargetAction);

		originalSelector = @selector(setEnabled:);
		originalMethod = class_getInstanceMethod(class, originalSelector);
		original_setEnabled = method_setImplementation(originalMethod, (IMP)bruistyle_setEnabled);
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

+ (NSArray *)orderedSupportedStates {
	return @[@(UIControlStateDisabled),
			 @(BRUIStyleControlStateDangerous)];
}

+ (void)removeAllDefaultUiStyles {
	[DefaultStateStyles removeAllObjects];
}

+ (void)setDefaultUiStyle:(nullable BRUIStyle *)style forState:(UIControlState)state {
	NSMutableDictionary<NSNumber *, BRUIStyle *> *dict = DefaultStateStyles;
	if ( !dict && style ) {
		dict = [[NSMutableDictionary alloc] initWithCapacity:5];
		DefaultStateStyles = dict;
	}
	NSNumber *key = @(state);
	if ( style ) {
		dict[key] = style;
	} else {
		[dict removeObjectForKey:key];
	}
}

+ (nullable BRUIStyle *)defaultUiStyleForState:(UIControlState)state {
	return DefaultStateStyles[@(state)];
}

- (void)setUiStyleStateFlag:(UIControlState)flag enabled:(BOOL)enabled {
	UIControlState state = [self uiStyleState];
	UIControlState newState = (enabled ? (state | flag) : (state & ~flag));
	if ( newState != state ) {
		[self setUiStyleState:newState];
	}
}

- (BOOL)isStateFlagSet:(UIControlState)state {
	UIControlState myState = [self uiStyleState];
	if ( !self.enabled ) {
		myState |= UIControlStateDisabled;
	}
	return ((myState & state) == state);
}

- (BOOL)isDangerous {
	return [self isStateFlagSet:BRUIStyleControlStateDangerous];
}

- (void)setDangerous:(BOOL)dangerous {
	[self setUiStyleStateFlag:BRUIStyleControlStateDangerous enabled:dangerous];
}

- (UIControlState)uiStyleState {
	NSNumber *val = objc_getAssociatedObject(self, @selector(uiStyleState));
	return [val unsignedIntegerValue];
}

- (void)setUiStyleState:(UIControlState)state {
	objc_setAssociatedObject(self, @selector(uiStyleState), @(state), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if ( [self respondsToSelector:@selector(stateDidChange)] ) {
		[self stateDidChange];
	}
}

- (NSMutableDictionary<NSNumber *, BRUIStyle *> *)uiStyleStateDictionary {
	return [self uiStyleStateDictionary:NO];
}

- (NSMutableDictionary<NSNumber *, BRUIStyle *> *)uiStyleStateDictionary:(BOOL)create {
	NSMutableDictionary<NSNumber *, BRUIStyle *> *val = objc_getAssociatedObject(self, @selector(uiStyleStateDictionary));
	if ( !val && create ) {
		val = [[NSMutableDictionary alloc] initWithCapacity:5];
		objc_setAssociatedObject(self, @selector(uiStyleStateDictionary), val, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return val;
}

- (BRUIStyle *)uiStyleForStateWithoutDefault:(UIControlState)state {
	NSNumber *key = @(state);
	BRUIStyle *style = [self uiStyleStateDictionary:NO][key];
	if ( !style ) {
		// try default for state
		style = DefaultStateStyles[@(state)];
	}
	if ( !style && state != UIControlStateNormal ) {
		
		// perhaps we have multiple states active, like Dangerous|Highlighted; choose based on hard-coded priority:
		for ( NSNumber *singleKey in [UIBarButtonItem orderedSupportedStates] ) {
			NSUInteger singleState = [singleKey unsignedIntegerValue];
			if ( (singleState & state) == singleState ) {
				style = [self uiStyleStateDictionary:NO][singleKey];
				if ( !style ) {
					// and try default for single state
					style = DefaultStateStyles[singleKey];
				}
				if ( style ) {
					return style;
				}
			}
		}
		
		// fall back to trying normal state
		NSNumber *normalKey = @(UIControlStateNormal);
		style = [self uiStyleStateDictionary:NO][normalKey];
		if ( !style ) {
			// try default for normal state
			style = DefaultStateStyles[normalKey];
		}
	}
	return style;
}

- (BRUIStyle *)uiStyleForState:(UIControlState)state {
	BRUIStyle *style = [self uiStyleForStateWithoutDefault:state];
	if ( !style ) {
		// fall back to global default style
		style = [BRUIStyle defaultStyle];
	}
	return style;
}

- (void)setUiStyle:(nullable BRUIStyle *)style forState:(UIControlState)state UI_APPEARANCE_SELECTOR {
	NSNumber *key = @(state);
	if ( style == nil ) {
		[[self uiStyleStateDictionary:NO] removeObjectForKey:key];
	} else {
		[self uiStyleStateDictionary:YES][key] = style;
	}
}

@end

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

static void bruistyle_setEnabled(id self, SEL _cmd, BOOL value) {
	BOOL previousValue = NO;
	previousValue = [self isEnabled];
	((void(*)(id,SEL,BOOL))original_setEnabled)(self, _cmd, value);
	if ( previousValue != value && [self respondsToSelector:@selector(stateDidChange)] ) {
		[self stateDidChange];
	}
}

