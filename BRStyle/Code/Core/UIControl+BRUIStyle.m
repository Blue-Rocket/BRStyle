//
//  UIControl+BRUIStyle.m
//  BRStyle
//
//  Created by Matt on 8/10/15.
//  Copyright © 2015 Blue Rocket, Inc. All rights reserved.
//

#import "UIControl+BRUIStyle.h"

#import <objc/runtime.h>
#import "BRUIStylishHost.h"

const UIControlState BRUIStyleControlStateDangerous = (1 << 16);

static IMP original_didMoveToWindow;//(id, SEL);
static IMP original_getState;//(id, SEL);
static IMP original_setHighlighted;//(id, SEL, BOOL);
static IMP original_setEnabled;//(id, SEL, BOOL);
static IMP original_setSelected;//(id, SEL, BOOL);
static void bruistyle_controlDidMoveToWindow(id self, SEL _cmd);
static UIControlState bruistyle_getState(id self, SEL _cmd);
static void bruistyle_setState(id self, SEL _cmd, BOOL);

static NSMutableDictionary<NSNumber *, BRUIStyle *> *DefaultStateStyles;

@implementation UIControl (BRUIStyle)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		SEL originalSelector = @selector(didMoveToWindow);
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		original_didMoveToWindow = method_setImplementation(originalMethod, (IMP)bruistyle_controlDidMoveToWindow);

		originalSelector = @selector(state);
		originalMethod = class_getInstanceMethod(class, originalSelector);
		original_getState = method_setImplementation(originalMethod, (IMP)bruistyle_getState);
		
		originalSelector = @selector(setHighlighted:);
		originalMethod = class_getInstanceMethod(class, originalSelector);
		original_setHighlighted = method_setImplementation(originalMethod, (IMP)bruistyle_setState);
		
		originalSelector = @selector(setEnabled:);
		originalMethod = class_getInstanceMethod(class, originalSelector);
		original_setEnabled = method_setImplementation(originalMethod, (IMP)bruistyle_setState);
		
		originalSelector = @selector(setSelected:);
		originalMethod = class_getInstanceMethod(class, originalSelector);
		original_setSelected = method_setImplementation(originalMethod, (IMP)bruistyle_setState);
	});
}

+ (NSArray *)orderedSupportedStates {
	return @[@(UIControlStateDisabled),
			 @(BRUIStyleControlStateDangerous),
			 @(UIControlStateHighlighted),
			 @(UIControlStateSelected),
			 @(UIControlStateFocused)];
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
	NSString *result = @"";
	for ( NSNumber *singleKey in [self orderedSupportedStates] ) {
		NSUInteger singleState = [singleKey unsignedIntegerValue];
		if ( (singleState & state) == singleState ) {
			if ( result.length > 0 ) {
				result = [result stringByAppendingString:@"|"];
			}
			switch ( singleState ) {
				case BRUIStyleControlStateDangerous:
					result = [result stringByAppendingString:@"dangerous"];
					break;
					
				case UIControlStateDisabled:
					result = [result stringByAppendingString:@"disabled"];
					break;
					
				case UIControlStateHighlighted:
					result = [result stringByAppendingString:@"highlighted"];
					break;
					
				case UIControlStateSelected:
					result = [result stringByAppendingString:@"selected"];
					break;
					
				case UIControlStateFocused:
					result = [result stringByAppendingString:@"focused"];
					break;
			}
		}
	}
	return (result.length > 0 ? result : @"normal");
}

+ (UIControlState)controlStateForKeyName:(NSString *)name {
	UIControlState result = UIControlStateNormal;
	NSArray *keys = [name componentsSeparatedByString:@"|"];
	for ( NSString *key in keys ) {
		if ( [key caseInsensitiveCompare:@"dangerous"] == NSOrderedSame ) {
			result |= BRUIStyleControlStateDangerous;
		} else if ( [key caseInsensitiveCompare:@"disabled"] == NSOrderedSame ) {
			result |= UIControlStateDisabled;
		} else if ( [key caseInsensitiveCompare:@"highlighted"] == NSOrderedSame ) {
			result |= UIControlStateHighlighted;
		} else if ( [key caseInsensitiveCompare:@"selected"] == NSOrderedSame ) {
			result |= UIControlStateSelected;
		} else if ( [key caseInsensitiveCompare:@"focused"] == NSOrderedSame ) {
			result |= UIControlStateFocused;
		}
	}
	return result;
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
		for ( NSNumber *singleKey in [UIControl orderedSupportedStates] ) {
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
	if ( [self respondsToSelector:@selector(uiStyleDidChange:forState:)] ) {
		[self uiStyleDidChange:[self uiStyleForState:state] forState:state];
	}
}

@end

static void bruistyle_controlDidMoveToWindow(id self, SEL _cmd) {
	((void(*)(id,SEL))original_didMoveToWindow)(self, _cmd);
	if ( !([self window] && [self conformsToProtocol:@protocol(BRUIStylishHost)]) ) {
		return;
	}
	if ( [self respondsToSelector:@selector(uiStyleDidChange:forState:)] ) {
		for ( NSNumber *stateVal in [UIControl orderedSupportedStates] ) {
			UIControlState state = [stateVal unsignedIntegerValue];
			if ( state == UIControlStateNormal ) {
				continue;
			}
			BRUIStyle *style = [self uiStyleForState:state];
			if ( style && style.isDefaultStyle == NO ) {
				[self uiStyleDidChange:style forState:state];
			}
		}
	}
}

static UIControlState bruistyle_getState(id self, SEL _cmd) {
	UIControlState result = ((UIControlState(*)(id,SEL))original_getState)(self, _cmd);
	return (result | [self uiStyleState]);
}

static void bruistyle_setState(id self, SEL _cmd, BOOL value) {
	BOOL previousValue = NO;
	if ( _cmd == @selector(setHighlighted:) ) {
		previousValue = [self isHighlighted];
		((void(*)(id,SEL,BOOL))original_setHighlighted)(self, _cmd, value);
	} else if ( _cmd == @selector(setEnabled:) ) {
		previousValue = [self isEnabled];
		((void(*)(id,SEL,BOOL))original_setEnabled)(self, _cmd, value);
	} else if ( _cmd == @selector(setSelected:) ) {
		previousValue = [self isSelected];
		((void(*)(id,SEL,BOOL))original_setSelected)(self, _cmd, value);
	}
	if ( previousValue != value && [self respondsToSelector:@selector(stateDidChange)] ) {
		[self stateDidChange];
	}
}

