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

@interface InstituteViewController ()

@property WebViewJavascriptBridge* bridge;
@property (nonatomic,strong)UIWebView *webView;

@end

@implementation InstituteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64 -49)];
    NSString *distPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"dist"];
    NSString *disthtmlPath = [distPath stringByAppendingPathComponent:@"index.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:disthtmlPath]]];
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
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
