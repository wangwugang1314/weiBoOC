//
//  AppDelegate.m
//  weiBoOC
//
//  Created by MAC on 15/11/25.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "AppDelegate.h"
#import "YBTabBarController.h"
#import "YBWelcomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 设置全局属性
    [self setGlobalProperty];
    
    // 创建window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen bounds]];
    // 设置跟试图
//    self.window.rootViewController = [YBTabBarController new];
    self.window.rootViewController = [YBWelcomeViewController new];
    // 显示
    [self.window makeKeyAndVisible];
    // 设置背景颜色
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 设置全局属性
- (void)setGlobalProperty {
    // barButtonItem
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor orangeColor]};
    [barButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
}

@end
