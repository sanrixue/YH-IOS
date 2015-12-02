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
#import "HttpResponse.h"
#import <SCLAlertView.h>

static NSString *const kDashboardSegueIdentifier = @"DashboardSegueIdentifier";

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
    
    [self.bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        
//        NSString *username = data[@"username"];
//        NSString *password = data[@"password"];
        
        if([HttpUtils isNetworkAvailable]) {
            [self performSegueWithIdentifier:kDashboardSegueIdentifier sender:nil];
        }
        else {
            [self showProgressHUD:@"请确认网络环境."];
            self.progressHUD.mode = MBProgressHUDModeText;
            [self.progressHUD hide:YES afterDelay:2.0];
        }
    }];
    
    UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadHtml)];
    tagGesture.numberOfTapsRequired = 3;
    tagGesture.numberOfTouchesRequired = 1;
    [self.browser addGestureRecognizer:tagGesture];

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
    NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
    NSString *htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
    
    if([FileUtils checkFileExist:htmlPath isDir:NO]) {
        NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
    }
    else {
        [self showLoading:YES];
    }
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([HttpUtils isNetworkAvailable]) {
            HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
            if([httpResponse.statusCode isEqualToNumber:@(200)]) {
                
                NSString *htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:[URL_WRITE_LOCAL isEqualToString:@"1"]];
                NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
                [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
            });
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



# pragma mark - 登录界面不支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}
@end
