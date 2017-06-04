//
//  JYCompareSaleView.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYCompareSaleView.h"

@interface JYCompareSaleView () {
    UILabel *ratio;
    UIImageView *IV;
    UILabel *actualLB;
    UILabel *targetLB;
}

@end

@implementation JYCompareSaleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubView];
    }
    return self;
}

- (void)initializeSubView {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake((JYViewWidth - JYViewWidth * 0.6) / 2.0, 0, JYViewWidth * 0.6, JYViewHeight / 2.0)];
    //topView.backgroundColor = JYColor_ArrowColor_Red;
    [self addSubview:topView];
    NSArray *titles = @[@"销售额", @"－VS－", @"对比数据"];
    CGFloat widthPer = CGRectGetWidth(topView.bounds) / 5.0;
    for (int i = 0; i < 3; i++) {
        CGFloat x = (widthPer + widthPer) * i;
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(x, (CGRectGetHeight(topView.bounds) - 30) / 2.0, widthPer , 20)];
        if (i != 1) number.text = @"4543";
        number.adjustsFontSizeToFitWidth = YES;
        [topView addSubview:number];
        if (i == 0) actualLB = number;
        else if (i == 2) targetLB = number;
            
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(number.frame), i==1?(CGRectGetMaxY(number.frame) - JYDefaultMargin):CGRectGetMaxY(number.frame), widthPer + JYDefaultMargin, 20)];
        title.text = titles[i];
        title.font = [UIFont systemFontOfSize:(i == 1?13:11)];
        //title.adjustsFontSizeToFitWidth = YES;
        [topView addSubview:title];
    }
    
    ratio = [[UILabel alloc] initWithFrame:CGRectMake((JYViewWidth - 100) / 2.0, JYViewHeight*(1/2.0), 100, JYViewHeight/2.0)];
    ratio.text = @"+9.00";
    ratio.textAlignment = NSTextAlignmentCenter;
    ratio.font = [UIFont systemFontOfSize:30];
    [self addSubview:ratio];
    
    IV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ratio.frame), CGRectGetMidY(ratio.frame) - 10, 20, 20)];
    IV.image = [UIImage imageNamed:@"down_greenarrow"];
    [self addSubview:IV];
    
    [self refreshSubViewData];
}

- (void)refreshSubViewData {
    
    CGSize size = [ratio.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, JYViewHeight/2.0) options:0 attributes:@{NSFontAttributeName : ratio.font} context:nil].size;
    CGRect frame = ratio.frame;
    frame.size.width = size.width;
    ratio.frame = frame;
    
    CGPoint center = ratio.center;
    center.x = JYViewWidth/2.0 - 20;
    ratio.center = center;
    
    frame = IV.frame;
    frame.origin.x = CGRectGetMaxX(ratio.frame) + JYDefaultMargin;
    IV.frame = frame;
    
}


- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    return JYViewWidth * 0.4;
}

@end
