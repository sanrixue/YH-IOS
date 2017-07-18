//
//  JYBaseViewController.m
//  YH-IOS
//
//  Created by li hao on 17/5/11.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "JYBaseViewController.h"
#import "DropTableViewCell.h"
#import "DropViewController.h"
#import "ViewUtils.h"
#import "NewSettingViewController.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "User.h"
#import "JumpCommonView.h"
#import "Version.h"
#import <Reachability/Reachability.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import <SCLAlertView.h>
#import "SubjectViewController.h"

@interface JYBaseViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
// 设置按钮点击下拉菜单
@property (nonatomic, strong) NSArray *dropMenuTitles;
@property (nonatomic, strong) NSArray *dropMenuIcons;
@property (nonatomic, strong) UITableView *dropMenu;
@property (nonatomic, strong) User* user;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) NSString *sharedPath;
@property (nonatomic, strong) NSMutableArray* menuArray;
@property (nonatomic, assign) NSInteger curLineNum;
@property (nonatomic, strong) JumpCommonView* menuView;
@property (strong, nonatomic) NSString *localNotificationPath;
@property (strong, nonatomic) NSArray *localNotificationKeys;
@property (strong, nonatomic) NSMutableDictionary *remoteDict;

@end

@implementation JYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  /*  UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Banner-Logo"]];
    imageView.contentMode =UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(self.view.frame.size.width/2-50, 0, 100, 50);
    [self.navigationController.navigationBar addSubview:imageView];
    self.user = [[User alloc] init];
    [self initDropMenu];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
     //self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.localNotificationKeys = @[kTabKPILNName, kTabAnalyseLNName, kTabAppLNName, kTabMessageLNName, kSettingThursdaySayLNName];
    self.localNotificationPath = [FileUtils dirPath:kConfigDirName FileName:kLocalNotificationConfigFileName];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];*/
    self.title = @"生意概况";
    self.sharedPath = [FileUtils sharedPath];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:kHTMLDirName];
    }
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToRemote) name:@"ReceiveRemote" object:nil];
    [JumpCommonView clearMenu]; // 清除window菜单
    [self checkFromViewController];
    NSString *pushConfigPath = [[FileUtils userspace] stringByAppendingPathComponent:@"receiveRemote"];
    if ([FileUtils checkFileExist:pushConfigPath isDir:NO]) {
        self.remoteDict = [[FileUtils readConfigFile:pushConfigPath] copy];
        NSLog(@"%@",_remoteDict);
        [self DealRemote];
        [FileUtils removeFile:pushConfigPath];
    }
    [self initDropMenu]; //重新生成菜单
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Barcode-Scan-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(dropTableView:)];

    // Do any additional setup after loading the view.
}

-(void)DealRemote{
    NSString *remoteType = _remoteDict[@"type"];
    if ([remoteType isEqualToString:@"kpi"]) {
        return;
    }
    else if ([remoteType isEqualToString:@"report"]){
        [self jumpToDetailViewWithDict:_remoteDict];
    }
    else if ([remoteType isEqualToString:@"message"]){
        self.tabBarController.selectedIndex = 3;
    }
    else if ([remoteType isEqualToString:@"analyse"]){
        self.tabBarController.selectedIndex = 1;
    }
    else if ([remoteType isEqualToString:@"app"]){
        self.tabBarController.selectedIndex = 2;
    }
    else{
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)jumpToRemote {
    NSString *pushConfigPath = [[FileUtils userspace] stringByAppendingPathComponent:@"receiveRemote"];
    if ([FileUtils checkFileExist:pushConfigPath isDir:NO]) {
        self.remoteDict = [[FileUtils readConfigFile:pushConfigPath] copy];
        NSLog(@"%@",_remoteDict);
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self DealRemote];
        [FileUtils removeFile:pushConfigPath];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

/*
 * 解屏进入主页面，需检测版本更新
 */
- (void)checkFromViewController {
    // if(self.fromViewController && [self.fromViewController isEqualToString:@"AppDelegate"]) {
    // self.fromViewController = @"AlreadyShow";
    // 检测版本更新
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appToUpgradeMethod:)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"解屏";
            [APIHelper actionLog:logParams];
            
            /**
             *  解屏验证用户信息，更新用户权限
             *  若难失败，则在下次解屏检测时进入登录界面
             */
            NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
            NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
            if(!userDict[kUserNumCUName]) {
                return;
            }
            
            NSString *userlocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERLOCATION"];
            NSString *msg = [APIHelper userAuthentication:userDict[kUserNumCUName] password:userDict[kPasswordCUName] coordinate:userlocation];
            if(msg.length != 0) {
                userDict[kIsLoginCUName] = @(NO);
                [userDict writeToFile:userConfigPath atomically:YES];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}


# pragma mark - assitant methods
/**
 *  内容检测版本升级，判断版本号是否为偶数。以便内测
 *
 *  @param response <#response description#>
 */
- (void)appToUpgradeMethod:(NSDictionary *)response {
    if(!response || !response[kDownloadURLCPCName] || !response[kVersionCodeCPCName] || !response[kVersionNameCPCName]) {
        return;
    }
    
    NSString *pgyerVersionPath = [[FileUtils basePath] stringByAppendingPathComponent:kPgyerVersionConfigFileName];
    [FileUtils writeJSON:[NSMutableDictionary dictionaryWithDictionary:response] Into:pgyerVersionPath];
    
    Version *version = [[Version alloc] init];
    NSInteger currentVersionCode = [version.build integerValue];
    NSInteger responseVersionCode = [response[kVersionCodeCPCName] integerValue];
    
    // 对比 build 值，只准正向安装提示
    if(responseVersionCode <= currentVersionCode) {
        return;
    }
    
    NSMutableDictionary *localNotificationDict = [FileUtils readConfigFile:self.localNotificationPath];
    localNotificationDict[kSettingPgyerLNName] = @(1);
    [FileUtils writeJSON:localNotificationDict Into:self.localNotificationPath];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if(responseVersionCode % 2 == 0) {
        if (responseVersionCode % 10 == 8 && [reach isReachableViaWiFi]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"重大改动，请升级" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[kDownloadURLCPCName]]];
                NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [[UIApplication sharedApplication] openURL:url];
                [self exitApplication];
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[kDownloadURLCPCName]] options:@{} completionHandler:nil];
              //  [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
            }];
            
            [alertVC addAction:action1];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:kUpgradeBtnText actionBlock:^(void) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[kDownloadURLCPCName]]];
                [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
            }];
            
            NSString *subTitle = [NSString stringWithFormat:kUpgradeWarnText, response[kVersionNameCPCName], response[kVersionCodeCPCName]];
            [alert showSuccess:self title:kUpgradeTitleText subTitle:subTitle closeButtonTitle:kCancelBtnText duration:0.0f];
        }
    }
}


-(void)jumpToDetailViewWithDict:(NSDictionary*)dict{
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
        subjectView.bannerName =dict[@"title"];
        subjectView.link = dict[@"url"];
        subjectView.commentObjectType = [dict[@"obj_type"] intValue];
        subjectView.objectID = dict[@"obj_id"];
               /* else if ([data[@"link"] rangeOfString:@"template/"].location != NSNotFound){
         if ([data[@"link"] rangeOfString:@"template/5/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/1/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/2/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/3/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/4/"].location == NSNotFound) {
         SCLAlertView *alert = [[SCLAlertView alloc] init];
         [alert addButton:@"下一次" actionBlock:^(void) {}];
         [alert addButton:@"立刻升级" actionBlock:^(void) {
         NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         [[UIApplication sharedApplication] openURL:url];
         }];
         [alert showSuccess:self title:@"温馨提示" subTitle:@"您当前的版本暂不支持该模块，请升级之后查看" closeButtonTitle:nil duration:0.0f];
         }
         }*/

            UINavigationController *subjectCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
            [self presentViewController:subjectCtrl animated:YES completion:nil];
}

- (void)exitApplication {
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
    
}

- (void)initDropMenu {
    NSMutableArray *tmpTitles = [NSMutableArray array];
    NSMutableArray *tmpIcons = [NSMutableArray array];
    
    if(kDropMenuScan) {
        [tmpTitles addObject:kDropMentScanText];
        [tmpIcons addObject:@"DropMenu-Scan"];
    }
    
    if(kDropMenuVoice) {
        [tmpTitles addObject:kDropMentVoiceText];
        [tmpIcons addObject:@"DropMenu-Voice"];
    }
    
    if(kDropMenuSearch) {
        [tmpTitles addObject:kDropMentSearchText];
        [tmpIcons addObject:@"DropMenu-Search"];
    }
    
    if(kDropMenuUserInfo) {
        [tmpTitles addObject:kDropMentUserInfoText];
        [tmpIcons addObject:@"DropMenu-UserInfo"];
    }
    // [tmpTitles addObject:@"原生报表"];
    //[tmpIcons addObject:@"DropMenu-UserInfo"];
    self.dropMenuTitles = [NSArray arrayWithArray:tmpTitles];
    self.dropMenuIcons = [NSArray arrayWithArray:tmpIcons];
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - action methods

/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender
 */
-(void)dropTableView:(UIBarButtonItem *)sender {
    [self actionBarCodeScanView:nil];
   /* DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, 150, 150);
    dropTableViewController.preferredContentSize = CGSizeMake(150,self.dropMenuTitles.count*150/4);
    dropTableViewController.dataSource = self;
    dropTableViewController.delegate = self;
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.barButtonItem = self.navigationItem.rightBarButtonItem;
    popover.delegate = self;
    [popover setSourceRect:sender.customView.frame];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kDropViewColor];
    [self presentViewController:dropTableViewController animated:YES completion:nil];*/
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(NSInteger)numberOfPagesIndropView:(DropViewController *)flowView{
    return self.dropMenuTitles.count;
}

-(UITableViewCell *)dropView:(DropViewController *)flowView cellForPageAtIndex:(NSIndexPath *)index{
    DropTableViewCell*  cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dorpcell"];
    cell.tittleLabel.text = self.dropMenuTitles[index.row];
    cell.iconImageView.image = [UIImage imageNamed:self.dropMenuIcons[index.row]];
    
    UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
    cellBackView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = cellBackView;
    cell.tittleLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

-(void)dropView:(DropViewController *)flowView didTapPageAtIndex:(NSIndexPath *)index{
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *itemName = self.dropMenuTitles[index.row];
        
        if([itemName isEqualToString:kDropMentScanText]) {
            [self actionBarCodeScanView:nil];
        }
        else if([itemName isEqualToString:kDropMentVoiceText]) {
            [ViewUtils showPopupView:self.view Info:@"功能开发中，敬请期待"];
        }
        else if([itemName isEqualToString:kDropMentSearchText]) {
            [ViewUtils showPopupView:self.view Info:@"功能开发中，敬请期待"];
        }
        else if([itemName isEqualToString:kDropMentUserInfoText]) {
            NewSettingViewController *settingViewController = [[NewSettingViewController alloc]init];
            UINavigationController *userInfoViewControlller = [[UINavigationController alloc]initWithRootViewController:settingViewController];
            [self presentViewController:userInfoViewControlller animated:YES completion:nil];
        }
    }];
}


- (IBAction)actionBarCodeScanView:(UIButton *)sender {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(!userDict[kStoreIDsCUName] || [userDict[kStoreIDsCUName] count] == 0) {
        [[[UIAlertView alloc] initWithTitle:kWarningTitleText message:kWarningNoStoreText delegate:nil cancelButtonTitle:kSureBtnText otherButtonTitles:nil] show];
        
        return;
    }
    
    if(![self cameraPemission]) {
        [[[UIAlertView alloc] initWithTitle:kWarningTitleText message:kWarningNoCaremaText delegate:nil cancelButtonTitle:kSureBtnText otherButtonTitles:nil] show];
        
        return;
    }
    
    [self qqStyle];
}


#pragma mark - LBXScan Delegate Methods

- (BOOL)cameraPemission {
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
            isHavePemission = YES;
            break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
            break;
            case AVAuthorizationStatusNotDetermined:
            isHavePemission = YES;
            break;
        }
    }
    
    return isHavePemission;
}


#pragma mark - 扫描商品二维码（模仿qq界面）

- (void)qqStyle {
    //设置扫码区域参数设置
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    vc.isQQSimulator = YES;
    vc.isVideoZoom = YES;
    
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
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
