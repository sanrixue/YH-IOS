//
//  AppDelegate.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "AppDelegate.h"
#import "const.h"
#import "NSData+MD5.h"
#import <PgySDK/PgyManager.h>
#import "Version.h"
#import "FileUtils+Assets.h"

#import "DashboardViewController.h"
#import "LoginViewController.h"
#import "LTHPasscodeViewController.h"

@interface AppDelegate ()<LTHPasscodeViewControllerDelegate>
@end

@implementation AppDelegate

void UncaughtExceptionHandler(NSException * exception) {
    NSArray *arr     = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name   = [exception name];
    Version *version = [[Version alloc] init];
    NSString *mailContent = [NSString stringWithFormat:@"mailto:jay_li@intfocus.com \
                             ?subject=%@客户端bug报告                                 \
                             &body=很抱歉%@应用出现故障,发送这封邮件可协助我们改善此应用<br> \
                             感谢您的配合!<br><br>                                     \
                             应用详情:<br>                                            \
                             %@<br>                                                  \
                             错误详情:<br>                                            \
                             %@<br>                                                  \
                             --------------------------<br>                          \
                             %@<br>                                                  \
                             --------------------------<br>                          \
                             %@",
                             version.appName, version.appName,
                             [version simpleDescription],
                             name,reason,[arr componentsJoinedByString:@"<br>"]];
    
    NSURL *url = [NSURL URLWithString:[mailContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    @try {
        //启动基本SDK
        [[PgyManager sharedPgyManager] setEnableFeedback:NO];
        [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
        NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    }
    @catch (NSException *exception) {
        NSLog(@"NSSetUncaughtExceptionHandler - %@", exception.name);
    } @finally {}
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyBoard instantiateInitialViewController];
    self.window.rootViewController = initViewController;
    
    /**
     *  静态文件放在共享文件夹内,以便与服务器端检测、更新
     *  assets.zip不受服务器更新控制，但可以更新fonts/images/stylesheets/javascripts文件夹下内容
     *
     *  解压表态资源
     */
    [self checkVersionUpgrade];
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    [FileUtils checkAssets:@"assets" isInAssets:NO bundlePath:bundlePath];
    [FileUtils checkAssets:@"loading" isInAssets:NO bundlePath:bundlePath];
    [FileUtils checkAssets:@"fonts" isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:@"images" isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:@"javascripts" isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:@"stylesheets" isInAssets:YES bundlePath:bundlePath];
    
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

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
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
             *  若难失败，则在下次解屏检测时进入登录界面
             */
            NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
            NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
            if(!userDict[@"user_num"]) return;
            
            NSString *msg = [APIHelper userAuthentication:userDict[@"user_num"] password:userDict[@"user_md5"]];
            if(msg.length == 0) return;
            
            userDict[@"is_login"] = @(NO);
            [userDict writeToFile:userConfigPath atomically:YES];
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

#pragma mark - 缓存当前应用版本，每次检测，不一致时，有所动作
/**
 *  应用版本更新后，拷贝静态资源至sharedPath/下
 *
 *  注意: 需在 [FileUtils checkAssets:isInAssets:bundlePath:; 操作之前
 *  本次操作只拷贝覆盖， 解压等操作由FileUtils来完成
 *
 *  @param assetsPath <#assetsPath description#>
 */
- (void)checkVersionUpgrade {
    NSError *error;
    NSDictionary *bundleInfo       =[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion       = bundleInfo[@"CFBundleShortVersionString"];
    NSString *versionConfigPath    = [NSString stringWithFormat:@"%@/%@", [FileUtils basePath], CURRENT_VERSION__FILENAME];
    
    BOOL isUpgrade = YES;
    NSString *localVersion = @"noexist";
    if([FileUtils checkFileExist:versionConfigPath isDir:NO]) {
        localVersion = [NSString stringWithContentsOfFile:versionConfigPath encoding:NSUTF8StringEncoding error:nil];
        
        if(localVersion && [localVersion isEqualToString:currentVersion]) {
            isUpgrade = NO;
        }
    }
    
    if(isUpgrade) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *sharedPath = [FileUtils sharedPath], *bundleZipPath, *zipPath, *assetFileName;
        for(NSString *assetName in @[@"assets", @"loading", @"fonts", @"images", @"stylesheets", @"javascripts"]) {
            assetFileName = [NSString stringWithFormat:@"%@.zip", assetName];
            bundleZipPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:assetFileName];
            zipPath = [sharedPath stringByAppendingPathComponent:assetFileName];
            
            NSLog(@"version updated: %@ => %@", bundleZipPath, zipPath);
            [fileManager removeItemAtPath:zipPath error:&error];
            if(error) { NSLog(@"%@", [error localizedDescription]); }
            [fileManager copyItemAtPath:bundleZipPath toPath:zipPath error:&error];
            if(error) { NSLog(@"%@", [error localizedDescription]); }
        }

        [currentVersion writeToFile:versionConfigPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}
@end
