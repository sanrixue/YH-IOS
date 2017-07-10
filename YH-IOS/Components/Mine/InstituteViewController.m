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
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *distPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"dist"];
    NSString *disthtmlPath = [distPath stringByAppendingPathComponent:[NSString stringWithFormat:@"index.html?userId=%@",user.userNum]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:disthtmlPath]]];
}

- (void)addWebViewJavascriptBridge {
    
    [self.bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"很好很好");
        self.DataId =[NSString stringWithFormat:@"%@",data[@"objectID"]];
        YHInstituteDetailViewController *instiDetail = [[YHInstituteDetailViewController alloc]init];
        instiDetail.dataId = _DataId;
        instiDetail.userId = user.userNum;
        instiDetail.title = data[@"bannerName"];
        UINavigationController *instiDetailNav = [[UINavigationController alloc]initWithRootViewController:instiDetail];
       [self.navigationController presentViewController: instiDetailNav animated:YES completion:^{
        }];
        //[self.navigationController pushViewController:instiDetailNav animated:YES];
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
