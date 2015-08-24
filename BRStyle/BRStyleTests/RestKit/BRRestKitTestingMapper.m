//
//  BRRestKitTestingMapper.m
//  BRStyle
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRRestKitTestingMapper.h"

#import <RestKit/ObjectMapping/RKObjectMappingOperationDataSource.h>

@interface BRRestKitTestingMapper () <RKMappingOperationDelegate>
@property (nonatomic, strong, readwrite) RKMapping *mapping;
@property (nonatomic, strong, readwrite) id sourceObject;
@property (nonatomic, strong, readwrite) id destinationObject;
@property (nonatomic, assign, getter = hasPerformedMapping) BOOL performedMapping;
@end

@implementation BRRestKitTestingMapper

+ (instancetype)testForMapping:(RKMapping *)mapping sourceObject:(id)sourceObject destinationObject:(id)destinationObject
{
	return [[self alloc] initWithMapping:mapping sourceObject:sourceObject destinationObject:destinationObject];
}

- (id)initWithMapping:(RKMapping *)mapping sourceObject:(id)sourceObject destinationObject:(id)destinationObject
{
	NSAssert(sourceObject != nil, @"Cannot perform a mapping operation without a sourceObject object");
	NSAssert(mapping != nil, @"Cannot perform a mapping operation without a mapping");
	
	self = [super init];
	if (self) {
		self.sourceObject = sourceObject;
		self.destinationObject = destinationObject;
		self.mapping = mapping;
		self.performedMapping = NO;
	}
	
	return self;
}

- (id<RKMappingOperationDataSource>)dataSourceForMappingOperation:(RKMappingOperation *)mappingOperation
{
	// If we have been given an explicit data source, use it
	if (self.mappingOperationDataSource) return self.mappingOperationDataSource;
	
	return [RKObjectMappingOperationDataSource new];
}

- (void)performMapping
{
	// Ensure repeated invocations of verify only result in a single mapping operation
	if (! self.hasPerformedMapping) {
		id sourceObject = self.rootKeyPath ? [self.sourceObject valueForKeyPath:self.rootKeyPath] : self.sourceObject;
		RKMappingOperation *mappingOperation = [[RKMappingOperation alloc] initWithSourceObject:sourceObject destinationObject:self.destinationObject mapping:self.mapping];
		id<RKMappingOperationDataSource> dataSource = [self dataSourceForMappingOperation:mappingOperation];
		mappingOperation.dataSource = dataSource;
		NSError *error = nil;
		mappingOperation.delegate = self;
		[mappingOperation start];
		if (mappingOperation.error) {
			[NSException raise:NSInternalInconsistencyException format:@"%p: failed with error: %@\n%@ during mapping from %@ to %@ with mapping %@",
			 self, error, [self description], self.sourceObject, self.destinationObject, self.mapping];
		}
		
		self.performedMapping = YES;
		
		// Get the destination object from the mapping operation
		if (! self.destinationObject) self.destinationObject = mappingOperation.destinationObject;
	}
}

@end
