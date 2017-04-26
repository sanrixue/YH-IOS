//
//  YHBaseViewController.h
//  SwiftCharts
//
//  Created by li hao on 17/4/18.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "MainTabbarViewController.h"

@class EmptyView;

#define RootTabbarViewConTroller [YHBaseViewController getMainTabController]
#define RootNavigationController [YHBaseViewController getRootNavController]

typedef void(^CommonBack)(id item);

@interface YHBaseViewController : UIViewController

@property (nonatomic, strong) EmptyView* emptyView;

+ (MainTabbarViewController*)getMainTabController;

+ (BaseNavigationController*)getRootNavController;

- (void)addSubViews;

- (void)makeConstrains;

- (void)backAction;

- (void)showEmptyView:(BOOL)show;

- (void)creatRightItemWithTitle:(NSString*)title target:(id)target selector:(SEL)selector;

- (void)creatBackItem;

- (void)popNeedAnimation:(BOOL)needAnimation;
/**
 *  是否全屏布局
 *
 *  @param full 是否全屏
 */
- (void)fullScreen:(BOOL)full;

- (NSInvocation *)callClassName:(NSString *)className
           staticMethodSelector:(SEL)aSelector
                         params:(void*[])params
                     paramsSize:(int)size;


- (void)setUIRectEdge:(BOOL)edge;
/** 控制器push方法 */
- (void)pushViewController:(UIViewController*)vc
                 animation:(BOOL)needAnimation
                hideBottom:(BOOL)hideBottom;

- (void)popNeedAnimation:(BOOL)needAnimation;

+ (void)gotoHomeViewControllerNeedRefresh:(BOOL)refresh;

+ (void)gotoMyPersonViewController;

+ (void)gotoMyOrderViewController;

+ (void)gotoProductDetailWithId:(NSString*)productId
                       imageUrl:(NSString*)url
                    productName:(NSString*)name;


//返回上一个视图
- (void)backTo;

+ (void)gotoEmptyVc;

- (void)showNoCartView:(BOOL)show;

@end
