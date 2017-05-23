//
//  OptionConfigViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "OptionConfigViewController.h"
#import "SwitchTableViewCell.h"
#import "SettingNormalViewController.h"
#import "FileUtils.h"
#import "ViewUtils.h"
#import "APIHelper.h"
#import "LTHPasscodeViewController.h"
#import <AFNetworking.h>
#import "FileUtils+Assets.h"

@interface OptionConfigViewController ()<UITableViewDelegate,UITableViewDataSource,SwitchTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (assign, nonatomic) BOOL isChangeLochPassword;
@property (strong, nonatomic) NSString *settingsConfigPath;
@property (strong, nonatomic) NSString *sharedPath;
@property (assign, nonatomic) BOOL isSuccess;

@end

@implementation OptionConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kBetaConfigFileName];
    // Do any additional setup after loading the view.
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewWillAppear:(BOOL)animated {
    if ([self.title isEqualToString:@"选项配置"]) {
        NSDictionary *infodict = @{@"锁屏设置": @{@"启用锁屏":@YES,@"修改锁屏密码":@{}}, @"微信分享长图":@"", @"报表操作":@"", @"清理缓存":@{@"手工清理":@"",@"校正":@""}};
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
        BOOL isUseGesturePassword = [userDict[kIsUseGesturePasswordCUName] boolValue];
        if (!isUseGesturePassword) {
            infodict = @{@"锁屏设置": @{@"启用锁屏":@NO}, @"分享微信长图":@"", @"报表操作":@"", @"清理缓存":@{@"手工清理":@"",@"校正":@""} };
        }
        self.arraydict = infodict;
        [self.tableView reloadData];
    }
    [self.navigationController setNavigationBarHidden:false];
}

-(void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arraydict allKeys].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_arraydict allValues][indexPath.row] isKindOfClass:[NSDictionary class]]) {
        NSString * resuIndetifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuIndetifier];
        cell.textLabel.text = [_arraydict allKeys][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else {
      //  NSString * resuIndetifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        SwitchTableViewCell*  cell = [[SwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.messageLabel.text = [_arraydict allKeys][indexPath.row];
        cell.delegate = self;
        cell.cellId  = indexPath.row;
        if ([[_arraydict allKeys][indexPath.row] isEqualToString:@"分享微信长图"]) {
            NSMutableDictionary* betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
            cell.changStatusBtn.on = (betaDict[@"image_within_screen"] && [betaDict[@"image_within_screen"] boolValue]);
        }
        else if ([[_arraydict allKeys][indexPath.row] isEqualToString:@"报表操作"]) {
            NSMutableDictionary* betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
            cell.changStatusBtn.on = (betaDict[@"allow_brower_copy"] && [betaDict[@"allow_brower_copy"] boolValue]);
        }
        else if ([[_arraydict allKeys][indexPath.row] isEqualToString:@"启用锁屏"]) {
            cell.changStatusBtn.on =[[_arraydict allValues][indexPath.row] boolValue];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_arraydict allKeys][indexPath.row] isEqualToString:@"锁屏设置"]) {
            NSDictionary *infoArray = [_arraydict allValues][indexPath.row];
            OptionConfigViewController *settingNormalView = [[OptionConfigViewController alloc]init];
            settingNormalView.arraydict = infoArray;
            settingNormalView.title = @"锁屏设置";
            [self.navigationController pushViewController:settingNormalView animated:YES];
        }
    else if ([[_arraydict allKeys][indexPath.row] isEqualToString:@"修改锁屏密码"]){
        [self actionChangeGesturePassword];
        _arraydict =   @{@"启用锁屏":@YES,@"修改锁屏密码":@{}};
        [self.tableView reloadData];
    }
    
    else if ([[_arraydict allKeys][indexPath.row] isEqualToString:@"清理缓存"]){
        SettingNormalViewController *settingNormalCtrl = [[SettingNormalViewController alloc]init];
        settingNormalCtrl.infodict = [_arraydict allValues][indexPath.row];
        settingNormalCtrl.title = @"清理缓存";
        [self.navigationController pushViewController:settingNormalCtrl animated:YES];
    }
}

- (void)actionChangeGesturePassword {
    [self showLockViewForChangingPasscode];
}

- (void)SwitchTableViewCellButtonClick:(UISwitch *)button with:(NSInteger)cellId {
    if ([[_arraydict allKeys][cellId] isEqualToString:@"启用锁屏"]) {
        [self actionWehtherUseGesturePassword:button];
    }
    else if ([[_arraydict allKeys][cellId] isEqualToString:@"微信分享长图"]){
        [self actionSwitchToNewUI:button];
    }
    
    else if ([[_arraydict allKeys][cellId] isEqualToString:@"报表操作"]){
        [self actionSwitchToReportDeal:button];
    }
}

- (void)actionSwitchToReportDeal:(UISwitch *)sender {
    NSMutableDictionary* betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
    betaDict[@"allow_brower_copy"] = @(sender.isOn);
    [betaDict writeToFile:self.settingsConfigPath atomically:YES];
}

//清理缓存

- (void)actionCheckAssets {
    User* user = [[User alloc] init];
    self.sharedPath = [FileUtils sharedPath];
    NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", self.sharedPath, kCachedHeaderConfigFileName];
    [FileUtils removeFile:cachedHeaderPath];
    cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", [FileUtils dirPath:kHTMLDirName], kCachedHeaderConfigFileName];
    [FileUtils removeFile:cachedHeaderPath];
    
    [APIHelper userAuthentication:user.userNum password:user.password];
    
    [self checkAssetsUpdate];
    
    // 第三方消息推送，设备标识
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    self.isSuccess = [APIHelper pushDeviceToken:userDict[kDeviceUUIDCUName]];
    
    
    [ViewUtils showPopupView:self.view Info:@"清理完成"];
}

/**
 *  检测服务器端静态文件是否更新
 */
- (void)checkAssetsUpdate {
    // 初始化队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    AFHTTPRequestOperation *op;
    op = [self checkAssetUpdate:kLoadingAssetsName info:kLoadingPopupText isInAssets: NO];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kFontsAssetsName info:kFontsPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kImagesAssetsName info:kImagesPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kStylesheetsAssetsName info:kStylesheetsPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kJavascriptsAssetsName info:kJavascriptsPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kBarCodeScanAssetsName info:kBarCodeScanPopupText isInAssets: NO];
    if(op) { [queue addOperation:op]; }
    // op = [self checkAssetUpdate:kAdvertisementAssetsName info:kAdvertisementPopupText isInAssets: NO];
    // if(op) { [queue addOperation:op]; }
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
    __block NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    __block NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(!isShouldUpdateAssets && ![userDict[assetKey] isEqualToString:userDict[localAssetKey]]) {
        isShouldUpdateAssets = YES;
        NSLog(@"%@ - local: %@, server: %@", assetName, userDict[localAssetKey], userDict[assetKey]);
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kDownloadAssetsAPIPath, kBaseUrl, assetName]];
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


// 分享长图
- (void)actionSwitchToNewUI:(UISwitch *)sender {
    NSMutableDictionary* betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
    if (!betaDict[@"image_within_screen"]) {
        betaDict[@"image_within_screen"] = @(1);
        [betaDict writeToFile:self.settingsConfigPath atomically:YES];
    }
    betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
    betaDict[@"image_within_screen"] = @(sender.isOn);
    [betaDict writeToFile:self.settingsConfigPath atomically:YES];
}


- (void)actionWehtherUseGesturePassword:(UISwitch *)sender {
    if([sender isOn]) {
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
        userDict[kIsUseGesturePasswordCUName] = @(YES);
        [userDict writeToFile:userConfigPath atomically:YES];
        [userDict writeToFile:self.settingsConfigPath atomically:YES];
        self.isChangeLochPassword = YES;
        [self showLockViewForEnablingPasscode];
        _arraydict =  @{@"启用锁屏":@1,@"修改锁屏密码":@{}};
        [self.tableView reloadData];
    }
    else {
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
        userDict[kIsUseGesturePasswordCUName] = @(NO);
        [userDict writeToFile:userConfigPath atomically:YES];
        [userDict writeToFile:self.settingsConfigPath atomically:YES];
        
        //self.buttonChangeGesturePassword.enabled = NO;
        
        [ViewUtils showPopupView:self.view Info:@"禁用手势锁设置成功"];
        self.isChangeLochPassword = NO;
        
        _arraydict =  @{@"启用锁屏":@NO,@"修改锁屏密码":@{}};
        [self.tableView reloadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
