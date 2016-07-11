//
//  AppDelegate.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "AppDelegate.h"
#import "UMessage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "Constants.h"
#import "NSData+MD5.h"
#import <PgySDK/PgyManager.h>
#import "Version.h"
#import "FileUtils+Assets.h"

#import "DashboardViewController.h"
#import "LoginViewController.h"
#import "LTHPasscodeViewController.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyBoard instantiateInitialViewController];
    [self.window setRootViewController:initViewController];
    [self.window makeKeyAndVisible];
    
    [self initPgyer];
    [self initUMessage:launchOptions];
    [self initUMSocial];
    [self checkVersionUpgrade];
    [self checkAssets];
    [self initWebViewUserAgent];
    [self initScreenLock];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
    NSString *pushToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                           stringByReplacingOccurrencesOfString: @">" withString: @""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:PUSH_CONFIG_FILENAME];
    NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
    if(pushToken.length != 64 || (pushDict[@"push_valid"] && [pushDict[@"push_valid"] boolValue])) return;
    
    pushDict[@"push_device_token"] = pushToken;
    pushDict[@"push_valid"] = @(NO);
    [pushDict writeToFile:pushConfigPath atomically:YES];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 关闭友盟自带的弹出框
    // [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo];
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

- (void)checkAssets {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    [FileUtils checkAssets:@"assets" isInAssets:NO bundlePath:bundlePath];
    [FileUtils checkAssets:@"loading" isInAssets:NO bundlePath:bundlePath];
    [FileUtils checkAssets:@"fonts" isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:@"images" isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:@"javascripts" isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:@"stylesheets" isInAssets:YES bundlePath:bundlePath];
}

- (void)initWebViewUserAgent {
    NSString *userAgentPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_AGENT_FILENAME];
    if(![FileUtils checkFileExist:userAgentPath isDir:NO]) {
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        [userAgent writeToFile:userAgentPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)initScreenLock {
    [LTHPasscodeViewController sharedUser].delegate = self;
    [LTHPasscodeViewController useKeychain:NO];
    [LTHPasscodeViewController sharedUser].allowUnlockWithTouchID = NO;
    if ([LTHPasscodeViewController doesPasscodeExist] && [LTHPasscodeViewController didPasscodeTimerEnd]) {
        [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:YES withLogout:NO andLogoutTitle:nil];
    }
}

#pragma mark - initialized SDK
- (void)initPgyer {
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    [[PgyManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
}

- (void)initUMessage:(NSDictionary *)launchOptions {
    [UMessage startWithAppkey:kUMAppId launchOptions:launchOptions];
    // [UMessage setChannel:@"App Store"];
    
    //register remoteNotification types （iOS 8.0及其以上版本）
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"Accept";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"Reject";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    
    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
    categorys.identifier = @"category1";//这组动作的唯一标示
    [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    
    UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                 categories:[NSSet setWithObject:categorys]];
    [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    
    [UMessage setLogEnabled:YES];
    [UMessage setBadgeClear:NO];
}

- (void)initUMSocial {
    [UMSocialData setAppKey:kUMAppId];
    [UMSocialData openLog:YES];
    // 如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:kWXAppId appSecret:kWXAppSecret url:kBaseUrl];
}

#pragma mark - UMeng Social Callback
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
@end
