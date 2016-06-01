//
//  BRUIStyleAppearanceLoader.h
//  BRStyle
//
//  Created by Matt on 1/06/16.
//  Copyright © 2016 Blue Rocket, Inc. All rights reserved.
//

#import "BRUIStyle.h"

/**
 Register styles for @c UIAppearance proxies.
 */
@interface BRUIStyleAppearanceLoader : NSObject

/**
 Setup @c UIAppearance styles from a dictionary of styles.
 
 The keys of the dictionary represent the @c UIAppearance containers to set the associated @c BRUIStyle objects on. Keys take
 the form of <code>[ContainerClassName/...]ClassName[-ControlState[|ControlState...]]</code>. At a minimum, the key can be
 the name of the class to set the style on. For example, to set the style on the @c UITableViewCell class, the key would simply
 be @i UITableViewCell and the equivalant operation is like
 
 @code
BRUIStyle *style = styles[@"UITableViewCell"];
[UITableViewCell appearance].uiStyle = style;
 @endcode
 
 To configure appearance containment hierarchies, add the hierarchy as a slash-delimited list before the class name. For example,
 to configure table view cells that are in a @c UITableViewController that is in a popover, the key would be
 
 @code
UIPopoverController/UITableViewController/UITableViewCell
 @endcode
 
 which is the equivalent of calling
 
 @code
BRUIStyle *style = styles[@"UIPopoverController/UITableViewController/UITableViewCell"];
[UITableViewCell appearanceWhenContainedIn:[UITableViewController class], [UIPopoverController class], nil].uiStyle = style;
 @endcode

 Finally, for @c UIControl subclasses, specific control states can be configured by appending a dash followed by a pipe-delimited
 list of control state names. For example, to configure buttons that are both highlighted and selected and are contained in a 
 table cell in a popover the key would be
 
 @code
UIPopoverController/UITableViewCell/UIButton-highlighted|selected
 @endcode
 
 @param styles The styles to setup on @c UIAppearance proxies.
 */
- (void)setupAppearanceStyles:(NSDictionary<NSString *, BRUIStyle *> *)styles;

@end
