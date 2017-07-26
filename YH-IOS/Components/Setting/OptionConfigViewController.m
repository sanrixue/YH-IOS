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
#import <CoreLocation/CoreLocation.h>

@interface OptionConfigViewController ()<UITableViewDelegate,UITableViewDataSource,SwitchTableViewCellDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (assign, nonatomic) BOOL isChangeLochPassword;
@property (strong, nonatomic) NSString *settingsConfigPath;
@property (strong, nonatomic) NSString *sharedPath;
@property (assign, nonatomic) BOOL isSuccess;
@property (strong, nonatomic) NSMutableDictionary *userdict;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) NSString *userLongitude;
@property(nonatomic, strong) NSString *userlatitude;

@end

@implementation OptionConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    [self.navigationController.navigationBar setHidden:NO];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.tabBarController.tabBar setHidden:YES];
    [self setupUI];
     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
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
        NSDictionary *infodict = @{@"锁屏设置": @(YES), @"微信分享长图":@"", @"报表操作":@"", @"清理缓存":@{@"手工清理":@"",@"校正":@""}};
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
        _userdict = [FileUtils readConfigFile:userConfigPath];
        BOOL isUseGesturePassword = [_userdict[kIsUseGesturePasswordCUName] boolValue];
        if (!isUseGesturePassword) {
            infodict = @{@"锁屏设置": @(NO), @"微信分享长图":@"", @"报表操作":@"", @"清理缓存":@{@"手工清理":@"",@"校正":@""} };
        }
        self.arraydict = infodict;
        [self.tableView reloadData];
    }
   /* [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"Banner-Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
    self.navigationController.navigationBar.translucent = NO;*/
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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


    return _titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* key = _titleArray[indexPath.row];
    if ([_arraydict[key] isKindOfClass:[NSDictionary class]]) {
        NSString * resuIndetifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuIndetifier];
//        cell.textLabel.text = key;
        UILabel *cacheLabel=[[UILabel alloc] init];
        [cell addSubview:cacheLabel];
        cacheLabel.textColor=[UIColor colorWithHexString:@"#666666"];
        cacheLabel.font=[UIFont systemFontOfSize:15];
        cacheLabel.text = key;
        [cacheLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.contentView.mas_top).offset(17);
            make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
        }];
        
        
        UIImageView *cellImage=[[UIImageView alloc] init];
        
        [cell.contentView addSubview:cellImage];
        
        [cellImage setImage:[UIImage imageNamed:@"btn_more"]];
        
        [cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            //            make.top.mas_equalTo(cell.contentView.mas_top).offset(17);
            make.right.mas_equalTo(cell.contentView.mas_right).offset(-20);
        }];
        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
         [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
    return cell;
    }
    else {
      //  NSString * resuIndetifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        SwitchTableViewCell*  cell = [[SwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.messageLabel.text = key;
        cell.delegate = self;
        cell.cellId  = indexPath.row;
        if ([key  isEqualToString:@"微信分享长图"]) {
            NSMutableDictionary* betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
            cell.changStatusBtn.on = (betaDict[@"image_within_screen"] && [betaDict[@"image_within_screen"] boolValue]);
        }
        else if ([key isEqualToString:@"报表操作"]) {
            NSMutableDictionary* betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
            cell.changStatusBtn.on = (betaDict[@"allow_brower_copy"] && [betaDict[@"allow_brower_copy"] boolValue]);
        }
        else if ([key  isEqualToString:@"锁屏设置"]) {
            NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
             _userdict = [FileUtils readConfigFile:userConfigPath];
            cell.changStatusBtn.on = [ _userdict[kIsUseGesturePasswordCUName] boolValue];
        }
     
         [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
        return cell;
    }
}

// 获取经纬度

-(void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    // 获取当前所在的城市名
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    self.userlatitude = [NSString stringWithFormat:@"%.6f",oldCoordinate.latitude];
    self.userLongitude = [NSString stringWithFormat:@"%.6f", oldCoordinate.longitude];
    
    
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* key = _titleArray[indexPath.row];
    if ([key isEqualToString:@"锁屏设置"]) {
           /* NSDictionary *infoArray = [_arraydict allValues][indexPath.row];
            OptionConfigViewController *settingNormalView = [[OptionConfigViewController alloc]init];
            settingNormalView.arraydict = infoArray;
            settingNormalView.title = @"锁屏设置";
            [self.navigationController pushViewController:settingNormalView animated:YES];*/
         //[self actionChangeGesturePassword];
         // [self.tableView reloadData];
        }
   /* else if ([[_arraydict allKeys][indexPath.row] isEqualToString:@"锁屏设置"]){
        [self actionChangeGesturePassword];
        _arraydict =   @{@"启用锁屏":@YES,@"修改锁屏密码":@{}};
        [self.tableView reloadData];
    }*/
    
    else if ([key  isEqualToString:@"清理缓存"]){
          [self actionCheckAssets];
    }
}

- (void)actionChangeGesturePassword {
    [self showLockViewForChangingPasscode];
}

- (void)SwitchTableViewCellButtonClick:(UISwitch *)button with:(NSInteger)cellId {
    if ([[_arraydict allKeys][cellId] isEqualToString:@"锁屏设置"]) {
       // [self actionChangeGesturePassword];
        [self actionWehtherUseGesturePassword:button];
        [self.tableView reloadData];
    }
    else if ([_titleArray[cellId] isEqualToString:@"微信分享长图"]){
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
    NSString *coordianteString = [NSString stringWithFormat:@"%@,%@",self.userLongitude,self.userlatitude];
    [[NSUserDefaults standardUserDefaults] setObject:coordianteString forKey:@"USERLOCATION"];
    [APIHelper userAuthentication:user.userNum password:user.password coordinate:coordianteString];
    
    [self checkAssetsUpdate];
    
    // 第三方消息推送，设备标识
    self.isSuccess = [APIHelper pushDeviceToken: _userdict[kDeviceUUIDCUName]];
    
    
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
         _userdict = [FileUtils readConfigFile:userConfigPath];
         _userdict[kIsUseGesturePasswordCUName] = @(1);
        [ _userdict writeToFile:userConfigPath atomically:YES];
        [ _userdict writeToFile:self.settingsConfigPath atomically:YES];
        self.isChangeLochPassword = YES;
        [self showLockViewForEnablingPasscode];
       // _arraydict =  @{@"启用锁屏":@1,@"修改锁屏密码":@{}};
        [self.tableView reloadData];
    }
    else {
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
         _userdict = [FileUtils readConfigFile:userConfigPath];
         _userdict[kIsUseGesturePasswordCUName] = @(0);
        [ _userdict writeToFile:userConfigPath atomically:YES];
        [ _userdict writeToFile:self.settingsConfigPath atomically:YES];
        
        //self.buttonChangeGesturePassword.enabled = NO;
        
        [ViewUtils showPopupView:self.view Info:@"禁用手势锁设置成功"];
        self.isChangeLochPassword = NO;
        
       // _arraydict =  @{@"启用锁屏":@NO,@"修改锁屏密码":@{}};
        [self.tableView reloadData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [APIHelper screenLock: _userdict[kUserDeviceIDCUName] passcode: _userdict[kGesturePasswordCUName] state:NO];
            
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
