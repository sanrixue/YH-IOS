//
//  BaseNavigationController.m
//  Chart
//
//  Created by ice on 16/5/17.
//  Copyright © 2016年 ice. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) CAGradientLayer* gradientLayer;
@property (nonatomic, strong) UIView* barBg;
@end

@implementation BaseNavigationController

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [[CAGradientLayer alloc] init];
        _gradientLayer.colors = @[(__bridge id)UIColorHex(62C99A).CGColor,(__bridge id)UIColorHex(3A9F99).CGColor];
        　　//位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    }
    return _gradientLayer;
}

- (UIView *)barBg{
    if (!_barBg) {
        _barBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        [_barBg.layer addSublayer:self.gradientLayer];
    }
    return _barBg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.navigationBar.layer addSublayer:gradientLayer];
    self.interactivePopGestureRecognizer.delegate = self;
    self.navigationBar.opaque = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    //    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[AppColor oneColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    //    [self.navigationBar.layer insertSublayer:self.gradientLayer atIndex:0];
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
//    [self.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    //    [self.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageWithColor:[UIColor clearColor]]];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    //    [self.navigationBar insertSubview:self.barBg atIndex:0];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self customBackItem:viewController];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated hideBottom:(BOOL)hide{
    [viewController setHidesBottomBarWhenPushed:hide];
    [self pushViewController:viewController animated:animated];
}

- (void)customBackItem:(UIViewController *)viewController {
    if ([self.viewControllers count] > 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        UIBarButtonItem *button = [UIBarButtonItem createBarButtonItemWithString:@"返回" font:14 color:[UIColor whiteColor] target:self action:@selector(backAction)];
        viewController.navigationItem.leftBarButtonItem = button;
    }
}

- (void)backAction {
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count > 1) {
        return YES;
    }else{
        return NO;
    };
}@end
