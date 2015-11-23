//
//  BTAppDelegate.m
//  BTLabel
//
//  Created by CocoaPods on 12/26/2014.
//  Copyright (c) 2014 Денис Либит. All rights reserved.
//

#import "BTAppDelegate.h"
#import "BTLabelVC.h"
#import "BTTableVC.h"


@implementation BTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	self.window.tintColor = [UIColor colorWithHue:0.5 saturation:0.5 brightness:0.5 alpha:1];
	
	UITabBarController *rootVC = [[UITabBarController alloc] init];
	rootVC.viewControllers = @[
		[[BTLabelVC alloc] init],
		[[BTTableVC alloc] init]
	];
	self.window.rootViewController = rootVC;
	
	[self.window makeKeyAndVisible];
	return YES;
}
							
@end
