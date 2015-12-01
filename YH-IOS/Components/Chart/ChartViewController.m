//
//  ChartViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "FileUtils.h"
#import "HttpUtils.h"
#import "const.h"
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"
#import "ChartViewController.h"
#import "HttpResponse.h"
#import <SCLAlertView.h>
#import "DashboardViewController.h"


static NSString *const kDashbaordSegueIdentifer = @"ChartToDashboardSegueIdentifier";

@interface ChartViewController ()
@property WebViewJavascriptBridge* bridge;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (strong, nonatomic) NSString *chartUrlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (weak, nonatomic) IBOutlet UILabel *labelTheme;
@property (assign, nonatomic) BOOL isInnerLink;

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isInnerLink = !([self.link hasPrefix:@"http://"] || [self.link hasPrefix:@"https://"]);
    
    if(self.isInnerLink) {
        self.chartUrlString = [NSString stringWithFormat:@"%@%@", BASE_URL, self.link];
    }
    else {
        self.chartUrlString = self.link;
    }
    
    self.assetsPath = [FileUtils dirPath:HTML_DIRNAME];
    
    self.labelTheme.text = self.bannerName;
    
//    _browser.scrollView.scrollEnabled = NO;
//    _browser.scrollView.bounces = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    _dashBoardTabBarItemIndex = nil;
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
    self.isInnerLink ? [self loadOuterLink] : [self loadInnerLink];
}
- (void)loadOuterLink {
    [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.chartUrlString]]];
}
- (void)loadInnerLink {
    NSString *htmlName = [HttpUtils urlTofilename:self.chartUrlString suffix:@".html"][0];
    NSString *htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
    
    if([FileUtils checkFileExist:htmlPath isDir:NO]) {
        NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([HttpUtils isNetworkAvailable]) {
            HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.chartUrlString assetsPath:self.assetsPath];
            if([httpResponse.statusCode isEqualToNumber:@(200)]) {
                
                [self showProgressHUD:@"loading..."];
                
                NSString *htmlPath = [HttpUtils urlConvertToLocal:self.chartUrlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:[URL_WRITE_LOCAL isEqualToString:@"1"]];
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
- (IBAction)actionBack:(id)sender {
    [self performSegueWithIdentifier:kDashbaordSegueIdentifer sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kDashbaordSegueIdentifer]) {
        DashboardViewController *dashboardViewController = (DashboardViewController*)segue.destinationViewController;
        dashboardViewController.tabBarItemIndex = self.dashBoardTabBarItemIndex;
    }
}

- (void)showProgressHUD:(NSString *)text {
    _progressHUD = [MBProgressHUD showHUDAddedTo:_browser animated:YES];
    _progressHUD.labelText = text;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
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
