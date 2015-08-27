//
//  BRUIStyleSettings.h
//  BRStyle
//
//  Created by Matt on 26/08/15.
//  Copyright (c) 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A common base class for other settings containers.
 */
@interface BRUIStyleSettings : NSObject <NSCopying, NSSecureCoding>

/**
 Decode a settings intance from a dictionary representation.
 
 The dictionary shoud be in the form returned by the @c dictionaryRepresentation method.
 Note that default values will be provided, and @c dictionary values override those defaults.
 
 @param dictionary The dictionary to decode.
 @return A new settings instance.
 */
- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionary;

/**
 Get a dictionary representation of the receiver.
 
 The resulting dictionary will contain only simple data types, suitable for serializing
 into JSON or other encodings.
 
 @return A dictionary representation.
 @see styleWithDictionary:
 */
- (NSDictionary *)dictionaryRepresentation;

@end

/**
 Font style settings.
 */
@interface BRUIStyleFontSettings : BRUIStyleSettings <NSMutableCopying>

///-------------------------------
/// @name UI font styles
///-------------------------------

@property (nonatomic, readonly) UIFont *actionFont;
@property (nonatomic, readonly) UIFont *formFont;
@property (nonatomic, readonly) UIFont *navigationFont;
@property (nonatomic, readonly) UIFont *alertHeadlineFont;
@property (nonatomic, readonly) UIFont *alertFont;

///-------------------------------
/// @name Structural font styles
///-------------------------------

@property (nonatomic, readonly) UIFont *heroFont;
@property (nonatomic, readonly) UIFont *headlineFont;
@property (nonatomic, readonly) UIFont *secondaryHeadlineFont;
@property (nonatomic, readonly) UIFont *textFont;
@property (nonatomic, readonly) UIFont *captionFont;

///-------------------------------
/// @name List font styles
///-------------------------------

@property (nonatomic, readonly) UIFont *listFont;
@property (nonatomic, readonly) UIFont *listSecondaryFont;
@property (nonatomic, readonly) UIFont *listCaptionFont;

@end

/**
 Control style settings.
 */
@interface BRUIStyleControlColorSettings : BRUIStyleSettings <NSMutableCopying>

@property (nonatomic, readonly) UIColor *actionColor;
@property (nonatomic, readonly) UIColor *borderColor;
@property (nonatomic, readonly, nullable) UIColor *glossColor;
@property (nonatomic, readonly, nullable) UIColor *shadowColor;

@end

/**
 Control state style settings.
 */
@interface BRUIStyleControlStateColorSettings : BRUIStyleSettings <NSMutableCopying>

@property (nonatomic, readonly) BRUIStyleControlColorSettings *normalColorSettings;
@property (nonatomic, readonly) BRUIStyleControlColorSettings *highlightedColorSettings;
@property (nonatomic, readonly) BRUIStyleControlColorSettings *selectedColorSettings;
@property (nonatomic, readonly) BRUIStyleControlColorSettings *disabledColorSettings;
@property (nonatomic, readonly) BRUIStyleControlColorSettings *dangerousColorSettings;

@end

/**
 Color style settings.
 */
@interface BRUIStyleColorSettings : BRUIStyleSettings <NSMutableCopying>

///-------------------------------
/// @name Structural color styles
///-------------------------------

@property (nonatomic, readonly) UIColor *primaryColor;
@property (nonatomic, readonly) UIColor *secondaryColor;
@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) UIColor *separatorColor;

///-------------------------------
/// @name Text color styles
///-------------------------------

@property (nonatomic, readonly) UIColor *heroColor;
@property (nonatomic, readonly) UIColor *headlineColor;
@property (nonatomic, readonly) UIColor *secondaryHeadlineColor;
@property (nonatomic, readonly) UIColor *textColor;
@property (nonatomic, readonly) UIColor *captionColor;

///-------------------------------
/// @name UI font styles
///-------------------------------

@property (nonatomic, readonly) UIColor *formColor;
@property (nonatomic, readonly) UIColor *placeholderColor;
@property (nonatomic, readonly) UIColor *navigationColor;
@property (nonatomic, readonly) UIColor *alertHeadlineColor;
@property (nonatomic, readonly) UIColor *alertColor;
@property (nonatomic, readonly) UIColor *alertBackgroundColor;

///-------------------------------
/// @name Control color styles
///-------------------------------

@property (nonatomic, readonly) BRUIStyleControlStateColorSettings *controlSettings;
@property (nonatomic, readonly) BRUIStyleControlStateColorSettings *inverseControlSettings;

@end

#pragma mark - Mutable support

/**
 Font style settings.
 */
@interface BRMutableUIStyleFontSettings : BRUIStyleFontSettings

///-------------------------------
/// @name UI font styles
///-------------------------------

@property (nonatomic, readwrite) UIFont *actionFont;
@property (nonatomic, readwrite) UIFont *formFont;
@property (nonatomic, readwrite) UIFont *navigationFont;
@property (nonatomic, readwrite) UIFont *alertHeadlineFont;
@property (nonatomic, readwrite) UIFont *alertFont;

///-------------------------------
/// @name Structural font styles
///-------------------------------

@property (nonatomic, readwrite) UIFont *heroFont;
@property (nonatomic, readwrite) UIFont *headlineFont;
@property (nonatomic, readwrite) UIFont *secondaryHeadlineFont;
@property (nonatomic, readwrite) UIFont *textFont;
@property (nonatomic, readwrite) UIFont *captionFont;

///-------------------------------
/// @name List font styles
///-------------------------------

@property (nonatomic, readwrite) UIFont *listFont;
@property (nonatomic, readwrite) UIFont *listSecondaryFont;
@property (nonatomic, readwrite) UIFont *listCaptionFont;

@end

/**
 Control style settings.
 */
@interface BRMutableUIStyleControlColorSettings : BRUIStyleControlColorSettings

@property (nonatomic, readwrite) UIColor *actionColor;
@property (nonatomic, readwrite) UIColor *borderColor;
@property (nonatomic, readwrite, nullable) UIColor *glossColor;
@property (nonatomic, readwrite, nullable) UIColor *shadowColor;

@end

/**
 Control state style settings.
 */
@interface BRMutableUIStyleControlStateColorSettings : BRUIStyleControlStateColorSettings

@property (nonatomic, readwrite) BRUIStyleControlColorSettings *normalColorSettings;
@property (nonatomic, readwrite) BRUIStyleControlColorSettings *highlightedColorSettings;
@property (nonatomic, readwrite) BRUIStyleControlColorSettings *selectedColorSettings;
@property (nonatomic, readwrite) BRUIStyleControlColorSettings *disabledColorSettings;
@property (nonatomic, readwrite) BRUIStyleControlColorSettings *dangerousColorSettings;

@end

/**
 Color style settings.
 */
@interface BRMutableUIStyleColorSettings : BRUIStyleColorSettings

///-------------------------------
/// @name Structural color styles
///-------------------------------

@property (nonatomic, readwrite) UIColor *primaryColor;
@property (nonatomic, readwrite) UIColor *secondaryColor;
@property (nonatomic, readwrite) UIColor *backgroundColor;
@property (nonatomic, readwrite) UIColor *separatorColor;

///-------------------------------
/// @name Text color styles
///-------------------------------

@property (nonatomic, readwrite) UIColor *heroColor;
@property (nonatomic, readwrite) UIColor *headlineColor;
@property (nonatomic, readwrite) UIColor *secondaryHeadlineColor;
@property (nonatomic, readwrite) UIColor *textColor;
@property (nonatomic, readwrite) UIColor *captionColor;

///-------------------------------
/// @name UI font styles
///-------------------------------

@property (nonatomic, readwrite) UIColor *formColor;
@property (nonatomic, readwrite) UIColor *placeholderColor;
@property (nonatomic, readwrite) UIColor *navigationColor;
@property (nonatomic, readwrite) UIColor *alertHeadlineColor;
@property (nonatomic, readwrite) UIColor *alertColor;
@property (nonatomic, readwrite) UIColor *alertBackgroundColor;

///-------------------------------
/// @name Control color styles
///-------------------------------

@property (nonatomic, readwrite) BRUIStyleControlStateColorSettings *controlSettings;
@property (nonatomic, readwrite) BRUIStyleControlStateColorSettings *inverseControlSettings;

@end

NS_ASSUME_NONNULL_END
