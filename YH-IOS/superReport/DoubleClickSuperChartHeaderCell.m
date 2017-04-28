//
//  DoubleClickSuperChartHeaderCell.m
//  SwiftCharts
//
//  Created by CJG on 17/4/25.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "DoubleClickSuperChartHeaderCell.h"

@implementation DoubleClickSuperChartHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.sortBack) {
            self.sortBack(self);
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
