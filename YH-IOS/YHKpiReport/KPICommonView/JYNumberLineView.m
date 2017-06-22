//
//  JYNumberLineView.m
//  各种报表
//
//  Created by niko on 17/4/29.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYNumberLineView.h"
#import "JYLineChartView.h"
#import "JYTrendTypeView.h"

@interface JYNumberLineView () {
    UILabel *unit;
}

@property (nonatomic, strong) JYLineChartView *lineView;
@property (nonatomic, strong) UILabel *groupNameLB;
@property (nonatomic, strong) JYTrendTypeView *trendTypeView;
@property (nonatomic, strong) UILabel *saleNumberLB;
@property (nonatomic, strong) UILabel *ratio;;


@end

@implementation JYNumberLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initilizedSubView];
    }
    return self;
}

- (void)initilizedSubView {
 
    [self addSubview:self.lineView];
    [self addSubview:self.groupNameLB];
    [self addSubview:self.trendTypeView];
    [self addSubview:self.ratio];
    [self addSubview:self.saleNumberLB];
    
    unit = [[UILabel alloc] initWithFrame:CGRectMake(JYViewWidth - 30, CGRectGetHeight(self.frame) - 30, 30, 30)];
    unit.text = @"万";
    unit.font = [UIFont systemFontOfSize:13];
    unit.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:unit];
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.8;
}

- (void)setModel:(YHKPIDetailModel *)model {
    if (![_model isEqual:model]) {
        _model = model;
        
        [self refreshSubViewData];
    }
}

- (JYLineChartView *)lineView {
    if (!_lineView) {
        _lineView = [[JYLineChartView alloc] initWithFrame:CGRectMake(0, 0, JYViewWidth, JYViewHeight / 2.0 - JYDefaultMargin)];
        _lineView.backgroundColor = [UIColor whiteColor];
        _lineView.lineColor = [UIColor colorWithRed:0.91 green:0.27 blue:0.24 alpha:1.00];
        //_lineView.lineColor = [UIColor whiteColor];
        //_lineView.dataSource = @[@"2", @"5", @"7", @"3", @"33", @"12", @"10"];
        _lineView.interval = 2.0;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_lineView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 1)];
        CAShapeLayer *shapelayer = [[CAShapeLayer alloc] init];
        shapelayer.path = path.CGPath;
        shapelayer.frame = _lineView.bounds;
        _lineView.layer.mask = shapelayer;
    }
    return _lineView;
}

- (UILabel *)groupNameLB {
    if (!_groupNameLB) {
        _groupNameLB = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, CGRectGetMaxY(self.lineView.frame) + JYDefaultMargin * 2, 120, 15)];
        _groupNameLB.textColor = [UIColor colorWithHexString:@"#323232"];
        //_groupNameLB.text = @"第二集群销售额";
        _groupNameLB.adjustsFontSizeToFitWidth = NO;
        _groupNameLB.font = [UIFont systemFontOfSize:14];
    }
    return _groupNameLB;
}

- (JYTrendTypeView *)trendTypeView {
    if (!_trendTypeView) {
        _trendTypeView = [[JYTrendTypeView alloc] initWithFrame:CGRectMake(JYViewWidth - JYDefaultMargin - 15, CGRectGetMinY(self.groupNameLB.frame), 15, 15)];
    }
    return _trendTypeView;
}

- (UILabel *)ratio {
    
    if (!_ratio) {
        _ratio = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_trendTypeView.frame) - 200, CGRectGetMaxY(_trendTypeView.frame) + JYDefaultMargin, 200, 20)];
        _ratio.text = @"+0.04";
        _ratio.textColor = JYColor_TextColor_Gray;
        _ratio.textAlignment = NSTextAlignmentRight;
    }
    return _ratio;
}

- (UILabel *)saleNumberLB {
    if (!_saleNumberLB) {
        _saleNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, CGRectGetMaxY(self.trendTypeView.frame) + JYDefaultMargin + 20 + JYDefaultMargin, JYViewWidth - JYDefaultMargin * 2, 33)];
        _saleNumberLB.text = @"2,460";
        _saleNumberLB.textAlignment = NSTextAlignmentCenter;
        _saleNumberLB.font = [UIFont systemFontOfSize:30];
        _saleNumberLB.textColor = JYColor_TextColor_Gray;
        _saleNumberLB.adjustsFontSizeToFitWidth = YES;
    }
    return _saleNumberLB;
}

- (void)refreshSubViewData {
    
    self.lineView.dataSource = self.model.chartData;
    self.groupNameLB.text = self.model.title;
   // self.trendTypeView.arrow = self.model.arrow;
    
    self.ratio.text = self.model.floatRate;
   // self.ratio.textColor = self.model.arrowToColor;
    
    self.saleNumberLB.text = self.model.saleNumber;
   // self.saleNumberLB.textColor = self.model.arrowToColor;
    
    unit.text = self.model.percentage ? @"%" : self.model.unit;
}

@end
