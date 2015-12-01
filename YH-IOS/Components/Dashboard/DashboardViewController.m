//
//  DashboardViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "DashboardViewController.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "const.h"
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"
#import "ChartViewController.h"
#import "HttpResponse.h"
#import <SCLAlertView.h>


static NSString *const kChartSegueIdentifier = @"DashboardToChartSegueIdentifier";

@interface DashboardViewController ()
@property WebViewJavascriptBridge* bridge;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (strong, nonatomic) NSString *dashboardUrlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.assetsPath = [FileUtils dirPath:HTML_DIRNAME];
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *bannerName = data[@"bannerName"];
        NSString *link       = data[@"link"];
        [self performSegueWithIdentifier:kChartSegueIdentifier sender:@{@"bannerName": bannerName, @"link": link, @"tabBarItemIndex": self.tabBarItemIndex}];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(!self.tabBarItemIndex) {
        self.tabBarItemIndex = @(0);
    }
    
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:[self.tabBarItemIndex integerValue]]];
    [self tabBarClick: [self.tabBarItemIndex integerValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self showProgressHUD:@"收到IOS系统，内存警告."];
    self.progressHUD.mode = MBProgressHUDModeText;
    [_progressHUD hide:YES afterDelay:2.0];
}

- (void)dealloc {
    _browser.delegate = nil;
    _browser = nil;
    [_progressHUD hide:YES];
    _progressHUD = nil;
    _bridge = nil;
}

#pragma mark - status bar settings
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - assistant methods
- (void)loadHtml {
    NSString *htmlName = [HttpUtils urlTofilename:self.dashboardUrlString suffix:@".html"][0];
    NSString *htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];

    
    if([FileUtils checkFileExist:htmlPath isDir:NO]) {
        NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([HttpUtils isNetworkAvailable]) {
            HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.dashboardUrlString assetsPath:self.assetsPath];
            if([httpResponse.statusCode isEqualToNumber:@(200)]) {
                
                [self showProgressHUD:@"loading..."];
                
                NSString *htmlPath = [HttpUtils urlConvertToLocal:self.dashboardUrlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:[URL_WRITE_LOCAL isEqualToString:@"1"]];
                NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
                [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
                
                [self.progressHUD hide:YES];
            }
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            [alert addButton:@"刷新" actionBlock:^(void) {
                [self loadHtml];
            }];
            
            [alert showError:self title:@"温馨提示" subTitle:@"网络环境不稳定" closeButtonTitle:@"先这样" duration:0.0f];
        }
    });
}



- (void)showProgressHUD:(NSString *)text {
    _progressHUD = [MBProgressHUD showHUDAddedTo:_browser animated:YES];
    _progressHUD.labelText = text;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kChartSegueIdentifier]) {
        ChartViewController *chartViewController = (ChartViewController *)segue.destinationViewController;
        chartViewController.bannerName = sender[@"bannerName"];
        chartViewController.link = sender[@"link"];
        chartViewController.dashBoardTabBarItemIndex = self.tabBarItemIndex;
    }
}

#pragma mark - UITabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

    [self tabBarClick:item.tag];
    
}

- (void)tabBarClick:(NSInteger)index {
    
    NSString *path = KPI_PATH;
    switch (index) {
        case 0: path = KPI_PATH; break;
        case 1: path = ANALYSE_PATH; break;
        case 2: path = APPLICATION_PATH; break;
        case 3: path = MESSAGE_PATH; break;
        default: path = KPI_PATH; break;
    }
    
    self.tabBarItemIndex = @(index);
    self.dashboardUrlString = [NSString stringWithFormat:@"%@%@", BASE_URL, path];
    
    [self loadHtml];
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
