//
//  MianTabBarViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MianTabBarViewController.h"
#import "ApplicationViewController.h"
#import "MessageViewController.h"
#import "AnalysisViewController.h"
#import "KPIViewController.h"
#import <MBProgressHUD.h>
#import "AFNetworking.h"
#import "JYHomeViewController.h"
#import "YH_IOS-Swift.h"
#import "MineController.h"
#import "YHReportViewController.h"
#import "YHTopicViewController.h"
#import "BaseNavigationController.h"

@interface MianTabBarViewController ()

@end

@implementation MianTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remotePushJump:) name:@"remotepush" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remotrPushJump:) name:@"remotepush" object:nil];
    [self addchildControllers];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];  
}

-(void)viewWillAppear:(BOOL)animated {
    [self checkAssetsUpdate];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)addchildControllers{
    
    YHTopicViewController *applicationRootView  = [[YHTopicViewController alloc]init];
   // ApplicationViewController *applicationRootView = [[ApplicationViewController alloc]init];
    UINavigationController *applicationRootViewController = [[BaseNavigationController alloc]initWithRootViewController:applicationRootView];
    applicationRootView.title = @"专题";
    applicationRootViewController.tabBarItem.title = @"专题";
    applicationRootViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    [applicationRootViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:kThemeColor]} forState:UIControlStateSelected];
    applicationRootViewController.tabBarItem.image = [[UIImage imageNamed:@"TabBar-App"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    applicationRootViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"TabBar-App-Selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MineController *messageRootView = [[MineController alloc]init];
   // MessageViewController *messageRootView= [[MessageViewController alloc]init];
    UINavigationController *messageRootViewController = [[BaseNavigationController alloc]initWithRootViewController:messageRootView];
    messageRootViewController.tabBarItem.title = @"我的";
    messageRootViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    [messageRootViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:kThemeColor]} forState:UIControlStateSelected];
    messageRootViewController.tabBarItem.image = [[UIImage imageNamed:@"TabBar-Message"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageRootViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"TabBar-Message-Selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    YHReportViewController *analysisRootView = [[YHReportViewController alloc]init];
    //AnalysisViewController *analysisRootView = [[AnalysisViewController alloc]init];
    UINavigationController *analysisRootViewController = [[BaseNavigationController alloc]initWithRootViewController:analysisRootView];
    analysisRootView.title = @"报表";
    analysisRootViewController.tabBarItem.title = @"报表";
    analysisRootViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    [analysisRootViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:kThemeColor]} forState:UIControlStateSelected];
    analysisRootViewController.tabBarItem.image = [[UIImage imageNamed:@"TabBar-Analyse"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    analysisRootViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"TabBar-Analyse-Selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
   // KPIViewController *kpiRootView = [[KPIViewController alloc]init];
    //UINavigationController *kpiRootViewController  = [[UINavigationController alloc]initWithRootViewController:kpiRootView];
    JYHomeViewController *kpiRootView = [[JYHomeViewController alloc]init];
    UINavigationController *kpiRootViewController  = [[BaseNavigationController alloc]initWithRootViewController:kpiRootView];
    kpiRootViewController.tabBarItem.title = @"生意概况";
    [kpiRootViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:kThemeColor]} forState:UIControlStateSelected];
    kpiRootViewController.edgesForExtendedLayout = UIRectEdgeNone;
    kpiRootViewController.tabBarItem.image = [[UIImage imageNamed:@"TabBar-KPI"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    kpiRootViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"TabBar-KPI-Selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    kpiRootViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    self.viewControllers = @[kpiRootViewController,analysisRootViewController,applicationRootViewController,messageRootViewController];
    
}


/**
 *  检测服务器端静态文件是否更新
 */
- (void)checkAssetsUpdate {
    // 初始化队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    AFHTTPRequestOperation *op;
    op = [self checkAssetUpdate:kLoadingAssetsName info:kLoadingPopupText isInAssets: NO];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kFontsAssetsName info:kFontsPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kImagesAssetsName info:kImagesPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kStylesheetsAssetsName info:kStylesheetsPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kJavascriptsAssetsName info:kJavascriptsPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kBarCodeScanAssetsName info:kBarCodeScanPopupText isInAssets: NO];
    if(op) { [queue addOperation:op]; }
    // op = [self checkAssetUpdate:kAdvertisementAssetsName info:kAdvertisementPopupText isInAssets: NO];
    // if(op) { [queue addOperation:op]; }
}

- (AFHTTPRequestOperation *)checkAssetUpdate:(NSString *)assetName info:(NSString *)info isInAssets:(BOOL)isInAssets {
    BOOL isShouldUpdateAssets = NO;
    __block NSString *sharedPath = [FileUtils sharedPath];
    
    NSString *assetsZipPath = [sharedPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", assetName]];
    if(![FileUtils checkFileExist:assetsZipPath isDir:NO]) {
        isShouldUpdateAssets = YES;
    }
    
    __block NSString *assetKey = [NSString stringWithFormat:@"%@_md5", assetName];
    __block  NSString *localAssetKey = [NSString stringWithFormat:@"local_%@_md5", assetName];
    __block NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    __block NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(!isShouldUpdateAssets && ![userDict[assetKey] isEqualToString:userDict[localAssetKey]]) {
        isShouldUpdateAssets = YES;
        NSLog(@"%@ - local: %@, server: %@", assetName, userDict[localAssetKey], userDict[assetKey]);
    }
    
    if(!isShouldUpdateAssets) { return nil; }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.tag       = 1000;
    HUD.mode      = MBProgressHUDModeDeterminate;
    HUD.labelText = [NSString stringWithFormat:@"更新%@", info];
    HUD.square    = YES;
    [HUD show:YES];
    
    // 下载地址
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kDownloadAssetsAPIPath, kBaseUrl, assetName]];
    // 保存路径
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:assetsZipPath append:NO];
    // 根据下载量设置进度条的百分比
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
        HUD.progress = precent;
    }];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [FileUtils checkAssets:assetName isInAssets:isInAssets bundlePath:[[NSBundle mainBundle] bundlePath]];
        
        [HUD removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@" 下载失败 ");
        [HUD removeFromSuperview];
    }];
    return op;
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
