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
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, SCREEN_HEIGHT- 59 -49)];
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
       [self.navigationController presentViewController: instiDetailNav animated:YES completion:^{
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
