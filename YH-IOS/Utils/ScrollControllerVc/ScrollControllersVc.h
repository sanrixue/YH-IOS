//
//  ViewController.h
//  demo
//
//  Created by CJG on 16/7/25.
//  Copyright © 2016年 CJG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDAutoLayout.h"

typedef void(^CommonBack)(id item);

@interface ScrollControllersVc: UIViewController
/** 选中第几个控制器, item interger类型 */
@property (nonatomic, copy) CommonBack selectBack;
/** 移动的比例系数 item number类型*/
@property (nonatomic, copy) CommonBack scaleBack;

@property (nonatomic, assign) NSInteger curIndex;

@property (nonatomic, assign) CGFloat lableW; //必须set
@property (nonatomic, assign) CGFloat lableH; //必须set

- (void)scrollWithIndex:(NSInteger)index;

- (instancetype)initWithControllers:(NSArray*)controllers
                             titles:(NSArray*)titles;

- (instancetype)initWithControllers:(NSArray*)controllers;

- (void)updateControllers:(NSArray*)controllers
                   titles:(NSArray*)titles;

- (void)updateTitles:(NSArray*)titles;

@end

