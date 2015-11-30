//
//  ViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "LoginViewController.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "const.h"
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"
#import "DashboardViewController.h"

static NSString *const kDashboardSegueIdentifier = @"DashboardSegueIdentifier";

@interface LoginViewController ()
@property WebViewJavascriptBridge* bridge;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (strong, nonatomic) NSString *loginUrlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.loginUrlString = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_PATH];
    self.assetsPath = [FileUtils dirPath:HTML_DIRNAME];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadHtml)];
    tapGesture.numberOfTapsRequired = 3;
    tapGesture.numberOfTouchesRequired = 1;
    [self.browser addGestureRecognizer:tapGesture];
    
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        
//        NSString *username = data[@"username"];
//        NSString *password = data[@"password"];
        
        if([HttpUtils isNetworkAvailable]) {
            [self performSegueWithIdentifier:kDashboardSegueIdentifier sender:nil];
        }
        else {
            [self showProgressHUD:@"请确认网络环境."];
            _progressHUD.mode = MBProgressHUDModeText;
            [_progressHUD hide:YES afterDelay:2.0];
        }
    }];
    
    UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadHtml)];
    tagGesture.numberOfTapsRequired = 3;
    tagGesture.numberOfTouchesRequired = 1;
    [_browser addGestureRecognizer:tagGesture];

    _browser.scrollView.scrollEnabled = NO;
    _browser.scrollView.bounces = NO;
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
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
            [_progressHUD hide:YES];
            return YES;
        }
    }
    else if ([requestString hasPrefix:@"file://"]) {

    }
    
    return YES;
}

- (void)loadHtml {
    NSURL *url = [NSURL URLWithString:self.loginUrlString];
    NSString *htmlName = [HttpUtils urlTofilename:[url.pathComponents componentsJoinedByString:@"/"] suffix:@".html"][0];
    NSString *htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
    
    
//    if([FileUtils checkFileExist:htmlPath isDir:NO]) {
//        NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//        [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
//    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([HttpUtils isNetworkAvailable]) {
            [self.browser loadRequest:[NSURLRequest requestWithURL:url]];
        }
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kDashboardSegueIdentifier]) {
        
    }
    else {
        NSLog(@"unkown identifier: %@", segue.identifier);
    }
}

- (void)showProgressHUD:(NSString *)text {
    _progressHUD = [MBProgressHUD showHUDAddedTo:_browser animated:YES];
    _progressHUD.labelText = text;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

# pragma mark - 登录界面不支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}
@end
