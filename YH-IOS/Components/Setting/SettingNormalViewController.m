//
//  SettingNormalViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SettingNormalViewController.h"
#import "PrivateConstants.h"
#import "FileUtils.h"
#import "APIHelper.h"
#import "ViewUtils.h"
#import "Version.h"
#import <SCLAlertView.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "SettingArrayViewController.h"
#import "SwitchTableViewCell.h"
#import "ResetPasswordViewController.h"
#import <AFNetworking.h>
#import "User.h"
#import "FileUtils+Assets.h"


@interface SettingNormalViewController ()<UITableViewDelegate,UITableViewDataSource,SwitchTableViewCellDelegate>
{
    int cellnum;
}
@property (nonatomic,strong)UITableView *tableView;
@property (copy, nonatomic) NSString *pgyLinkString;
@property (strong, nonatomic) NSMutableDictionary *noticeDict;
@property (strong, nonnull) Version *version;


@end

@implementation SettingNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cellnum = 0;
    [self.navigationController.navigationBar setHidden:NO];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.tabBarController.tabBar setHidden:YES];
     [self setupUI];
     NSString* noticeFilePath = [FileUtils dirPath:kConfigDirName FileName:kLocalNotificationConfigFileName];
    self.noticeDict = [FileUtils readConfigFile:noticeFilePath];
    self.version = [[Version alloc]init];
     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
 //   self.pgyLinkString =  [NSString stringWithFormat:@"i%@(%@)", _version.current, _version.build];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
  /*  [self.navigationController setNavigationBarHidden:false];
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
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];*/
    if ([self.title isEqualToString:@"应用详情"]) {
        [self actionCheckUpgrade];
    }
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _indictKey.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell;
    if ([_indictKey[indexPath.row] isEqualToString:@"消息推送"]){
        SwitchTableViewCell*  cell = [[SwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dictcell"];
        cell.messageLabel.text = _indictKey[indexPath.row];
        cell.changStatusBtn.on = [_infodict[@"消息推送"] boolValue];
        cell.delegate = self;
        cellnum++;
         [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
        return cell;
    }
     cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
     [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
    
    UILabel *cellLabel=[[UILabel alloc] init];
    [cell addSubview:cellLabel];
    cellLabel.text=_indictKey[indexPath.row];
    cellLabel.textColor=[UIColor colorWithHexString:@"#666666"];
    cellLabel.font=[UIFont systemFontOfSize:15];
    [cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.contentView.mas_top).offset(17);
        make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
    }];

    NSString *key = _indictKey[indexPath.row];
    if ([_infodict[key] isKindOfClass:[NSDictionary class]]) {
//        cell.detailTextLabel.text = @"";


        
        
         if ([key isEqualToString:@"检测更新"]) {
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)", _version.current, _version.build];
//             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             
             UIImageView *cellImage=[[UIImageView alloc] init];
             
             [cell.contentView addSubview:cellImage];
             
             [cellImage setImage:[UIImage imageNamed:@"btn_more"]];
             
             [cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                 make.right.mas_equalTo(cell.contentView.mas_right).offset(-20);
             }];
             
             
             UILabel *detailLabel=[[UILabel alloc] init];
             
             [cell.contentView addSubview:detailLabel];
             
             detailLabel.textColor=[UIColor colorWithRed:0.21 green:0.25 blue:0.29 alpha:1];
             
             detailLabel.font=[UIFont systemFontOfSize:15];
             
             detailLabel.text=[NSString stringWithFormat:@"%@(%@)", _version.current, _version.build];
             
             [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.right.mas_equalTo(cell.contentView.mas_right).offset(-32);
                 make.centerY.mas_equalTo(cell.contentView.mas_centerY);
             }];

             
        }
    }
    else if ([_infodict[key] isKindOfClass:[NSArray class]]) {
//        cell.detailTextLabel.text = @"";

//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
     else if ([_infodict[key] isKindOfClass:[NSString class]]){
//        cell.detailTextLabel.text = _infodict[key];
//        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
//         cell.userInteractionEnabled = NO;
         UILabel *detailLabel=[[UILabel alloc] init];
         [cell.contentView addSubview:detailLabel];
         detailLabel.textColor=[UIColor colorWithRed:0.21 green:0.25 blue:0.29 alpha:1];
         detailLabel.font=[UIFont systemFontOfSize:15];
         
         NSString *detailLabelPoint=@"20";
         if ([key isEqualToString:@"检查新版本"]) {
             cell.detailTextLabel.text = self.pgyLinkString;
             detailLabelPoint=@"32";
         }
         else if([key isEqualToString:@"蒲公英下载"]){
         detailLabel.text=_infodict[key];
            detailLabelPoint=@"32";
         }
         else
         {detailLabel.text=_infodict[key];
         detailLabelPoint=@"20";
         
         }
         [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.mas_equalTo(cell.contentView.mas_right).offset(-[detailLabelPoint integerValue]);
             make.centerY.mas_equalTo(cell.contentView.mas_centerY);
         }];
         
         
         if ([key isEqualToString:@"检查新版本"]) {
             

             UIImageView *cellImage=[[UIImageView alloc] init];
             
             [cell.contentView addSubview:cellImage];
             
             [cellImage setImage:[UIImage imageNamed:@"btn_more"]];
             
             [cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                 //            make.top.mas_equalTo(cell.contentView.mas_top).offset(17);
                 make.right.mas_equalTo(cell.contentView.mas_right).offset(-20);
             }];

             cell.userInteractionEnabled = YES;

         }
         else if ([key isEqualToString:@"蒲公英下载"]) {
//             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             
             
//             UILabel *detailLabel=[[UILabel alloc] init];
//             
//             [cell.contentView addSubview:detailLabel];
//             
//             detailLabel.textColor=[UIColor colorWithRed:0.21 green:0.25 blue:0.29 alpha:1];
//             
//             detailLabel.font=[UIFont systemFontOfSize:15];
//             
//             detailLabel.text=_infodict[key];
//             
//             [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                 make.right.mas_equalTo(cell.contentView.mas_right).offset(-32);
//                 make.centerY.mas_equalTo(cell.contentView.mas_centerY);
//             }];

        
             UIImageView *cellImage=[[UIImageView alloc] init];
             
             [cell.contentView addSubview:cellImage];
             
             [cellImage setImage:[UIImage imageNamed:@"btn_more"]];
             
             [cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                 //            make.top.mas_equalTo(cell.contentView.mas_top).offset(17);
                 make.right.mas_equalTo(cell.contentView.mas_right).offset(-20);
             }];
             
             
             cell.userInteractionEnabled = YES;
         }
         else if ([key isEqualToString:@"修改密码"]) {
//             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.userInteractionEnabled = YES;
         }
         else if ([key isEqualToString:@"校正"]) {
//             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.userInteractionEnabled = YES;
         }
         else if ([key isEqualToString:@"手工清理"]) {
//             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.userInteractionEnabled = YES;
             
         }
    }

    else {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_infodict[key]];
    }
    cellnum++;
 
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* key = _indictKey[indexPath.row];
    if ([_infodict[key] isKindOfClass:[NSDictionary class]]) {
        SettingNormalViewController *thirdView = [[SettingNormalViewController alloc]init];
        thirdView.title = key;
        thirdView.indictKey = [[_infodict[key] allKeys]copy];
        thirdView.infodict = _infodict[key];
        [self.navigationController pushViewController:thirdView animated:YES];
    }
    
   else if ([_infodict[key] isKindOfClass:[NSArray class]]) {
        SettingArrayViewController *thirdView = [[SettingArrayViewController alloc]init];
        thirdView.title = [_infodict allKeys][indexPath.row];
        thirdView.array = [_infodict allValues][indexPath.row];
        [self.navigationController pushViewController:thirdView animated:YES];
    }
    
    else if ([key isEqualToString:@"检查新版本"]) {
             [self actionCheckUpgrade];
    }
    else if ([key isEqualToString:@"蒲公英下载"]) {
        [self actionOpenLink];
    }
    else if ([key isEqualToString:@"修改密码"]){
        [self ResetPassword];
    }
    else if ([key isEqualToString:@"校正"]){
        [self actionCheckAssets];
    }
    else if ([key isEqualToString:@"手工清理"]){
        SettingArrayViewController *settingArrayCtrl = [[SettingArrayViewController alloc]init];
        if ([self getDocumentName] && [[self getPathFileName] count]) {
          // settingArrayCtrl.array = [self getPathFileName];
          // settingArrayCtrl.titleArray = [self getDocumentName];
        }
        settingArrayCtrl.array = [self getPathFileName];
        settingArrayCtrl.titleArray = [self getDocumentName];
        settingArrayCtrl.title = @"手工清理";
        [self.navigationController pushViewController:settingArrayCtrl animated:YES];
    }
}


// 手工清理
- (NSArray *)getPathFileName{
    NSArray *firstSavePathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    for (NSString *path in firstSavePathArray) {
        NSLog(@"%@",path);
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:firstSavePathArray[0] error:&error];
    NSMutableArray* cleanArray = [[NSMutableArray alloc]init];
    NSLog(@"%@",fileList);
    User *user = [[User alloc]init];
    NSString *userFileName = [NSString stringWithFormat:@"user-%@",user.userID];
    for (NSString* value in fileList) {
        if  ([value hasPrefix:@"user-"] && ![value isEqualToString:userFileName] && ![value isEqualToString:@"user-(null)"]) {
            [cleanArray addObject:value];
        }
    }
    return cleanArray;
}

// 获取清理文件
- (NSArray*)getDocumentName{
    NSArray *firstSavePathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    for (NSString *path in firstSavePathArray) {
        NSLog(@"%@",path);
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:firstSavePathArray[0] error:&error];
    NSMutableArray* cleanArray = [[NSMutableArray alloc]init];
    NSLog(@"%@",fileList);
    User* user = [[User alloc]init];
    NSString *userFileName = [NSString stringWithFormat:@"user-%@",user.userID];
    for (NSString* value in fileList) {
        if ([value hasPrefix:@"user-"] && ![value isEqualToString:userFileName] && ![value isEqualToString:@"user-(null)"]) {
            NSMutableDictionary *userDict;
            NSString *userPath = [[FileUtils basePath] stringByAppendingPathComponent:value];
            if ([FileUtils checkFileExist:userPath isDir:YES]) {
                NSString *userConfigPath = [userPath stringByAppendingPathComponent:@"Configs"];
                if ([FileUtils checkFileExist:userConfigPath isDir:YES]) {
                    NSString *userInfoPath = [userConfigPath stringByAppendingPathComponent:@"setting.plist"];
                    userDict = [FileUtils readConfigFile:userInfoPath];
                    if (userDict[@"user_name"] && ![userDict[@"user_name"] isEqualToString:@""]) {
                        [cleanArray addObject:userDict[@"user_name"]];
                    }
                }
            }
        }
    }
    return cleanArray;
}

// 修改密码
- (void)ResetPassword {
    ResetPasswordViewController *resertPwdViewController = [[ResetPasswordViewController alloc]init];
    resertPwdViewController.title = @"修改密码";
    [self.navigationController pushViewController:resertPwdViewController animated:YES];
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


//校正
- (void)actionCheckAssets {
    User* user = [[User alloc] init];
    NSString* sharedPath = [FileUtils sharedPath];
    NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", sharedPath, kCachedHeaderConfigFileName];
    [FileUtils removeFile:cachedHeaderPath];
    cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", [FileUtils dirPath:kHTMLDirName], kCachedHeaderConfigFileName];
    [FileUtils removeFile:cachedHeaderPath];
    NSString *userlocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERLOCATION"];
    [APIHelper userAuthentication:user.userNum password:user.password coordinate:userlocation];
    
    [self checkAssetsUpdate];
    
    // 第三方消息推送，设备标识
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    [APIHelper pushDeviceToken:userDict[kDeviceUUIDCUName]];
    [ViewUtils showPopupView:self.view Info:@"校正完成"];
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



-(void)SwitchTableViewCellButtonClick:(UISwitch *)button with:(NSInteger)cellId; {
    NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kPushConfigFileName];
    NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerfall) name:@"registerFall" object:nil];
    if(![button isOn]) {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        pushDict[@"push_valid"] = @"false";
    }
    else {
        pushDict[@"push_valid"] = @"yes";
        [[UIApplication sharedApplication]registerForRemoteNotifications];
    }
    [FileUtils writeJSON:pushDict Into:pushConfigPath];
}

-(void)registerfall {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:@"打开失败，请到系统中打开远程推送"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.tableView reloadData];}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)actionOpenLink{
    NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
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
- (void)actionCheckUpgrade {
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appUpgradeMethod:)];
}

- (void)checkPgyerVersionLabel:(Version *)version pgyerResponse:(NSDictionary *)pgyerResponse {
    if(!pgyerResponse || !pgyerResponse[kDownloadURLCPCName] || !pgyerResponse[kVersionCodeCPCName] || !pgyerResponse[kVersionNameCPCName]) {
        self.pgyLinkString = @"蒲公英链接";
    }
    else {
        BOOL isPygerUpgrade = ([pgyerResponse[kVersionCodeCPCName] integerValue] > [version.build integerValue]);
        self.pgyLinkString = @"已是最新版本";
        if (!isPygerUpgrade) {
            self.noticeDict[kSettingPgyerLNName] = @NO;
        }
        else {
            NSString *betaName = ([pgyerResponse[kVersionCodeCPCName] integerValue] % 2 == 0) ? @"" : @"测试";
            self.pgyLinkString= [NSString stringWithFormat:@"%@版本:%@(%@)", betaName, pgyerResponse[kVersionNameCPCName],  pgyerResponse[kVersionCodeCPCName]];
        }
    }
    //self.infodict[@"检查新版本"] = self.pgyLinkString;
   [self.tableView reloadData];
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
    
    NSString *pgyerVersionPath = [[FileUtils basePath] stringByAppendingPathComponent:kPgyerVersionConfigFileName];
    [FileUtils writeJSON:[NSMutableDictionary dictionaryWithDictionary:response] Into:pgyerVersionPath];
    
    NSInteger currentVersionCode = [_version.build integerValue];
    NSInteger responseVersionCode = [response[kVersionCodeCPCName] integerValue];
    
    // 对比 build 值，只准正向安装提示
    if(responseVersionCode <= currentVersionCode) {
        self.pgyLinkString = @"已是最新版本";
        [self.tableView reloadData];
        return;
    }
    
    NSString *localNotificationPath = [FileUtils dirPath:kConfigDirName FileName:kLocalNotificationConfigFileName];
    NSMutableDictionary *localNotificationDict = [FileUtils readConfigFile:localNotificationPath];
    localNotificationDict[kSettingPgyerLNName] = @(1);
    [FileUtils writeJSON:localNotificationDict Into:localNotificationPath];
    
    /**
     * 更新按钮右侧提示文字
     */
    [self checkPgyerVersionLabel:_version pgyerResponse:response];
    
    if(responseVersionCode % 2 == 0) {
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
