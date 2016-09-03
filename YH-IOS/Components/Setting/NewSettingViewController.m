//
//  NewSettingViewController.m
//  YH-IOS
//
//  Created by li hao on 16/8/30.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "NewSettingViewController.h"
#import "SwitchTableViewCell.h"
#import "Version.h"
#import "FileUtils.h"
#import "APIHelper.h"
#import "ViewUtils.h"
#import "PgyUpdateTableViewCell.h"
#import "ResetPasswordViewController.h"
#import "UserHeadView.h"
#import "UILabel+Badge.h"
#import "GestureTableViewCell.h"
#import "OneButtonTableViewCell.h"
#import <PgyUpdate/PgyUpdateManager.h>

static NSString *const kResetPasswordSegueIdentifier = @"ResetPasswordSegueIdentifier";
@interface NewSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) UITableView *settingTableView;
@property (strong, nonatomic) NSArray *userInfoArray;
@property (strong, nonatomic) NSArray *appInfoArray;
@property (strong, nonatomic) UIButton *logoutBtn;
@property (strong, nonatomic) NSDictionary *MessageDict;
@property (strong, nonatomic) NSString *pgyLinkString;
@property (assign, nonatomic) BOOL isSuccess;
@property (assign, nonatomic) BOOL isChangeLochPassword;
@property (strong, nonatomic) NSArray *headInfoArray;
@property (strong,nonatomic) UIImage *userIconImage;
@property (strong, nonatomic)NSDictionary *settingDict;

@end

@implementation NewSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserIcon];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.view.backgroundColor = [UIColor clearColor];
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStyleGrouped];
    [self.view addSubview:self.settingTableView];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self initLabelInfoDict];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 70, 40)];
    UIImage *imageback = [UIImage imageNamed:@"Banner-Back"];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 15, 25)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 50, 25)];
    backLabel.text = @"返回";
    backLabel.textColor = [UIColor whiteColor];
    [backBtn addSubview:backLabel];
    [self.settingTableView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - init need-show message
- (void)initLabelInfoDict {
    self.appInfoArray = @[@"名称",@"版本号",@"设备型号",@"数据接口",@"应用标识",@"消息推送",@"校正",@"检测版本更新"];
    self.headInfoArray = @[@"应用信息",@"安全策略",@"配色主题"];
    [self initLabelMessageDict];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - init need-show message info
-(void)initLabelMessageDict {
    Version *version = [[Version alloc] init];
    [self checkPgyerVersionLabel:version];
    self.isChangeLochPassword = NO;
    NSString *userName = [NSString stringWithFormat:@"%@(%@)", self.user.userName, self.user.userID];
    NSString *userRole = [NSString stringWithFormat:@"%@(%@)", self.user.roleName, self.user.roleID];
    NSString *userGroup = [NSString stringWithFormat:@"%@(%@)", self.user.groupName, self.user.groupID];
    NSString *appName   = version.appName;
    NSString *appVersion = [NSString stringWithFormat:@"%@(%@)", version.current, version.build];
    NSString *deviceMode = [[Version machineHuman] componentsSeparatedByString:@" ("][0];
    NSString *bundleID = version.bundleID;
    NSString *apiDomain  = [kBaseUrl componentsSeparatedByString:@"://"][1];
    NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:PUSH_CONFIG_FILENAME];
    NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
    NSString *pushState = pushDict[@"push_valid"] && [pushDict[@"push_valid"] boolValue] ? @"开启" : @"关闭";
    self.MessageDict = @{@"userName":userName,@"userRole":userRole,@"userGroup":userGroup};
    self.settingDict = @{self.appInfoArray[0]:appName,self.appInfoArray[1]:appVersion,self.appInfoArray[2]:deviceMode,self.appInfoArray[3]:apiDomain,self.appInfoArray[4]:bundleID,self.appInfoArray[5]:pushState};
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 8;
    }
    if (section == 2) {
        return 2;
    }
    if (section == 3) {
        return 1;
    }
    if (section == 4) {
        return 1;
    }
    else {
        return 0;
    }

}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    }
    else {
        return 30;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserHeadView *cell = [[UserHeadView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userId"];
        [cell.userIcon addTarget:self action:@selector(addUserIcon) forControlEvents:UIControlEventTouchUpInside];
        self.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.userName.text = self.MessageDict[@"userName"];
        cell.userRole.text = [NSString stringWithFormat:@"%@ | %@",self.MessageDict[@"userRole"],self.MessageDict[@"userGroup"]];
        if (self.userIconImage) {
            [cell.userIcon setBackgroundImage:self.userIconImage forState:UIControlStateNormal];
        }
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingId"];
        cell.textLabel.text = self.appInfoArray[indexPath.row];
        cell.detailTextLabel.text = self.settingDict[self.appInfoArray[indexPath.row ]];
        if (indexPath.row == 6) {
            cell.detailTextLabel.text = @"若发现界面显示异常，请校正";
            cell.textLabel.textColor = [UIColor blueColor];
        }
        else if(indexPath.row == 7) {
            PgyUpdateTableViewCell *cell = [[PgyUpdateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingId"];
            [cell.messageButton setTitle:self.appInfoArray[7] forState:UIControlStateNormal];
            [cell.messageButton addTarget:self action:@selector(actionCheckUpgrade) forControlEvents:UIControlEventTouchUpInside];
            [cell.openOutLink setTitle:self.pgyLinkString forState:UIControlStateNormal];
            [cell.openOutLink addTarget:self action:@selector(actionOpenLink) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        return cell;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            BOOL isUseGesturePassword = [LTHPasscodeViewController doesPasscodeExist] && [LTHPasscodeViewController didPasscodeTimerEnd];
            GestureTableViewCell *cell = [[GestureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingId"];
            cell.messageLabel.text = @"启用锁屏";
            cell.changStatusBtn.on = isUseGesturePassword;
            [cell.changeGestureBtn setTitle:@"修改锁屏密码" forState:UIControlStateNormal];
            [cell.changeGestureBtn addTarget:self action:@selector(actionChangeGesturePassword) forControlEvents:UIControlEventTouchUpInside];
            if (isUseGesturePassword) {
                [cell.changeGestureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                cell.changeGestureBtn.userInteractionEnabled = YES;
            }
            else {
                [cell.changeGestureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                cell.changeGestureBtn.userInteractionEnabled = NO;
            }
            [cell.changStatusBtn addTarget:self action:@selector(actionWehtherUseGesturePassword:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingId"];
            cell.textLabel.text = @"修改登录密码";
            cell.textLabel.textColor = [UIColor blueColor];
            return cell;
        }
        else {
            return nil;
        }
    }
    if (indexPath.section == 3) {
        SwitchTableViewCell *cell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingId"];
        cell.messageLabel.text = @"旧版UI";
        cell.changStatusBtn.on = [[self currentUIVersion] isEqualToString:@"v1"];
        [cell.changStatusBtn addTarget:self action:@selector(actionSwitchToNewUI:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    if (indexPath.section == 4) {
        OneButtonTableViewCell *cell = [[OneButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"threesection"];
        [cell.actionBtn addTarget:self action:@selector(actionLogout) forControlEvents:UIControlEventTouchUpInside];
        [cell.actionBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [cell.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        return cell;
    }
    else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headString;
    switch (section) {
        case 0:
            break;
        case 1:
            headString = self.headInfoArray[section -1];
            break;
        case 2:
            headString = self.headInfoArray[section - 1];
            break;
        case 3:
            headString = self.headInfoArray[section - 1];
            break;
        default:
            break;
    }
    return headString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 70;
        }
        else {
            return 44;
        }
    }
    else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 2)&&(indexPath.row == 1)) {
        [self ResetPassword];
    }
    if ((indexPath.section == 1) && (indexPath.row == 6)) {
        [self actionCheckAssets];
        UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = self.isSuccess ? @"开启":@"关闭";
    }
}

#pragma mark - click userIcon to get a new image
- (void)addUserIcon {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"从相册选取" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action){}];
    [self presentViewController:alertController animated:YES completion:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [alertController addAction:photoAction];
}

#pragma mark - after get the picture which you want,the things you will do
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    self.userIconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *userPath = [FileUtils userspace];
    NSString *userIconPath = [userPath stringByAppendingPathComponent:@"userIcon"];
    NSData *imageData = UIImageJPEGRepresentation(self.userIconImage, 0.5);
    [imageData writeToFile:userIconPath atomically:YES];
    [self.settingTableView reloadData];
}

#pragma mark - get user Icon
- (void)getUserIcon {
    NSString *userIconString = [[FileUtils userspace] stringByAppendingPathComponent:@"userIcon"];
    if (userIconString) {
        self.userIconImage = [UIImage imageWithContentsOfFile:userIconString];
    }
    else {
        self.userIconImage = [UIImage imageNamed:@"xiaojv.jpg"];
    }
}

#pragma mark - action methods
- (void)actionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)actionSwitchToNewUI:(UISwitch *)sender {
    NSLog(@"更改ui");
    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:BETA_CONFIG_FILENAME];
    NSMutableDictionary *betaDict = [FileUtils readConfigFile:settingsConfigPath];
    betaDict[@"new_ui"] = @(sender.isOn);
    [betaDict writeToFile:settingsConfigPath atomically:YES];
}

- (void)checkPgyerVersionLabel:(Version *)version {
    NSString *pgyerVersionPath = [[FileUtils basePath] stringByAppendingPathComponent:PGYER_VERSION_FILENAME];
    if(![FileUtils checkFileExist:pgyerVersionPath isDir:NO]) {
        return;
    }
    NSMutableDictionary *pgyerVersionDict = [FileUtils readConfigFile:pgyerVersionPath];
    BOOL isPgyerLatest = [version.current isEqualToString:pgyerVersionDict[@"versionName"]] && [version.build isEqualToString:pgyerVersionDict[@"versionCode"]];
    self.pgyLinkString = @"已是最新版本";
    
    if(isNULL(pgyerVersionDict[@"versionCode"])) {
        self.pgyLinkString = @"蒲公英链接";
    }
    else if(!isPgyerLatest) {
        NSString *betaName = (pgyerVersionDict[@"versionCode"] && [pgyerVersionDict[@"versionCode"] integerValue] % 2 == 0) ? @"" : @"测试";
        self.pgyLinkString= [NSString stringWithFormat:@"%@版本:%@(%@)", betaName, pgyerVersionDict[@"versionName"], pgyerVersionDict[@"versionCode"]];
    }
}

/**
 *  检测版本升级，判断版本号是否为偶数。以便内测
 response = @{
 @"appUrl": @"http://www.pgyer.com/yh-i",
 @"build": @118,
 @"downloadURL": @"itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/93bb21bdb7f10bdf0a84ad51045bd70e",
 @"lastBuild": @118,
 @"releaseNote": @"asdfasdfc: 1.3.87(build118)",
 @"versionCode": @188,
 @"versionName ": @"1.4.0"
 };
 *
 *  @param response <#response description#>
 */
- (void)appUpgradeMethod:(NSDictionary *)response {
    if(!response || !response[@"downloadURL"] || !response[@"versionCode"] || !response[@"versionName"]) {
        [ViewUtils showPopupView:self.view Info:@"未检测到更新"];
        return;
    }
    
    NSString *pgyerVersionPath = [[FileUtils basePath] stringByAppendingPathComponent:PGYER_VERSION_FILENAME];
    
    NSInteger currentVersionCode = 0;
    if([FileUtils checkFileExist:pgyerVersionPath isDir:NO]) {
        NSDictionary *currentResponse = [FileUtils readConfigFile:pgyerVersionPath];
        if(currentResponse[@"versionCode"]) {
            currentVersionCode = [currentResponse[@"versionCode"] integerValue];
        }
    }
    
    [FileUtils writeJSON:[NSMutableDictionary dictionaryWithDictionary:response] Into:pgyerVersionPath];
    
    // 对比 build 值，只准正向安装提示
    if([response[@"versionCode"] integerValue] <= currentVersionCode) {
        [ViewUtils showPopupView:self.view Info:@"未检测到更新"];
        return;
    }
    
    /**
     * 更新按钮右侧提示文字
     */
    Version *version = [[Version alloc] init];
    [self checkPgyerVersionLabel:version];
    
    BOOL isPgyerLatest = [version.current isEqualToString:response[@"versionName"]] && [version.build isEqualToString:response[@"versionCode"]];
    if(!isPgyerLatest && [response[@"versionCode"] integerValue] % 2 == 0) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert addButton:@"升级" actionBlock:^(void) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
        }];
        
        NSString *subTitle = [NSString stringWithFormat:@"更新到版本: %@(%@)", response[@"versionName"], response[@"versionCode"]];
        [alert showSuccess:self title:@"版本更新" subTitle:subTitle closeButtonTitle:@"放弃" duration:0.0f];
    }
    else {
        [ViewUtils showPopupView:self.view Info:@"有测试版本发布，请手工安装。"];
    }
    
    [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
}

- (void)actionOpenLink{
    NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)actionChangeGesturePassword {
    [self showLockViewForChangingPasscode];
}

- (void)actionCheckUpgrade {
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appUpgradeMethod:)];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kResetPasswordSegueIdentifier]) {
        ResetPasswordViewController *resetPasswordViewController = (ResetPasswordViewController *)segue.destinationViewController;
        resetPasswordViewController.bannerName = @"重置密码";
        resetPasswordViewController.link       = RESET_PASSWORD_PATH;
    }
}

- (void)actionCheckAssets {
    NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", self.sharedPath, CACHED_HEADER_FILENAME];
    [FileUtils removeFile:cachedHeaderPath];
    cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", [FileUtils dirPath:HTML_DIRNAME], CACHED_HEADER_FILENAME];
    [FileUtils removeFile:cachedHeaderPath];
    
    [APIHelper userAuthentication:self.user.userNum password:self.user.password];
    
    [self checkAssetsUpdate];
    
    // 第三方消息推送，设备标识
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    self.isSuccess = [APIHelper pushDeviceToken:userDict[@"device_uuid"]];
    
    [ViewUtils showPopupView:self.view Info:@"校正完成"];
}

- (void)ResetPassword {
    NSLog(@"修改密码");
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

- (void)actionWehtherUseGesturePassword:(UISwitch *)sender {
    if([sender isOn]) {
        NSLog(@"启动锁屏");
        self.isChangeLochPassword = YES;
        [self showLockViewForEnablingPasscode];
    }
    else {
        NSLog(@"开始设置");
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
        userDict[@"use_gesture_password"] = @(NO);
        [userDict writeToFile:userConfigPath atomically:YES];
        
        NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
        [userDict writeToFile:settingsConfigPath atomically:YES];
        
        //self.buttonChangeGesturePassword.enabled = NO;
        
        [ViewUtils showPopupView:self.view Info:@"禁用手势锁设置成功"];
        self.isChangeLochPassword = NO;
        
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
    [self.settingTableView reloadData];
}

- (void)actionLogout{
    [self clearBrowserCache];
    NSLog(@"退出登录");
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

#pragma mark - LTHPasscode delegate methods
- (void)showLockViewForEnablingPasscode {
    [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self
                                                                            asModal:YES];
}

- (void)showLockViewForChangingPasscode {
    [[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController:self asModal:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end