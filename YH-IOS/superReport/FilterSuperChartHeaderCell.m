//
//  FilterSuperChartHeaderCell.m
//  SwiftCharts
//
//  Created by CJG on 17/4/24.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "FilterSuperChartHeaderCell.h"

@implementation FilterSuperChartHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_swichBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (_swichBack) {
            _swichBack(self);
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
