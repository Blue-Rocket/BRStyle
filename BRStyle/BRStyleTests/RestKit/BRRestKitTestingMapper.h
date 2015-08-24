//
//  BRRestKitTestingMapper.h
//  BRStyle
//
//  Adpated from RestKit's RKMappingTest.
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <RestKit/ObjectMapping.h>

@interface BRRestKitTestingMapper : NSObject

/**
 The mapping under test. Can be either an `RKObjectMapping` or `RKDynamicMapping` object.
 */
@property (nonatomic, strong, readonly) RKMapping *mapping;

/**
 A data source for the mapping operation.
 
 If `nil`, an appropriate data source will be constructed for you using the available configuration of the receiver.
 */
@property (nonatomic, strong) id<RKMappingOperationDataSource> mappingOperationDataSource;

/**
 A key path to apply to the source object to specify the location of the root of the data under test. Useful when testing subsets of a larger payload or object graph.
 
 **Default**: `nil`
 */
@property (nonatomic, copy) NSString *rootKeyPath;

/**
 The source object being mapped from.
 */
@property (nonatomic, strong, readonly) id sourceObject;

/**
 The destionation object being mapped to.
 
 If `nil`, the mapping test will instantiate a destination object to perform the mapping by invoking `[self.mappingOperationDataSource objectForMappableContent:self.sourceObject mapping:self.mapping]` to obtain a new object from the data source and then assign the object as the value for the destinationObject property.
 
 @see `mappingOperationDataSource`
 */
@property (nonatomic, strong, readonly) id destinationObject;

/**
 Creates and returns a new test for a given object mapping, source object and destination
 object.
 
 @param mapping The mapping being tested.
 @param sourceObject The source object being mapped from.
 @param destinationObject The destionation object being to.
 @return A new mapping test object for a mapping, a source object and a destination object.
 */
+ (instancetype)testForMapping:(RKMapping *)mapping sourceObject:(id)sourceObject destinationObject:(id)destinationObject;

/**
 Initializes the receiver with a given object mapping, source object, and destination object.
 
 @param mapping The mapping being tested.
 @param sourceObject The source object being mapped from.
 @param destinationObject The destionation object being to.
 @return The receiver, initialized with mapping, sourceObject and destinationObject.
 */
- (id)initWithMapping:(RKMapping *)mapping sourceObject:(id)sourceObject destinationObject:(id)destinationObject;

/**
 Performs the object mapping operation and records any mapping events that occur. The mapping events can be verified against expectation through a subsequent call to verify.
 
 @exception NSInternalInconsistencyException Raises an `NSInternalInconsistencyException` if mapping fails.
 */
- (void)performMapping;

@end
