//
//  JYNumberCircleView.m
//  各种报表
//
//  Created by niko on 17/4/29.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYNumberCircleView.h"
#import "JYCircleProgressView.h"

@interface JYNumberCircleView () {
    UILabel *unit;
}

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) JYCircleProgressView *progressView;
@property (nonatomic, strong) UILabel *saleNumberLB;

@end

@implementation JYNumberCircleView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initilizedSubView];
    }
    return self;
}

- (void)initilizedSubView {
    
    [self addSubview:self.title];
    [self addSubview:self.progressView];
    [self addSubview:self.saleNumberLB];
    
    unit = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.saleNumberLB.frame), JYViewWidth, 20)];
    unit.text = @"万";
    unit.textAlignment = NSTextAlignmentCenter;
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

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin, 120, 20)];
        _title.textColor = [UIColor colorWithHexString:@"#323232"];
        _title.numberOfLines = 0;
        _title.font = [UIFont systemFontOfSize:14];
        //_title.text = @"第二集群实时数据";
    }
    return _title;
}

- (JYCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[JYCircleProgressView alloc] initWithFrame:CGRectMake(JYDefaultMargin, CGRectGetMaxY(self.title.frame) + JYDefaultMargin, 75, 75)];
        _progressView.progressColor = [UIColor colorWithHexString:@"#FBBC05"];
        _progressView.progressBackColor = [UIColor colorWithHexString:@"#E1E5E6"];
        _progressView.percent = 0.8;
        _progressView.progressWidth = 8;
        _progressView.interval = 1;
        
        CGPoint center = _progressView.center;
        center.x = JYViewWidth / 2.0;
        _progressView.center = center;
    }
    return _progressView;
}

- (UILabel *)saleNumberLB {
    if (!_saleNumberLB) {
        _saleNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JYViewWidth, 33)];
        _saleNumberLB.text = @"233";
        _saleNumberLB.textAlignment = NSTextAlignmentCenter;
        _saleNumberLB.font = [UIFont systemFontOfSize:24];
        _saleNumberLB.textColor = [UIColor colorWithHexString:@"#999999"];
        
        CGPoint center = _saleNumberLB.center;
        center.y = CGRectGetMidY(self.progressView.frame) - JYDefaultMargin;
        _saleNumberLB.center = center;
    }
    return _saleNumberLB;
}

- (void)refreshSubViewData {
    
    self.title.text = self.model.title;
   // self.progressView.percent =[self.model.saleNumber floatValue]/[self.model.hightLightData[@"compare"] floatValue];
    self.saleNumberLB.text = self.model.saleNumber;
    unit.text = self.model.percentage ? @"%" : self.model.unit;
}


@end
