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


@interface SettingNormalViewController ()<UITableViewDelegate,UITableViewDataSource,SwitchTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (strong, nonatomic) NSString *pgyLinkString;
@property (strong, nonatomic) NSMutableDictionary *noticeDict;
@property (strong, nonnull) Version *version;

@end

@implementation SettingNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setupUI];
     NSString* noticeFilePath = [FileUtils dirPath:kConfigDirName FileName:kLocalNotificationConfigFileName];
    self.noticeDict = [FileUtils readConfigFile:noticeFilePath];
    self.version = [[Version alloc]init];
    self.pgyLinkString =  [NSString stringWithFormat:@"i%@(%@)", _version.current, _version.build];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:false];
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
    return [_infodict allKeys].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell;
    if ([[_infodict allKeys][indexPath.row] isEqualToString:@"消息推送"]){
        SwitchTableViewCell*  cell = [[SwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellidcell"];
        cell.messageLabel.text = [_infodict allKeys][indexPath.row];
        cell.changStatusBtn.on = [[_infodict allValues][indexPath.row] boolValue];
        cell.delegate = self;
        return cell;
    }
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellid"];
    }
    cell.textLabel.text = [_infodict allKeys][indexPath.row];
    if ([[_infodict allValues][indexPath.row] isKindOfClass:[NSDictionary class]]) {
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([[_infodict allValues][indexPath.row] isKindOfClass:[NSArray class]]) {
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
     else if ([[_infodict allValues][indexPath.row] isKindOfClass:[NSString class]]){
        cell.detailTextLabel.text = [_infodict allValues][indexPath.row];
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
         if ([[_infodict allValues][indexPath.row] isEqualToString:@"检查新版本"]) {
             cell.detailTextLabel.text = self.pgyLinkString;
             cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
         }
    }
    else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[_infodict allValues][indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[_infodict allValues][indexPath.row] isKindOfClass:[NSDictionary class]]) {
        SettingNormalViewController *thirdView = [[SettingNormalViewController alloc]init];
        thirdView.title = [_infodict allKeys][indexPath.row];
        thirdView.infodict = [_infodict allValues][indexPath.row];
        [self.navigationController pushViewController:thirdView animated:YES];
    }
    
    if ([[_infodict allValues][indexPath.row] isKindOfClass:[NSArray class]]) {
        SettingArrayViewController *thirdView = [[SettingArrayViewController alloc]init];
        thirdView.title = [_infodict allKeys][indexPath.row];
        thirdView.array = [_infodict allValues][indexPath.row];
        [self.navigationController pushViewController:thirdView animated:YES];
    }
    
    if ([[_infodict allKeys][indexPath.row] isEqualToString:@"检查新版本"]) {
        [self actionCheckUpgrade];
    }
    else if ([[_infodict allKeys][indexPath.row] isEqualToString:@"蒲公英下载"]) {
        [self actionOpenLink];
    }
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
        if(isPygerUpgrade) {
            NSString *betaName = ([pgyerResponse[kVersionCodeCPCName] integerValue] % 2 == 0) ? @"" : @"测试";
            self.pgyLinkString= [NSString stringWithFormat:@"%@版本:%@(%@)", betaName, pgyerResponse[kVersionNameCPCName],  pgyerResponse[kVersionCodeCPCName]];
        }
    }
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
