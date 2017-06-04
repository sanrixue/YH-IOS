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

@interface JYBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) JYDashboardModel *model;

@property (nonatomic, strong) JYHistogramView *histogramView;
@property (nonatomic, strong) JYSaleView *saleView;
@property (nonatomic, strong) JYNumberCircleView *numberCircle;
@property (nonatomic, strong) JYNumberLineView *numberLine;

@end
