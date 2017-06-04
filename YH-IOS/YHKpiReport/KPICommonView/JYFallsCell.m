//
//  JYFallsCollectionViewCell.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYFallsCell.h"

@implementation JYFallsCell

- (void)setModel:(JYDashboardModel *)model {
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
            
        default:
            break;
    }
}



@end
