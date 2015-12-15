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

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchGesturePassword;
@property (strong, nonatomic) GesturePasswordController *gesturePasswordController;

@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelUserRole;
@property (weak, nonatomic) IBOutlet UILabel *labelUserGroup;
@property (weak, nonatomic) IBOutlet UILabel *labelAppName;
@property (weak, nonatomic) IBOutlet UILabel *labelAppVersion;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceMode;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bannerView.backgroundColor = [UIColor colorWithHexString:YH_COLOR];
    
    [self.btnLogout.layer setCornerRadius:10.0];

    self.labelUserName.text = [NSString stringWithFormat:@"%@(%@)", self.user.userName, self.user.userID];
    self.labelUserRole.text = [NSString stringWithFormat:@"%@(%@)", self.user.roleName, self.user.roleID];
    self.labelUserGroup.text = [NSString stringWithFormat:@"%@(%@)", self.user.groupName, self.user.groupID];
    
    Version *version = [[Version alloc] init];
    self.labelAppName.text = version.appName;
    self.labelAppVersion.text = version.current;
    self.labelDeviceMode.text = [[Version machineHuman] componentsSeparatedByString:@" ("][0];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
    NSDictionary *settingsInfo = [FileUtils readConfigFile:settingsConfigPath];
    self.switchGesturePassword.on = (settingsInfo && [settingsInfo[@"use_gesture_password"] isEqualToNumber:@1]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action methods
- (IBAction)actionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionWehtherUseGesturePassword:(UISwitch *)sender {
    if([sender isOn]) {
        _gesturePasswordController = [[GesturePasswordController alloc] init];
        _gesturePasswordController.delegate = self;
        [self presentViewController:_gesturePasswordController animated:YES completion:nil];
    }
    else {
        NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
        NSMutableDictionary *settingsInfo = [FileUtils readConfigFile:settingsConfigPath];
        settingsInfo[@"use_gesture_password"] = @(0);
        [settingsInfo writeToFile:settingsConfigPath atomically:YES];
        
        [ViewUtils showPopupView:self.view Info:@"禁用手势锁设置成功"];
    }
}

- (IBAction)actionLogout:(id)sender {
    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
    NSMutableDictionary *settingsDict = [FileUtils readConfigFile:settingsConfigPath];
    settingsDict[@"is_login"] = @(0);
    [settingsDict writeToFile:settingsConfigPath atomically:YES];
    
    
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[@"is_login"] = @(0);
    [userDict writeToFile:userConfigPath atomically:YES];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.view.window.rootViewController = loginViewController;
}

#pragma mark - GesturePasswordControllerDelegate
- (void)verifySucess {
    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
    NSMutableDictionary *settingsInfo = [FileUtils readConfigFile:settingsConfigPath];
    if(![settingsInfo[@"use_gesture_password"] isEqualToNumber:@1]) {
        settingsInfo[@"use_gesture_password"] = @1;
        [settingsInfo writeToFile:settingsConfigPath atomically:YES];
    }
    
    [_gesturePasswordController dismissViewControllerAnimated:YES completion:nil];
    _gesturePasswordController.delegate = nil;
    _gesturePasswordController = nil;
}


@end
