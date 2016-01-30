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
#import "LTHPasscodeViewController.h"
#import "APIHelper.h"
#import "ResetPasswordViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>


static NSString *const kResetPasswordSegueIdentifier = @"ResetPasswordSegueIdentifier";

@interface SettingViewController ()<LTHPasscodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switchGesturePassword;

@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelUserRole;
@property (weak, nonatomic) IBOutlet UILabel *labelUserGroup;
@property (weak, nonatomic) IBOutlet UILabel *labelAppName;
@property (weak, nonatomic) IBOutlet UILabel *labelAppVersion;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceMode;
@property (weak, nonatomic) IBOutlet UILabel *labelAPIDomain;
@property (weak, nonatomic) IBOutlet UIButton *buttonChangeGesturePassword;

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
    
    self.labelAPIDomain.text  = [BASE_URL componentsSeparatedByString:@"://"][1];
    
    [LTHPasscodeViewController sharedUser].delegate = self;
    [LTHPasscodeViewController useKeychain:NO];
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
    [self dismissViewControllerAnimated:YES completion:^{
        
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"返回/设置页面";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }];
}

- (IBAction)actionCheckUpgrade {
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appUpgradeMethod:)];
}

- (IBAction)actionCheckAssets:(id)sender {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if([userDict.allKeys containsObject:@"assets_md5"]) {
        [userDict removeObjectForKey:@"assets_md5"];
    }
    if([userDict.allKeys containsObject:@"loading_md5"]) {
        [userDict removeObjectForKey:@"loading_md5"];
    }
    [userDict writeToFile:userConfigPath atomically:YES];
    
    NSString *headerPath = [self.sharedPath stringByAppendingPathComponent:CACHED_HEADER_FILENAME];
    [FileUtils removeFile:headerPath];
    
    
    [self checkAssets:@"loading"];
    [self checkAssets:@"assets"];
    
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
        });
        
        
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
    }
}

- (IBAction)actionLogout:(id)sender {
    [self jumpToLogin];
    
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
}

- (IBAction)actionResetPassword:(id)sender {
    [self performSegueWithIdentifier:kResetPasswordSegueIdentifier sender:nil];
    
    
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

- (void)showLockViewForTestingPasscode {
    [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:YES
                                                             withLogout:NO
                                                         andLogoutTitle:nil];
}

- (void)showLockViewForChangingPasscode {
    [[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController:self asModal:YES];
}

- (void)showLockViewForTurningPasscodeOff {
    [[LTHPasscodeViewController sharedUser] showForDisablingPasscodeInViewController:self
                                                                             asModal:NO];
}

# pragma mark - LTHPasscodeViewController Delegates -

- (void)passcodeViewControllerWillClose {
    NSLog(@"Passcode View Controller Will Be Closed");
    //[self _refreshUI];
}

- (void)maxNumberOfFailedAttemptsReached {
    [LTHPasscodeViewController deletePasscodeAndClose];
    NSLog(@"Max Number of Failed Attemps Reached");
    
    self.buttonChangeGesturePassword.enabled = NO;
}

- (void)passcodeWasEnteredSuccessfully {
    NSLog(@"Passcode Was Entered Successfully");
    
    self.buttonChangeGesturePassword.enabled = YES;
}

- (void)logoutButtonWasPressed {
    NSLog(@"Logout Button Was Pressed");
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
    @try {
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[@"action"] = @"设置锁屏";
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
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



@end
