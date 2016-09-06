//
//  DashboardViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//
#define mADVIEWHEIGHT self.view.frame.size.height / 4.5

#import "DashboardViewController.h"
#import "SubjectViewController.h"
#import "Version.h"
#import "NSData+MD5.h"
#import "ViewUtils.h"
#import <SCLAlertView.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "DropTableViewCell.h"
#import "SubLBXScanViewController.h"
#import "UITabBar+Badge.h"
#import "UIButton+SettingBadge.h"
#import "UILabel+Badge.h"
#import "NSString+MD5.h"
#import "WebViewJavascriptBridge.h"

static NSString *const kDropMentScanText     = @"扫一扫";
static NSString *const kDropMentVoiceText    = @"语音播报";
static NSString *const kDropMentSearchText   = @"搜索";
static NSString *const kDropMentUserInfoText = @"个人信息";
static NSString *const kChartSegueIdentifier   = @"DashboardToChartSegueIdentifier";
static NSString *const kSettingSegueIdentifier = @"DashboardToSettingSegueIdentifier";

@interface DashboardViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UINavigationBarDelegate> {
    UIViewController *contentView;
}
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIButton *btnScanCode;
@property (assign, nonatomic) CommentObjectType commentObjectType;
@property (assign, nonatomic) NSInteger objectID;
@property (strong, nonatomic) NSArray *tabBarItemNames;
@property (weak, nonatomic) IBOutlet UIButton *setting;
// 本地通知
@property (nonatomic, strong) NSMutableArray *urlStrings;
@property (strong, nonatomic) NSString *noticeFilePath;
@property (strong , nonatomic) NSMutableDictionary *noticeDict;
@property (nonatomic) BOOL isNeedUpgrade;
@property (assign, nonatomic)BOOL isShowUserInfoNotice;
// 设置按钮点击下拉菜单
@property (nonatomic, strong) NSArray *dropMenuTitles;
@property (nonatomic, strong) NSArray *dropMenuIcons;
@property (nonatomic, strong) UITableView *dropMenu;
// 广告栏
@property (strong, nonatomic) UIWebView *advertWebView;
@property WebViewJavascriptBridge *adBridge;
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    self.tabBarItemNames = @[@"kpi", @"analyse", @"app", @"message"];
    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:kThemeColor]];
    self.browser.frame = CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), self.view.frame.size.width, self.view.frame.size.height - 104);
    [self idColor];
    
    [self initUrlStrings];
    [self initLocalNotifications];
    [self initDropMenu];
    [self loadWebView];
    
    self.btnScanCode.hidden = !kDropMenuScan;
    [self setTabBarItems];
    
    [self receivePushMessageParams];
    [self initTabClick];
    [self setNotificationBadgeTimer];
    
    /*
     * 解屏进入主页面，需检测版本更新
     */
    [self checkFromViewController];
    
    /**
     *  登录或解屏后，密码为初始值时提示:
     *      初始化密码未修改，安全起见，请在【设置】-【个人信息】-【修改密码】页面修改密码。
     */
    [self checkUserModifiedInitPassword];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkPushMessageAction];
    [self checkAssetsUpdate];
    [self showUserInfoRedIcon];
    [self setTabBarHeight];
}


- (void)setTabBarHeight {
    for (NSLayoutConstraint *constraint in self.tabBar.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = [self getTabHeight];
            break;
        }
    }
}

-(int)getTabHeight {
    int bannerHeight =[[UIScreen mainScreen] bounds].size.height < 668 ? 49 : 56;
    return bannerHeight;
}

/**
 *  消息推送点击后操作
 */
- (void)checkPushMessageAction {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if([app.pushMessageDict allKeys].count == 0) {
        return;
    }
    
    NSString *type = [app.pushMessageDict objectForKey:@"type"];
    if ([type isEqualToString:@"report"]) {
        [self performSegueWithIdentifier:kChartSegueIdentifier sender:@{@"link":app.pushMessageDict[@"link"]}];
    }
    app.pushMessageDict = [NSMutableDictionary dictionary];

}

- (void)initTabClick{
    NSInteger tabIndex = self.clickTab > 0 ? self.clickTab : 0;
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:tabIndex]];
    [self tabBarClick: tabIndex];
}

#pragma mark - 通知处理
- (void)receivePushMessageParams {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if([app.pushMessageDict allKeys].count == 0) {
        self.clickTab = -1;
        return;
    }
    
    NSString *type = [app.pushMessageDict objectForKey:@"type"];
    if ([type isEqualToString:@"analyse"]) {
        self.clickTab = 1;
    }
    else if ([type isEqualToString:@"app"]) {
        self.clickTab = 2;
    }
    else if ([type isEqualToString:@"message"]) {
        self.clickTab = 3;
    }
    else if([type isEqualToString:@"report"]){
        self.clickTab = 0;
    }
    else {
        self.clickTab = 0;
    }
}

#pragma mark - 添加广告视图
- (void)addAdvertWebView {
    self.advertWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), self.view.frame.size.width, mADVIEWHEIGHT)];
    self.advertWebView.tag = 1234;
    self.advertWebView.delegate = self;
    self.advertWebView.scalesPageToFit = YES;
    self.advertWebView.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.advertWebView];
    [self loadAdvertView];
    [self clickAdvertisement];
    
    self.browser.frame = CGRectMake(0, CGRectGetMaxY(self.bannerView.frame) + mADVIEWHEIGHT, self.view.frame.size.width, self.view.frame.size.height - 104);
}

#pragma mark - 隐藏广告视图
- (void)hideAdertWebView {
    UIWebView *subViews = [self.view viewWithTag:1234];
    [subViews removeFromSuperview];
    self.browser.frame = CGRectMake(0, 55, self.view.frame.size.width, self.view.frame.size.height - 104);
}

#pragma mark - loadAdvertisement
- (void)loadAdvertView {
    NSString *advertise = [[FileUtils sharedPath] stringByAppendingPathComponent:@"advertisement"];
    NSString *advetisePath = [advertise stringByAppendingPathComponent:@"index_ios.html"];
    if ([FileUtils checkFileExist:advetisePath isDir:YES]) {
        NSString *advertiseContent = [NSString stringWithContentsOfFile:advetisePath encoding:NSUTF8StringEncoding error:nil];
        NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000 + arc4random()];
        advertiseContent = [advertiseContent stringByReplacingOccurrencesOfString:@"TIMESTAMP" withString:timestamp];
        [self.advertWebView loadHTMLString:advertiseContent baseURL:[NSURL URLWithString:advetisePath]];
    }
    else {
        [self hideAdertWebView];
    }
}

#pragma mark - clickAdvertisment
- (void)clickAdvertisement {
    self.adBridge = [WebViewJavascriptBridge bridgeForWebView:self.advertWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"DashboardViewController - ObjC received message from JS: %@", data);
        responseCallback(@"DashboardViewController - Response for message from ObjC");
    }];
    
    [self.adBridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[@"action"] = @"JS异常";
                logParams[@"obj_type"] = @(self.commentObjectType);
                logParams[@"obj_title"] = [NSString stringWithFormat:@"主页面/%@", data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    [self.adBridge registerHandler:@"adLink" handler:^(id data, WVJBResponseCallback responseCallback) {
        if(![self checkAdParams:data containName:@"openType"]) {
            return;
        }
        [self openAdClickLink:data[@"openType"] data:data];
    }];
}


#pragma mark - openAdclickLink 
/**
 *  javascript:
 *  jbridge.callHandler('adLink', {'openType': openType, 'openLink': openLink, 'objectID': objectID, 'objectType': objectType, 'objectTitle': objectTitle},
 *    function(response) {});
 *
 *  @param openType <#openType description#>
 *  @param urlLink  <#urlLink description#>
 */
- (BOOL) checkAdParams:(NSDictionary *)data containName:(NSString *)paramName {
    BOOL isContain = [data.allKeys containsObject:paramName];
    if(!isContain) {
        [ViewUtils showPopupView:self.view Info:[NSString stringWithFormat:@"错误: 未提供参数 `%@`", paramName]];
    }

    return isContain;
}
- (void) openAdClickLink:(NSString *)openType data:(NSDictionary *)data {
    NSString *actionLogTitle = @"";
    NSDictionary *tabIndexDict = @{@"tab_kpi": @0, @"tab_analyse": @1, @"tab_app": @2, @"tab_message": @3};
    
    if ([openType isEqualToString:@"browser"]) {
        if(![self checkAdParams:data containName:@"openLink"]) {
            return;
        }
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:data[@"openLink"]]];
        actionLogTitle = data[@"openLink"];
    }
    else if ([tabIndexDict.allKeys containsObject:openType]) {
        NSInteger tabIndex = [tabIndexDict[openType] integerValue];
        
        [self tabBarClick: tabIndex];
        [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:tabIndex]];
    }
    else if ([openType isEqualToString:@"report"]) {
        if(![self checkAdParams:data containName:@"openLink"]) {
            return;
        }
        if(![self checkAdParams:data containName:@"objectID"]) {
            return;
        }
        if(![self checkAdParams:data containName:@"objectType"]) {
            return;
        }
        if(![self checkAdParams:data containName:@"objectTitle"]) {
            return;
        }
        
        NSDictionary *params = @{@"bannerName": data[@"objectTitle"], @"link": data[@"openLink"], @"objectID": data[@"objectID"]};
        self.commentObjectType = [data[@"objectType"] integerValue];
        [self performSegueWithIdentifier:kChartSegueIdentifier sender:params];
        actionLogTitle = data[@"objectTitle"];
    }
    else {
        [ViewUtils showPopupView:self.view Info:[NSString stringWithFormat:@"错误: 未知openType: `%@`", openType]];
    }
    
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    @try {
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[@"action"] = [NSString stringWithFormat:@"点击广告#%@", openType];
        logParams[@"obj_title"] = actionLogTitle;
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (void)dealloc {
    [self.browser stopLoading];
    [self.browser cleanForDealloc];
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
    self.tabBar.delegate = nil;
    self.tabBar = nil;
}

#pragma mark - init controls

- (void)initUrlStrings {
    self.urlStrings = [NSMutableArray array];
    
    NSString *uiVersion = [self currentUIVersion];
    [self.urlStrings addObject:[NSString stringWithFormat:KPI_PATH, kBaseUrl, uiVersion, self.user.groupID, self.user.roleID]];
    [self.urlStrings addObject:[NSString stringWithFormat:ANALYSE_PATH, kBaseUrl, uiVersion, self.user.roleID]];
    [self.urlStrings addObject:[NSString stringWithFormat:APPLICATION_PATH, kBaseUrl, uiVersion, self.user.roleID]];
    [self.urlStrings addObject:[NSString stringWithFormat:MESSAGE_PATH, kBaseUrl, uiVersion, self.user.roleID, self.user.groupID, self.user.userID]];
}

/**
 *  初始化本地通知
 */
- (void)initLocalNotifications {
    self.noticeFilePath = [FileUtils dirPath:@"Cached" FileName:@"local_notifition.json"];
    if([FileUtils checkFileExist:self.noticeFilePath isDir:NO]) {
        return;
    }
    
    NSDictionary *noticeDict = @{
        @"app": @(-1),
        @"tab_kpi_last": @(-1),
        @"tab_kpi": @(-1),
        @"tab_analyse_last": @(-1),
        @"tab_analyse": @(-1),
        @"tab_app_last": @(-1),
        @"tab_app": @(-1),
        @"tab_message_last": @(-1),
        @"tab_message": @(-1),
        @"setting": @(-1),
        @"setting_pgyer": @(-1),
        @"setting_password": @(-1)
    };
    NSMutableDictionary *noticeCachedDict = [[NSMutableDictionary alloc] initWithDictionary:noticeDict];
    [FileUtils writeJSON:noticeCachedDict Into:self.noticeFilePath];
}

/*
 * 解屏进入主页面，需检测版本更新
 */
- (void)checkFromViewController {
    if(self.fromViewController && [self.fromViewController isEqualToString:@"AppDelegate"]) {
        self.fromViewController = @"AlreadyShow";
        // 检测版本更新
        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
        [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appUpgradeMethod:)];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[@"action"] = @"解屏";
                [APIHelper actionLog:logParams];
                
                /**
                 *  解屏验证用户信息，更新用户权限
                 *  若难失败，则在下次解屏检测时进入登录界面
                 */
                NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
                NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
                if(!userDict[@"user_num"]) {
                    return;
                }
                
                NSString *msg = [APIHelper userAuthentication:userDict[@"user_num"] password:userDict[@"user_md5"]];
                if(msg.length == 0) {
                    return;
                }
                
                userDict[@"is_login"] = @(NO);
                [userDict writeToFile:userConfigPath atomically:YES];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }
}

/**
 *  登录或解屏后，密码为初始值时提示:
 *      初始化密码未修改，安全起见，请在【设置】-【个人信息】-【修改密码】页面修改密码。
 */
- (void)checkUserModifiedInitPassword {
    if(![self.user.password isEqualToString:@"123456".md5]) {
        return;
    }
   
    [ViewUtils simpleAlertView:self Title:@"温馨提示" Message:@"初始化密码未修改，安全起见，请在\n【设置】-【个人信息】-【修改密码】页面修改密码" ButtonTitle:@"知道了"];
}

- (void)loadWebView {
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"DashboardViewController - ObjC received message from JS: %@", data);
        responseCallback(@"DashboardViewController - Response for message from ObjC");
    }];
    
    [self addWebViewJavascriptBridge];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
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
    
    self.dropMenuTitles = [NSArray arrayWithArray:tmpTitles];
    self.dropMenuIcons = [NSArray arrayWithArray:tmpIcons];
}

#pragma mark - UIWebview pull down to refresh
- (void)handleRefresh:(UIRefreshControl *)refresh {
    [self addWebViewJavascriptBridge];
    
    [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
    [self loadHtml];
    [refresh endRefreshing];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[@"action"] = @"刷新/主页面/浏览器";
        logParams[@"obj_title"] = self.urlString;
        [APIHelper actionLog:logParams];
    });
}

/**
 *  标签栏及标签项显示隐藏设置
 */
- (void)setTabBarItems {
    if(!kTabBar) {
        NSLayoutConstraint *heightConstraint;
        for (NSLayoutConstraint *constraint in self.tabBar.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                heightConstraint = constraint;
                break;
            }
        }
        
        heightConstraint.constant = 0;
        self.tabBar.hidden = !kTabBar;
        
        return;
    }
    
    NSArray *allItems = self.tabBar.items;
    NSMutableArray *displayItems = [NSMutableArray array];
    
    if(kTabBarKPI) {
        [displayItems addObject:allItems[0]];
    }
    
    if(kTabBarAnalyse) {
        [displayItems addObject:allItems[1]];
    }
    
    if(kTabBarApp) {
        [displayItems addObject:allItems[2]];
    }
    
    if(kTabBarMessage) {
        [displayItems addObject:allItems[3]];
    }
    
    self.tabBar.items = displayItems;
}

- (void)addWebViewJavascriptBridge {
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[@"action"] = @"JS异常";
                logParams[@"obj_type"] = @(self.commentObjectType);
                logParams[@"obj_title"] = [NSString stringWithFormat:@"主页面/%@", data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    [self.bridge registerHandler:@"refreshBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
        
        [self loadHtml];
    }];
    
    [self.bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self performSegueWithIdentifier:kChartSegueIdentifier sender:@{@"bannerName": data[@"bannerName"], @"link": data[@"link"], @"objectID": data[@"objectID"]}];
    }];
    
    [self.bridge registerHandler:@"dashboardDataCount" handler:^(id data, WVJBResponseCallback responseCallback) {
        // NSString *tabType = data[@"tabType"];
        // NSNumber *dataCount = data[@"dataCount"];
    }];
    
    [self.bridge registerHandler:@"pageTabIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *tabIndexConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:TABINDEX_CONFIG_FILENAME];
        NSMutableDictionary *tabIndexDict = [FileUtils readConfigFile:tabIndexConfigPath];
        
        NSString *action = data[@"action"], *pageName = data[@"pageName"];
        NSNumber *tabIndex = data[@"tabIndex"];
        
        if([action isEqualToString:@"store"]) {
            tabIndexDict[pageName] = tabIndex;
            
            [tabIndexDict writeToFile:tabIndexConfigPath atomically:YES];
        }
        else if([action isEqualToString:@"restore"]) {
            tabIndex = tabIndexDict[pageName] ?: @(0);
            
            responseCallback(tabIndex);
        }
        else {
            NSLog(@"unkown action %@", action);
        }
    }];
}

#pragma mark - assistant methods

- (void)loadHtml {
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        [self _loadHtml];
    }
    else if(deviceState == StateForbid) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"知道了" actionBlock:^(void) {
            [self jumpToLogin];
        }];
        
        [alert showError:self title:@"温馨提示" subTitle:@"您被禁止在该设备使用本应用" closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)_loadHtml {
    // [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
        
        __block NSString *htmlPath;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:URL_WRITE_LOCAL];
        }
        else {
            NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
            htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *htmlContent = [self stringWithContentsOfFile:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
            
            [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(enableTabBar) userInfo:nil repeats:NO];
        });
    });
}

#pragma mark - action methods

/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender <#sender description#>
 */
-(void)dropTableView:(UIButton *)sender {
    contentView=[[UIViewController alloc]init];
    //contentView.view.frame = CGRectMake(self.view.frame.size.width - 150, 40, 150, 200);
    contentView.modalPresentationStyle = UIModalPresentationPopover;
    [contentView setPreferredContentSize:CGSizeMake(self.view.frame.size.width / 2.5, 150 / 4 * self.dropMenuTitles.count)];
    self.dropMenu = [[UITableView alloc] initWithFrame:contentView.view.frame style:UITableViewStylePlain];
    self.dropMenu.dataSource = self;
    self.dropMenu.delegate = self;
    self.dropMenu.scrollEnabled = NO;
    self.dropMenu.backgroundColor = [UIColor clearColor];
    self.dropMenu.separatorColor = [UIColor whiteColor];
    self.dropMenu.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.dropMenu.layoutMargins = UIEdgeInsetsZero;
    self.dropMenu.separatorInset = UIEdgeInsetsZero;
    // contentView.view.backgroundColor = [UIColor colorWithHexString:@"31809f"];
    
    [contentView.view addSubview:self.dropMenu];
    UIPopoverPresentationController *popover = [contentView popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.delegate = self;
    [popover setSourceRect:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 12, sender.frame.size.width, sender.frame.size.height)];
    //popover.barButtonItem=self.navigationItem.rightBarButtonItem;
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:@"31809f"];
    [self presentViewController:contentView animated:YES completion:nil];
}

- (IBAction)actionPerformSettingView:(UIButton *)sender {
    [self dropTableView:sender];
}

- (IBAction)actionBarCodeScanView:(UIButton *)sender {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(!userDict[@"store_ids"] || [userDict[@"store_ids"] count] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您无门店权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        
        return;
    }
    
    if(![self cameraPemission]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像机权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        
        return;
    }
    
    [self qqStyle];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    
    if([segue.identifier isEqualToString:kChartSegueIdentifier]) {
        SubjectViewController *subjectViewController = (SubjectViewController *)segue.destinationViewController;
        subjectViewController.bannerName        = sender[@"bannerName"];
        subjectViewController.link              = sender[@"link"];
        subjectViewController.objectID          = sender[@"objectID"];
        subjectViewController.commentObjectType = self.commentObjectType;
        
        logParams[@"action"] = @"点击/主页面/浏览器";
        logParams[@"obj_id"] = sender[@"objectID"];
        logParams[@"obj_type"] = @(self.commentObjectType);
        logParams[@"obj_title"] = sender[@"bannerName"];
        
    }
    else if([segue.identifier isEqualToString:kSettingSegueIdentifier]) {
        logParams[@"action"] = @"点击/主页面/设置";
    }
    
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
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

#pragma mark - UIWebview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    /**
     *  忽略 NSURLErrorDomain 错误 - 999
     */
    if([error code] == NSURLErrorCancelled) {
        return;
    }
    
    NSLog(@"dvc: %@", error.description);
}

#pragma mark - UITabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self tabBarClick:item.tag];
}

- (void)tabBarClick:(NSInteger)index {
    // index == 0 ? [self addAdvertWebView] : [self hideAdertWebView];
    [self.tabBar displayBadgeOnItemIndex:index orNot:YES];
    NSString *uiVersion = [self currentUIVersion];
    switch (index) {
        case 0: {
            self.urlString = [NSString stringWithFormat:KPI_PATH, kBaseUrl, uiVersion, self.user.groupID, self.user.roleID];
            self.commentObjectType = ObjectTypeKpi;
            break;
        }
        case 1: {
            self.urlString = [NSString stringWithFormat:ANALYSE_PATH, kBaseUrl, uiVersion, self.user.roleID];
            self.commentObjectType = ObjectTypeAnalyse;
            break;
        }
        case 2: {
            self.urlString = [NSString stringWithFormat:APPLICATION_PATH, kBaseUrl, uiVersion, self.user.roleID];
            self.commentObjectType = ObjectTypeApp;
            break;
        }
        case 3: {
            self.urlString = [NSString stringWithFormat:MESSAGE_PATH, kBaseUrl, uiVersion, self.user.roleID, self.user.groupID, self.user.userID];
            self.commentObjectType = ObjectTypeMessage;
            break;
        }
        default: {
            self.urlString = [NSString stringWithFormat:KPI_PATH, kBaseUrl, uiVersion, self.user.roleID, self.user.groupID];
            self.commentObjectType = ObjectTypeReport;
            break;
        }
    }
    
    [self tabBarState: NO];
    [self loadHtml];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"点击/主页面/标签栏";
            logParams[@"obj_type"] = @(self.commentObjectType);
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}

- (void)enableTabBar {
    [self tabBarState:YES];
}

- (void)tabBarState:(BOOL)state {
    for(UITabBarItem *item in self.tabBar.items) {
        item.enabled = state;
    }
}

# pragma mark - 不支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

# pragma mark - UITableView Delgate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    if (indexPath.row == 3 ) {
        if ([self.noticeDict[@"setting"] isEqualToNumber:@(2)]) {
            [cell.tittleLabel showRedIcon];
            return cell;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150 / 4;
}

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
            [self performSegueWithIdentifier:kSettingSegueIdentifier sender:nil];
        }
    }];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - show userInfoNotification
- (BOOL) showUserInfoRedIcon {
    self.noticeDict = [FileUtils readConfigFile:self.noticeFilePath];
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    NSString *virgiPassword = @"123456";
    if ([userDict[@"user_md5"] isEqualToString:virgiPassword.md5]) {
        self.noticeDict[@"setting_password"] = @(1);
        [FileUtils writeJSON:self.noticeDict Into:self.noticeFilePath];
    }
    self.isNeedUpgrade = NO;
    if (self.isNeedUpgrade) {
        self.noticeDict[@"setting_pgyer"] = @(1);
    }
    else {
        self.noticeDict[@"setting_pgyer"] = @(-1);
    }
    [FileUtils writeJSON:self.noticeDict Into:self.noticeFilePath];
    if (self.isNeedUpgrade || [userDict[@"user_md5"] isEqualToString:virgiPassword.md5]) {
        self.noticeDict[@"setting"] = @(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.setting showRedIcon];
        });
        return YES;
    }
    else {
        return NO;
    }
}

# pragma mark - assitant methods
/**
  *  内容检测版本升级，判断版本号是否为偶数。以便内测
  *
  *  @param response <#response description#>
  */
- (void)appUpgradeMethod:(NSDictionary *)response {
    if(!response || !response[@"downloadURL"] || !response[@"versionCode"] || !response[@"versionName"]) {
        // [ViewUtils showPopupView:self.view Info:@"未检测到更新"];
        self.isNeedUpgrade = NO;
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
        return;
    }
    
    Version *version = [[Version alloc] init];
    BOOL isPgyerLatest = [version.current isEqualToString:response[@"versionName"]] && [version.build isEqualToString:response[@"versionCode"]];
    if (isPgyerLatest && [response[@"versionCode"] integerValue] > currentVersionCode) {
        self.isNeedUpgrade = YES;
    }
    if(!isPgyerLatest && [response[@"versionCode"] integerValue] % 2 == 0) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert addButton:@"升级" actionBlock:^(void) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
        }];
        
        NSString *subTitle = [NSString stringWithFormat:@"更新到版本: %@(%@)", response[@"versionName"], response[@"versionCode"]];
        [alert showSuccess:self title:@"版本更新" subTitle:subTitle closeButtonTitle:@"放弃" duration:0.0f];
    }
    
    [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
}

#pragma mark - 本地通知，样式加载
- (void)setNotificationBadgeTimer {
//    NSTimeInterval period = 10.0;
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, period * NSEC_PER_SEC, 0);
//    dispatch_source_set_event_handler(timer, ^{
//        [self extractDataCountFromUrlStrings];
//    });
//    
//    dispatch_resume(timer);
    
    [NSTimer scheduledTimerWithTimeInterval:60 * 15 target:self selector:@selector(extractDataCountFromUrlStrings) userInfo:nil repeats:YES];
}

- (void)extractDataCountFromUrlStrings {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString;
        HttpResponse *httpResponse;
        for (NSInteger index = 0, len = self.urlStrings.count; index < len; index ++) {
            urlString = self.urlStrings[index];
            httpResponse = [HttpUtils checkResponseHeader:urlString assetsPath:self.assetsPath];
            
            if ([httpResponse.statusCode isEqualToNumber:@(200)]) {
                [HttpUtils urlConvertToLocal:urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:URL_WRITE_LOCAL];
                [self extractDataCountFromHtmlContent:httpResponse.string Index:index];
                 [self setLocalNotifications];
            }
        }
    });
}

- (void)extractDataCountFromHtmlContent:(NSString *)htmlContent Index:(NSInteger)index {
    NSString *scriptContent;
    NSRange range = [htmlContent rangeOfString:@"<script>[\\s\\S]+<\\/script>" options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        return;
    }
    
    scriptContent = [htmlContent substringWithRange:range];
    NSRange range2 = [scriptContent rangeOfString:@"\\bMobileBridge.setDashboardDataCount.+" options:NSRegularExpressionSearch];
    if (range2.location == NSNotFound) {
        return;
    }
    
    NSRange range3 = [[scriptContent substringWithRange:range2] rangeOfString:@"\\(.+\\)" options:NSRegularExpressionSearch];
    NSArray  *noticeArray = [[[scriptContent substringWithRange:range2] substringWithRange:range3] componentsSeparatedByString:@","];
    NSString *keyString1 = [noticeArray[0] substringFromIndex:2];
    NSString *keyString = [keyString1 substringToIndex:keyString1.length - 1];
    NSString *valueString = [noticeArray[1] substringToIndex:[noticeArray[1] length] - 1];
    NSLog(@"得出的结果字符串为 %@ %@",keyString, valueString);
    if (valueString == nil || [valueString integerValue] < 0) {
        return;
    }
    
    /**
     *  - 如果 `tab_*_last = -1` 时，表示第一次加载， `tab_*_last = dataCount; tab_* = 0`
     *  - 如果 `tab_*_last > 0 && tab_*_last != dataCount`
     *      - 显示通知样式
     *      - `tab_* = abs(dataCount - tab_*_last); tab_*_last = dataCount`
     */
    NSInteger dataCount = [valueString integerValue];
    NSString *keyWord = [NSString stringWithFormat:@"tab_%@", self.tabBarItemNames[index]];
    NSString *lastKeyWord = [NSString stringWithFormat:@"%@_last", keyWord];
    
    NSMutableDictionary *noticeDict = [FileUtils readConfigFile:self.noticeFilePath];
    if ([noticeDict[lastKeyWord] integerValue] == -1) {
        noticeDict[keyWord] = @(0);
    }
    else if ([noticeDict[lastKeyWord] integerValue] > 0 && [noticeDict[lastKeyWord] integerValue] != [noticeDict[keyWord] integerValue]) {
        noticeDict[keyWord] = @(labs([noticeDict[keyWord] integerValue] - [noticeDict[lastKeyWord] integerValue]));
    }
    noticeDict[lastKeyWord] = @(dataCount);
    
    [FileUtils writeJSON:noticeDict Into:self.noticeFilePath];
}

- (void)setLocalNotifications {
    NSMutableDictionary *noticeDict = [FileUtils readConfigFile:self.noticeFilePath];
    
    if ([noticeDict[@"app"] intValue] > 0) {
        UIApplication *application = [UIApplication sharedApplication];
        application.applicationIconBadgeNumber = [noticeDict[@"app"] integerValue];
    }
    
    NSString *keyWord, *lastKeyWord;
    NSInteger dataCount = 0;
    for (NSInteger index = 0, len = self.tabBarItemNames.count; index < len; index ++) {
        keyWord = [NSString stringWithFormat:@"tab_%@", self.tabBarItemNames[index]];
        lastKeyWord = [NSString stringWithFormat:@"%@_last", keyWord];
        dataCount = [noticeDict[keyWord] integerValue];
        
        if (dataCount <= 0) {
            continue;
        }
  
        BOOL isCurrentSelectedItem = self.tabBar.selectedItem.tag == index;
        [self displayTabBarBadgeOnItemIndex:index orNot:isCurrentSelectedItem];
        // [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    }
}

- (void)displayTabBarBadgeOnItemIndex:(NSInteger)index orNot:(BOOL)isOrNot {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tabBar displayBadgeOnItemIndex:index orNot:isOrNot];
    });
}

@end
