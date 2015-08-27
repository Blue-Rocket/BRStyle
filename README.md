# BRStyle

**BRStyle** provides a simple application style support framework for UIKit.
Many applications rely on style guidelines involving color and font treatments.
The `UIAppearance` system supports configuring some basic style settings, but
often falls short. **BRStyle** aims to make using style guidelines easier.

# Getting started

For the simplest case in an application with a single global style, you'd
customize a single `BRUIStyle` instance when your application starts up and set
that as the default global style:

```objc
BRMutableUIStyle *mutableStyle = [BRMutableUIStyle new];

BRMutableUIStyleColorSettings *colors = [BRMutableUIStyleColorSettings new];
colors.primaryColor = [UIColor blueColor];
// configure more color styles as needed...

BRMutableUIStyleFontSettings *fonts = [BRMutableUIStyleFontSettings new];
fonts.actionFont = [UIFont systemFontOfSize:15];
// configure more font styles as needed...

// when configured, set as the global default
[BRUIStyle setDefaultStyle:mutableStyle];
```

That's quite a lot of code, so `BRUIStyle` supports loading the configuration
from a JSON encoded file. Given a JSON file `style.json` with contents like this:

```json
{
	"colors" : {
		"primaryColor" : "#0000ffff"
	},
	"fonts" : {
		"actionFont" : { "size" : 15 }
	}
}
```

the setup code is then reduced to this:

```objc
BRUIStyle *style = [BRUIStyle styleWithJSONResource:@"style.json" inBundle:nil];
[BRUIStyle setDefaultStyle:mutableStyle];
```

# Style properties

**BRStyle** designates three main categories of style properties:

 1. **Colors:** the `BRUIStyleColorSettings` class defines a set of color style
    properties, such as `primaryColor`, `textColor`, `captionColor`, etc.

 2. **Fonts:** the `BRUIStyleFontSettings` class defines a set of font style
    properties, such as `actionFont`, `textFont`, `captionFont`, etc.

 3. **Control colors:** the `BRUIStyleControlStateColorSettings` class defines a
    set of style properties for different control (button) states, such as
    `normalColorSettings` and `highlightedColorSettings`. Each state is configured
    by a `BRUIStyleControlColorSettings` class, which defines properties such as
    `actionColor` and `borderColor`.

# Applying style properties

For the impatient, by default **BRStyle** hooks into common system classes such as `UIButton` and `UINavigationBar` and applies the default global style to them for you. By merely including **BRStyle** in your project, you'll start to see the default style applied to things.

## Digging in and being a stylish host

**BRStyle** defines a couple of special protocols, `BRStylish` and `BRStylishHost`, that are used to flag objects as being interested in being styled. The protocol looks like this:

```objc
@protocol BRUIStylish <NSObject>

/** A BRUIStyle object to use. If not configured, the global default style should be returned. */
@property (nonatomic, strong, null_resettable) IBOutlet BRUIStyle *uiStyle;

@end

@protocol BRUIStylishHost <BRUIStylish>

@optional

/**
 Sent to the receiver if the @c BRUIStyle object associated with the receiver has changed.
 */
- (void)uiStyleDidChange:(BRUIStyle *)style;

@end

```

**BRStyle** defines some core system class categories on `UIBarButtonItem`, `UIView`, and `UIViewController` gives them all a `uiStyle` property. Here's the `UIViewController` category as an example:

```objc
@interface UIViewController (BRUIStyle)

/** A BRUIStyle object to use. If not configured, the global default style will be returned. */
@property (nonatomic, strong, null_resettable) IBOutlet BRUIStyle *uiStyle;

@end
```

Thus you can easily apply styles to view hierarchy objects from any view controller by simply referring to its `uiStyle` property. If your view controller then conforms to `BRUIStylishHost` then the `uiStyleDidChange:` method will be called on those controllers _when their views load_.

## Automagical styling

**BRStyle** goes one step further from providing an easy way to access style properties from your app: it can automatically apply those properties to your classes. This support comes from some additional categories added to core system classes such as `UIButton`. Using buttons as an example, the `UIBarButtonItem+BRUIStylishHost` category makes every button a `BRUIStylishHost`:

```objc
// UIButton+BRUIStylishHost.h
@interface UIButton (BRUIStylishHost) <BRUIStylishHost>

@end

// UIButton+BRUIStylishHost.m
@implementation UIButton (BRUIStylishHost)

@dynamic uiStyle; // implemented in UIView+BRUIStyle!

- (void)uiStyleDidChange:(BRUIStyle *)style {
	const BOOL inverse = ([self nearestAncestorViewOfType:[UINavigationBar class]] != nil || [self nearestAncestorViewOfType:[UIToolbar class]] != nil);
	self.titleLabel.font = style.fonts.actionFont;
	BRUIStyleControlStateColorSettings *controlSettings = (inverse ? style.colors.inverseControlSettings : style.colors.controlSettings);
	[self setTitleColor:controlSettings.normalColorSettings.actionColor forState:UIControlStateNormal];
	[self setTitleColor:controlSettings.highlightedColorSettings.actionColor forState:UIControlStateHighlighted];
	[self setTitleColor:controlSettings.selectedColorSettings.actionColor forState:UIControlStateSelected];
	[self setTitleColor:controlSettings.disabledColorSettings.actionColor forState:UIControlStateDisabled];
}

@end

```

In this way, core interface components will have their style configured via **BRStyle**.

## Non-magical styling

If you prefer to style your objects yourself, then you can use just the `BRStyle/Core` Cocopod subspec (or don't include any of the `+BRUIStylishHost` categories in your project). Then you can implement classes, or add extensions to existing ones, that conform to `BRUIStylishHost` and style them in the `uiStyleDidChange:` callback.
