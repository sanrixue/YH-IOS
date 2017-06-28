//
//  JYBaseCollectionViewCell.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYDashboardModel.h"

#import "JYHistogramView.h"
#import "JYSaleView.h"
#import "JYNumberLineView.h"
#import "JYNumberCircleView.h"
#import "JYSigleValueView.h"
#import "JYSignleValueLoneView.h"
#import "YHKPIModel.h"

@interface JYBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) YHKPIDetailModel *model;

//柱状图
@property (nonatomic, strong) JYHistogramView *histogramView;
// 只有值的图
@property (nonatomic, strong) JYSaleView *saleView;
// 环形图
@property (nonatomic, strong) JYNumberCircleView *numberCircle;
// 折线图
@property (nonatomic, strong) JYNumberLineView *numberLine;

//短单值类型
@property (nonatomic, strong) JYSigleValueView *signleValue;

//长单值类型
@property (nonatomic, strong) JYSignleValueLoneView *signleLongValue;
@property (nonatomic, assign) BOOL isFirstRow;

@end
