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


static NSString *const kChartSegueIdentifier = @"DashboardToChartSegueIdentifier";

@interface DashboardViewController ()
@property WebViewJavascriptBridge* bridge;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (strong, nonatomic) NSString *dashboardUrlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dashboardUrlString = [NSString stringWithFormat:@"%@%@", BASE_URL, DASHBOARD_PATH];
    self.assetsPath = [FileUtils dirPaths:@[ASSETS_DIRNAME, DASHBOARD_DIRNAME]];
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *chartTheme = data[@"chartTheme"];
        [self performSegueWithIdentifier:kChartSegueIdentifier sender:chartTheme];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadHtml];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSURL *url = [NSURL URLWithString:self.dashboardUrlString];
    NSString *htmlName = [HttpUtils urlTofilename:[url.pathComponents componentsJoinedByString:@"/"] suffix:@".html"];
    NSString *htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
    
    [self showProgressHUD:@"loading..."];
    
    if([FileUtils checkFileExist:htmlPath isDir:NO]) {
        NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([HttpUtils isNetworkAvailable]) {
            [self.browser loadRequest:[NSURLRequest requestWithURL:url]];
        }
        [_progressHUD hide: YES];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)showProgressHUD:(NSString *)text {
    _progressHUD = [MBProgressHUD showHUDAddedTo:_browser animated:YES];
    _progressHUD.labelText = text;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kChartSegueIdentifier]) {
        ChartViewController *chartViewController = (ChartViewController *)segue.destinationViewController;
        chartViewController.chartTheme = sender;
    }
}
@end
