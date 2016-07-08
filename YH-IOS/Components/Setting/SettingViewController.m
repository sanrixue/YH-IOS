//
//  SettingViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/10.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "SettingViewController.h"
#import "ViewUtils.h"
#import "LoginViewController.h"
#import "Version.h"
#import "APIHelper.h"
#import "ResetPasswordViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>


static NSString *const kResetPasswordSegueIdentifier = @"ResetPasswordSegueIdentifier";

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchGesturePassword;
@property (weak, nonatomic) IBOutlet UISwitch *switchNewUI;

@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelUserRole;
@property (weak, nonatomic) IBOutlet UILabel *labelUserGroup;
@property (weak, nonatomic) IBOutlet UILabel *labelAppName;
@property (weak, nonatomic) IBOutlet UILabel *labelAppVersion;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceMode;
@property (weak, nonatomic) IBOutlet UILabel *labelAPIDomain;
@property (weak, nonatomic) IBOutlet UILabel *labelPushState;
@property (weak, nonatomic) IBOutlet UILabel *labelBundleID;
@property (weak, nonatomic) IBOutlet UIButton *buttonChangeGesturePassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonPgyerLink;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bannerView.backgroundColor = [UIColor colorWithHexString:YH_COLOR];
    [self idColor];
    [self.btnLogout.layer setCornerRadius:10.0];

    self.labelUserName.text = [NSString stringWithFormat:@"%@(%@)", self.user.userName, self.user.userID];
    self.labelUserRole.text = [NSString stringWithFormat:@"%@(%@)", self.user.roleName, self.user.roleID];
    self.labelUserGroup.text = [NSString stringWithFormat:@"%@(%@)", self.user.groupName, self.user.groupID];
    
    Version *version = [[Version alloc] init];
    self.labelAppName.text    = version.appName;
    self.labelAppVersion.text = [NSString stringWithFormat:@"%@(%@)", version.current, version.build];
    self.labelDeviceMode.text = [[Version machineHuman] componentsSeparatedByString:@" ("][0];
    self.labelBundleID.text   = version.bundleID;
    self.labelAPIDomain.text  = [kBaseUrl componentsSeparatedByString:@"://"][1];
    
    NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:PUSH_CONFIG_FILENAME];
    NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
    self.labelPushState.text = pushDict[@"push_valid"] && [pushDict[@"push_valid"] boolValue] ? @"开启" : @"关闭";
    self.switchNewUI.on = [[self currentUIVersion] isEqualToString:@"v2"];
    
    NSString *pgyerVersionPath = [[FileUtils basePath] stringByAppendingPathComponent:PGYER_VERSION_FILENAME];
    if([FileUtils checkFileExist:pgyerVersionPath isDir:NO]) {
        NSMutableDictionary *pgyerVersionDict = [FileUtils readConfigFile:pgyerVersionPath];
        BOOL isPgyerLatest = [version.current isEqualToString:pgyerVersionDict[@"versionName"]] && [version.build isEqualToString:pgyerVersionDict[@"versionCode"]];
        NSString *pgyerVersionState = isPgyerLatest ? @"已是最新版本" : [NSString stringWithFormat:@"有发布测试版本:%@(%@)", pgyerVersionDict[@"versionName"], pgyerVersionDict[@"versionCode"] ];
        [self.buttonPgyerLink setTitle:pgyerVersionState forState:UIControlStateNormal];
        UIColor *buttonColor = isPgyerLatest ? [UIColor darkGrayColor] : [UIColor blueColor];
        [self.buttonPgyerLink setTitleColor:buttonColor forState:UIControlStateNormal];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BOOL isUseGesturePassword = [LTHPasscodeViewController doesPasscodeExist] && [LTHPasscodeViewController didPasscodeTimerEnd];
    self.switchGesturePassword.on = isUseGesturePassword;
    self.buttonChangeGesturePassword.enabled = isUseGesturePassword;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action methods
- (IBAction)actionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)actionCheckUpgrade {
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appUpgradeMethod:)];
}

- (IBAction)actionOpenLink:(id)sender {
    NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)actionCheckAssets:(id)sender {
    NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", self.sharedPath, CACHED_HEADER_FILENAME];
    [FileUtils removeFile:cachedHeaderPath];
    cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", [FileUtils dirPath:HTML_DIRNAME], CACHED_HEADER_FILENAME];
    [FileUtils removeFile:cachedHeaderPath];
    
    [APIHelper userAuthentication:self.user.userNum password:self.user.password];
    
    [self checkAssetsUpdate];
    
    // 第三方消息推送，设备标识
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    BOOL isSuccess = [APIHelper pushDeviceToken:userDict[@"device_uuid"]];
    self.labelPushState.text = isSuccess ? @"开启" : @"关闭";
    
    [ViewUtils showPopupView:self.view Info:@"校正完成"];
}

- (IBAction)actionChangeGesturePassword:(id)sender {
    [self showLockViewForChangingPasscode];
}

- (IBAction)actionWehtherUseGesturePassword:(UISwitch *)sender {
    if([sender isOn]) {
        [self showLockViewForEnablingPasscode];
    }
    else {
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
        userDict[@"use_gesture_password"] = @(NO);
        [userDict writeToFile:userConfigPath atomically:YES];

        NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
        [userDict writeToFile:settingsConfigPath atomically:YES];
        
        self.buttonChangeGesturePassword.enabled = NO;
        
        [ViewUtils showPopupView:self.view Info:@"禁用手势锁设置成功"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [APIHelper screenLock:userDict[@"user_device_id"] passcode:userDict[@"gesture_password"] state:NO];
        
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[@"action"] = [NSString stringWithFormat:@"点击/设置页面/%@锁屏", sender.isOn ? @"开启" : @"禁用"];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }
}

- (IBAction)actionSwitchToNewUI:(UISwitch *)sender {
    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:BETA_CONFIG_FILENAME];
    NSMutableDictionary *betaDict = [FileUtils readConfigFile:settingsConfigPath];
    betaDict[@"new_ui"] = @(sender.isOn);
    [betaDict writeToFile:settingsConfigPath atomically:YES];
}

- (IBAction)actionLogout:(id)sender {
    [self clearBrowserCache];
    [self jumpToLogin];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"退出登录";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}

- (IBAction)actionResetPassword:(id)sender {
    [self performSegueWithIdentifier:kResetPasswordSegueIdentifier sender:nil];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"点击/设置页面/修改密码";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kResetPasswordSegueIdentifier]) {
        ResetPasswordViewController *resetPasswordViewController = (ResetPasswordViewController *)segue.destinationViewController;
        resetPasswordViewController.bannerName = @"重置密码";
        resetPasswordViewController.link       = RESET_PASSWORD_PATH;
    }
}

#pragma mark - LTHPasscode delegate methods
- (void)showLockViewForEnablingPasscode {
    [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self
                                                                            asModal:YES];
}
//
//- (void)showLockViewForTestingPasscode {
//    [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:YES
//                                                             withLogout:NO
//                                                         andLogoutTitle:nil];
//}

- (void)showLockViewForChangingPasscode {
    [[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController:self asModal:YES];
}

//- (void)showLockViewForTurningPasscodeOff {
//    [[LTHPasscodeViewController sharedUser] showForDisablingPasscodeInViewController:self
//                                                                             asModal:NO];
//}
@end
