//
//  JYBaseCollectionViewCell.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseCollectionViewCell.h"


@interface JYBaseCollectionViewCell ()


@end

@implementation JYBaseCollectionViewCell

- (void)setModel:(JYDashboardModel *)model {
    if (![model isEqual:_model]) {
        _model = model;
    }
}

- (JYHistogramView *)histogramView {
    if (!_histogramView) {
        _histogramView = [[JYHistogramView alloc] initWithFrame:self.bounds];
        _histogramView.model = self.model;
        _histogramView.backgroundColor = [UIColor whiteColor];
        _histogramView.layer.cornerRadius = 5;
    }
    return _histogramView;
}

- (JYSaleView *)saleView {
    if (!_saleView) {
        
        _saleView = [[JYSaleView alloc] initWithFrame:self.bounds];
        _saleView.model = self.model;
        _saleView.backgroundColor = [UIColor whiteColor];
        _saleView.layer.cornerRadius = 5;
    }
    return _saleView;
}

- (JYNumberCircleView *)numberCircle {
    if (!_numberCircle) {
        
        _numberCircle = [[JYNumberCircleView alloc] initWithFrame:self.bounds];
        _numberCircle.model = self.model;
        _numberCircle.backgroundColor = [UIColor whiteColor];
        _numberCircle.layer.cornerRadius = 5;
    }
    return _numberCircle;
}

- (JYNumberLineView *)numberLine {
    if (!_numberLine) {
        
        _numberLine = [[JYNumberLineView alloc] initWithFrame:self.bounds];
        _numberLine.model = self.model;
        _numberCircle.backgroundColor = [UIColor whiteColor];
        _numberLine.layer.cornerRadius = 5;        
    }
    return _numberLine;
}


@end
