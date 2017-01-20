//
//  ResetPasswordViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/29.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "APIHelper.h"
#import "HttpResponse.h"
#import "NSString+MD5.h"
#import "ViewUtils.h"

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bannerView.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    self.labelTheme.textColor = [UIColor colorWithHexString:kBannerTextColor];
   // [self idColor];
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
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
    
    [self.bridge registerHandler:@"ResetPassword" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *oldPassword = data[@"oldPassword"];
        NSString *newPassword = data[@"newPassword"];
        NSLog(@"%@,%@", oldPassword, newPassword);
        
        if([oldPassword.md5 isEqualToString:self.user.password]) {
            
            HttpResponse *response = [APIHelper resetPassword:self.user.userID newPassword:newPassword.md5];
            NSString *message = [NSString stringWithFormat:@"%@", response.data[@"info"]];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            if(response.statusCode && [response.statusCode isEqualToNumber:@(201)]) {
                [self changLocalPwd:newPassword];
                [alert addButton:@"重新登录" actionBlock:^(void) {
                    [self jumpToLogin];
                }];
                
                [alert showSuccess:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    /*
                     * 用户行为记录, 单独异常处理，不可影响用户体验
                     */
                    @try {
                        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                        logParams[@"action"] = @"重置密码";
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
                        [self.browser cleanForDealloc];
                        self.browser.delegate = nil;
                        self.browser = nil;
                        [self.progressHUD hide:YES];
                        self.progressHUD = nil;
                        self.bridge = nil;
                    }];
                }];
                [alert showWarning:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
            }
        }
        else {
            [ViewUtils showPopupView:self.view Info:@"原始密码输入有误"];
            [self loadHtml];
        }
    }];
    
    self.labelTheme.text = self.bannerName;
    self.urlString = [NSString stringWithFormat:kResetPwdMobilePath, kBaseUrl, [FileUtils currentUIVersion]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadHtml];
}

- (void)changLocalPwd:(NSString *)newPassword {
    NSString  *noticeFilePath = [FileUtils dirPath:@"Cached" FileName:@"local_notifition.json"];
    NSMutableDictionary *noticeDict = [FileUtils readConfigFile:noticeFilePath];
    noticeDict[@"setting_password"] = @(-1);
    noticeDict[@"setting"] = @(0);
    [FileUtils writeJSON:noticeDict Into:noticeFilePath];
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[@"user_md5"] = newPassword.md5;
    [FileUtils writeJSON:userDict Into:userConfigPath];
}

- (void)dealloc {
    [self.browser stopLoading];
    [self.browser cleanForDealloc];
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
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
            [self jumpToLogin];
        }];
        
        [alert showError:self title:@"温馨提示" subTitle:@"您被禁止在该设备使用本应用" closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)_loadHtml {
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
        
        __block NSString *htmlPath;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:kIsUrlWrite2Local];
        }
        else {
            NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
            htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[FileUtils sharedPath]]];
        });
    });
}

#pragma mark - ibaction block
- (IBAction)actionBack:(id)sender {
    [super dismissViewControllerAnimated:YES completion:^{
        [self.browser stopLoading];
        [self.browser cleanForDealloc];
        self.browser.delegate = nil;
        self.browser = nil;
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
        self.bridge = nil;
    }];
}
@end
