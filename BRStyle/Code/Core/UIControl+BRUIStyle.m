//
//  UIControl+BRUIStyle.m
//  BRStyle
//
//  Created by Matt on 8/10/15.
//  Copyright © 2015 Blue Rocket, Inc. All rights reserved.
//

#import "UIControl+BRUIStyle.h"

#import <objc/runtime.h>

const UIControlState BRUIStyleControlStateDangerous = (1 << 16);

static IMP original_getState;//(id, SEL);
static UIControlState bruistyle_getState(id self, SEL _cmd);

static NSMutableDictionary *DefaultStateStyles;

@implementation UIControl (BRUIStyle)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		SEL originalSelector = @selector(state);
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		original_getState = method_setImplementation(originalMethod, (IMP)bruistyle_getState);
	});
}

+ (void)setDefaultUiStyle:(nullable BRUIStyle *)style forState:(UIControlState)state {
	NSMutableDictionary *dict = DefaultStateStyles;
	if ( !dict && style ) {
		dict = [[NSMutableDictionary alloc] initWithCapacity:5];
		DefaultStateStyles = dict;
	}
	NSString *key = [UIControl keyNameForControlState:state];
	if ( style ) {
		dict[key] = style;
	} else {
		[dict removeObjectForKey:key];
	}
}

+ (nullable BRUIStyle *)defaultUiStyleForState:(UIControlState)state {
	return DefaultStateStyles[[UIControl keyNameForControlState:state]];
}

- (void)setUiStyleStateFlag:(UIControlState)flag enabled:(BOOL)enabled {
	UIControlState state = [self uiStyleState];
	UIControlState newState = (enabled ? (state | flag) : (state & ~flag));
	if ( newState != state ) {
		[self setUiStyleState:newState];
	}
}

- (BOOL)isStateFlagSet:(UIControlState)state {
	return (([self state] & state) == state);
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

+ (NSString *)keyNameForControlState:(UIControlState)state {
	switch ( state ) {
		case BRUIStyleControlStateDangerous:
			return @"dangerous";
			
		case UIControlStateDisabled:
			return @"disabled";
			
		case UIControlStateHighlighted:
			return @"highlighted";
			
		case UIControlStateSelected:
			return @"selected";
			
		default:
			return @"normal";
	}
}

+ (UIControlState)controlStateForKeyName:(NSString *)name {
	if ( [name isEqualToString:@"dangerous"] ) {
		return BRUIStyleControlStateDangerous;
	}
	if ( [name isEqualToString:@"disabled"] ) {
		return UIControlStateDisabled;
	}
	if ( [name isEqualToString:@"highlighted"] ) {
		return UIControlStateHighlighted;
	}
	if ( [name isEqualToString:@"selected"] ) {
		return UIControlStateSelected;
	}
	return UIControlStateNormal;
}

- (NSMutableDictionary<NSString *, BRUIStyle *> *)uiStyleStateDictionary {
	return [self uiStyleStateDictionary:NO];
}

- (NSMutableDictionary<NSString *, BRUIStyle *> *)uiStyleStateDictionary:(BOOL)create {
	NSMutableDictionary<NSString *, BRUIStyle *> *val = objc_getAssociatedObject(self, @selector(uiStyleStateDictionary));
	if ( !val && create ) {
		val = [[NSMutableDictionary alloc] initWithCapacity:5];
		objc_setAssociatedObject(self, @selector(uiStyleStateDictionary), val, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return val;
}

- (BRUIStyle *)uiStyleForState:(UIControlState)state {
	NSString *key = [UIControl keyNameForControlState:state];
	BRUIStyle *style = [self uiStyleStateDictionary:NO][key];
	if ( !style ) {
		// try default for state
		style = DefaultStateStyles[key];
	}
	if ( !style && state != UIControlStateNormal ) {
		// try normal state
		NSString *normalKey = [UIControl keyNameForControlState:UIControlStateNormal];
		style = [self uiStyleStateDictionary:NO][normalKey];
		if ( !style ) {
			// try default for normal state
			style = DefaultStateStyles[normalKey];
		}
	}
	if ( !style ) {
		// fall back to global default style
		style = [BRUIStyle defaultStyle];
	}
	return style;
}

- (void)setUiStyle:(nullable BRUIStyle *)style forState:(UIControlState)state UI_APPEARANCE_SELECTOR {
	NSString *key = [UIControl keyNameForControlState:state];
	if ( style == nil ) {
		[[self uiStyleStateDictionary:NO] removeObjectForKey:key];
	} else {
		[self uiStyleStateDictionary:YES][key] = style;
	}
}

@end

static UIControlState bruistyle_getState(id self, SEL _cmd) {
	UIControlState result = ((UIControlState(*)(id,SEL))original_getState)(self, _cmd);
	return (result | [self uiStyleState]);
}
