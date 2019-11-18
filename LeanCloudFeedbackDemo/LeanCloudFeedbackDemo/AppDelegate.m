//
//  AppDelegate.m
//  LeanCloudFeedbackDemo
//
//  Created by Feng Junwen on 5/22/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#warning 用公共账号登录 https://leancloud.cn ，账号/密码：leancloud@163.com/Public123 即可查看用户反馈
    NSString *appId = @"sl9sxfb9d9x0sc5g8c5wsv00f4nvztrgo5qcx4i4sjk1myn3";
    NSString *appKey = @"ysz2l1zttl802m3qq8lvvqnmw8tnp4wiiuwe5xtydcjxrwtg";
    [AVOSCloud setApplicationId:appId clientKey:appKey serverURLString:@"https://sl9sxfb9.lc-cn-n1-shared.com"];

    [AVOSCloud setAllLogsEnabled:YES];

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

@end
