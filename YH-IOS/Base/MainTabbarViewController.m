//
//  MainTabbarViewController.m
//  Chart
//
//  Created by ice on 16/5/16.
//  Copyright © 2016年 ice. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "UITabBar+TabBarTip.h"

@interface MainTabbarViewController () <UITabBarControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, assign) BOOL isShouldSelected;
@property (nonatomic, strong) NSArray* dataArr;
@end

@implementation MainTabbarViewController

+ (instancetype)instance {
    MainTabbarViewController *controller = [[MainTabbarViewController alloc] init];
    controller.viewControllers = [controller createSubViewsFromItems:controller.dataArr];
    [controller setSelectedIndex:0];
    [controller setItems];
    return controller;
}

+ (instancetype)instanceWithArr:(NSArray *)arr{
    MainTabbarViewController *controller = [[MainTabbarViewController alloc] init];
    controller.viewControllers = [controller createSubViewsFromItems:arr];
    [controller setSelectedIndex:0];
    [controller setItems];
    return controller;
}

+ (instancetype)instanceEnterpriseTabVc{
    NSArray *arr = [NSArray arrayWithObjects:
                    @"福利商城,EnterpriseBuyHomeVc,tab_home2,tab_home1",
                    @"分类,EnterpriseCategoryVc,tab_recipe2,tab_recipe1",
                    @"采购清单,CartViewController,tab_shop2,tab_shop1",
                    @"我的,PersonCenterController,tab_my2,tab_my1",
                    nil];
    return [self instanceWithArr:arr];
}

//- (instancetype)init{
//    self = [super init];
//    [self setValue:[[APPTabBar alloc] init] forKeyPath:@"tabBar"];
//    return self;
//}

- (void)showBadgeOnItemIndex:(int)index{
    [self.tabBar showBadgeOnItemIndex:index];
}

- (void)hideBadgeOnItemIndex:(int)index{
    [self.tabBar hideBadgeOnItemIndex:index];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    self.viewControllers = [self createSubViewController];
//    [self setSelectedIndex:0];
    self.delegate = self;//    [self setItems];
}

- (void)updateWithCartChange{
//    if (CurDataManager.customer && CurDataManager.cart.data.count>0) {
//        self.tabBar.items[2].badgeValue = [NSString stringWithFormat:@"%zd",CurDataManager.cart.data.count];
//    }else{
//        self.tabBar.items[2].badgeValue = nil;
//    }
}

- (void)dealloc{
    [NotificationDefaultCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

/** 设置底部item样式 */
- (void)setItems{
    for (UIViewController *vc in self.childViewControllers) {
        [vc.tabBarItem setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName:[AppColor textColor]
                                                } forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName:[AppColor oneColor]
                                                } forState:UIControlStateSelected];
    }


}
//
//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    int count = 0;
//    for (int i = 0; i<self.tabBar.subviews.count; i++) {
//        UIView *item = self.tabBar.subviews[i];
//        if ([item isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            count++;
//            CGFloat width = SCREEN_WIDTH/self.viewControllers.count;
//            item.frame = CGRectMake(width*count, 0, width, self.tabBar.bounds.size.height);
//        }
//
//    }
//}


- (NSArray *)createSubViewController {
        return [self createSubViewsFromItems:self.dataArr];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    _isShouldSelected = 0;
//    self.tabBar.hidden = NO;
//    BaseNavigationController *nav = (BaseNavigationController*)viewController;
//    if ([nav.topViewController isKindOfClass:NSClassFromString(@"PersonCenterController")]||[nav.topViewController isKindOfClass:NSClassFromString(@"CartViewController")] || [nav.topViewController isKindOfClass:NSClassFromString(@"EnterpriseCategoryVc")]) {
//        [Customer verifyIsOnline:^(Customer *customer) {
//            [self setSelectedViewController:viewController];
//        }];
//    }else{
//        _isShouldSelected = YES;
//    }
    return _isShouldSelected;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UIViewController *vc = ((UINavigationController*)viewController).viewControllers[0];
//    if ( [vc isKindOfClass:[ class]]) {
//        if ([vc isViewLoaded]) {
//            [vc performSelector:@selector(loadData)];
//        }
//    }
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.selectedViewController;
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray arrayWithObjects:
                    @"订单中心,PersonCenterController,1_02,1_01",
                    @"结算中心,PersonCenterController,2_02,2_01",
                    @"我的,PersonCenterController,3_02,3_01",
                    @"设置,SettingVc,4_02,4_01",
                    nil];
    }
    return _dataArr;
}



@end
