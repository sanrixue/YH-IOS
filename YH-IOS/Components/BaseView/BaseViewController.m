//
//  BaseView.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>
#import "ViewUtils.h"
#import "NSData+MD5.h"
#import <SSZipArchive.h>

@interface BaseViewController ()<LTHPasscodeViewControllerDelegate>
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [[User alloc] init];
    self.sharedPath = [FileUtils sharedPath];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:HTML_DIRNAME];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [LTHPasscodeViewController sharedUser].delegate = self;
    [LTHPasscodeViewController useKeychain:NO];
    [LTHPasscodeViewController sharedUser].allowUnlockWithTouchID = NO;
}

#pragma  mark - assistant methods
- (void)idColor {
    NSArray *colors = @[@"ffffff", @"ffcd0a", @"fd9053", @"dd0929", @"016a43", @"9d203c", @"093db5", @"6a3906", @"192162", @"000000"];
    NSArray *colorViews = @[self.idColor0, self.idColor1, self.idColor2, self.idColor3, self.idColor4];
    NSString *userID = [NSString stringWithFormat:@"%@", self.user.userID];
    
    
    NSString *color;
    NSInteger userIDIndex, numDiff = colorViews.count - userID.length;
    UIImageView *imageView;
    
    numDiff = numDiff < 0 ? 0 : numDiff;
    for(NSInteger i = 0; i < colorViews.count; i++) {
        color = colors[0];
        if(i >= numDiff) {
            userIDIndex = [[NSString stringWithFormat:@"%c", [userID characterAtIndex:i-numDiff]] integerValue];
            color = colors[userIDIndex];
        }
        imageView = colorViews[i];
        imageView.image = [self imageWithColor:[UIColor colorWithHexString:color] size:CGSizeMake(5.0, 5.0)];
        imageView.layer.cornerRadius = 2.5f;
        imageView.layer.masksToBounds = YES;
        imageView.hidden = NO;
    }
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.idView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bannerView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-10.0f]];
}

- (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
    [color setFill];
    [rPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (NSString *)stringWithContentsOfFile:(NSString *)htmlPath {
    NSError *error = nil;
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"%@ - %@", error.description, htmlPath);
    }
    
    NSString *from, *to, *timestamp = TimeStamp;
    for(NSString *ext in @[@"js", @"css", @"png", @"gif"]) {
        from = [NSString stringWithFormat:@".%@\"", ext];
        to = [NSString stringWithFormat:@".%@?%@\"", ext, timestamp];
        
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:from withString:to options:NSCaseInsensitiveSearch range:NSMakeRange(0, htmlContent.length)];
    }
    
    return htmlContent;
}


- (void)clearBrowserCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *domain = [[NSURL URLWithString:self.urlString] host];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:domain]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}
- (void)showLoading {
    [self showLoading:NO];
}

- (void)showLoading:(BOOL)isLogin {
    NSString *loadingPath = [FileUtils loadingPath:isLogin];
    NSString *loadingContent = [NSString stringWithContentsOfFile:loadingPath encoding:NSUTF8StringEncoding error:nil];
    
    [self.browser loadHTMLString:loadingContent baseURL:[NSURL fileURLWithPath:loadingPath]];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void)showProgressHUD:(NSString *)text {
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.browser animated:YES];
    self.progressHUD.labelText = text;
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}


- (void)jumpToLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[@"is_login"] = @(NO);
    [userDict writeToFile:userConfigPath atomically:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.view.window.rootViewController = loginViewController;
}

#pragma mark - status bar settings
- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // [self showProgressHUD:@"收到IOS系统，内存警告."];
    NSLog(@"收到IOS系统，内存警告.");
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"警告/内存";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
    //self.progressHUD.mode = MBProgressHUDModeText;
    //[self.progressHUD hide:YES afterDelay:2.0];
}

/**
 *  内容检测版本升级，判断版本号是否为偶数。以便内测
 *
 *  @param response <#response description#>
 */
- (void)appUpgradeMethod:(NSDictionary *)response {
    NSLog(@"%@", response);
    
    if(response && response[@"downloadURL"] && response[@"versionCode"] && [response[@"versionCode"] integerValue] % 2 == 0) {
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert addButton:@"升级" actionBlock:^(void) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
        }];
        
        [alert showSuccess:self title:@"版本更新" subTitle:response[@"releaseNote"] closeButtonTitle:@"放弃" duration:0.0f];
    }
    else {
        [ViewUtils showPopupView:self.view Info:@"已是最新版本"];
    }
}

/**
 *  检测静态文件
 *
 *  @param fileName <#fileName description#>
 */
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
        NSString *loadingPath = [self.sharedPath stringByAppendingPathComponent:fileName];
        if(![FileUtils checkFileExist:loadingPath isDir:YES]) {
            [FileUtils removeFile:loadingPath];
        }
        
        [SSZipArchive unzipFileAtPath:zipPath toDestination:self.sharedPath];
        
        userDict[keyName] = md5String;
        [userDict writeToFile:userConfigPath atomically:YES];
        NSLog(@"unzipfile for %@, %@", fileName, md5String);
    }
}


#pragma mark - LTHPasscodeViewControllerDelegate methods

- (void)passcodeWasEnteredSuccessfully {
    NSLog(@"BaseViewController - Passcode Was Entered Successfully");
    
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
    });}


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

- (void)savePasscode:(NSString *)passcode {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[@"use_gesture_password"] = @(YES);
    userDict[@"gesture_password"] = passcode;
    [userDict writeToFile:userConfigPath atomically:YES];
    
    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
    [userDict writeToFile:settingsConfigPath atomically:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIHelper screenLock:userDict[@"user_device_id"] passcode:passcode state:YES];
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"设置锁屏";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}

@end
