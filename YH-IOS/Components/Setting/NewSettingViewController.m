//
//  NewSettingViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//
// 鉴定 暂未使用
#import "NewSettingViewController.h"
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

@interface NewSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UserHeadViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *userInfoArray;
    User *user;
}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UserInfoModel *userInfo;
@property(nonatomic,strong) NSDictionary *pushdeviceDict;
@property(nonatomic,strong)UIImage* userIconImage;

@end

@implementation NewSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    userInfoArray = @[@"基本信息",@"应用信息",@"选项配置",@"消息推送",@"更新日志"];
    user =[[User alloc]init];
    [self loadUserGravatar];
    [self setupUI];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSString* settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
    NSDictionary* betaDict = [FileUtils readConfigFile:settingsConfigPath];
    self.userInfo = [[UserInfoModel alloc] initWithDict:betaDict];
    NSLog(@"%@",_userInfo.user_name);
     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
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
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [self tableFooterView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (UIView *)tableHeadView {
    UserHeadView *settingHeadView = [[UserHeadView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 160)];
    settingHeadView.delegate  = self;
    UIImage *userHead = self.userIconImage ?: [UIImage imageNamed:@"AppIcon"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImage *imageback = [[UIImage imageNamed:@"Banner-Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    [settingHeadView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    [settingHeadView.userIcon setBackgroundImage:userHead forState:UIControlStateNormal];
    self.navigationController.navigationBar.translucent = NO;
    return settingHeadView;
}

- (void)usericonClick:(UIButton *)button {
    [self addUserIcon];
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
    NSData *imageData = UIImageJPEGRepresentation(_userIconImage, 1.0);
    
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSString *gravatarName = [NSString stringWithFormat:@"%@-%@-%@.jpg", kAppCode, user.userNum, timestamp];
    NSString *gravatarPath = [FileUtils dirPath:kConfigDirName FileName:gravatarName];
    [imageData writeToFile:gravatarPath atomically:YES];
    NSString *urlPath = [NSString stringWithFormat:kUploadGravatarAPIPath, user.deviceID, user.userID];
    [HttpUtils uploadImage:urlPath withImagePath:gravatarPath withImageName:gravatarName];
    [self.tableView reloadData];
}

#pragma mark - load user gravatar
- (UIImage *)loadUserGravatar {
    // default gravatar
    self.userIconImage = [UIImage imageNamed:@"AppIcon"];
    
    NSString *gravatarUrl = user.gravatar;
    if(!gravatarUrl || (![gravatarUrl hasPrefix:@"http://"] && ![gravatarUrl hasPrefix:@"https://"])) {
        return self.userIconImage;
    }
    
    NSString *gravatarName = [[gravatarUrl componentsSeparatedByString:@"/"] lastObject];
    NSString *gravatarPath = [FileUtils dirPath:kConfigDirName FileName:gravatarName];
    
    if([FileUtils checkFileExist:gravatarPath isDir:NO]) {
        self.userIconImage = [UIImage imageWithContentsOfFile:gravatarPath];
        [self.tableView reloadData];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *gravatarName = [[user.gravatar componentsSeparatedByString:@"/"] lastObject];
            NSString *gravatarPath = [FileUtils dirPath:kConfigDirName FileName:gravatarName];
            
            [HttpUtils downLoadFile:user.gravatar withSavePath:gravatarPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([FileUtils checkFileExist:gravatarPath isDir:NO]) {
                    self.userIconImage = [UIImage imageWithContentsOfFile:gravatarPath];
                    [self.tableView reloadData];
                    NSString *gravatarConfigPath = [FileUtils dirPath:kConfigDirName FileName:kGravatarConfigFileName];
                    BOOL uploadState = [FileUtils checkFileExist:gravatarConfigPath isDir:YES];
                    NSMutableDictionary *gravatarDict = [FileUtils readConfigFile:gravatarConfigPath];
                    gravatarDict[@"name"] = gravatarName;
                    gravatarDict[@"upload_state"] = @(uploadState);
                    [FileUtils writeJSON:gravatarDict Into:gravatarConfigPath];
                }
            });
            
        });
    }
    return self.userIconImage;
}


#pragma mark - action methods
- (void)actionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (UIView *)tableFooterView {
    
    UIView *sepertatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, 1)];
    sepertatorView.backgroundColor = [ UIColor lightGrayColor];
    sepertatorView.alpha = 0.6;
    UIView *sepertatorView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 90, self.view.bounds.size.width, 1)];
    sepertatorView1.backgroundColor = [ UIColor lightGrayColor];
    sepertatorView1.alpha = 0.6;
    UIView *settingFooterView = [[UIView alloc]initWithFrame:CGRectMake(0,  40, self.view.bounds.size.width, 100)];
    UIButton *logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, settingFooterView.frame.size.width, settingFooterView.frame.size.height - 60)];
    [settingFooterView addSubview:sepertatorView];
    [settingFooterView addSubview:sepertatorView1];
    [settingFooterView addSubview:logoutBtn];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    logoutBtn.backgroundColor = [UIColor whiteColor];
    logoutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    logoutBtn.layer.cornerRadius = 8;
    [logoutBtn addTarget:self action:@selector(logoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return settingFooterView;
}

- (void)logoutButtonClick:(UIButton*) button {
    [self jumpToLogin];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        [APIHelper deleteUserDevice:@"ios" withDeviceID:user.deviceID];
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

- (void)jumpToLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[kIsLoginCUName] = @(NO);
    [userDict writeToFile:userConfigPath atomically:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kMainSBName bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:kLoginVCName];
    self.view.window.rootViewController = loginViewController;
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
        cell.textLabel.text = userInfoArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self tableHeadView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 140.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            NSString *userRole =[NSString stringWithFormat:@"%@", user.roleName];
            NSString *userGroup = [NSString stringWithFormat:@"%@", user.groupName];
            NSArray *userBaseDictKey = @[@"用户名",@"用户角色",@"所属商行",@"手机电话",@"邮箱",@"修改密码"];
            NSDictionary *userBaseDict = @{@"用户名":user.userName,@"用户角色":userRole,@"所属商行":userGroup,@"手机电话":@"",@"邮箱":@"",@"修改密码":@""};
            SettingNormalViewController *settingNormalView = [[SettingNormalViewController alloc]init];
            settingNormalView.infodict  = [userBaseDict copy];
            settingNormalView.indictKey = [userBaseDictKey copy];
            settingNormalView.title = userInfoArray[indexPath.row];
            [self.navigationController pushViewController:settingNormalView animated:YES];
        }
            break;
        case 2:{
            NSDictionary *infodict = @{@"锁屏设置":@"", @"微信分享长图":@"", @"报表操作":@"", @"清理缓存":@""};
            NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
            NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
            BOOL isUseGesturePassword = [userDict[kIsUseGesturePasswordCUName] boolValue];
            if (!isUseGesturePassword) {
                infodict = @{@"锁屏设置": @{@"启用锁屏":@NO}, @"分享微信长图":@"", @"报表操作":@"", @"清理缓存":@""};
            }
            NSArray* titleArray = @[@"锁屏设置",@"报表操作",@"微信分享长图",@"清理缓存"];
            OptionConfigViewController *optionView = [[OptionConfigViewController alloc]init];
            optionView.title = userInfoArray[indexPath.row];
            optionView.arraydict = infodict;
            optionView.titleArray = titleArray;
            [self.navigationController pushViewController:optionView animated:YES];
        }
            break;
            
        case 1:{
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
        case 3:{
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
        case 4:{
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
