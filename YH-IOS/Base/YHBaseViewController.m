//
//  YHBaseViewController.m
//  SwiftCharts
//
//  Created by li hao on 17/4/18.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHBaseViewController.h"


#define NoContentViewTag 0x010101010101


@interface YHBaseViewController ()

@end

@implementation YHBaseViewController


+ (MainTabbarViewController *)getMainTabController{
    return ((MainTabbarViewController*)[AppDelegate shareAppdelegate].window.rootViewController);
}

+ (BaseNavigationController *)getRootNavController{
    return [YHBaseViewController getMainTabController].selectedViewController;
}

- (void)backAction{
    if (self.navigationController && self.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)creatRightItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[AppColor textColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self fullScreen:NO];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)fullScreen:(BOOL)full {
    if (full) {
        self.edgesForExtendedLayout =  UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = YES;
    } else {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
}

- (NSInvocation *)callClassName:(NSString *)className staticMethodSelector:(SEL)aSelector params:(void*[])params paramsSize:(int)size {
    Class cellClass =NSClassFromString(className);
    SEL selector = aSelector;
    
    NSMethodSignature *sig=[cellClass methodSignatureForSelector:selector];
    //根据方法签名创建一个NSInvocation
    NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:sig];
    //设置调用者也就是AsynInvoked的实例对象，在这里我用self替代
    [invocation setTarget:cellClass];
    //设置被调用的消息
    [invocation setSelector:selector];
    
    //如果此消息有参数需要传入，那么就需要按照如下方法进行参数设置，需要注意的是，atIndex的下标必须从2开始。原因为：0 1 两个参数已经被target 和selector占用
    for (int i =0; i < size; i ++) {
        [invocation setArgument:params[i] atIndex:2+i];
    }
    
    //消息调用
    [invocation invoke];
    return invocation;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)pushViewController:(UIViewController *)vc animation:(BOOL)needAnimation hideBottom:(BOOL)hideBottom{
    [vc setHidesBottomBarWhenPushed:hideBottom];
    [self.navigationController pushViewController:vc animated:needAnimation];
}

- (void)popNeedAnimation:(BOOL)needAnimation{
    [self.navigationController popViewControllerAnimated:needAnimation];
}

- (void)setUIRectEdge:(BOOL)edge
{
    if (!edge) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    else{
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
}

+ (void)gotoHomeViewControllerNeedRefresh:(BOOL)refresh{
    BaseNavigationController *nav = RootNavigationController;
    [nav popToRootViewControllerAnimated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [RootTabbarViewConTroller setSelectedIndex:0];
        //        HomeViewController *home = RootNavigationController.viewControllers[0];
        //        if (refresh == YES) {
        //            [home refresh];
        //        }
    });
}

+ (void)gotoMyPersonViewController{
    if (RootNavigationController.childViewControllers.count>1) {
        [RootNavigationController  popToRootViewControllerAnimated:NO];
    }
    RootTabbarViewConTroller.selectedIndex = 3;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //    });
}

+ (void)gotoMyOrderViewController{
    if (RootNavigationController.childViewControllers.count>1) {
        [RootNavigationController  popToRootViewControllerAnimated:NO];
    }
    RootTabbarViewConTroller.selectedIndex = 3;
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

+ (void)gotoProductDetailWithId:(NSString *)productId imageUrl:(NSString *)url productName:(NSString *)name{
    //    GoodDetailSynthesizeViewController *vc = [[GoodDetailSynthesizeViewController alloc] init:productId imageUrl:url prouctName:name];
    //    [RootNavigationController pushViewController:vc animated:1 hideBottom:1];
}

+ (void)gotoEmptyVc{
    YHBaseViewController *vc = [[YHBaseViewController alloc] init];
    vc.title = @"建设中";
    [RootNavigationController pushViewController:vc animated:YES hideBottom:YES];
    [vc showEmptyView:YES];
}

//- (void)showEmptyView:(BOOL)show{
//    [EmptyView removeEmptyViewInView:self.view];
//    self.emptyView = nil;
//    if (show) {
//        self.emptyView = [EmptyView instanceJiansheZhongView];
//        [self.view addSubview:self.emptyView];
//        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
//    }
//}
//
//- (void)showNoCartView:(BOOL)show{
//    [EmptyView removeEmptyViewInView:self.view];
//    if (show) {
//        EmptyView *emptyView = [EmptyView instanceCartEmptyView];
//        [self.view addSubview:emptyView];
//        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
//    }
//}

- (void)creatBackItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"newnav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)gotoHomeVc{
    [self dismissViewControllerAnimated:YES completion:^{
        [YHBaseViewController gotoHomeViewControllerNeedRefresh:NO];
    }];
}

- (void)makeConstrains{
    // do nothing
}

-  (void)addSubViews{
    // do nothing
}

- (void)dealloc{
    DLog(@"%@ %@控制器==== 销毁了",self.title,NSStringFromClass([self class]))
}

//返回上级视图
- (void)backTo{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([self.tabBarController.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]){
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
