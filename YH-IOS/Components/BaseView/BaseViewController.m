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
#import "AppDelegate.h"
#import "AFNetworking.h"
#import <SSZipArchive.h>
#import "TFHpple.h"
#import "Version.h"

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
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error],
             *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    if(error) {
        NSLog(@"%@ - %@", error.description, htmlPath);
    }
    
    
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSMutableDictionary *uniqDict = [NSMutableDictionary dictionary];
    
    // <script src="../*.js"></script>
    NSArray *elements = [doc searchWithXPathQuery:@"//script"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"src"] && [dict[@"src"] length] > 0 && [dict[@"src"] hasPrefix:@"assets/"]) {
            uniqDict[dict[@"src"]] = [NSString stringWithFormat:@"%@?%@", [dict[@"src"] componentsSeparatedByString:@"?"][0], timestamp];
        }
    }
    // <link href="../*.css">
    elements = [doc searchWithXPathQuery:@"//link"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"href"] && [dict[@"href"] length] > 0 && [dict[@"href"] hasPrefix:@"assets/"]) {
            uniqDict[dict[@"href"]] = [NSString stringWithFormat:@"%@?%@", [dict[@"href"] componentsSeparatedByString:@"?"][0], timestamp];
        }
    }
    // <img src="../*.png">
    elements = [doc searchWithXPathQuery:@"//img"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"src"] && [dict[@"src"] length] > 0 && [dict[@"src"] hasPrefix:@"assets/"]) {
            uniqDict[dict[@"src"]] = [NSString stringWithFormat:@"%@?%@", [dict[@"src"] componentsSeparatedByString:@"?"][0], timestamp];
        }
    }
    for(id key in uniqDict) {
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:key withString:uniqDict[key]];
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

- (void)showLoading:(LoadingType)loadingType {
    NSString *loadingPath = [FileUtils loadingPath:loadingType];
    NSString *loadingContent = [NSString stringWithContentsOfFile:loadingPath encoding:NSUTF8StringEncoding error:nil];
    
    [self.browser loadHTMLString:loadingContent baseURL:[NSURL fileURLWithPath:loadingPath]];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void)showProgressHUD:(NSString *)text {
    [self showProgressHUD:text mode:MBProgressHUDModeIndeterminate];
}

- (void)showProgressHUD:(NSString *)text mode:(MBProgressHUDMode)mode {
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.browser animated:YES];
    self.progressHUD.labelText = text;
    self.progressHUD.mode = mode;
    
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
//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}

-(UIStatusBarStyle)preferredStatusBarStyle {
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
}

/**
 *  检测版本升级，判断版本号是否为偶数。以便内测
 *
 *  @param response <#response description#>
 */
- (void)appUpgradeMethod:(NSDictionary *)response {
    NSLog(@"appUpgradeMethod: %@", response);
    
    if(!response || !response[@"downloadURL"]) return;
    
    NSString *pgyerVersionPath = [[FileUtils basePath] stringByAppendingPathComponent:PGYER_VERSION_FILENAME];
    [FileUtils writeJSON:[NSMutableDictionary dictionaryWithDictionary:response] Into:pgyerVersionPath];
    
    Version *version = [[Version alloc] init];
    if([version.current isEqualToString:response[@"versionName"]] && [version.build isEqualToString:response[@"versionCode"]]) {
        [ViewUtils showPopupView:self.view Info:@"已是最新版本"];
    }
    else if(response[@"versionCode"] && [response[@"versionCode"] integerValue] % 2 == 0) {
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"升级" actionBlock:^(void) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
        }];
        [alert showSuccess:self title:@"版本更新" subTitle:response[@"releaseNote"] closeButtonTitle:@"放弃" duration:0.0f];
    }
    else {
        [ViewUtils showPopupView:self.view Info:[NSString stringWithFormat:@"有发布测试版本%@(%@)", response[@"versionName"], response[@"versionCode"]]];
    }
}

/**
 *  设置是否允许横屏
 *
 *  @param allowRotation 允许横屏
 */
- (void)setAppAllowRotation:(BOOL)allowRotation {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = allowRotation;
}

/**
 *  检测服务器端静态文件是否更新
 */
- (void)checkAssetsUpdate {
    // 初始化队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    AFHTTPRequestOperation *op;
    op = [self checkAssetUpdate:@"loading" info: @"加载库" isInAssets: NO];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:@"fonts" info: @"字体" isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:@"images" info: @"图片" isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:@"stylesheets" info: @"样式库" isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:@"javascripts" info: @"解析库" isInAssets: YES];
    if(op) { [queue addOperation:op]; }
}

- (AFHTTPRequestOperation *)checkAssetUpdate:(NSString *)assetName info:(NSString *)info isInAssets:(BOOL)isInAssets {
    BOOL isShouldUpdateAssets = NO;
    __block NSString *sharedPath = [FileUtils sharedPath];
    
    NSString *assetsZipPath = [sharedPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", assetName]];
    if(![FileUtils checkFileExist:assetsZipPath isDir:NO]) {
        isShouldUpdateAssets = YES;
    }
    
    __block NSString *assetKey = [NSString stringWithFormat:@"%@_md5", assetName];
    __block  NSString *localAssetKey = [NSString stringWithFormat:@"local_%@_md5", assetName];
    __block NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    __block NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(!isShouldUpdateAssets && ![userDict[assetKey] isEqualToString:userDict[localAssetKey]]) {
        isShouldUpdateAssets = YES;
        NSLog(@"local: %@, server: %@", userDict[localAssetKey], userDict[assetKey]);
    }
    
    if(!isShouldUpdateAssets) { return nil; }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.tag       = 1000;
    HUD.mode      = MBProgressHUDModeDeterminate;
    HUD.labelText = [NSString stringWithFormat:@"更新%@", info];
    HUD.square    = YES;
    [HUD show:YES];
    
    // 下载地址
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_ASSETS_PATH, kBaseUrl, assetName]];
    // 保存路径
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:assetsZipPath append:NO];
    // 根据下载量设置进度条的百分比
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
        HUD.progress = precent;
    }];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [FileUtils checkAssets:assetName isInAssets:isInAssets bundlePath:[[NSBundle mainBundle] bundlePath]];
                
        [HUD removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@" 下载失败 ");
        [HUD removeFromSuperview];
    }];
    return op;
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
    
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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

- (NSString *)currentUIVersion {
    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:BETA_CONFIG_FILENAME];
    NSMutableDictionary *betaDict = [FileUtils readConfigFile:settingsConfigPath];
    return betaDict[@"new_ui"] && [betaDict[@"new_ui"] boolValue] ? @"v2" : @"v1";
}

@end
