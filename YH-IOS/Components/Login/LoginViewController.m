//
//  ViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "LoginViewController.h"
#import "DashboardViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_PATH];

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
        
        if([HttpUtils isNetworkAvailable]) {
            [self jumpToDashboardView];
        }
        else {
            [self showProgressHUD:@"请确认网络环境."];
            self.progressHUD.mode = MBProgressHUDModeText;
            [self.progressHUD hide:YES afterDelay:2.0];
        }
    }];

    self.browser.scrollView.scrollEnabled = NO;
    self.browser.scrollView.bounces = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([HttpUtils isNetworkAvailable]) {
            NSString *fontsPath = [NSString stringWithFormat:@"%@%@", BASE_URL, FONTS_PATH];
            [HttpUtils downloadAssetFile:fontsPath assetsPath:[FileUtils userspace]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadHtml];
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)loadHtml {
    [self clearBrowserCache];
    [self showLoading:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([HttpUtils isNetworkAvailable]) {
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
                [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
            });
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
    });
}

- (void)jumpToDashboardView {
    UIWindow *window = self.view.window;
    LoginViewController *previousRootViewController = (LoginViewController *)window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController *dashboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    window.rootViewController = dashboardViewController;
    
    // Nasty hack to fix http://stackoverflow.com/questions/26763020/leaking-views-when-changing-rootviewcontroller-inside-transitionwithview
    // The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:self.class]) {
            [subview removeFromSuperview];
        }
    }
    // Allow the view controller to be deallocated
    [previousRootViewController dismissViewControllerAnimated:NO completion:^{
        // Remove the root view in case its still showing
        [previousRootViewController.view removeFromSuperview];
    }];
}


# pragma mark - 登录界面不支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}
@end
