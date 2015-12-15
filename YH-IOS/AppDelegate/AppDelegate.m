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

#import "DashboardViewController.h"
#import "GesturePasswordController.h"

@interface AppDelegate ()
@property (nonatomic, nonatomic) GesturePasswordController *gesturePasswordController;
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
    
    
    [self checkAssets:@"Loading"];
    [self checkAssets:@"assets"];
    [self checkUsedGesturePassword];
    
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
    
    [self checkUsedGesturePassword];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - asisstant methods
- (void)checkAssets:(NSString *)fileName {
    NSString *zipName = [NSString stringWithFormat:@"%@.zip", fileName];
    NSString *zipPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:zipName];
    NSString *sharedPath = [FileUtils sharedPath];
    NSString *loadingPath = [sharedPath stringByAppendingPathComponent:fileName];
    
    if(![FileUtils checkFileExist:loadingPath isDir:YES]) {
        [SSZipArchive unzipFileAtPath:zipPath toDestination:sharedPath];
    }
}
- (void)checkUsedGesturePassword {
    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
    NSDictionary *settingsInfo = [FileUtils readConfigFile:settingsConfigPath];
    
    if(settingsInfo
       && [settingsInfo[@"is_login"] isEqualToNumber:@1]
       && [settingsInfo[@"use_gesture_password"] isEqualToNumber:@1]) {
        self.gesturePasswordController = [[GesturePasswordController alloc] init];
        self.gesturePasswordController.delegate = self;
        
        [self.window.rootViewController presentViewController:self.gesturePasswordController animated:YES completion:nil];
        //self.window.rootViewController = gesturePasswordController;
    }
}
#pragma mark - GesturePasswordControllerDelegate
- (void)verifySucess {
    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
    NSMutableDictionary *settingsInfo = [FileUtils readConfigFile:settingsConfigPath];
    if(![settingsInfo[@"use_gesture_password"] isEqualToNumber:@1]) {
        settingsInfo[@"use_gesture_password"] = @1;
        [settingsInfo writeToFile:settingsConfigPath atomically:YES];
    }
    
    [self.gesturePasswordController dismissViewControllerAnimated:NO completion:^{
        self.gesturePasswordController.delegate = nil;
        self.gesturePasswordController = nil;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DashboardViewController *dashboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        self.window.rootViewController = dashboardViewController;
    }];
}

@end
