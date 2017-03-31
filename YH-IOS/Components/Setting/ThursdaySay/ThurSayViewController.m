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
    self.browser = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.browser];
    
    self.urlString = [NSString stringWithFormat:kThursdaySayMobilePath, kBaseUrl, [FileUtils currentUIVersion]];
    self.assetsPath = [FileUtils dirPath:kHTMLDirName];
    [self loadHtml];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:false];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
