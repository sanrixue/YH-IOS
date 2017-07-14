//
//  YHScanStoreViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/14.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHScanStoreViewController.h"
#import "WebViewJavascriptBridge.h"
#import "APIHelper.h"


@interface YHScanStoreViewController ()<UIWebViewDelegate>

@property(nonatomic, strong)UIWebView *webview;
@property WebViewJavascriptBridge* bridge;

@end

@implementation YHScanStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webview = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webview.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:self.webview];
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webview webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"SubjectViewController - Response for message from ObjC");
    }];
    [self addWebViewJavascriptBridge];
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://development.shengyiplus.com:4568/patrol/inspection/default.html"]]];
    // Do any additional setup after loading the view.
}

- (void)addWebViewJavascriptBridge {
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        // [self showLoading:LoadingRefresh];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName]   = @"JS异常";
                logParams[kObjIDALCName]    = @"门店巡检";
                logParams[kObjTypeALCName]  = @(1);
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    


    
    /*[self.bridge registerHandler:@"uploadFile" handler:^(id data, WVJBResponseCallback responseCallback) {
     [self addUserIcon];
     }];*/

    
    [self.bridge registerHandler:@"setBannerTitle" handler:^(id data, WVJBResponseCallback responseCallback){
    }];
    
    
    [self.bridge registerHandler:@"toggleShowBanner" handler:^(id data, WVJBResponseCallback responseCallback){

    }];
    
    [self.bridge registerHandler:@"showAlert" handler:^(id data, WVJBResponseCallback responseCallback){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:data[@"title"]
                                                                       message:data[@"content"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    
    [self.bridge registerHandler:@"showBarCodeScanner" handler:^(id data, WVJBResponseCallback responseCallback){
        //[self actionBarCodeScanView];
        [ViewUtils showPopupView:self.view Info:@"功能未开放"];
    }];
    
    [self.bridge registerHandler:@"showAlertAndRedirect" handler:^(id data, WVJBResponseCallback responseCallback){
    }];
    
    [self.bridge registerHandler:@"showAlertAndRedirectWithCleanStack" handler:^(id data, WVJBResponseCallback responseCallback){

    }];
    
    // UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //[refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    //[self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
