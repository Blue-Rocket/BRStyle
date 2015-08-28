//
//  UIFont+BRUIStyle.m
//  BRStyle
//
//  Created by Matt on 28/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import "UIFont+BRUIStyle.h"

@implementation UIFont (BRUIStyle)

+ (BRUIStyleCSSFontWeight)uiStyleCSSFontWeightForFontWeight:(CGFloat)fontWeight {
	// fontWeight is -1..1
	CGFloat percent = (fontWeight + 1.0) / 2.0;
	// convert percent to 100..900
	int cssWeight = ((int)roundf((percent * 8.0)) * 100 + 100);
	return cssWeight;
}

+ (CGFloat)fontWeightForUIStyleCSSFontWeight:(BRUIStyleCSSFontWeight)weight {
	NSParameterAssert(weight >= 0);
	CGFloat percent = ((CGFloat)(weight - 100) / 800.0);
	CGFloat fontWeight = (percent * 2.0) - 1.0;
	return fontWeight;
}

- (BRUIStyleCSSFontWeight)uiStyleCSSFontWeight {
	UIFontDescriptor *descriptor = [self fontDescriptor];
	NSDictionary *attributes = [descriptor fontAttributes];
	NSDictionary *traits = attributes[UIFontDescriptorTraitsAttribute];
	NSNumber *fontWeight = traits[UIFontWeightTrait];
	if ( fontWeight ) {
		return [UIFont uiStyleCSSFontWeightForFontWeight:[fontWeight floatValue]];
	}

	// fall back to name wrangling
	NSString *name = [self.fontName lowercaseString];
	
	// use regex to extract style variant
	static NSRegularExpression *WeightNameRegex;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSError *error = nil;
		WeightNameRegex = [[NSRegularExpression alloc] initWithPattern:@"-([a-z]+)[1-9]?$" options:0 error:&error];
		if ( error ) {
			NSLog(@"Regex error: %@", [error localizedDescription]);
		}
	});
	NSTextCheckingResult *match = [WeightNameRegex firstMatchInString:name options:0 range:NSMakeRange(0, name.length)];
	int wnum = 0;
	if ( match && match.range.location != NSNotFound ) {
		NSRange matchRange = [match rangeAtIndex:1];
		if ( matchRange.location + matchRange.length < name.length ) {
			// get num
			wnum = [[name substringFromIndex:(matchRange.location + matchRange.length)] intValue];
			// take off the P or W preceeding the wnum
			matchRange.length--;
		}
		name = [name substringWithRange:matchRange];
	}
	
	// look for: UltraLight, Thin, Light, (-)Regular|Normal, Medium, (Semi|Demi)bold, Bold, (Extra|Ultra)Bold|Heavy Black|ExtraBlack
	// as        100,        200,  300,   400,               500,    600,             700,  800,                    900
	
	if ( [name hasSuffix:@"ultralight"] ) {
		return 100;
	}
	if ( [name hasSuffix:@"thin"] ) {
		return 200;
	}
	if ( [name hasSuffix:@"light"] ) {
		return 300;
	}
	if ( [name hasSuffix:@"medium"] ) {
		return 500;
	}
	if ( [name hasSuffix:@"semibold"] || [name hasSuffix:@"demibold"] ) {
		return 600;
	}
	if ( [name hasSuffix:@"extrabold"] || [name hasSuffix:@"ultrabold"] ) {
		return 800;
	}
	if ( [name hasSuffix:@"bold"] ) {
		return 700;
	}
	if ( [name hasSuffix:@"heavy"] || [name hasSuffix:@"black"] ) {
		return 900;
	}

	if ( wnum ) {
		return (wnum * 100);
	}
		
	// check symboilc traits
	UIFontDescriptorSymbolicTraits symbolic = [descriptor symbolicTraits];
	if ( (symbolic & UIFontDescriptorTraitBold) == UIFontDescriptorTraitBold ) {
		return BRUIStyleCSSFontWeightBold;
	}
	
	return BRUIStyleCSSFontWeightNormal;
}

- (UIFont *)fontWithUIStyleCSSFontWeight:(BRUIStyleCSSFontWeight)weight {
	CGFloat desiredFontWeight = 0; // normal
	if ( weight == BRUIStyleCSSFontWeightLighter || weight == BRUIStyleCSSFontWeightBolder ) {
		BRUIStyleCSSFontWeight desiredWeight = [self uiStyleCSSFontWeight];
		if ( weight == BRUIStyleCSSFontWeightBolder && desiredWeight < 900 ) {
			desiredWeight += 100;
		} else if ( weight == BRUIStyleCSSFontWeightLighter && desiredWeight > 100 ) {
			desiredWeight -= 100;
		}
		desiredFontWeight = [UIFont fontWeightForUIStyleCSSFontWeight:desiredWeight];
	} else {
		desiredFontWeight = [UIFont fontWeightForUIStyleCSSFontWeight:weight];
	}
	
	NSDictionary *attributes = [[self fontDescriptor] fontAttributes];
	NSMutableDictionary *traits = [attributes[UIFontDescriptorTraitsAttribute] mutableCopy];
	if ( !traits ) {
		traits = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	traits[UIFontWeightTrait] = @(desiredFontWeight);
	
	NSDictionary *newAttributes = @{UIFontDescriptorFamilyAttribute: self.familyName,
									UIFontDescriptorTraitsAttribute: traits};
	
	UIFontDescriptor *newDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:newAttributes];
	UIFont *result = [UIFont fontWithDescriptor:newDescriptor size:self.pointSize];
	if ( result == nil ) {
		result = self;
	}
	return result;
}

@end
