//
//  InstituteViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "InstituteViewController.h"
#import "FileUtils.h"
#import "WebViewJavascriptBridge.h"
#import "User.h"
#import "YHInstituteDetailViewController.h"
#import "APIHelper.h"

@interface InstituteViewController ()<UIWebViewDelegate>
{
    User *user;
}

@property WebViewJavascriptBridge* bridge;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic, strong)NSString *DataId;

@end

@implementation InstituteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [[User alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"SubjectViewController - Response for message from ObjC");
    }];
    [self addWebViewJavascriptBridge];
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *distPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"dist"];
    NSString *disthtmlPath = [distPath stringByAppendingPathComponent:[NSString stringWithFormat:@"index.html?userId=%@",user.userNum]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:disthtmlPath]]];
}

- (void)addWebViewJavascriptBridge {
    
    [self.bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        self.DataId =[NSString stringWithFormat:@"%@",data[@"objectID"]];
        YHInstituteDetailViewController *instiDetail = [[YHInstituteDetailViewController alloc]init];
        instiDetail.dataId = _DataId;
        instiDetail.userId = user.userNum;
        instiDetail.title = data[@"bannerName"];
        UINavigationController *instiDetailNav = [[UINavigationController alloc]initWithRootViewController:instiDetail];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"点击/数据学院";
            logParams[kObjIDALCName] = _DataId;
            [APIHelper actionLog:logParams];
        });
       [self.navigationController presentViewController: instiDetailNav animated:YES completion:^{
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
