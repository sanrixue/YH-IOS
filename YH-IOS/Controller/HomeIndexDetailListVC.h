//
//  HomeIndexDetailListVC.h
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHBaseViewController.h"
#import "HomeIndexModel.h"

@class HomeIndexDetailListVC;

@protocol HomeIndexDetailListVCDelegate <NSObject>

- (void)HomeIndexDetailListVCSelectIndex:(NSInteger)index model:(HomeIndexModel*)model vc:(HomeIndexDetailListVC*)vc;
/** 排序 */
- (void)HomeIndexDetailListVCSortDown:(BOOL)down model:(HomeIndexModel*)model vc:(HomeIndexDetailListVC*)vc;


@end

typedef NS_ENUM(NSInteger, HomeIndexDetailListVCSortType) {
    HomeIndexDetailListVCSortTypeDefault,          //regular table view
    HomeIndexDetailListVCSortTypeUp, // 升序列
    HomeIndexDetailListVCSortTypeDown,// 降序列
};

@interface HomeIndexDetailListVC : YHBaseViewController

@property (nonatomic, assign) HomeIndexDetailListVCSortType sortType;
@property (nonatomic, weak) id<HomeIndexDetailListVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *topNamebtn;

- (void)setWithHomeIndexModel:(HomeIndexModel*)model;

@end
