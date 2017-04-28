//
//  DoubleClickSuperChartCell.m
//  SwiftCharts
//
//  Created by CJG on 17/4/25.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "DoubleClickSuperChartCell.h"

@interface DoubleClickSuperChartCell ()


@end

@implementation DoubleClickSuperChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)backAction:(id)sender {
    if (self.doubleBack) {
        self.doubleBack(self);
    }
}

@end
