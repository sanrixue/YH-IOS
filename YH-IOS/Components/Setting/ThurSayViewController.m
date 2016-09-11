//
//  ThurSayViewController.m
//  YH-IOS
//
//  Created by li hao on 16/9/11.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "ThurSayViewController.h"
#import "FileUtils.h"

@interface ThurSayViewController ()<UINavigationBarDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UIWebView *browser;
@property (nonatomic,strong) NSString *thurSayPath;
@property (nonatomic,strong) UIView *navBar;

@end

@implementation ThurSayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kBannerHeight)];
    self.navBar.backgroundColor = [UIColor lightGrayColor];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 30)];
    [backBtn addTarget:self action:@selector(dismissThurSay) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"Banner-Back"] forState:UIControlStateNormal];
    [self.view addSubview:self.navBar];
    [self.navBar addSubview:backBtn];
    self.browser = [[UIWebView alloc]initWithFrame:CGRectMake(0, kBannerHeight, self.view.frame.size.width, self.view.frame.size.height - kBannerHeight)];
    [self.view addSubview:self.browser];
    self.thurSayPath = [FileUtils dirPath:@"HTML" FileName:@"thursday_say.html"];
    [self loadHtml];
    // Do any additional setup after loading the view.
}

- (void) loadHtml {
    NSString *contentHtml;
    if (![FileUtils checkFileExist:self.thurSayPath isDir:YES]) {
        contentHtml = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://yonghui-test.idata.mobi/thursday_say"] encoding:NSUTF8StringEncoding error:nil];;
    }
    else {
        contentHtml = [NSString stringWithContentsOfFile:self.thurSayPath encoding:NSUTF8StringEncoding error:nil];
    }
    [self.browser loadHTMLString:contentHtml baseURL:[NSURL URLWithString:self.thurSayPath]];
}

- (void) dismissThurSay {
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
