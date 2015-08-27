//
//  StyleController.h
//  BRStyleSampler
//
//  Created by Matt on 27/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRMutableUIStyle;

/**
 A controller object to help with collection views on the style properties avaialble in a @c BRUIStyle object.
 */
@interface StyleController : NSObject

@property (nonatomic, readonly) BRMutableUIStyle *style;

/**
 Initialize with a given style instance.
 */
- (instancetype)initWithStyle:(BRMutableUIStyle *)style;

/**
 Get the number of sections to display.
 
 @return The count of available sections.
 */
- (NSInteger)numberOfSections;

/**
 Get a title for a section.
 
 @param section The section to get the title for.
 @return The title.
 */
- (NSString *)titleForSection:(NSInteger)section;

/**
 Get the count of items within a given section.
 
 @param section The section to get the count for.
 @return The number of items in the section.
 */
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/**
 Get a key path for a style object.
 
 @param indexPath The index path of the item to get the key path for.
 @return A key path.
 */
- (NSString *)styleItemKeyPathForIndexPath:(NSIndexPath *)indexPath;

/**
 Get a title for a style object.
 
 @param indexPath The section and item index path to retrieve.
 @return The title.
 */
- (NSString *)titleForStyleItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Get a @c UIColor or UIFont for a given section and index.
 
 @param indexPath The section and item index path to retrieve.
 @return The UIColor or UIFont for the given index path, or @c nil if not available.
 */
- (id)styleItemAtIndexPath:(NSIndexPath *)indexPath;

@end
