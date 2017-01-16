//
//  FindPasswordViewController.m
//  YH-IOS
//
//  Created by li hao on 17/1/13.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "APIHelper.h"
#import "UIColor+Hex.h"
#import "HttpResponse.h"
#import "Version.h"
#import <SCLAlertView.h>
#import "WebViewJavascriptBridge.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "User.h"
#import "FileUtils+Assets.h"

@interface FindPasswordViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) Version *version;
@property (nonatomic, strong) UIWebView *webView;
@property WebViewJavascriptBridge* bridge;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *assetsPath;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[User alloc] init];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:kHTMLDirName];
    }
    self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,60)];
    self.navBar.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 60, 30)];
    [backBtn addTarget:self action:@selector(dismissFindPwd) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setImage:[UIImage imageNamed:@"Banner-Back"] forState:UIControlStateNormal];
    [self.navBar addSubview:backBtn];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 30)];
    titleLabel.text = @"找回密码";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navBar addSubview:titleLabel];
    [self.view addSubview:self.navBar];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ResetPasswordViewController - ObjC received message from JS: %@", data);
        responseCallback(@"ResetPasswordViewController - Response for message from ObjC");
    }];
    
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[@"action"] = @"JS异常";
                logParams[@"obj_title"] = [NSString stringWithFormat:@"重置密码页面/%@", data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    [self.bridge registerHandler:@"ForgetPassword" handler:^(id data, WVJBResponseCallback responseCallback){
        
        NSString *userNum = data[@"usernum"];
        NSString *userPhone = data[@"mobile"];
        NSLog(@"%@%@",userNum,userPhone);
        
        if (userNum && userPhone) {
            HttpResponse *reponse =  [APIHelper findPassword:userNum withMobile:userPhone];
            NSString *message = [NSString stringWithFormat:@"%@",reponse.data[@"info"]];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            if ([reponse.statusCode isEqualToNumber:@(201)]) {
                [alert addButton:@"重新登录" actionBlock:^(void){
                    [self dismissFindPwd];
                }];
                
                [alert showSuccess:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    /*
                     * 用户行为记录, 单独异常处理，不可影响用户体验
                     */
                    @try {
                        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                        logParams[@"action"] = @"找回密码";
                        [APIHelper actionLog:logParams];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"%@", exception);
                    }
                });
                
            }
            else {
                // [self changLocalPwd:newPassword];
                [alert addButton:@"好的" actionBlock:^(void) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        self.webView.delegate = nil;
                        self.webView = nil;
                        self.bridge = nil;
                    }];
                }];
                [alert showWarning:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self loadHtml];
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
            [self dismissFindPwd];
        }];
        
        [alert showError:self title:@"温馨提示" subTitle:@"您被禁止在该设备使用本应用" closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)showLoading:(LoadingType)loadingType {
    NSString *loadingPath = [FileUtils loadingPath:loadingType];
    NSString *loadingContent = [NSString stringWithContentsOfFile:loadingPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:loadingContent baseURL:[NSURL fileURLWithPath:loadingPath]];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void)_loadHtml {
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlstring = [NSString stringWithFormat:@"%@/mobile/v2/forget_user_password",kBaseUrl];
        HttpResponse *httpResponse = [HttpUtils checkResponseHeader:urlstring assetsPath:self.assetsPath];
        
        __block NSString *htmlPath;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            htmlPath = [HttpUtils urlConvertToLocal:urlstring content:httpResponse.string assetsPath:self.assetsPath writeToLocal:kIsUrlWrite2Local];
        }
        else {
            NSString *htmlName = [HttpUtils urlTofilename:urlstring suffix:@".html"][0];
            htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
            [self.webView loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[FileUtils sharedPath]]];
        });
    });
}

- (void)clearBrowserCache {
    [self.webView stopLoading];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


- (void)dismissFindPwd {
    [self dismissViewControllerAnimated:YES completion:^{
        self.webView.delegate = nil;
        self.webView = nil;
        self.bridge = nil;
    }];
}

@end
