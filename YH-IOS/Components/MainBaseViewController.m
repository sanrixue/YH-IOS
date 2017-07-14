//
//  MainBaseViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MainBaseViewController.h"
#import "LoginViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>
#import "AppDelegate.h"
#import "AFNetworking.h"
#import <SSZipArchive.h>
#import "Version.h"
#import "DropViewController.h"
#import "DropTableViewCell.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "NewSettingViewController.h"
#import "SettingViewController.h"
#import "HomeIndexVC.h"
#import "HomeIndexModel.h"
#import "CommonMenuView.h"
#import "ThurSayViewController.h"
#import "ResetPasswordViewController.h"
#import "UIColor+Hex.h"
#import <Reachability/Reachability.h>


@interface MainBaseViewController ()<LTHPasscodeViewControllerDelegate,UINavigationControllerDelegate,DropViewDataSource,DropViewDelegate>
@property (nonatomic, copy) NSMutableArray* menuArray;
@property (nonatomic, assign) NSInteger curLineNum;
@property (nonatomic, strong) CommonMenuView* menuView;
@property (strong, nonatomic) NSString *localNotificationPath;
@property (strong, nonatomic) NSArray *localNotificationKeys;
@end

@implementation MainBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Banner-Logo"]];
    imageView.contentMode =UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.frame = CGRectMake(self.view.frame.size.width/2-50, 0, 100, 50);
    [self.navigationController.navigationBar addSubview:imageView];
    self.user = [[User alloc] init];
    [self initDropMenu];
   // [self checkFromViewController];
    self.localNotificationKeys = @[kTabKPILNName, kTabAnalyseLNName, kTabAppLNName, kTabMessageLNName, kSettingThursdaySayLNName];
    self.localNotificationPath = [FileUtils dirPath:kConfigDirName FileName:kLocalNotificationConfigFileName];
   // self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    //[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [self idColor];

    //@{}代表Dictionary
   // [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.sharedPath = [FileUtils sharedPath];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:kHTMLDirName];
    }
  //  [CommonMenuView clearMenu]; // 清除window菜单
   // [self getHomemenuView]; //重新生成菜单
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Barcode-Scan-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(dropTableView:)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   // [self noteToChangePwd];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remotePushJump:) name:@"remotepush" object:nil];
    [LTHPasscodeViewController sharedUser].delegate = self;
}

- (void)idColor {
    UIView* idView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50,34, 30, 10)];
   //idView.backgroundColor = [UIColor redColor];
    [self.navigationController.navigationBar addSubview:idView];
    
    UIImageView* idColor0 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 4, 4)];
    idColor0.layer.cornerRadius = 2;
    [idView addSubview:idColor0];
    
    UIImageView* idColor1 = [[UIImageView alloc]initWithFrame:CGRectMake(6, 1, 4, 4)];
    idColor1.layer.cornerRadius = 1;
    [idView addSubview:idColor1];
    
    UIImageView* idColor2 = [[UIImageView alloc]initWithFrame:CGRectMake(12, 1, 4, 4)];
    idColor2.layer.cornerRadius = 1;
    [idView addSubview:idColor2];
    
    UIImageView* idColor3 = [[UIImageView alloc]initWithFrame:CGRectMake(18, 1, 4, 4)];
    idColor3.layer.cornerRadius = 1;
    [idView addSubview:idColor3];
    
    UIImageView* idColor4 = [[UIImageView alloc]initWithFrame:CGRectMake(24, 1, 4, 4)];
    idColor4.layer.cornerRadius = 1;
    [idView addSubview:idColor4];
    
    
    NSArray *colors = @[@"00ffff", @"ffcd0a", @"fd9053", @"dd0929", @"016a43", @"9d203c", @"093db5", @"6a3906", @"192162", @"000000"];
    
    NSArray *colorViews = @[idColor0, idColor1, idColor2, idColor3, idColor4];
    NSString *userID = [NSString stringWithFormat:@"%@", self.user.userID];
    
    NSString *color;
    NSInteger userIDIndex, numDiff = colorViews.count - userID.length;
    UIImageView *imageView;
    
    numDiff = numDiff < 0 ? 0 : numDiff;
    for(NSInteger i = 0; i < colorViews.count; i++) {
        color = colors[0];
        if(i >= numDiff) {
            userIDIndex = [[NSString stringWithFormat:@"%c", [userID characterAtIndex:i-numDiff]] integerValue];
            color = colors[userIDIndex];
        }
        imageView = colorViews[i];
        imageView.image = [self imageWithColor:[UIColor colorWithHexString:color] size:CGSizeMake(5.0, 5.0)];
        imageView.layer.cornerRadius = 2.5f;
        imageView.layer.masksToBounds = YES;
        imageView.hidden = NO;
    }
    
}

- (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
    [color setFill];
    [rPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (BOOL)shouldAutorotate
{
    return YES;
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/** 展示菜单 */
/*
- (void)showMenu:(UIButton*)sender{
    self.menuArray = [self getHomemenuArray];
    self.menuView = [self getHomemenuView];
    [CommonMenuView showMenuAtPoint:CGPointMake(sender.centerX, sender.bottom+10)];
}

- (NSMutableArray *)getHomemenuArray{
      NSMutableArray* menuArray = [[NSMutableArray alloc]init];
        if (kDropMentScanText) {
            NSDictionary *dict1 = @{@"imageName" :@"DropMenu-Scan",
                                    @"itemName" : kDropMentScanText
                                    };
            [menuArray addObject:dict1];
        }
        if (kDropMentVoiceText) {
            NSDictionary *dict2 = @{@"imageName" : @"DropMenu-Voice",
                                    @"itemName" : kDropMentVoiceText
                                    };
            [menuArray addObject:dict2];
        }
        if (kDropMentSearchText) {
            NSDictionary *dict3 = @{@"imageName" : @"DropMenu-Search",
                                    @"itemName" :kDropMentSearchText
                                    };
            [menuArray addObject:dict3];
        }
        if (kDropMenuUserInfo) {
            NSDictionary *dict4 = @{@"imageName" : @"DropMenu-UserInfo",
                                    @"itemName" : kDropMentUserInfoText
                                    };
            [menuArray addObject:dict4];
        }
    return menuArray;
}

- (CommonMenuView *)getHomemenuView{
    self.menuArray = [self getHomemenuArray];
        MJWeakSelf;
       CommonMenuView* menuView = [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:self.menuArray itemsClickBlock:^(NSString *str, NSInteger tag) {
            [weakSelf menuActionTitle:str];
        } backViewTap:^{
            
        }];
    menuView.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    return menuView;
}

#pragma mark - 处理菜单点击
- (void)menuActionTitle:(NSString*)title{
    [CommonMenuView hidden];
    if([title isEqualToString:kDropMentScanText]) {
        [self actionBarCodeScanView:nil];
    }
    else if([title isEqualToString:kDropMentVoiceText]) {
        [ViewUtils showPopupView:self.view Info:@"功能开发中，敬请期待"];
    }
    else if([title isEqualToString:kDropMentSearchText]) {
        [ViewUtils showPopupView:self.view Info:@"功能开发中，敬请期待"];
    }
    else if([title isEqualToString:kDropMentUserInfoText]) {
        NewSettingViewController *settingViewController = [[NewSettingViewController alloc]init];
        UINavigationController *userInfoViewControlller = [[UINavigationController alloc]initWithRootViewController:settingViewController];
        [self presentViewController:userInfoViewControlller animated:YES completion:nil];
    }
    
}
*/

/*
 * 解屏进入主页面，需检测版本更新
 
- (void)checkFromViewController {
   // if(self.fromViewController && [self.fromViewController isEqualToString:@"AppDelegate"]) {
       // self.fromViewController = @"AlreadyShow";
        // 检测版本更新
        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
        [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appToUpgradeMethod:)];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
 
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName] = @"解屏";
                [APIHelper actionLog:logParams];
                
                /**
                 *  解屏验证用户信息，更新用户权限
                 *  若难失败，则在下次解屏检测时进入登录界面
 
                NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
                NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
                if(!userDict[kUserNumCUName]) {
                    return;
                }
                
                NSString *msg = [APIHelper userAuthentication:userDict[kUserNumCUName] password:userDict[kPasswordCUName]];
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
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[kDownloadURLCPCName]]];
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[kDownloadURLCPCName]] options:@{} completionHandler:nil];
                [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
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
*/
// 远程推送处理
-(void)remotePushJump:(NSNotification*)notification{
    NSDictionary* userinfo = notification.userInfo;
    NSArray* remoteMessageType = @[@"kpi",@"analyse",@"app",@"message",@"thursday_say",@"report"];
    NSUInteger index = [remoteMessageType indexOfObject:userinfo[@"type"]];
    switch (index) {
        case 0:
            self.tabBarController.selectedIndex = 0;
            break;
        case 1:
            self.tabBarController.selectedIndex = 1;
            break;
        case 2:
            self.tabBarController.selectedIndex = 2;
            break;
        case 3:
            self.tabBarController.selectedIndex = 3;
            break;
        case 4:
            [self jumpToThursday];
            break;
        case 5:
            [self jumptoReport:userinfo[@"url"] reportTitle:userinfo[@"title"]];
            break;
        default:
            break;
    }
    
}

-(void)jumpToThursday{
    ThurSayViewController *thurSayView = [[ThurSayViewController alloc]init];
    thurSayView.title = @"更新日志";
    [self.navigationController pushViewController:thurSayView animated:YES];
}

-(void)jumptoReport:(NSString*)reportLink reportTitle:(NSString*)title{
    if ([reportLink isEqualToString:@""]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"该功能正在开发中"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
        subjectView.bannerName = title;
        subjectView.link = reportLink;
        //subjectView.objectID = data[@"objectID"];
        if ([reportLink rangeOfString:@"template/3/"].location != NSNotFound) {
            NSArray * models = [HomeIndexModel homeIndexModelWithJson:nil withUrl:reportLink];
            HomeIndexVC *vc = [[HomeIndexVC alloc] init];
            vc.dataLink = reportLink;
            vc.bannerTitle = title;
            [vc setWithHomeIndexArray:models];
            UINavigationController *rootchatNav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:rootchatNav animated:YES completion:nil];
        }
        else if ([reportLink rangeOfString:@"template/5/"].location != NSNotFound) {
            SuperChartVc *superChaerCtrl = [[SuperChartVc alloc]init];
            superChaerCtrl.bannerTitle = title;
            superChaerCtrl.dataLink =reportLink;
            UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
            [self presentViewController:superChartNavCtrl animated:YES completion:nil];
        }
        else{ //跳转事件
            [self.navigationController presentViewController:subjectView animated:YES completion:nil];
        }
    }
    
}

// 提示用户更改密码
-(void)NoteToChangePassword{
   NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
   NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (NSArray *)urlTofilename:(NSString *)url suffix:(NSString *)suffix {
    NSArray *blackList = @[@".", @":", @"/", @"?"];
    
    url = [url stringByReplacingOccurrencesOfString:kBaseUrl withString:@""];
    NSArray *parts = [url componentsSeparatedByString:@"?"];
    
    NSString *timestamp = nil;
    if([parts count] > 1) {
        url = parts[0];
        timestamp = parts[1];
    }
    
    
    if([url hasSuffix:suffix]) {
        url = [url stringByDeletingPathExtension];
    }
    
    while([url hasPrefix:@"/"]) {
        url = [url substringWithRange:NSMakeRange(1,url.length-1)];
    }
    
    for(NSString *str in blackList) {
        url = [url stringByReplacingOccurrencesOfString:str withString:@"_"];
    }
    
    if(![url hasSuffix:suffix]) {
        url = [NSString stringWithFormat:@"%@%@", url, suffix];
    }
    
    NSArray *result = [NSArray array];
    if(timestamp) {
        result = @[url, timestamp];
    }
    else {
        result = @[url];
    }
    
    return result;
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

#pragma mark - action methods

/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender
 */
-(void)dropTableView:(UIBarButtonItem *)sender {
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
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
    [self presentViewController:dropTableViewController animated:YES completion:nil];
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

# pragma mark - UITableView Delgate
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dropMenuTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dropMenuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dorpcell"];
    if (!cell) {
        cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dorpcell"];
    }
    cell.tittleLabel.text = self.dropMenuTitles[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:self.dropMenuIcons[indexPath.row]];
    
    UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
    cellBackView.backgroundColor = [UIColor darkGrayColor];
    cell.selectedBackgroundView = cellBackView;
    cell.tittleLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150 / 4;
}
*/

#pragma mark - action methods

/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender
 */
/*
-(void)dropTableView{
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, 150, 150);
    dropTableViewController.modalPresentationStyle = UIModalPresentationPopover;
    dropTableViewController.view.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    //dropTableViewController.dropTableView.delegate = self;
    //dropTableViewController.dropTableView.dataSource =self;
    dropTableViewController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 150, 150);
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
   // popover.delegate = self;
   // popover.barButtonItem = self.navigationItem.rightBarButtonItem;
    [popover setSourceRect:self.navigationItem.rightBarButtonItem.customView.frame];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    
    [self presentViewController:dropTableViewController animated:YES completion:nil];
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *itemName = self.dropMenuTitles[indexPath.row];
        
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
         else if([itemName isEqualToString:@"原生报表"]) {
             NSArray * models = [HomeIndexModel homeIndexModelWithJson:nil withUrl:nil];
             HomeIndexVC *vc = [[HomeIndexVC alloc] init];
             [vc setWithHomeIndexArray:models];
             [self presentViewController:vc animated:YES completion:nil];
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


- (void)clearBrowserCache {
    [self.browser stopLoading];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *domain = [[NSURL URLWithString:self.urlString] host];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:domain]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

- (void)showLoading:(LoadingType)loadingType {
    NSString *loadingPath = [FileUtils loadingPath:loadingType];
    NSString *loadingContent = [NSString stringWithContentsOfFile:loadingPath encoding:NSUTF8StringEncoding error:nil];
    [self.browser loadHTMLString:loadingContent baseURL:[NSURL fileURLWithPath:loadingPath]];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void)showProgressHUD:(NSString *)text {
    [self showProgressHUD:text mode:MBProgressHUDModeIndeterminate];
}

- (void)showProgressHUD:(NSString *)text mode:(MBProgressHUDMode)mode {
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.browser animated:YES];
    self.progressHUD.labelText = text;
    self.progressHUD.mode = mode;
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
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

#pragma mark - status bar settings
//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"收到IOS系统，内存警告.");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"警告/内存";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}

/**
 *  设置是否允许横屏
 *
 *  @param allowRotation 允许横屏
 */
- (void)setAppAllowRotation:(BOOL)allowRotation {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = allowRotation;
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
    op = [self checkAssetUpdate:kIconsAssetsName info:@"图标库" isInAssets: NO];
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

#pragma mark - LTHPasscodeViewControllerDelegate methods

- (void)passcodeWasEnteredSuccessfully {
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
             */
            NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
            NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
            if(!userDict[kUserNumCUName]) {
                return;
            }
            
            NSString *userlocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERLOCATION"];
            NSString *msg = [APIHelper userAuthentication:userDict[kUserNumCUName] password:userDict[kPasswordCUName] coordinate:userlocation];
            if(msg.length > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self jumpToLogin];
                });
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}


- (BOOL)didPasscodeTimerEnd {
    return YES;
}
- (NSString *)passcode {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if([userDict[kIsLoginCUName] boolValue] && [userDict[kIsUseGesturePasswordCUName] boolValue]) {
        return userDict[kGesturePasswordCUName] ?: @"";
    }
    return @"";
}

- (void)savePasscode:(NSString *)passcode {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[kIsUseGesturePasswordCUName] = @(YES);
    userDict[kGesturePasswordCUName] = passcode;
    [userDict writeToFile:userConfigPath atomically:YES];
    
    NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
    [userDict writeToFile:settingsConfigPath atomically:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIHelper screenLock:userDict[kUserDeviceIDCUName] passcode:passcode state:YES];
    });
    
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"设置锁屏";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}


@end
