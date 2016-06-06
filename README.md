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
[BRUIStyle setDefaultStyle:style];
```

# For the ❤️ of UIAppearance

**BRStyle** does not try to replace `UIAppearance`! In fact, you can use BRStyle as
a way to configure UIAppearance proxies. For example, you might do something like
this when your app starts up:

```objc
// load up style from JSON resource
BRUIStyle *style = [BRUIStyle styleWithJSONResource:@"style.json" inBundle:nil];
[BRUIStyle setDefaultStyle:style];

// configure UINavigationBar and UIToolbar style via UIAppearance
UINavigationBar *bar = [UINavigationBar appearance];
bar.tintColor = style.colors.inverseControlSettings.normalColorSettings.actionColor;
bar.barTintColor = style.colors.navigationColor;
[bar setTitleTextAttributes:@{
							  NSForegroundColorAttributeName: style.colors.inverseControlSettings.normalColorSettings.actionColor,
							  NSFontAttributeName: style.fonts.navigationFont,
							  }];

UIToolbar *toolbar = [UIToolbar appearance];
toolbar.tintColor = bar.tintColor;
toolbar.barTintColor = bar.barTintColor;
```

In fact, why not use the [BRUIStyleAppearanceLoader](BRStyle/Code/Core/BRUIStyleAppearanceLoader.m)
helper class to automatically apply appearance settings from a handy `styles.json` file?
For example, take a (very simplified) BRStyle `styles.json` file like this:

```json
{
  "default" : {
    "colors" : {
      "primaryColor" : "#ff0000ff",
      "backgroundColor" : null
    },
    "fonts" : {
      "actionFont" : { "name" : "Helvetica-Regular", "size" : 12 }
    },
    "controls" : {
      "actionColor" : "#0000ccff",
      "borderColor" : "#000000ff",
      "glossColor" : "#ffffff33"
    }
  },

  "MyCustomButton" : {
    "fonts" : {
      "actionFont" : { "name" : "Helvetica-Bold", "size" : 10 }
    }
  },

  "UIPopoverController/MyCustomButton" : {
    "fonts" : {
      "actionFont" : { "name" : "Helvetica-Bold", "size" : 14 }
    }
  },

  "MyCustomButton-highlighted|selected" : {
    "controls" : {
      "actionColor" : "#ff00ccff"
    }
  }

}
```

Setup your styles like this:

```objc
NSDictionary<NSString *, BRUIStyle *> *styles = [BRUIStyle registerDefaultStylesWithJSONResource:@"styles.json" inBundle:nil];
[[BRUIStyleAppearanceLoader new] setupAppearanceStyles:styles];
```

The `default` key represent the global default style settings. All other keys represent
arbitrary named styles you can reference as needed. By passing the `styles` dictionary to
`BRUIStyleAppearanceLoader`, the keys are interpreted in specific ways. If the keys are
class names that conform to `UIAppearance` _and_ either `BRUIStylish` or `BRUIStylishControl`
the style will be set on the `UIAppearance` proxy for that class.

You can configure `UIAppearanceContainer` hierarchies by using slashes before the class
name you want to style. In the example above, the `MyCustomButton` class's style will
be configured with an `actionFont` of size **10** by default, but when contained in a
`UIPopoverController` it will have size **14**.

You can also configure specific control states with classes conforming to `BRUIStylishControl`
by appending a `-` followed by the state name to the key. Multiple states can be specified
by delimiting them with a `|` character. In the example above, the `MyCustomButton` class's
style when it is in both the `highlighted` _and_ `selected` states.


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

For the impatient, by default **BRStyle** hooks into common system classes such
as `UIButton` and `UINavigationBar` and applies the default global style to them
for you. By merely including **BRStyle** in your project, you'll start to see
the default style applied to things.

## Digging in and being a stylish host

**BRStyle** defines a couple of special protocols, `BRStylish` and
`BRStylishHost`, that are used to flag objects as being interested in being
styled. The protocol looks like this:

```objc
@protocol BRUIStylish <NSObject>

/** A BRUIStyle object to use. If not configured, the global default style should be returned. */
@property (nonatomic, strong, null_resettable) IBOutlet BRUIStyle *uiStyle UI_APPEARANCE_SELECTOR;

@end

@protocol BRUIStylishHost <BRUIStylish>

@optional

/**
 Sent to the receiver if the @c BRUIStyle object associated with the receiver has changed.
 */
- (void)uiStyleDidChange:(BRUIStyle *)style;

@end
```

**BRStyle** defines some core system class categories on `UIBarButtonItem`, `UIView`,
and `UIViewController` gives them all a `uiStyle` property. Here's the
`UIViewController` category as an example:

```objc
@interface UIViewController (BRUIStyle)

/** A BRUIStyle object to use. If not configured, the global default style will be returned. */
@property (nonatomic, strong, null_resettable) IBOutlet BRUIStyle *uiStyle;

@end
```

Thus you can easily apply styles to view hierarchy objects from any view
controller by simply referring to its `uiStyle` property. If your view
controller then conforms to `BRUIStylishHost` then the `uiStyleDidChange:`
method will be called on those controllers _when their views load_.

## Stylish controls

One more protocol is used specifically for classes that extend `UIControl`: `BRUIStylishControl`.
This protocol defines some support for control state specific styling, for example to change
the background color of a button while it is being pressed (i.e. in the `highlighted` state). The
protocol looks like this:

```objc
/**
 API for objects that act like controls, with style settings based on a UIControlState.
 */
@protocol BRUIStylishControl <NSObject>

/** Manage the BRUIStyleControlStateDangerous state flag. */
@property (nonatomic, getter=isDangerous) IBInspectable BOOL dangerous;

/**
 Get a style for a control state. If a style is not defined for the given state, then
 the style configured for the @c UIControlStateNormal state should be returned. If no
 state is configured for the @c UIControlStateNormal state, then the global default
 style should be returned.

 @param state The control state.

 @return The style associated with the given control state, or the defalut style if
         nothing specific configured.
 */
- (BRUIStyle *)uiStyleForState:(UIControlState)state;

/**
 Set a style to use for a specific control state.

 @param style The style to use.
 @param state The control state to apply the style settings to.
 */
- (void)setUiStyle:(nullable BRUIStyle *)style forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

@optional

/**
 Notify the receiver that the control state has been updated.
 */
- (void)stateDidChange;

/**
 Notify the receiver that the style has been changed for a specific state.

 @param style The updated style.
 @param state The state the style is associated with.
 */
- (void)uiStyleDidChange:(BRUIStyle *)style forState:(UIControlState)state;

@end
```

As you can see, it adds a new control state `dangerous` which can be used to easily style
buttons that preform a destructive operation.


## Automagical styling

**BRStyle** goes one step further from providing an easy way to access style
properties from your app: it can automatically apply those properties to your
classes. This support comes from some additional categories added to core system
classes such as `UIButton`. Using buttons as an example, the
`UIButton+BRUIStylishHost` category makes every button a `BRUIStylishHost`:

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

If you prefer to style your objects yourself, then you can use just the
`BRStyle/Core` Cocopod subspec (or don't include any of the `+BRUIStylishHost`
categories in your project). Then you can implement classes, or add extensions
to existing ones, that conform to `BRUIStylishHost` and style them in the
`uiStyleDidChange:` callback.

# Sample app

The `BRStyleSampler` project included in the source repository includes a sample
application that shows how the styling can be used, and includes simple editing
functionality to modify the colors and see the changes applied. It can also
generate JSON from your style, so you could use that as a starting point for
your own app's style needs.
