//
//  UITabBarControllerAdditionals.h
//  Chart
//
//  Created by yh on 16/8/30.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController(Additionals)
/**
 *  tabbaritem的批量生成，格式如下
 NSArray* subViewClasses = [NSArray arrayWithObjects:
 @"供零在线,HomeViewController,shouye2,shouye",
 @"订购服务,OrderDetailsController,dinggou,dinggou2-0",
 @"门店服务,StoreServiceController,mendian-1,mendian-2",
 @"用户中心,PersonCenterController,geren,geren2",
 @"购物车,CartViewController,gouwuche,gouwuche-2",nil];
 *
 *  @param subViewClasses
 *
 *
 *  @return 
 */
- (NSArray *)createSubViewsFromItems:(NSArray *)subViewClasses;
@end
