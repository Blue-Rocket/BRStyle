//
//  BRUIStyleMappingRestKit.m
//  BRStyle
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRUIStyleMappingRestKit.h"

#import <MAObjCRuntime/MARTNSObject.h>
#import <MAObjCRuntime/RTProperty.h>
#import "BRUIStyle.h"

@implementation BRUIStyleMappingRestKit

+ (id<RKValueTransforming>)colorValueTransformer {
	static dispatch_once_t onceToken;
	static id<RKValueTransforming> result;
	static NSArray *validClasses;
	dispatch_once(&onceToken, ^{
		validClasses = @[ [NSNumber class], [UIColor class]];
		result = [RKBlockValueTransformer valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass, __unsafe_unretained Class outputValueClass) {
			return (([inputValueClass isSubclassOfClass:[UIColor class]] && [outputValueClass isSubclassOfClass:[NSNumber class]]) ||
					([inputValueClass isSubclassOfClass:[NSNumber class]] && [outputValueClass isSubclassOfClass:[UIColor class]]));
		} transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
			RKValueTransformerTestInputValueIsKindOfClass(inputValue, validClasses, error);
			RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, validClasses, error);
			if ( [inputValue isKindOfClass:[NSNumber class]] ) {
				UIColor *color = [BRUIStyle colorWithRGBAHexInteger:[inputValue unsignedIntValue]];
				RKValueTransformerTestTransformation(color != nil, error, @"Failed transformation of '%@' to UIColor: the number is not in RGBA hex form and cannot be transformed to a `UIColor` representation.", inputValue);
				*outputValue = color;
			} else if ( [inputValue isKindOfClass:[UIColor class]] ) {
				*outputValue = @([BRUIStyle rgbaHexIntegerForColor:inputValue]);
			}
			return YES;
		}];
	});
	return result;
}

+ (id<RKValueTransforming>)fontValueTransformer {
	static dispatch_once_t onceToken;
	static id<RKValueTransforming> result;
	static NSArray *validClasses;
	dispatch_once(&onceToken, ^{
		validClasses = @[ [NSDictionary class], [UIFont class]];
		result = [RKBlockValueTransformer valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass, __unsafe_unretained Class outputValueClass) {
			return (([inputValueClass isSubclassOfClass:[UIFont class]] && [outputValueClass isSubclassOfClass:[NSDictionary class]]) ||
					([inputValueClass isSubclassOfClass:[NSDictionary class]] && [outputValueClass isSubclassOfClass:[UIFont class]]));
		} transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
			RKValueTransformerTestInputValueIsKindOfClass(inputValue, validClasses, error);
			RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, validClasses, error);
			if ( [inputValue isKindOfClass:[NSDictionary class]] ) {
				UIFont *font = [UIFont fontWithName:inputValue[@"name"] size:[inputValue[@"size"] floatValue]];
				RKValueTransformerTestTransformation(font != nil, error, @"Failed transformation of '%@' to UIFont: the object form and cannot be transformed to a `UIFont` representation.", inputValue);
				*outputValue = font;
			} else if ( [inputValue isKindOfClass:[UIFont class]] ) {
				UIFont *font = inputValue;
				*outputValue = @{@"name" : font.fontName, @"size" : @(font.pointSize)};
			}
			return YES;
		}];
	});
	return result;
}

+ (RKAttributeMapping *)colorPropertyMappingWithName:(NSString *)propName {
	RKAttributeMapping* mapping = [RKAttributeMapping attributeMappingFromKeyPath:propName toKeyPath:propName];
	mapping.valueTransformer = [self colorValueTransformer];
	return mapping;
}

+ (RKAttributeMapping *)fontPropertyMappingWithName:(NSString *)propName {
	RKAttributeMapping* mapping = [RKAttributeMapping attributeMappingFromKeyPath:propName toKeyPath:propName];
	mapping.valueTransformer = [self fontValueTransformer];
	return mapping;
}

+ (RKObjectMapping *)uiStyleMapping {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[BRUIStyle class]];
	for ( RTProperty *prop in [[BRUIStyle class] rt_properties] ) {
		if ( [prop.name hasSuffix:@"Color"] ) {
			[mapping addPropertyMapping:[self colorPropertyMappingWithName:prop.name]];
		} else if ( [prop.name hasSuffix:@"Font"] ) {
			[mapping addPropertyMapping:[self fontPropertyMappingWithName:prop.name]];
		}
	}
	return mapping;
}

@end
