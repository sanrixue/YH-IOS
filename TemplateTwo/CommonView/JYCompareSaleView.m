//
//  JYCompareSaleView.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYCompareSaleView.h"
#import "JYSingleValueModel.h"
#import "JYTrendTypeView.h"

@interface JYCompareSaleView () {
    UIButton *ratio;
    JYTrendTypeView *arrowView;
    UILabel *actualLB;
    UILabel *targetLB;
    UILabel *actualTitleLB;
    UILabel *targetTitleLB;
}

@property (nonatomic, strong) JYSingleValueModel *singleValueModel;

@end

@implementation JYCompareSaleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubView];
    }
    return self;
}

- (JYSingleValueModel *)singleValueModel {
    if (!_singleValueModel) {
        _singleValueModel = (JYSingleValueModel *)self.moduleModel;
    }
    return _singleValueModel;
}

- (void)initializeSubView {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake((JYViewWidth - JYViewWidth * 0.6) / 2.0, 0, JYViewWidth * 0.6, JYViewHeight / 2.0)];
    //topView.backgroundColor = JYColor_ArrowColor_Red; 
    [self addSubview:topView];
    NSArray *titles = @[@"销售额", @"－VS－", @"对比数据"];
    CGFloat widthPer = CGRectGetWidth(topView.bounds) / 5.0;
    for (int i = 0; i < 3; i++) {
        CGFloat x = (widthPer + widthPer) * i;
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(x, (CGRectGetHeight(topView.bounds) - 30) / 2.0, widthPer * 1.5 , 30)];
        if (i != 1) number.text = @"4543";
        number.adjustsFontSizeToFitWidth = YES;
        number.textAlignment = NSTextAlignmentCenter;
        number.textColor = JYColor_TextColor_Chief;
        number.font = [UIFont systemFontOfSize:20];
        [topView addSubview:number];
            
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(number.frame), i==1?(CGRectGetMaxY(number.frame) - JYDefaultMargin):CGRectGetMaxY(number.frame), CGRectGetWidth(number.frame), 20)];
        title.text = titles[i];
        title.font = [UIFont systemFontOfSize:(i == 1?13:11)];
        //title.adjustsFontSizeToFitWidth = YES;
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = i != 1 ? JYColor_TextColor_Chief : title.textColor;
        [topView addSubview:title];
        if (i == 0) {
            actualTitleLB = title;
            actualLB = number;
        }
        else if (i == 2) {
            targetTitleLB = title;
            targetLB = number;
        }
    }
    
    ratio = [UIButton buttonWithType:UIButtonTypeCustom];
    ratio.frame = CGRectMake((JYViewWidth - 100) / 2.0, JYViewHeight*(1/2.0), 100, JYViewHeight/2.0);
    [ratio addTarget:self action:@selector(changeHighNumber:) forControlEvents:UIControlEventTouchUpInside];
    [ratio setTitle:@"+9.00" forState:UIControlStateNormal];
    [ratio setTitleColor:JYColor_TextColor_Chief forState:UIControlStateNormal];
    [ratio.titleLabel setTextAlignment:NSTextAlignmentCenter];
    ratio.titleLabel.font = [UIFont systemFontOfSize:30];
    [self addSubview:ratio];
    
    arrowView = [[JYTrendTypeView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ratio.frame), CGRectGetMidY(ratio.frame) - 10, 20, 20)];
    [self addSubview:arrowView];
    
    [self refreshSubViewData];
}

- (void)changeHighNumber:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self refreshSubViewData];
}

- (void)refreshSubViewData {
    
    actualLB.text = self.singleValueModel.mainData;
    actualTitleLB.text = self.singleValueModel.mainName;
    actualLB.textColor = self.singleValueModel.arrowToColor;
    targetLB.text = self.singleValueModel.subData;
    targetTitleLB.text = self.singleValueModel.subName;
    [ratio setTitleColor:self.singleValueModel.arrowToColor forState:UIControlStateNormal];
    
    if (ratio.selected) {
        //actualLB.text = self.singleValueModel.floatRatio;
        NSString *selectedStr = [NSString stringWithFormat:@"%.2f", [self.singleValueModel.mainData floatValue] - [self.singleValueModel.subData floatValue]];
        [ratio setTitle:selectedStr forState:UIControlStateNormal];
    }
    else {
        //actualLB.text = self.singleValueModel.mainData;
        [ratio setTitle:self.singleValueModel.floatRatio forState:UIControlStateNormal];
    }
    
    CGSize size = [ratio.currentTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, JYViewHeight/2.0) options:0 attributes:@{NSFontAttributeName : ratio.titleLabel.font} context:nil].size;
    CGRect frame = ratio.frame;
    frame.size.width = size.width;
    ratio.frame = frame;
    
    CGPoint center = ratio.center;
    center.x = JYViewWidth/2.0;
    ratio.center = center;
    
    frame = arrowView.frame;
    frame.origin.x = CGRectGetMaxX(ratio.frame) + JYDefaultMargin;
    arrowView.frame = frame;
    arrowView.arrow = self.singleValueModel.arrow;
    
}


- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    return JYViewWidth * 0.4;
}

@end
