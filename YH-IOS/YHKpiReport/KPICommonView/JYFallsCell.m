//
//  JYFallsCollectionViewCell.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYFallsCell.h"
#import "YHKPIModel.h"

@implementation JYFallsCell

- (void)setModel:(YHKPIDetailModel *)model {
    [super setModel:model];
    
    switch (model.dashboardType) {
        case DashBoardTypeBar:
            self.histogramView.model = self.model;
            [self addSubview:self.histogramView];
            break;
        case DashBoardTypeNumber:
            self.saleView.model = self.model;
            [self addSubview:self.saleView];
            break;
        case DashBoardTypeRing:
            self.numberCircle.model = self.model;
            [self addSubview:self.numberCircle];
            break;
        case DashBoardTypeLine:
            self.numberLine.model = self.model;
            [self addSubview:self.numberLine];
            break;
        case DashBoardTypeSignleValue1:
            self.signleValue.model = self.model;
            [self addSubview:self.signleValue];
            break;
        case DashBoardTypeSignleLongValue1:
            self.signleLongValue.model  = self.model;
            self.signleLongValue.isShow = self.isFirstRow;
            [self addSubview:self.signleLongValue];
            break;
            
        default:
            break;
    }
}



@end
