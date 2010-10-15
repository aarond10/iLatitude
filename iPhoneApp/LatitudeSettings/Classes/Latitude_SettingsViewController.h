//
//  Latitude_SettingsViewController.h
//  Latitude Settings
//
//  Created by Drew Aaron on 10/14/10.
//  Copyright Lingo Network 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Latitude_SettingsViewController : UIViewController<UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
}

@property(nonatomic,retain) UIWebView *webView;

@end

