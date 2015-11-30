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
        NSString *subjectName = data[@"subjectName"];
        [self performSegueWithIdentifier:kChartSegueIdentifier sender:subjectName];
    }];
    
//    _browser.scrollView.scrollEnabled = NO;
//    _browser.scrollView.bounces = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];

    self.dashboardUrlString = [NSString stringWithFormat:@"%@%@", BASE_URL, KPI_PATH];
    [self loadHtml];
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
    NSURL *url = [NSURL URLWithString:self.dashboardUrlString];
    NSString *htmlName = [HttpUtils urlTofilename:[url.pathComponents componentsJoinedByString:@"/"] suffix:@".html"][0];
    NSString *htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];

    
    if([FileUtils checkFileExist:htmlPath isDir:NO]) {
        NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([HttpUtils isNetworkAvailable]) {
            [self.browser loadRequest:[NSURLRequest requestWithURL:url]];
        }
    });
}

/**
 *  core methods - 所有网络链接都缓存至本地
 *
 *  @param webView        <#webView description#>
 *  @param request        <#request description#>
 *  @param navigationType <#navigationType description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    
    if ([requestString hasPrefix:@"http://"] || [requestString hasPrefix:@"https://"]) {
        
        if([requestString hasPrefix:BASE_URL]) {
            
            [self showProgressHUD:@"loading..."];
            
            NSString *htmlPath = [HttpUtils urlConvertToLocal:requestString assetsPath:self.assetsPath writeToLocal:[URL_WRITE_LOCAL isEqualToString:@"1"]];
            NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            [webView loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
            
            [_progressHUD hide:YES];
            return NO;
        }
        else {
            
            return YES;
        }
    }
    else if ([requestString hasPrefix:@"file://"]) {
        
    }
    
    return YES;
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

#pragma mark - UITabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSString *path = KPI_PATH;
    
    if([item.title isEqualToString:@"KPI"]) {
        path = KPI_PATH;
    }
    else if([item.title isEqualToString:@"分析"]) {
        path = ANALYSE_PATH;
    }
    else if([item.title isEqualToString:@"消息"]) {
        path = MESSAGE_PATH;
    }
    
    if([item.title isEqualToString:@"应用"]) {
        [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://form.mikecrm.com/f.php?t=fErp3n"]]];
    }
    else {
        self.dashboardUrlString = [NSString stringWithFormat:@"%@%@", BASE_URL, path];
        
        [self loadHtml];
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
