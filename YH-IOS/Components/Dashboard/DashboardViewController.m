//
//  DashboardViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "DashboardViewController.h"
#import "SubjectViewController.h"
#import <SCLAlertView.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "NSData+MD5.h"


static NSString *const kChartSegueIdentifier = @"DashboardToChartSegueIdentifier";
static NSString *const kSettingSegueIdentifier = @"DashboardToSettingSegueIdentifier";

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (assign, nonatomic) CommentObjectType commentObjectType;
@property (assign, nonatomic) NSInteger objectID;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color = [UIColor colorWithHexString:YH_COLOR];;
    self.bannerView.backgroundColor = color;
    [[UITabBar appearance] setTintColor:color];
    [self idColor];
    
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"DashboardViewController - ObjC received message from JS: %@", data);
        responseCallback(@"DashboardViewController - Response for message from ObjC");
    }];
    
    [self addWebViewJavascriptBridge];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
    
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    [self tabBarClick: 0];
    
    /*
     * 解屏进入主页面，需检测版本更新
     */
    if(self.fromViewController && [self.fromViewController isEqualToString:@"AppDelegate"]) {
        self.fromViewController = @"AlreadyShow";
        //启动检测版本更新
        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
        [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appUpgradeMethod:)];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkAssetsUpdate];
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
    [self clearBrowserCache];
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
- (IBAction)actionPerformSettingView:(UIButton *)sender {
    [self performSegueWithIdentifier:kSettingSegueIdentifier sender:nil];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}
#pragma mark - UIWebview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    /**
     *  忽略 NSURLErrorDomain 错误 - 999
     */
    if([error code] == NSURLErrorCancelled) return;
    
    NSLog(@"dvc: %@", error.description);
}

#pragma mark - UITabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self tabBarClick:item.tag];
}

- (void)tabBarClick:(NSInteger)index {
    NSString *path;
    switch (index) {
        case 0: {
            path = [NSString stringWithFormat:KPI_PATH, self.user.roleID, self.user.groupID];
            self.commentObjectType = ObjectTypeKpi;
            break;
        }
        case 1: {
            path = [NSString stringWithFormat:ANALYSE_PATH, self.user.roleID];
            self.commentObjectType = ObjectTypeAnalyse;
            break;
        }
        case 2: {
            path = [NSString stringWithFormat:APPLICATION_PATH, self.user.roleID];
            self.commentObjectType = ObjectTypeApp;
            break;
        }
        case 3: {
            path = [NSString stringWithFormat:MESSAGE_PATH, self.user.roleID, self.user.groupID, self.user.userID];
            self.commentObjectType = ObjectTypeMessage;
            break;
        }
        default: {
            path = [NSString stringWithFormat:KPI_PATH, self.user.roleID, self.user.groupID];
            self.commentObjectType = ObjectTypeReport;
            break;
        }
    }
    
    self.urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, path];
    
    
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
/**
  *  内容检测版本升级，判断版本号是否为偶数。以便内测
  *
  *  @param response <#response description#>
  */
- (void)appUpgradeMethod:(NSDictionary *)response {
    
    if(response && response[@"downloadURL"] && response[@"versionCode"] && [response[@"versionCode"] integerValue] % 2 == 0) {
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert addButton:@"升级" actionBlock:^(void) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
        }];
        
        [alert showSuccess:self title:@"版本更新" subTitle:response[@"releaseNote"] closeButtonTitle:@"放弃" duration:0.0f];
    }
}
@end
