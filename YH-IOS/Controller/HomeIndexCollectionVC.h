//
//  HomeIndexCollectionVC.h
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHBaseViewController.h"
#import "HomeIndexModel.h"

@class HomeIndexCollectionVC;

@protocol HomeIndexCollectionVCDelegate <NSObject>
- (void)homeIndexCollectionVCSelectIndex:(NSInteger)index model:(HomeIndexItemModel*)model vc:(HomeIndexCollectionVC*)vc;
- (void)doubClikWithHomeIndexCollectionVCSelectIndex:(NSInteger)index model:(HomeIndexItemModel*)model vc:(HomeIndexCollectionVC*)vc;
@end

@interface HomeIndexCollectionVC : YHBaseViewController
@property (nonatomic, weak)  id<HomeIndexCollectionVCDelegate> delegate;

- (void)setWithHomeIndexModel:(HomeIndexItemModel*)model;

@end
