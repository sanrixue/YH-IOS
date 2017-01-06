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
#import "DropViewController.h"
#import "ThurSayViewController.h"
#import "LoadingView.h"
#import <Reachability/Reachability.h>


static NSString *const kSubjectSegueIdentifier = @"DashboardToChartSegueIdentifier";
static NSString *const kSettingSegueIdentifier = @"DashboardToSettingSegueIdentifier";

static NSString *const kBannerNameSubjectColumn = @"bannerName";
static NSString *const kLinkSubjectColumn       = @"link";
static NSString *const kObjIDSubjectColumn      = @"objectID";
static NSString *const kObjTypeSubjectColumn    = @"objectType";

@interface DashboardViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UINavigationBarDelegate> {
    UIViewController *contentView;
    NSDictionary *betaDict;
}
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIButton *btnScanCode;
@property (assign, nonatomic) CommentObjectType commentObjectType;
@property (assign, nonatomic) NSInteger objectID;
@property (weak, nonatomic) IBOutlet UIButton *setting;
// 本地通知
@property (nonatomic, strong) NSMutableArray *urlStrings;
@property (strong, nonatomic) NSArray *localNotificationKeys;
@property (strong, nonatomic) NSString *localNotificationPath;
@property (assign, nonatomic) BOOL isShowUserInfoNotice;
@property (strong, nonatomic) dispatch_source_t timer;
// 设置按钮点击下拉菜单
@property (nonatomic, strong) NSArray *dropMenuTitles;
@property (nonatomic, strong) NSArray *dropMenuIcons;
@property (nonatomic, strong) UITableView *dropMenu;
// 广告栏
@property (strong, nonatomic) UIWebView *advertWebView;
@property WebViewJavascriptBridge *adBridge;
@property (strong, nonatomic) NSString *behaviorPath;
@property (strong, nonatomic) NSMutableDictionary *behaviorDict;
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:kThemeColor]];
    [self idColor];
    self.advertWebView.tag = 1234;
    //self.browser.scrollView.showsVerticalScrollIndicator = NO;
    //LoadingView *loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(100,80, 150, 150)];
    //[self.view addSubview:loadingView];
    //[loadingView showHub];
    
    self.bannerView.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    self.labelTheme.textColor = [UIColor colorWithHexString:kBannerTextColor];
    
    self.localNotificationKeys = @[kTabKPILNName, kTabAnalyseLNName, kTabAppLNName, kTabMessageLNName, kSettingThursdaySayLNName];
    self.localNotificationPath = [FileUtils dirPath:kConfigDirName FileName:kLocalNotificationConfigFileName];
    self.behaviorPath = [FileUtils dirPath:kConfigDirName FileName:kBehaviorConfigFileName];
    
    [self initUrlStrings];
    [self initLocalNotifications];
    [self initDropMenu];
    [self loadWebView];
    
    self.btnScanCode.hidden = !kDropMenuScan;
    [self setTabBarItems];
    [self initTabClick];
    
    /**
     *  广告位隐藏于否
     */
    if(!kDashboardAd) { [self hideAdertWebView]; }
    
    [self checkAssetsUpdate];
    [self setTabBarHeight];
    
    /*
     * 解屏进入主页面，需检测版本更新
     */
    [self checkFromViewController];
    
    /**
     *  登录或解屏后，密码为初始值时提示:
     *      初始化密码未修改，安全起见，请在【设置】-【个人信息】-【修改密码】页面修改密码。
     */
    [self checkUserModifiedInitPassword];
    
    /**
     *  生命周期内仅执行一次
     */
    [self receiveLocalNotification];
}


- (void)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 2;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     betaDict = [FileUtils readConfigFile:[FileUtils dirPath:kConfigDirName FileName:kBetaConfigFileName]];
    if (!([betaDict[@"allow_brower_copy"] boolValue]) && !(self.tabBar.selectedItem.tag == 3)) {
        [self.browser stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
        [self.browser stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    }
    [self checkPushMessageAction];
}

- (void)setTabBarHeight {
    for (NSLayoutConstraint *constraint in self.tabBar.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = kTabBarHeight;
            break;
        }
    }
}

#pragma mark - 本地通知状态，定时刷新
- (void)receiveLocalNotification {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self setNotificationBadgeTimer];
    });
}

#pragma mark - 推送消息点击后的响应处理
/**
 *  消息推送点击后操作 
 *
     { // 服务器参数
         type: report,
         title: '16年第三季度季报'
         url: 'report-link’, // 与 API 链接格式相同
         obj_id: 1,
         obj_type: 1
     },
     state: true_or_false // 接收参数时设置为 `false`
 */
- (void)checkPushMessageAction {
    NSString *pushMessagePath = [[FileUtils basePath] stringByAppendingPathComponent:kPushMessageFileName];
    NSMutableDictionary *pushMessageDict = [FileUtils readConfigFile:pushMessagePath];
    if([pushMessageDict allKeys].count == 0 || [pushMessageDict[kStatePushColumn] boolValue]) {
        return;
    }
    
    NSInteger tabIndex = -1;
    NSString *pushType = pushMessageDict[kTypePushColumn];
    if ([pushType isEqualToString:kTypeReportPushColumn]) {
        [self performSegueWithIdentifier:kSubjectSegueIdentifier sender:@{
            kBannerNameSubjectColumn: pushMessageDict[kTitlePushColumn],
            kLinkSubjectColumn: pushMessageDict[kLinkPushColumn],
            kObjIDSubjectColumn: pushMessageDict[kObjIDPushColumn],
            kObjTypeSubjectColumn: pushMessageDict[kObjTypePushColumn]
        }];
    }
    else if ([pushType isEqualToString:kTypeKPIPushColumn]) {
        tabIndex = 0;
    }
    else if ([pushType isEqualToString:kTypeAnalysePushColumn]) {
        tabIndex = 1;
    }
    else if ([pushType isEqualToString:kTypeAppPushColumn]) {
        tabIndex = 2;
    }
    else if ([pushType isEqualToString:kTypeMessagePushColumn]) {
        tabIndex = 3;
    }
    else if([pushType isEqualToString:kTypeThursdaySayPushColumn]) {
        ThurSayViewController *thurSay = [[ThurSayViewController alloc] init];
        [self presentViewController:thurSay animated:YES completion:nil];
    }
    
    pushMessageDict[kStatePushColumn] = @(YES);
    [pushMessageDict writeToFile:pushMessagePath atomically:YES];
    
    if(tabIndex >= 0) { [self tabBarClick:tabIndex]; }
}

- (void)initTabClick {
    if(![FileUtils checkFileExist:self.behaviorPath isDir:NO]) {
        NSMutableDictionary *defaultBehaviorDict = [NSMutableDictionary dictionaryWithDictionary:@{
           kDashboardUBCName: @{
               kTabIndexUBCName: @(0)
           },
           kMessageUBCName: @{
               kTabIndexUBCName: @(0)
           },
           kReportUBCName: @{
               kTabIndexUBCName: @(0)
           }
        }];
        [defaultBehaviorDict writeToFile:self.behaviorPath atomically:YES];
    }
    
    self.behaviorDict = [FileUtils readConfigFile:self.behaviorPath];
    NSInteger tabIndex = [self.behaviorDict[kDashboardUBCName][kTabIndexUBCName] integerValue];
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:tabIndex]];
    [self tabBarClick:tabIndex];
}

#pragma mark - 添加广告视图
- (void)addAdvertWebView {
    self.browser.frame = CGRectMake(0, kBannerHeight + mADVIEWHEIGHT, self.view.frame.size.width, self.view.frame.size.height - kBannerHeight - mADVIEWHEIGHT - kTabBarHeight + 10);
    
    if(self.advertWebView) {
        self.advertWebView.hidden = NO;
        return;
    }
    
    self.advertWebView = [[UIWebView alloc]init];
    self.advertWebView.tag = 1234;
    
    self.advertWebView.frame =  CGRectMake(0, kBannerHeight, self.view.frame.size.width, mADVIEWHEIGHT);
    [self.view addSubview:self.advertWebView];
    
    self.advertWebView.delegate = self;
    self.advertWebView.scalesPageToFit = NO;
    self.advertWebView.scrollView.scrollEnabled = NO;
    
    [self loadAdvertView];
    [self clickAdvertisement];
}

#pragma mark - 隐藏广告视图
- (void)hideAdertWebView {
    self.advertWebView.hidden = YES;
    self.browser.frame = CGRectMake(0, kBannerHeight, self.view.frame.size.width, self.view.frame.size.height - kBannerHeight - kTabBarHeight + 10);
}

#pragma mark - loadAdvertisement
- (void)loadAdvertView {
    NSString *adFilePath = [FileUtils sharedDirPath:kAdFolderName FileName:kAdFileName];
    if ([FileUtils checkFileExist:adFilePath isDir:YES]) {
        NSString *adContent = [NSString stringWithContentsOfFile:adFilePath encoding:NSUTF8StringEncoding error:nil];
        NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000 + arc4random()];
        adContent = [adContent stringByReplacingOccurrencesOfString:@"TIMESTAMP" withString:timestamp];
        [self.advertWebView loadHTMLString:adContent baseURL:[NSURL URLWithString:adFilePath]];
    }
    else {
        [self hideAdertWebView];
    }
}

#pragma mark - clickAdvertisment
- (void)clickAdvertisement {
    self.adBridge = [WebViewJavascriptBridge bridgeForWebView:self.advertWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"DashboardViewController - Response for message from ObjC");
    }];
    
    [self.adBridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName]   = @"JS异常";
                logParams[kObjTypeALCName]  = @(self.commentObjectType);
                logParams[kObjTitleALCName] = [NSString stringWithFormat:@"主页面/%@", data[@"ex"]];
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

/**
 *  <#Description#>
 *
 *  @param openType <#openType description#>
 *  @param data     <#data description#>
 */
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
        if(![self checkAdParams:data containName:@"openLink"] ||
           ![self checkAdParams:data containName:@"objectID"] ||
           ![self checkAdParams:data containName:@"objectType"] ||
           ![self checkAdParams:data containName:@"objectTitle"]) {
            return;
        }
        
        NSDictionary *params = @{kBannerNameSubjectColumn: data[@"objectTitle"], kLinkSubjectColumn: data[@"openLink"], kObjIDSubjectColumn: data[@"objectID"]};
        self.commentObjectType = [data[@"objectType"] integerValue];
        [self performSegueWithIdentifier:kSubjectSegueIdentifier sender:params];
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
        logParams[kActionALCName]   = [NSString stringWithFormat:@"点击广告#%@", openType];
        logParams[kObjTitleALCName] = actionLogTitle;
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
    
    NSString *uiVersion = [FileUtils currentUIVersion];
    [self.urlStrings addObject:[NSString stringWithFormat:kKPIMobilePath, kBaseUrl, uiVersion, self.user.groupID, self.user.roleID]];
    [self.urlStrings addObject:[NSString stringWithFormat:kAnalyseMobilePath, kBaseUrl, uiVersion, self.user.roleID]];
    [self.urlStrings addObject:[NSString stringWithFormat:kAppMobilePath, kBaseUrl, uiVersion, self.user.roleID]];
    [self.urlStrings addObject:[NSString stringWithFormat:kMessageMobilePath, kBaseUrl, uiVersion, self.user.roleID, self.user.groupID, self.user.userID]];
    [self.urlStrings addObject:[NSString stringWithFormat:kThursdaySayMobilePath, kBaseUrl, uiVersion]];
}

- (NSString *)lastLocalNotification:(NSString *)keyName {
    return [NSString stringWithFormat:@"%@_last", keyName];
}

/**
 *  初始化本地通知
 */
- (void)initLocalNotifications {
    NSMutableDictionary *localNotificationDict = [FileUtils readConfigFile:self.localNotificationPath];
    
    NSString *lastKeyName;
    localNotificationDict[kAppLNName] = localNotificationDict[kAppLNName] ?: @(-1);
    
    localNotificationDict[kTabKPILNName] = localNotificationDict[kTabKPILNName] ?: @(-1);
    lastKeyName = [self lastLocalNotification:kTabKPILNName];
    localNotificationDict[lastKeyName] = localNotificationDict[lastKeyName] ?: @(-1);

    localNotificationDict[kTabAnalyseLNName] = localNotificationDict[kTabAnalyseLNName] ?: @(-1);
    lastKeyName = [self lastLocalNotification:kTabAnalyseLNName];
    localNotificationDict[lastKeyName] = localNotificationDict[lastKeyName] ?: @(-1);
    
    localNotificationDict[kTabAppLNName] = localNotificationDict[kTabAppLNName] ?: @(-1);
    lastKeyName = [self lastLocalNotification:kTabAppLNName];
    localNotificationDict[lastKeyName] = localNotificationDict[lastKeyName] ?: @(-1);
    
    localNotificationDict[kTabMessageLNName] = localNotificationDict[kTabMessageLNName] ?: @(-1);
    lastKeyName = [self lastLocalNotification:kTabMessageLNName];
    localNotificationDict[lastKeyName] = localNotificationDict[lastKeyName] ?: @(-1);
    
    localNotificationDict[kSettingLNName] = localNotificationDict[kSettingLNName] ?: @(-1);
    localNotificationDict[kSettingPgyerLNName] = localNotificationDict[kSettingPgyerLNName] ?: @(-1);
    localNotificationDict[kSettingPasswordLNName] = localNotificationDict[kSettingPasswordLNName] ?: @(-1);

    localNotificationDict[kSettingThursdaySayLNName] = localNotificationDict[kSettingThursdaySayLNName] ?: @(-1);
    lastKeyName = [self lastLocalNotification:kSettingThursdaySayLNName];
    localNotificationDict[lastKeyName] = localNotificationDict[lastKeyName] ?: @(-1);
    [FileUtils writeJSON:localNotificationDict Into:self.localNotificationPath];
}

/*
 * 解屏进入主页面，需检测版本更新
 */
- (void)checkFromViewController {
    if(self.fromViewController && [self.fromViewController isEqualToString:@"AppDelegate"]) {
        self.fromViewController = @"AlreadyShow";
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
    else if (self.fromViewController && [self.fromViewController isEqualToString:@"LoginViewController"]) {
        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
        [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appToUpgradeMethod:)];
    }
}

/**
 *  登录或解屏后，密码为初始值时提示:
 *      初始化密码未修改，安全起见，请在【设置】-【个人信息】-【修改密码】页面修改密码。
 */
- (void)checkUserModifiedInitPassword {
    if(![self.user.password isEqualToString:kInitPassword.md5]) {
        return;
    }
   
    [ViewUtils simpleAlertView:self Title:kWarmTitleText Message:kWarningInitPwdText ButtonTitle:kIAlreadyKnownText];
}

- (void)loadWebView {
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
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
        logParams[kActionALCName]   = @"刷新/主页面/浏览器";
        logParams[kObjTitleALCName] = self.urlString;
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
                logParams[kActionALCName]   = @"JS异常";
                logParams[kObjTypeALCName]  = @(self.commentObjectType);
                logParams[kObjTitleALCName] = [NSString stringWithFormat:@"主页面/%@", data[@"ex"]];
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
        if ([data[@"link"] isEqualToString:@""]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"该功能正在开发中"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            [self performSegueWithIdentifier:kSubjectSegueIdentifier sender:@{
                  kBannerNameSubjectColumn: data[@"bannerName"],
                  kLinkSubjectColumn: data[@"link"],
                  kObjIDSubjectColumn: data[@"objectID"]
            }];
        }
    }];
    
    [self.bridge registerHandler:@"dashboardDataCount" handler:^(id data, WVJBResponseCallback responseCallback) {
        // NSString *tabType = data[@"tabType"];
        // NSNumber *dataCount = data[@"dataCount"];
    }];
    
    [self.bridge registerHandler:@"hideAd" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self hideAdertWebView];
    }];
    
    [self.bridge registerHandler:@"pageTabIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *action = data[@"action"];
        NSNumber *tabIndex = data[@"tabIndex"];
        
        if([action isEqualToString:@"store"]) {
            self.behaviorDict[kMessageUBCName][kTabIndexUBCName] = tabIndex;
            [self.behaviorDict writeToFile:self.behaviorPath atomically:YES];
        }
        else if([action isEqualToString:@"restore"]) {
            tabIndex = self.behaviorDict[kMessageUBCName][kTabIndexUBCName];
            
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
        [alert addButton:kIAlreadyKnownText actionBlock:^(void) {
            [self jumpToLogin];
        }];
        
        [alert showError:self title:kWarmTitleText subTitle:kAppForbiedUseText closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)_loadHtml {
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
        
        __block NSString *htmlPath;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:kIsUrlWrite2Local];
        }
        else {
            NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
            htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
            
            [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(enableTabBar) userInfo:nil repeats:NO];
        });
    });
}

#pragma mark - action methods

/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender 
 */
-(void)dropTableView:(UIButton *)sender {
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width / 2.5, 150 / 4 * self.dropMenuTitles.count);
    dropTableViewController.modalPresentationStyle = UIModalPresentationPopover;
    [dropTableViewController setPreferredContentSize:CGSizeMake(self.view.frame.size.width / 2.5, 150 / 4 * self.dropMenuTitles.count)];
    dropTableViewController.view.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    dropTableViewController.dropTableView.delegate = self;
    dropTableViewController.dropTableView.dataSource =self;
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.delegate = self;
    [popover setSourceRect:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 12, sender.frame.size.width, sender.frame.size.height)];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    [self presentViewController:dropTableViewController animated:YES completion:nil];
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
    if (indexPath.row == 3) {
        NSMutableDictionary *localNotificationDict = [FileUtils readConfigFile:self.localNotificationPath];
        if([localNotificationDict[kSettingLNName] integerValue] > 0) {
            [cell.tittleLabel showRedIcon];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150 / 4;
}

- (IBAction)actionPerformSettingView:(UIButton *)sender {
    [self dropTableView:sender];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    
    if([segue.identifier isEqualToString:kSubjectSegueIdentifier]) {
        NSInteger objectType = self.commentObjectType;
        if(sender[kObjTypeSubjectColumn]) {
            objectType = [sender[kObjTypeSubjectColumn] integerValue];
        }
        SubjectViewController *subjectViewController = (SubjectViewController *)segue.destinationViewController;
        subjectViewController.bannerName        = sender[kBannerNameSubjectColumn];
        subjectViewController.link              = sender[kLinkSubjectColumn];
        subjectViewController.objectID          = sender[kObjIDSubjectColumn];
        subjectViewController.commentObjectType = objectType;
        
        logParams[kActionALCName]   = @"点击/主页面/浏览器";
        logParams[kObjIDALCName]    = sender[@"objectID"];
        logParams[kObjTypeALCName]  = @(objectType);
        logParams[kObjTitleALCName] = sender[@"bannerName"];
    }
    else if([segue.identifier isEqualToString:kSettingSegueIdentifier]) {
        logParams[kActionALCName]   = @"点击/主页面/设置";
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
    if (([betaDict[@"allow_brower_copy"] boolValue]) || (self.tabBar.selectedItem.tag == 3)) {
        return;
    }
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
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

/**
 *  <#Description#>
 *
 *  @param index <#index description#>
 */
- (void)tabBarClick:(NSInteger)index {
    /**
     *  避免用户极短时间内连接点击标签项:
     *  1. 点击后，禁用所有标签项
     *  2. _loadhtml 加载 html 再激活所有标签项
     */
    [self tabBarState: NO];
    
    self.behaviorDict[kDashboardUBCName][kTabIndexUBCName] = @(index);
    [self.behaviorDict writeToFile:self.behaviorPath atomically:YES];
    
    /**
     *  仅仪表盘显示广告位
     */
    if(kDashboardAd) {
        index == 0 ? [self addAdvertWebView] : [self hideAdertWebView];
    }

    self.urlString = @"";
    NSString *uiVersion = [FileUtils currentUIVersion];
    switch (index) {
        case 0: {
            self.urlString = [NSString stringWithFormat:kKPIMobilePath, kBaseUrl, uiVersion, self.user.groupID, self.user.roleID];
            self.commentObjectType = ObjectTypeKpi;
            break;
        }
        case 1: {
            self.urlString = [NSString stringWithFormat:kAnalyseMobilePath, kBaseUrl, uiVersion, self.user.roleID];
            self.commentObjectType = ObjectTypeAnalyse;
            break;
        }
        case 2: {
            self.urlString = [NSString stringWithFormat:kAppMobilePath, kBaseUrl, uiVersion, self.user.roleID];
            self.commentObjectType = ObjectTypeApp;
            break;
        }
        case 3: {
            self.urlString = [NSString stringWithFormat:kMessageMobilePath, kBaseUrl, uiVersion, self.user.roleID, self.user.groupID, self.user.userID];
            self.commentObjectType = ObjectTypeMessage;
            break;
        }
        default: {
            self.urlString = [NSString stringWithFormat:kKPIMobilePath, kBaseUrl, uiVersion, self.user.roleID, self.user.groupID];
            self.commentObjectType = ObjectTypeReport;
            break;
        }
    }
    
    [self loadHtml];
    [self resetTabLocalNotificationState:index];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName]  = @"点击/主页面/标签栏";
            logParams[kObjTypeALCName] = @(self.commentObjectType);
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
    if(responseVersionCode % 2 == 1) {
        if (responseVersionCode % 10 == 9 && [reach isReachableViaWiFi]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"由于程序有十分大的改动，您必须升级最新版本才能不影响使用，请您务必升级" preferredStyle:UIAlertControllerStyleAlert];
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

#pragma mark - 本地通知，样式加载
- (void)setNotificationBadgeTimer {
    NSTimeInterval period = 60 * kTimerInterval;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        [self extractDataCountFromUrlStrings];
    });
    
    dispatch_resume(_timer);
   // [NSTimer scheduledTimerWithTimeInterval:60 * 30  target:self selector:@selector(extractDataCountFromUrlStrings) userInfo:nil repeats:YES];
}

- (void)extractDataCountFromUrlStrings {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString, *paramsSplit;
        HttpResponse *httpResponse;
        NSString *versionString = [NSString stringWithFormat:@"i%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
        NSString *externParams = [NSString stringWithFormat:@"os=ios&version=%@&inteval=%li&udi=%@", versionString, (long)kTimerInterval, self.user.deviceID];
        
        for (NSInteger index = 0, len = self.urlStrings.count; index < len; index ++) {
            urlString = self.urlStrings[index];
            paramsSplit = [urlString containsString:@"?"] ? @"&" : @"?";
            urlString = [NSString stringWithFormat:@"%@%@%@", urlString, paramsSplit, externParams];
            
            httpResponse = [HttpUtils checkResponseHeader:urlString assetsPath:self.assetsPath];
            
            if ([httpResponse.statusCode isEqualToNumber:@(200)]) {
                [HttpUtils urlConvertToLocal:urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:kIsUrlWrite2Local];
                [self extractDataCountFromHtmlContent:httpResponse.string Index:index];
            }
        }
        [self setLocalNotifications];
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
    NSLog(@"%@: %@",keyString, valueString);
    if (valueString == nil || [valueString integerValue] < 0) {
        return;
    }
    
    /**
     *  - 如果 `tab_*_last = -1` 时，表示第一次加载， `tab_*_last = dataCount; tab_* = 0`
     *  - 如果 `tab_*_last > 0 && tab_*_last != dataCount`
     *      - 显示通知样式
     *      - `tab_* = abs(dataCount - tab_*_last); tab_*_last = dataCount`
     */
    NSMutableDictionary *localNotificationDict = [FileUtils readConfigFile:self.localNotificationPath];
    NSInteger dataCount = [valueString integerValue];

    NSString *keyWord = self.localNotificationKeys[index];
    NSString *lastKeyWord = [self lastLocalNotification:keyWord];
    
    if ([localNotificationDict[lastKeyWord] integerValue] < 0) {
        localNotificationDict[keyWord] = @(1);
    }
    else if ([localNotificationDict[lastKeyWord] integerValue] != dataCount) {
        localNotificationDict[keyWord] = @(labs(dataCount - [localNotificationDict[lastKeyWord] integerValue]));
    }
    localNotificationDict[lastKeyWord] = @(dataCount);
    
    [FileUtils writeJSON:localNotificationDict Into:self.localNotificationPath];
}

- (void)setLocalNotifications {
    NSMutableDictionary *localNotificationDict = [FileUtils readConfigFile:self.localNotificationPath];
    
    if ([localNotificationDict[kAppLNName] intValue] > 0) {
        UIApplication *application = [UIApplication sharedApplication];
        application.applicationIconBadgeNumber = [localNotificationDict[kAppLNName] integerValue];
    }
    
    /**
     *  底部标签页四个 tab 通知样式
     */
    NSString *keyWord;
    NSInteger dataCount = 0;
    for (NSInteger index = 0; index < 4; index ++) {
        keyWord = self.localNotificationKeys[index];
        dataCount = [localNotificationDict[keyWord] integerValue];
        
        if (dataCount <= 0) { continue; }
  
        BOOL isCurrentSelectedItem = self.tabBar.selectedItem.tag == index;
        [self displayTabBarBadgeOnItemIndex:index orNot:isCurrentSelectedItem];
    }
    
    /**
     *  右上角设置界面通知样式
     */
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    localNotificationDict[kSettingPasswordLNName] = @([userDict[kPasswordCUName] isEqualToString:kInitPassword.md5] ? 1 : 0);

    
    NSInteger settingCount = ([localNotificationDict[kSettingPgyerLNName] integerValue] > 0 ||
                              [localNotificationDict[kSettingPasswordLNName] integerValue] > 0 ||
                              [localNotificationDict[kSettingThursdaySayLNName] integerValue] > 0) ? 1 : 0;
    localNotificationDict[kSettingLNName] = @(settingCount);
    
    [FileUtils writeJSON:localNotificationDict Into:self.localNotificationPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        settingCount > 0 ? [self.setting showRedIcon] : [self.setting hideRedIcon];
    });
}

- (void)displayTabBarBadgeOnItemIndex:(NSInteger)index orNot:(BOOL)isOrNot {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tabBar displayBadgeOnItemIndex:index orNot:isOrNot];
    });
}

- (void)resetTabLocalNotificationState:(NSInteger)index {
    NSMutableDictionary *localNotificationDict = [FileUtils readConfigFile:self.localNotificationPath];
    localNotificationDict[self.localNotificationKeys[index]] = @(0);
    [FileUtils writeJSON:localNotificationDict Into:self.localNotificationPath];
    
    [self displayTabBarBadgeOnItemIndex:index orNot:YES];
}
@end
