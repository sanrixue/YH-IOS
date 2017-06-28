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

- (void)setModel:(YHKPIDetailModel *)model {
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


-(JYSigleValueView *)signleValue{
    if (!_signleValue) {
        _signleValue = [[JYSigleValueView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width,107)];
        _signleValue.model = self.model;
    }
    return _signleValue;
}


-(JYSignleValueLoneView *)signleLongValue{
    if (!_signleLongValue) {
        _signleLongValue = [[JYSignleValueLoneView alloc]initWithFrame:CGRectMake(8, 0, self.bounds.size.width-16,58) withShow:self.isFirstRow];
         _signleLongValue.model = self.model;
    }
    return _signleLongValue;
}

@end
