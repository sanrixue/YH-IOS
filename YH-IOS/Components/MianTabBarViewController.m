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

@interface MianTabBarViewController ()

@end

@implementation MianTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addchildControllers];
}

-(void)viewWillAppear:(BOOL)animated {
    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:kThemeColor]];
}

- (void)addchildControllers{
    ApplicationViewController *applicationRootView = [[ApplicationViewController alloc]init];
    UINavigationController *applicationRootViewController = [[UINavigationController alloc]initWithRootViewController:applicationRootView];
    applicationRootViewController.tabBarItem.title = @"应用";
    applicationRootViewController.tabBarItem.image = [UIImage imageNamed:@"TabBar-App"];
    applicationRootViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"TabBar-App-Selected"];
    
    MessageViewController *messageRootView= [[MessageViewController alloc]init];
    UINavigationController *messageRootViewController = [[UINavigationController alloc]initWithRootViewController:messageRootView];
    messageRootViewController.tabBarItem.title = @"消息";
    messageRootViewController.tabBarItem.image = [UIImage imageNamed:@"TabBar-Message"];
    messageRootViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"TabBar-Message-Selected"];
    
    AnalysisViewController *analysisRootView = [[AnalysisViewController alloc]init];
    UINavigationController *analysisRootViewController = [[UINavigationController alloc]initWithRootViewController:analysisRootView];
    analysisRootViewController.tabBarItem.title = @"分析";
    analysisRootViewController.tabBarItem.image = [UIImage imageNamed:@"TabBar-Analyse"];
    analysisRootViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"TabBar-Analyse-Selected"];
    
    KPIViewController *kpiRootView = [[KPIViewController alloc]init];
    UINavigationController *kpiRootViewController  = [[UINavigationController alloc]initWithRootViewController:kpiRootView];
    kpiRootViewController.tabBarItem.title = @"仪表盘";
    kpiRootViewController.tabBarItem.image = [UIImage imageNamed:@"TabBar-KPI"];
    kpiRootViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"TabBar-KPI-Selected"];
                                                           
    
    self.viewControllers = @[kpiRootViewController,analysisRootViewController,applicationRootViewController,messageRootViewController];
    
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
