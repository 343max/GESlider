//
//  GEAppDelegate.m
//  Slider
//
//  Created by Max von Webel on 03/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import "GETestViewController.h"

#import "GEAppDelegate.h"

@implementation GEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[GETestViewController alloc] initWithNibName:@"GETestViewController" bundle:nil];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
