//
//  UIViewController+Category.m
//  haofang
//
//  Created by PengFeiMeng on 3/26/14.
//  Copyright (c) 2014 iflysoft. All rights reserved.
//

#import "UIViewController+Category.h"
#import "UINavigationBar+Category.h"
#import "BasicTool.h"

@implementation UIViewController (Category)

#pragma mark - view life circle
- (void)viewDidLoadCustom{
    //autoresize
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask    = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //adaption
    if (SYSTEM_VERSION >= 7.0) {
        self.edgesForExtendedLayout                 = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars       = NO;
        self.automaticallyAdjustsScrollViewInsets   = NO;
    }
    
    // Fixed: 不用在每个view上都显示
    //通用自定义返回按钮设置
    //[self setBackBarButton];
    
    [self viewDidLoadCustom];
}

- (void)viewWillAppearCustom:(BOOL)animated{
    //[UIApplication sharedApplication].statusBarHidden = NO
    
    [self viewWillAppearCustom:animated];
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
