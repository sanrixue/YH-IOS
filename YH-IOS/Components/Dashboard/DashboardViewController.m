//
//  DashboardViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "DashboardViewController.h"
#import "ChartViewController.h"
#import <SCLAlertView.h>


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
    // Do any additional setup after loading the view.
    
    UIColor *color = [UIColor colorWithHexString:YH_COLOR];;
    self.bannerView.backgroundColor = color;
    [self idColor];
    [[UITabBar appearance] setTintColor:color];
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
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
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
    
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    [self tabBarClick: 0];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if([HttpUtils isNetworkAvailable]) {
//            NSString *fontsPath = [NSString stringWithFormat:@"%@%@", BASE_URL, FONTS_PATH];
//            [HttpUtils downloadAssetFile:fontsPath assetsPath:[FileUtils userspace]];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
//        });
//    });
}

- (void)dealloc {
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
-(void)handleRefresh:(UIRefreshControl *)refresh {
    [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
    [self loadHtml];
    [refresh endRefreshing];
    
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    logParams[@"action"] = @"刷新/主页面/浏览器";
    [APIHelper actionLog:logParams];
}

#pragma mark - assistant methods
- (void)loadHtml {
    
    if([HttpUtils isNetworkAvailable]) {
        if([APIHelper deviceState]) {
            [self _loadHtml];
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:@"知道了" actionBlock:^(void) {
                [self jumpToLogin];
            }];
            [alert showError:self title:@"温馨提示" subTitle:@"您被禁止在该设备使用本应用" closeButtonTitle:nil duration:0.0f];
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            [alert addButton:@"刷新" actionBlock:^(void) {
                [self loadHtml];
            }];
            
            [alert showError:self title:@"温馨提示" subTitle:@"网络环境不稳定" closeButtonTitle:@"先这样" duration:0.0f];
        });
    }
}
- (void)_loadHtml {
    [self clearBrowserCache];
    [self showLoading];
    
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
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[FileUtils sharedPath]]];
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
        ChartViewController *chartViewController = (ChartViewController *)segue.destinationViewController;
        chartViewController.bannerName        = sender[@"bannerName"];
        chartViewController.link              = sender[@"link"];
        chartViewController.objectID          = sender[@"objectID"];
        chartViewController.commentObjectType = self.commentObjectType;
        
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
    @try {
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
#pragma mark - UIWebview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error.description);
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
            path = [NSString stringWithFormat:MESSAGE_PATH, self.user.roleID, self.user.userID];
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
    [self tabBarState: YES];
    
    
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
}

- (void)tabBarState:(BOOL)state {
    for(UITabBarItem *item in self.tabBar.items) {
        item.enabled = state;
    }
}

# pragma mark - 登录界面不支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
#pragma mark - 屏幕旋转 刷新页面 
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self loadHtml];
}
@end
