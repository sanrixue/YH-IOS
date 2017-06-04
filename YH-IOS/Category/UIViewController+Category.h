//
//  UIViewController+Category.h
//  haofang
//
//  Created by PengFeiMeng on 3/26/14.
//  Copyright (c) 2014 iflysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)

/*!
 @method
 @abstract  自定义viewDidLoad方法
 */
- (void)viewDidLoadCustom;
/*!
 @method
 @abstract  自定义viewWillAppear方法
 */
- (void)viewWillAppearCustom:(BOOL)animated;

//返回上级视图
- (void)backTo;

@end
