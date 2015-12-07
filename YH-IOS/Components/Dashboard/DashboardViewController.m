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

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *color = [UIColor colorWithHexString:YH_COLOR];;
    self.bannerView.backgroundColor = color;
    [[UITabBar appearance] setTintColor:color];
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [self.bridge registerHandler:@"refreshBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self clearHttpResponeHeader];
        
        [self loadHtml];
    }];
    
    [self.bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *bannerName = data[@"bannerName"];
        NSString *link       = data[@"link"];
        [self performSegueWithIdentifier:kChartSegueIdentifier sender:@{@"bannerName": bannerName, @"link": link}];
    }];
    
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    [self tabBarClick: 0];
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
    self.tabBar.delegate = nil;
    self.tabBar = nil;
}

#pragma mark - assistant methods
- (void)loadHtml {
    [self clearBrowserCache];
    [self showLoading];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if([HttpUtils isNetworkAvailable]) {
            HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
            
            NSString *htmlPath, *htmlContent;
            if([httpResponse.statusCode isEqualToNumber:@(200)]) {
                htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:URL_WRITE_LOCAL];
            }
            else {
                NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
                htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
            }
            
            htmlContent = [self stringWithContentsOfFile:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
            });
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

- (void)webViewDidFinishLoad:(UIWebView *)webView {
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kChartSegueIdentifier]) {
        ChartViewController *chartViewController = (ChartViewController *)segue.destinationViewController;
        chartViewController.bannerName = sender[@"bannerName"];
        chartViewController.link = sender[@"link"];
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
    
    self.urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, path];
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
