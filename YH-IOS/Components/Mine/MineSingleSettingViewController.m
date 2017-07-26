//
//  MineSingleSettingViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/14.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineSingleSettingViewController.h"
#import "UserHeadView.h"
#import "FileUtils.h"
#import "UserInfoModel.h"
#import "OptionConfigViewController.h"
#import "SettingNormalViewController.h"
#import "Version.h"
#import "User.h"
#import "HttpUtils.h"
#import "LoginViewController.h"
#import "ThurSayViewController.h"
#import "ThurSayTableViewCell.h"

@interface MineSingleSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UserHeadViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *userInfoArray;
    User *user;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UserInfoModel *userInfo;
@property(nonatomic,strong) NSDictionary *pushdeviceDict;
@property(nonatomic,strong)UIImage* userIconImage;

@end

@implementation MineSingleSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.automaticallyAdjustsScrollViewInsets = YES;
    //[self.tabBarController.tabBar setHidden:YES];
     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    userInfoArray = @[@"应用信息",@"选项配置",@"消息推送",@"更新日志"];
    user =[[User alloc]init];
    [self setupUI];

    NSString* settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
    NSDictionary* betaDict = [FileUtils readConfigFile:settingsConfigPath];
    self.userInfo = [[UserInfoModel alloc] initWithDict:betaDict];
    NSLog(@"%@",_userInfo.user_name);
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];

    // Do any additional setup after loading the view.
}




- (NSArray *)getDocumentName{
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
    NSString *userFileName = [NSString stringWithFormat:@"user-%@",user.userID];
    for (NSString* value in fileList) {
        if ([value hasPrefix:@"user-"] && ![value isEqualToString:userFileName]) {
            [cleanArray addObject:value];
        }
    }
    return cleanArray;
}

//惰性获取推送设备
-(NSDictionary*)pushdeviceDict{
    if (!_pushdeviceDict) {
        NSString *pushdeviceString = [NSString stringWithFormat:@"%@/api/v1/user/%@/devices",kBaseUrl,user.userNum];
        HttpResponse *response = [HttpUtils httpGet:pushdeviceString];
        _pushdeviceDict = [[NSDictionary alloc]init];
        if ([response.statusCode isEqualToNumber:@(200)]) {
            _pushdeviceDict =   response.data;
        }
    }
    return _pushdeviceDict;
}



- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSString* settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
        NSDictionary* betaDict = [FileUtils readConfigFile:settingsConfigPath];
        NSArray* fileArray = [self getDocumentName];
        NSDictionary *infodict = @{@"报表缓存数据列表":@" ",@"请求头缓存列表":@"",@"配置文件列表":@"",@"扫码响应数据":@"",@"静态资源列表":@{@"手工清理":fileArray ,@"重新下载":@""},@"个人资料":betaDict};
        SettingNormalViewController *settingNormalView = [[SettingNormalViewController alloc]init];
        settingNormalView.infodict  = infodict;
        settingNormalView.title = @"开发者选项";
        [self.navigationController pushViewController:settingNormalView animated:YES];
    }
    return;
}

-(void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - action methods
- (void)actionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return userInfoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell) {
        UILabel *cellLabel=[[UILabel alloc] init];
        [cell addSubview:cellLabel];
        cellLabel.text=userInfoArray[indexPath.row];
        cellLabel.textColor=[UIColor colorWithHexString:@"#666666"];
        cellLabel.font=[UIFont systemFontOfSize:15];
        [cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
        
        
        
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return self.view.frame.size.height-210;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:{
            NSDictionary *infodict = @{@"锁屏设置":@"",@"微信分享长图":@"", @"报表操作":@"", @"清理缓存":@""};
            NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
            NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
            BOOL isUseGesturePassword = [userDict[kIsUseGesturePasswordCUName] boolValue];
            if (!isUseGesturePassword) {
                infodict = @{@"锁屏设置": @{@"启用锁屏":@NO}, @"微信分享长图":@"" ,@"报表操作":@"", @"清理缓存":@""};
            }
            NSArray* titleArray = @[@"锁屏设置",@"微信分享长图",@"报表操作",@"清理缓存"];
            OptionConfigViewController *optionView = [[OptionConfigViewController alloc]init];
            optionView.title = userInfoArray[indexPath.row];
            optionView.arraydict = infodict;
            optionView.titleArray = titleArray;
            [self.navigationController pushViewController:optionView animated:YES];

        }
            break;
            
        case 0:{
            Version *version = [[Version alloc]init];
            NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
            NSArray *userBaseDictKey = @[@"应用名称",@"检测更新",@"设备型号",@"数据接口",@"应用标识"];
            NSDictionary *infodict = @{@"应用名称":version.appName,@"设备型号":[NSString stringWithFormat: @"%@ (%@)",[[Version machineHuman]componentsSeparatedByString:@" ("][0], phoneVersion], @"数据接口":kBaseUrl,@"应用标识":version.bundleID,@"检测更新":@{@"检查新版本":@"已是最新版本",@"蒲公英下载":kPgyerUrl}};
            SettingNormalViewController *settingNormalView = [[SettingNormalViewController alloc]init];
            settingNormalView.infodict  = infodict;
            settingNormalView.indictKey = userBaseDictKey;
            settingNormalView.title = userInfoArray[indexPath.row];
            [self.navigationController pushViewController:settingNormalView animated:YES];
        }
           
            break;
        case 2:{
            NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kPushConfigFileName];
            NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
            NSString* pushstate = pushDict[@"push_valid"] && [pushDict[@"push_valid"] boolValue] ? @"true" : @"false";
            NSDictionary *devideDict = [self pushdeviceDict];
            NSString *pushDataPath = [[FileUtils userspace] stringByAppendingPathComponent:@"pushData.plist"];
            NSMutableDictionary *pushData = [FileUtils readConfigFile:pushDataPath];
            NSDictionary*  pushDatavalue = pushData;
            if ([[pushData allKeys]count] == 0) {
                pushDatavalue = @{@"暂无数据":@"0"};
            }
            
            NSDictionary *infodict;
            NSArray* infoArray = @[@"消息推送",@"关联的设备列表",@"推送的消息列表"];
            if (!devideDict || [devideDict allKeys].count == 0) {
                infodict = @{@"消息推送":pushstate,@"关联的设备列表":@"" ,@"推送的消息列表":pushDatavalue};
            }
            else{
                infodict = @{@"消息推送":pushstate,@"关联的设备列表":devideDict[@"devices"] ,@"推送的消息列表":pushDatavalue};
            }
            SettingNormalViewController *settingNormalView = [[SettingNormalViewController alloc]init];
            settingNormalView.infodict  = infodict;
            settingNormalView.indictKey = infoArray;
            settingNormalView.title = userInfoArray[indexPath.row];
            [self.navigationController pushViewController:settingNormalView animated:YES];
        }
            break;
        case 3:{
            ThurSayViewController *thurSayView = [[ThurSayViewController alloc]init];
            thurSayView.title = @"更新日志";
            [self.navigationController pushViewController:thurSayView animated:YES];
        }
            break;
        default:
            break;
    }
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
