//
//  NewSettingViewController.m
//  YH-IOS
//
//  Created by li hao on 16/8/30.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "SettingViewController.h"
#import "SwitchTableViewCell.h"
#import "Version.h"
#import "FileUtils.h"
#import "APIHelper.h"
#import "ViewUtils.h"
#import "PgyUpdateTableViewCell.h"
#import "ResetPasswordViewController.h"
#import "UserHeadView.h"
#import "UILabel+Badge.h"
#import "UIButton+Badge.h"
#import "GestureTableViewCell.h"
#import "OneButtonTableViewCell.h"
#import "SettingDefaultTableViewCell.h"
#import <PgyUpdate/PgyUpdateManager.h>
#import "AFNetworking.h"
#import "ThurSayViewController.h"
#import "ThurSayTableViewCell.h"
#import "NSString+MD5.h"

static NSString *const kResetPasswordSegueIdentifier = @"ResetPasswordSegueIdentifier";
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) UITableView *settingTableView;
@property (strong, nonatomic) NSArray *userInfoArray;
@property (strong, nonatomic) NSArray *appInfoArray;
@property (strong, nonatomic) UIButton *logoutBtn;
@property (strong, nonatomic) NSDictionary *MessageDict;
@property (strong, nonatomic) NSString *pgyLinkString;
@property (assign, nonatomic) BOOL isSuccess;
@property (assign, nonatomic) BOOL isChangeLochPassword;
@property (strong, nonatomic) NSArray *headInfoArray;
@property (strong, nonatomic) UIImage *userIconImage;
@property (strong, nonatomic) NSDictionary *settingDict;
@property (assign, nonatomic) BOOL isNeedChangepwd;
@property (assign, nonatomic) BOOL isNeedUpgrade;
@property (strong, nonatomic) Version *version;
@property (strong, nonatomic) NSMutableDictionary *noticeDict;
@property (strong, nonatomic) NSString *noticeFilePath;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.noticeFilePath = [FileUtils dirPath:CONFIG_DIRNAME FileName:LOCAL_NOTIFICATION_FILENAME];
    self.noticeDict = [FileUtils readConfigFile:self.noticeFilePath];
    
    [self loadUserGravatar];
    [self showNoticeRedIcon];
    
    self.version = [[Version alloc] init];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.view.backgroundColor = [UIColor clearColor];
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.settingTableView];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self initLabelInfoDict];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 70, 40)];
    UIImage *imageback = [UIImage imageNamed:@"Banner-Back"];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 15, 25)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 50, 25)];
    backLabel.text = @"返回";
    backLabel.textColor = [UIColor whiteColor];
    [backBtn addSubview:backLabel];
    [self.settingTableView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *userGavatarPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:GRAVATAR_CONFIG_FILENAME];
    NSMutableDictionary *userGravatar = [FileUtils readConfigFile:userGavatarPath];
    if (![userGravatar[@"upload_state"] boolValue] && userGravatar[@"name"] && userGravatar[@"local_name"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *urlPath = [NSString stringWithFormat:API_UPLOAD_GRAVATAR_PATH, self.user.deviceID, self.user.userID];
            [HttpUtils uploadImage:urlPath withImagePath:userGravatar[@"local_path"] withImageName:userGravatar[@"name"]];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutControllerSubViews:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)layoutControllerSubViews: (NSNotification *)notification {
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    
    self.settingTableView.frame = (statusBarRect.size.height == 40 ? CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) :CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ));
}

#pragma mark - init need-show message
- (void)initLabelInfoDict {
    self.appInfoArray = @[@"名称", @"版本号", @"设备型号", @"数据接口", @"应用标识", @"消息推送", @"校正", @"检测版本更新", @"小四说"];
    self.headInfoArray = @[@"应用信息", @"安全策略", @"配色主题"];

    NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:PUSH_CONFIG_FILENAME];
    NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
    self.settingDict = @{
        self.appInfoArray[0]: self.version.appName,
        self.appInfoArray[1]: [NSString stringWithFormat:@"%@(%@)", self.version.current, self.version.build],
        self.appInfoArray[2]: [[Version machineHuman] componentsSeparatedByString:@" ("][0],
        self.appInfoArray[3]: [kBaseUrl componentsSeparatedByString:@"://"][1],
        self.appInfoArray[4]: self.version.bundleID,
        self.appInfoArray[5]: pushDict[@"push_valid"] && [pushDict[@"push_valid"] boolValue] ? @"开启" : @"关闭"
    };
    [self initLabelMessageDict];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - init need-show message info
- (void)initLabelMessageDict {
    [self checkPgyerVersionLabel:self.version];
    self.isChangeLochPassword = NO;
}

- (void)showNoticeRedIcon {
    self.isNeedChangepwd = NO;
    self.isNeedUpgrade = NO;

    self.isNeedChangepwd = [self.noticeDict[kSettingPasswordLNName] isEqualToNumber:@(1)];
    self.isNeedUpgrade = [self.noticeDict[kSettingPgyerLNName] isEqualToNumber:@(1)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *numberOfRowsInSection = @[@1, @9, @2, @1, @1];
    return (section < numberOfRowsInSection.count ? [numberOfRowsInSection[section] integerValue] : 0);
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0 ? 0.001 : 30);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  用户信息
     */
    if (indexPath.section == 0) {
        UserHeadView *cell = [[UserHeadView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userId"];
        [cell.userIcon addTarget:self action:@selector(addUserIcon) forControlEvents:UIControlEventTouchUpInside];
        self.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        cell.userName.text = [NSString stringWithFormat:@"%@(%@)", self.user.userName, self.user.userID];;
        cell.userRole.text = [NSString stringWithFormat:@"%@ | %@", self.user.groupName, self.user.userName];
        UIImage *userHead = self.userIconImage ?: [UIImage imageNamed:@"AppIcon"];
        [cell.userIcon setBackgroundImage:userHead forState:UIControlStateNormal];

        return cell;
    }
    
    if (indexPath.section == 1) {
        SettingDefaultTableViewCell *cell = [[SettingDefaultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingId"];
        
        NSString *textTitle = self.appInfoArray[indexPath.row];
        cell.titleLabel.text = textTitle;
        cell.detailLabel.text = self.settingDict[textTitle];
        
        if (indexPath.row == 6) {
            cell.detailLabel.text = @"若发现界面显示异常，请校正";
            cell.titleLabel.textColor = [UIColor colorWithHexString:kThemeColor];
            return cell;
        }
        else if(indexPath.row == 7) {
            PgyUpdateTableViewCell *cell = [[PgyUpdateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingId"];
            [cell.messageButton setTitle:textTitle forState:UIControlStateNormal];
            [cell.messageButton addTarget:self action:@selector(actionCheckUpgrade) forControlEvents:UIControlEventTouchUpInside];
            [cell.openOutLink setTitle:self.pgyLinkString forState:UIControlStateNormal];
            [cell.openOutLink setTitleColor:[UIColor colorWithHexString:kThemeColor] forState:UIControlStateNormal];
            [cell.openOutLink addTarget:self action:@selector(actionOpenLink) forControlEvents:UIControlEventTouchUpInside];
            if ([self.noticeDict[kSettingPgyerLNName] isEqualToNumber:@(1)]) {
                [cell.messageButton showRedIcon];
            }
            else {
                [cell.messageButton hideRedIcon];
            }
            return cell;
        }
        else if (indexPath.row == 8) {
            ThurSayTableViewCell *cell = [[ThurSayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingId"];
            cell.titleLabel.text = self.appInfoArray[8];
            
            if ([self.noticeDict[kSettingThursdaySayLNName] integerValue] > 0) {
                [cell.titleLabel showRedIcon];
            }
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
            
            cell.changeGestureBtn.userInteractionEnabled = isUseGesturePassword;
            UIColor *btnColor = isUseGesturePassword ? [UIColor colorWithHexString:kThemeColor] : [UIColor lightGrayColor];
            [cell.changeGestureBtn setTitleColor:btnColor forState:UIControlStateNormal];
            
            [cell.changStatusBtn addTarget:self action:@selector(actionWehtherUseGesturePassword:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
        if (indexPath.row == 1) {
            SettingDefaultTableViewCell *cell = [[SettingDefaultTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingId"];
            cell.titleLabel.text = @"修改登录密码";
            cell.titleLabel.textColor = [UIColor colorWithHexString:kThemeColor];
             if (self.isNeedChangepwd) {
                [cell.titleLabel showRedIcon];
                 cell.detailLabel.text = @"请修改初始密码";
             }
             else {
                 [cell.titleLabel hideRedIcon];
             }
            return cell;
        }
    }
    if (indexPath.section == 3) {
        SwitchTableViewCell *cell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingId"];
        cell.messageLabel.text = @"旧版UI";
        cell.changStatusBtn.on = [[FileUtils currentUIVersion] isEqualToString:@"v1"];
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
    }
    if ((indexPath.section == 1) && (indexPath.row == 8)) {
        ThurSayViewController *thurSay = [[ThurSayViewController alloc] init];
        [self presentViewController:thurSay animated:YES completion:^{
            self.noticeDict[kSettingThursdaySayLNName] = @(0);
            [FileUtils writeJSON:self.noticeDict Into:self.noticeFilePath];
            [self.settingTableView reloadData];
        }];
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

#pragma mark - upload user gravatar
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    self.userIconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(self.userIconImage, 1.0);
    
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSString *gravatarName = [NSString stringWithFormat:@"%@-%@-%@.jpg", kAppCode, self.user.userNum, timestamp];
    NSString *gravatarPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:gravatarName];
    [imageData writeToFile:gravatarPath atomically:YES];
    
    [self.settingTableView reloadData];
    NSString *urlPath = [NSString stringWithFormat:API_UPLOAD_GRAVATAR_PATH, self.user.deviceID, self.user.userID];
    [HttpUtils uploadImage:urlPath withImagePath:gravatarPath withImageName:gravatarName];
}

#pragma mark - load user gravatar
- (void)loadUserGravatar {
    
    // default gravatar
    self.userIconImage = [UIImage imageNamed:@"AppIcon"];
    NSString *gravatarUrl = self.user.gravatar;
    if(!gravatarUrl || (![gravatarUrl hasPrefix:@"http://"] && ![gravatarUrl hasPrefix:@"https://"])) {
        return;
    }
    
    NSString *gravatarName = [[gravatarUrl componentsSeparatedByString:@"/"] lastObject];
    NSString *gravatarPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:gravatarName];
    
    if([FileUtils checkFileExist:gravatarPath isDir:NO]) {
        self.userIconImage = [UIImage imageWithContentsOfFile:gravatarPath];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *gravatarName = [[self.user.gravatar componentsSeparatedByString:@"/"] lastObject];
            NSString *gravatarPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:gravatarName];
            
            [HttpUtils downLoadFile:self.user.gravatar withSavePath:gravatarPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([FileUtils checkFileExist:gravatarPath isDir:NO]) {
                    self.userIconImage = [UIImage imageWithContentsOfFile:gravatarPath];
                    [self.settingTableView reloadData];
                    
                    NSString *gravatarConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:GRAVATAR_CONFIG_FILENAME];
                    BOOL uploadState = [FileUtils checkFileExist:gravatarConfigPath isDir:YES];
                    NSMutableDictionary *gravatarDict = [FileUtils readConfigFile:gravatarConfigPath];
                    gravatarDict[@"name"] = gravatarName;
                    gravatarDict[@"upload_state"] = @(uploadState);
                    [FileUtils writeJSON:gravatarDict Into:gravatarConfigPath];
                }
            });
            
        });
        
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
    if(!response || !response[kDownloadURLCPCName] || !response[kVersionCodeCPCName] || !response[kVersionNameCPCName]) {
        [ViewUtils showPopupView:self.view Info:kNoUpgradeWarnText];
        return;
    }
    
    NSString *pgyerVersionPath = [[FileUtils basePath] stringByAppendingPathComponent:PGYER_VERSION_FILENAME];
    
    NSInteger currentVersionCode = 0;
    if([FileUtils checkFileExist:pgyerVersionPath isDir:NO]) {
        NSDictionary *currentResponse = [FileUtils readConfigFile:pgyerVersionPath];
        if(currentResponse[kVersionCodeCPCName]) {
            currentVersionCode = [currentResponse[kVersionCodeCPCName] integerValue];
        }
    }
    
    [FileUtils writeJSON:[NSMutableDictionary dictionaryWithDictionary:response] Into:pgyerVersionPath];
    
    // 对比 build 值，只准正向安装提示
    if([response[kVersionCodeCPCName] integerValue] <= currentVersionCode) {
        [ViewUtils showPopupView:self.view Info:kNoUpgradeWarnText];
        return;
    }
    
    /**
     * 更新按钮右侧提示文字
     */
    Version *version = [[Version alloc] init];
    [self checkPgyerVersionLabel:version];
    
    BOOL isPgyerLatest = [version.current isEqualToString:response[kVersionNameCPCName]] && [version.build isEqualToString:response[kVersionCodeCPCName]];
    if(!isPgyerLatest && [response[kVersionCodeCPCName] integerValue] % 2 == 0) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert addButton:kUpgradeBtnText actionBlock:^(void) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[kDownloadURLCPCName]]];
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
        }];
        
        NSString *subTitle = [NSString stringWithFormat:kUpgradeWarnText, response[kVersionNameCPCName], response[kVersionCodeCPCName]];
        [alert showSuccess:self title:kUpgradeTitleText subTitle:subTitle closeButtonTitle:kCancelBtnText duration:0.0f];
    }
    else {
        [ViewUtils showPopupView:self.view Info:kUpgradeWarnTestText];
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
    self.isSuccess = [APIHelper pushDeviceToken:userDict[kDeviceUUIDCUName]];
    
    [ViewUtils showPopupView:self.view Info:@"校正完成"];
}

- (void)ResetPassword {
    [self performSegueWithIdentifier:kResetPasswordSegueIdentifier sender:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"点击/设置页面/修改密码";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}

- (void)actionWehtherUseGesturePassword:(UISwitch *)sender {
    if([sender isOn]) {
        self.isChangeLochPassword = YES;
        [self showLockViewForEnablingPasscode];
    }
    else {
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
        userDict[kIsUseGesturePasswordCUName] = @(NO);
        [userDict writeToFile:userConfigPath atomically:YES];
        
        NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
        [userDict writeToFile:settingsConfigPath atomically:YES];
        
        //self.buttonChangeGesturePassword.enabled = NO;
        
        [ViewUtils showPopupView:self.view Info:@"禁用手势锁设置成功"];
        self.isChangeLochPassword = NO;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [APIHelper screenLock:userDict[kUserDeviceIDCUName] passcode:userDict[kGesturePasswordCUName] state:NO];
            
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName] = [NSString stringWithFormat:@"点击/设置页面/%@锁屏", sender.isOn ? @"开启" : @"禁用"];
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
    [self jumpToLogin];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"退出登录";
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
