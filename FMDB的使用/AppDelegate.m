//
//  AppDelegate.m
//  FMDB的使用
//
//  Created by 李自杨 on 17/2/13.
//  Copyright © 2017年 View. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyWindow];
    
    HomePageViewController *homePage = [[HomePageViewController alloc]init];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:homePage];
    self.window.rootViewController = navi;
    
    return YES;
}





@end
