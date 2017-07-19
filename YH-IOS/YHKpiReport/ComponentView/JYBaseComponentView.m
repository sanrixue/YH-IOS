//
//  JYBaseComponentView.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseComponentView.h"

@implementation JYBaseComponentView

- (void)setModel:(JYBaseModel *)model {
    if (![_model isEqual:model]) {
        _model = model;
    }
    [self refreshSubViewData];
}

- (void)refreshSubViewData {
    
}

- (CGFloat)estimateViewHeight:(JYBaseModel *)model {
    return 0;
}

@end
