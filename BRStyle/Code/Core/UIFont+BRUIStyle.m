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
	
	if ( [name containsString:@"ultralight"] ) {
		return 100;
	}
	if ( [name containsString:@"thin"] ) {
		return 200;
	}
	if ( [name containsString:@"light"] ) {
		return 300;
	}
	if ( [name containsString:@"medium"] ) {
		return 500;
	}
	if ( [name containsString:@"semibold"] || [name containsString:@"demibold"] ) {
		return 600;
	}
	if ( [name containsString:@"extrabold"] || [name containsString:@"ultrabold"] ) {
		return 800;
	}
	if ( [name containsString:@"bold"] ) {
		return 700;
	}
	if ( [name containsString:@"heavy"] || [name containsString:@"black"] ) {
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

+ (NSArray *)fontNamesForFamilyNameSortedByWeight:(NSString *)familyName weights:(NSArray * __autoreleasing *)weights {
	NSMutableArray *fontNames = [[UIFont fontNamesForFamilyName:familyName] mutableCopy];
	NSMutableDictionary *fontWeights = [[NSMutableDictionary alloc] initWithCapacity:fontNames.count];
	[fontNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		NSNumber *w1 = fontWeights[obj1];
		if ( !w1 ) {
			UIFont *f1 = [UIFont fontWithName:obj1 size:12];
			w1 = @([f1 uiStyleCSSFontWeight]);
			fontWeights[obj1] = w1;
		}
		NSNumber *w2 = fontWeights[obj2];
		if ( !w2 ) {
			UIFont *f2 = [UIFont fontWithName:obj2 size:12];
			w2 = @([f2 uiStyleCSSFontWeight]);
			fontWeights[obj2] = w2;
		}
		return [w1 compare:w2];
	}];
	if ( weights ) {
		NSMutableArray *wOut = [[NSMutableArray alloc] initWithCapacity:fontNames.count];
		for ( NSString * fontName in fontNames ) {
			NSNumber *w = fontWeights[fontName];
			if ( !w ) {
				w = @0;
			}
			[wOut addObject:w];
		};
		*weights = wOut;
	}
	return fontNames;
}

- (UIFont *)fontWithUIStyleCSSFontWeight:(const BRUIStyleCSSFontWeight)weight {
	NSArray *familyWeights = nil;
	NSArray *fontFamilyNames = [UIFont fontNamesForFamilyNameSortedByWeight:self.familyName weights:&familyWeights];

	// get symboilc traits for italic variant
	UIFontDescriptorSymbolicTraits symbolic = [[self fontDescriptor] symbolicTraits];
	BOOL italic = NO;
	BOOL condensed = NO;
	if ( (symbolic & UIFontDescriptorTraitItalic) == UIFontDescriptorTraitItalic ) {
		italic = YES;
	}
	if ( (symbolic & UIFontDescriptorTraitCondensed) == UIFontDescriptorTraitCondensed ) {
		condensed = YES;
	}
	__block NSString *previousName = nil;
	__block NSString *matchingName = nil;
	[fontFamilyNames enumerateObjectsUsingBlock:^(id fontName, NSUInteger idx, BOOL *stop) {
		NSString *lcName = [fontName lowercaseString];
		if ( (italic != [lcName containsString:@"italic"]) || (condensed != [lcName containsString:@"condensed"]) ) {
			return;
		}
		BRUIStyleCSSFontWeight w = [familyWeights[idx] intValue];
		if ( w >= weight ) {
			matchingName = (w > weight && previousName ? previousName : fontName);
			*stop = YES;
		} else {
			previousName = fontName;
		}
	}];
	if ( !matchingName ) {
		matchingName = previousName;
	}
	if ( !matchingName ) {
		return self;
	}
	if ( [self.fontName isEqualToString:matchingName] ) {
		return self;
	}
	return [UIFont fontWithName:matchingName size:self.pointSize];
}

@end
