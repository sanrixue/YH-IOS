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
    self.labelAppName.text = version.appName;
    self.labelAppVersion.text = version.current;
    self.labelDeviceMode.text = [[Version machineHuman] componentsSeparatedByString:@" ("][0];
    
    self.labelAPIDomain.text = [BASE_URL componentsSeparatedByString:@"://"][1];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
    }
}

- (IBAction)actionLogout:(id)sender {
    [self jumpToLogin];
}

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
    return @"";}
@end
