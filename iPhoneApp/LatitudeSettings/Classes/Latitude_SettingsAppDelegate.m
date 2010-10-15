//
//  Latitude_SettingsAppDelegate.m
//  Latitude Settings
//
//  Created by Drew Aaron on 10/14/10.
//  Copyright Lingo Network 2010. All rights reserved.
//

#import "Latitude_SettingsAppDelegate.h"
#import "Latitude_SettingsViewController.h"

@implementation Latitude_SettingsAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
