//
//  AppDelegate.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "AppDelegate.h"
#import "const.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#import "FileUtils.h"
#import <SSZipArchive.h>

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    //启动检测版本更新
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    NSString *zipPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Loading.zip"];
    NSString *userspace = [FileUtils userspace];
    NSString *loadingPath = [userspace stringByAppendingPathComponent:@"Loading"];
    
    if(![FileUtils checkFileExist:loadingPath isDir:YES]) {
        [SSZipArchive unzipFileAtPath:zipPath toDestination:userspace];
    }
    
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