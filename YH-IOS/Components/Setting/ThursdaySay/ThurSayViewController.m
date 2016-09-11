//
//  ThurSayViewController.m
//  YH-IOS
//
//  Created by li hao on 16/9/11.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "ThurSayViewController.h"
#import "FileUtils+Assets.h"

@interface ThurSayViewController ()<UINavigationBarDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIWebView *browser;
@property (nonatomic, strong) NSString *thurSayPath;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *assetsPath;

@end

@implementation ThurSayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kBannerHeight)];
    self.navBar.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 60, 30)];
    [backBtn addTarget:self action:@selector(dismissThurSay) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setImage:[UIImage imageNamed:@"Banner-Back"] forState:UIControlStateNormal];
    [self.navBar addSubview:backBtn];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 30)];
    titleLabel.text = @"小四说";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navBar addSubview:titleLabel];
    
    [self.view addSubview:self.navBar];
    self.browser = [[UIWebView alloc]initWithFrame:CGRectMake(0, kBannerHeight, self.view.frame.size.width, self.view.frame.size.height - kBannerHeight)];
    [self.view addSubview:self.browser];
    
    self.urlString = [NSString stringWithFormat:THURSDAY_SAY_PATH, kBaseUrl, [FileUtils currentUIVersion]];
    self.assetsPath = [FileUtils dirPath:HTML_DIRNAME];
    
    self.thurSayPath = [FileUtils dirPath:HTML_DIRNAME FileName:@"thursday_say.html"];
    [self loadHtml];
}

- (void)loadHtml {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
            NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[FileUtils sharedPath]]];
        });
    });
 }

- (void)dismissThurSay {
    [self dismissViewControllerAnimated:YES completion:nil];
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
