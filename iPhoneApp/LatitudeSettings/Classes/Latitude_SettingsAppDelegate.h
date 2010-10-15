//
//  Latitude_SettingsAppDelegate.h
//  Latitude Settings
//
//  Created by Drew Aaron on 10/14/10.
//  Copyright Lingo Network 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Latitude_SettingsViewController;

@interface Latitude_SettingsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Latitude_SettingsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Latitude_SettingsViewController *viewController;

@end

