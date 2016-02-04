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

#import "FileUtils.h"
#import "NSData+MD5.h"
#import <SSZipArchive.h>

#import "DashboardViewController.h"
#import "LoginViewController.h"
#import "LTHPasscodeViewController.h"

@interface AppDelegate ()<LTHPasscodeViewControllerDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyBoard instantiateInitialViewController];
    self.window.rootViewController = initViewController;
    
    /**
     *  解压表态资源
     */
    [self checkAssets:@"loading"];
    [self checkAssets:@"assets"];
    
    /**
     *  初始化移动端本地webview的avigator.userAgent
     *  HttpUtils内部使用时，只需要读取
     */
    NSString *userAgentPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_AGENT_FILENAME];
    if(![FileUtils checkFileExist:userAgentPath isDir:NO]) {
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        [userAgent writeToFile:userAgentPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }

    [self.window makeKeyAndVisible];
    
    
    [LTHPasscodeViewController sharedUser].delegate = self;
    [LTHPasscodeViewController useKeychain:NO];
    [LTHPasscodeViewController sharedUser].allowUnlockWithTouchID = NO;
    if ([LTHPasscodeViewController doesPasscodeExist] &&
        [LTHPasscodeViewController didPasscodeTimerEnd]) {
        
        [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:YES
                                                                 withLogout:NO
                                                             andLogoutTitle:nil];
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

#pragma mark - asisstant methods
- (void)checkAssets:(NSString *)fileName {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    NSString *zipName = [NSString stringWithFormat:@"%@.zip", fileName];
    NSString *zipPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:zipName];
    NSString *keyName = [NSString stringWithFormat:@"%@_md5", fileName];
    NSData *fileData = [NSData dataWithContentsOfFile:zipPath];
    NSString *md5String = fileData.md5;
    
    BOOL isShouldUnZip = YES;
    
    if([FileUtils checkFileExist:userConfigPath isDir:NO]) {
        if([userDict.allKeys containsObject:keyName] && [userDict[keyName] isEqualToString:md5String]) {
            isShouldUnZip = NO;
        }
    }
    
    if(isShouldUnZip) {
        NSString *sharedPath = [FileUtils sharedPath];
        NSString *loadingPath = [sharedPath stringByAppendingPathComponent:fileName];
        if(![FileUtils checkFileExist:loadingPath isDir:YES]) {
            [FileUtils removeFile:loadingPath];
        }
        
        [SSZipArchive unzipFileAtPath:zipPath toDestination:sharedPath];
        
        userDict[keyName] = md5String;
        [userDict writeToFile:userConfigPath atomically:YES];
        NSLog(@"unzipfile for %@, %@", fileName, md5String);
    }
}

#pragma mark - LTHPasscodeViewControllerDelegate methods

- (void)passcodeWasEnteredSuccessfully {
    NSLog(@"AppDelegate - Passcode Was Entered Successfully");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController *dashboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    dashboardViewController.fromViewController = @"AppDelegate";
    self.window.rootViewController = dashboardViewController;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"解屏";
            [APIHelper actionLog:logParams];
            
            /**
             *  解屏验证用户信息，更新用户权限
             */
            
            NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
            NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
            if(userDict[@"user_num"]) {
                NSString *msg = [APIHelper userAuthentication:userDict[@"user_num"] password:userDict[@"user_md5"]];
                if(msg.length > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self jumpToLogin];
                    });
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}


- (BOOL)didPasscodeTimerEnd {
    return YES;
}
- (NSString *)passcode {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if([userDict[@"is_login"] boolValue] && [userDict[@"use_gesture_password"] boolValue]) {
        return userDict[@"gesture_password"] ?: @"";
    }
    return @"";
}


- (void)jumpToLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[@"is_login"] = @(NO);
    [userDict writeToFile:userConfigPath atomically:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.window.rootViewController = loginViewController;
}
@end
