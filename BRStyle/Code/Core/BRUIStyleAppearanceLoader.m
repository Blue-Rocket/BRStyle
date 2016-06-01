//
//  BRUIStyleAppearanceLoader.m
//  BRStyle
//
//  Created by Matt on 1/06/16.
//  Copyright © 2016 Blue Rocket, Inc. All rights reserved.
//

#import "BRUIStyleAppearanceLoader.h"

#import "BRUIStyle.h"
#import "BRUIStylish.h"
#import "BRUIStylishControl.h"
#import "UIControl+BRUIStyle.h"

@implementation BRUIStyleAppearanceLoader

- (void)setupAppearanceStyles:(NSDictionary<NSString *, BRUIStyle *> *)styles {
	[styles enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull styleKey, BRUIStyle * _Nonnull style, BOOL * _Nonnull stop) {
		if ( [styleKey isEqualToString:BRStyleKeyDefault] || [styleKey hasPrefix:BRStyleKeyControlsPrefix] || [styleKey hasPrefix:BRStyleKeyBarControlsPrefix] ) {
			return;
		}
		
		// split on , for multiple keys
		for ( NSString *key in [styleKey componentsSeparatedByString:@","] ) {
			// split on / for containment
			NSArray<NSString *> *hierarchy = [key componentsSeparatedByString:@"/"];
			NSString *appearanceProxyClassName = nil;
			NSMutableArray<NSString *> *containerClassNames = nil;
			NSMutableArray<Class<UIAppearanceContainer>> *containerClasses = nil;
			UIControlState state = UIControlStateNormal;
			for ( NSString *oneKey in [hierarchy reverseObjectEnumerator] ) {
				if ( !appearanceProxyClassName ) {
					NSUInteger dashIdx = [oneKey rangeOfString:@"-" options:NSBackwardsSearch].location;
					if ( dashIdx == NSNotFound ) {
						appearanceProxyClassName = oneKey;
					} else {
						appearanceProxyClassName = [oneKey substringToIndex:dashIdx];
						state = [UIControl controlStateForKeyName:[oneKey substringFromIndex:(dashIdx + 1)]];
					}
				} else {
					if ( containerClassNames == nil ) {
						containerClassNames = [[NSMutableArray alloc] initWithCapacity:hierarchy.count];
					}
					[containerClassNames addObject:oneKey];
				}
			}

			
			if ( !appearanceProxyClassName ) {
				NSLog(@"UIAppearance proxy class hierarhcy not found for style key %@", styleKey);
				return;
			}

			Class<UIAppearance> appearanceProxyClass = NSClassFromString(appearanceProxyClassName);
			if ( !appearanceProxyClass ) {
				NSLog(@"UIAppearance proxy class %@ not available", appearanceProxyClassName);
				return;
			}
			
			if ( [(Class)appearanceProxyClass respondsToSelector:@selector(appearance)] == NO ) {
				NSLog(@"Class %@ does not seem to conform to UIAppearance", appearanceProxyClassName);
				return;
			}
			
			if ( containerClassNames.count > 0 ) {
				containerClasses = [[NSMutableArray alloc] initWithCapacity:containerClassNames.count];
				for ( NSString *containerClassName in containerClassNames ) {
					Class<UIAppearanceContainer> containerClass = NSClassFromString(containerClassName);
					if ( !containerClass ) {
						NSLog(@"UIAppearanceContainer class %@ not available (style key %@)", containerClassName, styleKey);
						return;
					}
					[containerClasses addObject:containerClass];
				}
			}
			
			id<UIAppearance> appearanceProxy;
			if ( containerClasses.count > 0 ) {
				// check for iOS9+
				if ( [(Class)appearanceProxyClass respondsToSelector:@selector(appearanceWhenContainedInInstancesOfClasses:)] ) {
					// yea, this one's easy
					appearanceProxy = [appearanceProxyClass appearanceWhenContainedInInstancesOfClasses:containerClasses];
				} else if ( containerClasses.count == 1 ) {
					appearanceProxy = [appearanceProxyClass appearanceWhenContainedIn:containerClasses[0], nil];
				} else if ( containerClasses.count == 2 ) {
					appearanceProxy = [appearanceProxyClass appearanceWhenContainedIn:containerClasses[0], containerClasses[1], nil];
				} else if ( containerClasses.count > 2 ) {
					appearanceProxy = [appearanceProxyClass appearanceWhenContainedIn:containerClasses[0], containerClasses[1], containerClasses[2], nil];
				}
			} else {
				appearanceProxy = [appearanceProxyClass appearance];
			}
			
			if ( [(Class)appearanceProxyClass instancesRespondToSelector:@selector(setUiStyle:forState:)] ) {
				id<BRUIStylishControl> stylishControlProxy = (id<BRUIStylishControl>)appearanceProxy;
				[stylishControlProxy setUiStyle:style forState:state];
			} else if ( [(Class)appearanceProxyClass instancesRespondToSelector:@selector(setUiStyle:)] ) {
				id<BRUIStylish> stylishProxy = (id<BRUIStylish>)appearanceProxy;
				[stylishProxy setUiStyle:style];
			} else {
				NSLog(@"Class %@ does not seem to conform to BRUIStylish or BRUIStylishControl (style key %@)", appearanceProxyClassName, styleKey);
			}
		}
	}];
}

@end
