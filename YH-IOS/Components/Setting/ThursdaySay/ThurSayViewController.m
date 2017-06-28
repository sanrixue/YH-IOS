//
//  ThurSayViewController.m
//  YH-IOS
//
//  Created by li hao on 16/9/11.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "ThurSayViewController.h"
#import "FileUtils+Assets.h"
#import "HttpUtils.h"
#import "HttpResponse.h"

@interface ThurSayViewController ()
@property (nonatomic, strong) UIWebView *browser;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *assetsPath;

@end

@implementation ThurSayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:NO];
    //self.automaticallyAdjustsScrollViewInsets = YES;
    self.browser = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+49)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.browser.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.browser];
    
    self.urlString = [NSString stringWithFormat:kThursdaySayMobilePath, kBaseUrl, [FileUtils currentUIVersion]];
    self.assetsPath = [FileUtils dirPath:kHTMLDirName];
    [self loadHtml];
}

-(void)viewWillAppear:(BOOL)animated {
  /*  [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"Banner-Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
   // backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
  //  [self.navigationItem.leftBarButtonItem setTitlePositionAdjustment:UIOffsetMake(-30, 0) forBarMetrics:UIBarMetricsDefault];
    //[backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];*/
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadHtml {
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
            NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[FileUtils sharedPath]]];
        });
    });
 }

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
