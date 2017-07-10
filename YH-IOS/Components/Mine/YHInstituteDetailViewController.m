//
//  YHInstituteDetailViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHInstituteDetailViewController.h"

@interface YHInstituteDetailViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;

@end

@implementation YHInstituteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *kpiString = [NSString stringWithFormat:@"%@/mobile/v2/user/%@/article/%@",kBaseUrl,self.userId,self.dataId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kpiString]];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.delegate = self;
    [MRProgressOverlayView showOverlayAddedTo:_webView title:@"加载中" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
   // [MRProgressOverlayView dismissOverlayForView:self.webView animated:YES];
 //   // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 84, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"list_ic_arroow.png-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    self.navigationController.navigationBar.translucent = NO;
    UILabel *banBtn = [[UILabel alloc]initWithFrame:CGRectMake(34, 2, 30, 40)];
    banBtn.text = @"返回";
    banBtn.textColor = [UIColor colorWithHexString:@"#000"];
    banBtn.font = [UIFont systemFontOfSize:14];
    [backBtn addSubview:banBtn];
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [MRProgressOverlayView dismissOverlayForView:self.webView animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MRProgressOverlayView dismissOverlayForView:self.webView animated:YES];
}

-(void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
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
