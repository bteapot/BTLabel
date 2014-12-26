//
//  BTAppDelegate.m
//  BTLabel
//
//  Created by CocoaPods on 12/26/2014.
//  Copyright (c) 2014 Денис Либит. All rights reserved.
//

#import "BTAppDelegate.h"
#import "BTRootVC.h"


@implementation BTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	self.window.tintColor = [UIColor colorWithHue:0.5 saturation:0.5 brightness:0.5 alpha:1];
	self.window.rootViewController = [[BTRootVC alloc] init];
	[self.window makeKeyAndVisible];
	return YES;
}
							
@end
