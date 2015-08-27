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

/** A font to use for action objects, such as buttons. */
@property (nonatomic, readwrite) UIFont *actionFont;

/** A font to use for form fields. */
@property (nonatomic, readwrite) UIFont *formFont;

/** A font to use for navigation items, like navigation bars. */
@property (nonatomic, readwrite) UIFont *navigationFont;

/** A font to use in alert titles. */
@property (nonatomic, readwrite) UIFont *alertHeadlineFont;

/** A font to use in alert messages. */
@property (nonatomic, readwrite) UIFont *alertFont;

///-------------------------------
/// @name Structural font styles
///-------------------------------

/** A font to use for large, in your face titles. */
@property (nonatomic, readwrite) UIFont *heroFont;

/** A font to use for major titles. */
@property (nonatomic, readwrite) UIFont *headlineFont;

/** A font to use for minor titles. */
@property (nonatomic, readwrite) UIFont *secondaryHeadlineFont;

/** A font to use for normal content text. */
@property (nonatomic, readwrite) UIFont *textFont;

/** A font to use for captions. */
@property (nonatomic, readwrite) UIFont *captionFont;

///-------------------------------
/// @name List font styles
///-------------------------------

/** A font to use in listings, such as table views. */
@property (nonatomic, readwrite) UIFont *listFont;

/** A font to use for secondary information in listings. */
@property (nonatomic, readwrite) UIFont *listSecondaryFont;

/** A font to use for captions in listings. */
@property (nonatomic, readwrite) UIFont *listCaptionFont;

@end

/**
 Control style settings.
 */
@interface BRMutableUIStyleControlColorSettings : BRUIStyleControlColorSettings

/** An action color to use in controls, often the @c tintColor of a control */
@property (nonatomic, readwrite) UIColor *actionColor;

/** A border color to use in controls. */
@property (nonatomic, readwrite) UIColor *borderColor;

/** A gloss effect color to use in controls. */
@property (nonatomic, readwrite, nullable) UIColor *glossColor;

/** A shadow effect color to use in controls. */
@property (nonatomic, readwrite, nullable) UIColor *shadowColor;

@end

/**
 Control state style settings.
 */
@interface BRMutableUIStyleControlStateColorSettings : BRUIStyleControlStateColorSettings

/** Color settings to use for a control's normal state. */
@property (nonatomic, readwrite) BRUIStyleControlColorSettings *normalColorSettings;

/** Color settings to use for a control's highlighted (active) state. */
@property (nonatomic, readwrite) BRUIStyleControlColorSettings *highlightedColorSettings;

/** Color settings to use for a control's selected state. */
@property (nonatomic, readwrite) BRUIStyleControlColorSettings *selectedColorSettings;

/** Color settings to use for a control's disabled state. */
@property (nonatomic, readwrite) BRUIStyleControlColorSettings *disabledColorSettings;

/** Color settings to use for a control's dangerous state. This state represents a destructive action the user should be cautious of executing. */
@property (nonatomic, readwrite) BRUIStyleControlColorSettings *dangerousColorSettings;

@end

/**
 Color style settings.
 */
@interface BRMutableUIStyleColorSettings : BRUIStyleColorSettings

///-------------------------------
/// @name Structural color styles
///-------------------------------

/** The primary color to use, often the @c tintColor of the application. */
@property (nonatomic, readwrite) UIColor *primaryColor;

/** A secondary color to use. */
@property (nonatomic, readwrite) UIColor *secondaryColor;

/** A background color to use. */
@property (nonatomic, readwrite) UIColor *backgroundColor;

/** A separator or rule color to use. */
@property (nonatomic, readwrite) UIColor *separatorColor;

///-------------------------------
/// @name Text color styles
///-------------------------------

/** The color to apply to hero level text. */
@property (nonatomic, readwrite) UIColor *heroColor;

/** The color to apply to headline level text. */
@property (nonatomic, readwrite) UIColor *headlineColor;

/** The color to apply to secondary headline level text. */
@property (nonatomic, readwrite) UIColor *secondaryHeadlineColor;

/** The color to apply to normal content text. */
@property (nonatomic, readwrite) UIColor *textColor;

/** The color to apply to caption text. */
@property (nonatomic, readwrite) UIColor *captionColor;

/** The color to apply to form field text. */
@property (nonatomic, readwrite) UIColor *formColor;

/** The color to apply to placeholder text. */
@property (nonatomic, readwrite) UIColor *placeholderColor;

/** The color to apply to alert titles. */
@property (nonatomic, readwrite) UIColor *alertHeadlineColor;

/** The color to apply to alert messages. */
@property (nonatomic, readwrite) UIColor *alertColor;

///-------------------------------
/// @name UI color styles
///-------------------------------

/** The color to apply to navigation elements, such as @c UINavigationBar or @c UIToolbar objects. */
@property (nonatomic, readwrite) UIColor *navigationColor;

/** The color to apply to alert backgrounds. */
@property (nonatomic, readwrite) UIColor *alertBackgroundColor;

///-------------------------------
/// @name Control color styles
///-------------------------------

/** Color settings to apply to controls when shown on top of neutral content, e.g. not toolbars or navigation bars. */
@property (nonatomic, readwrite) BRUIStyleControlStateColorSettings *controlSettings;

/** Color settings to apply to controls when shown on top of primary colored content, e.g. toolbars or navigation bars. */
@property (nonatomic, readwrite) BRUIStyleControlStateColorSettings *inverseControlSettings;

@end

NS_ASSUME_NONNULL_END
