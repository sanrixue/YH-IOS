//
//  JYSaleView.m
//  各种报表
//
//  Created by niko on 17/4/29.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYSaleView.h"
#import "JYTrendTypeView.h"


@interface JYSaleView () {
    UILabel *unit;
}

@property (nonatomic, strong) UILabel *groupNameLB;
@property (nonatomic, strong) UILabel *saleNumberLB;
@property (nonatomic, strong) JYTrendTypeView *trendTypeView;
@property (nonatomic, strong) UILabel *ratio;;


@end

@implementation JYSaleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initilizedSubView];
    }
    return self;
}

- (void)initilizedSubView {   
    
    [self addSubview:self.groupNameLB];
    [self addSubview:self.saleNumberLB];
    [self addSubview:self.trendTypeView];
    [self addSubview:self.ratio];
    
    unit = [[UILabel alloc] initWithFrame:CGRectMake(JYViewWidth - 30, JYViewHeight - 30, 30, 30)];
    unit.text = @"元";
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

- (UILabel *)groupNameLB {
    if (!_groupNameLB) {
        _groupNameLB = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin, 120, 40)];
       // _groupNameLB.text = @"第二集群实时数据";
        _groupNameLB.numberOfLines = 0;
        _groupNameLB.font = [UIFont systemFontOfSize:14];
       // _groupNameLB.textColor = [UIColor redColor];
        _groupNameLB.textColor = [UIColor colorWithRed:0.28 green:0.29 blue:0.29 alpha:1.00];
    }
    return _groupNameLB;
}

- (UILabel *)saleNumberLB {
    if (!_saleNumberLB) {
        _saleNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.groupNameLB.frame) + 11, JYViewWidth, 56)];
        //_saleNumberLB.text = @"25.3";
        _saleNumberLB.textAlignment = NSTextAlignmentCenter;
        _saleNumberLB.font = [UIFont systemFontOfSize:30];
        _saleNumberLB.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _saleNumberLB;
}

- (JYTrendTypeView *)trendTypeView {
    if (!_trendTypeView) {
        _trendTypeView = [[JYTrendTypeView alloc] initWithFrame:CGRectMake(JYViewWidth - JYDefaultMargin - 15,JYDefaultMargin+15 , 15, 15)];
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

- (void)refreshSubViewData {
    if ([self.model.saleNumber boolValue]) {
        self.groupNameLB.text = self.model.title;
        self.groupNameLB.numberOfLines = 0;
      //  self.trendTypeView.arrow = self.model.arrow;
        self.saleNumberLB.text = self.model.saleNumber;
        //self.saleNumberLB.textColor = self.model.arrowToColor;
        self.ratio.text = self.model.floatRate;
        //self.ratio.textColor = self.model.arrowToColor;
        unit.text = self.model.percentage ? @"%" : self.model.unit;
    }
    else {
        _saleNumberLB.frame = CGRectMake(0, 0, JYViewWidth, JYViewHeight);
        _saleNumberLB.textColor = [UIColor colorWithRed:0.28 green:0.29 blue:0.29 alpha:1.00];
        self.groupNameLB.text = @"";
        self.groupNameLB.numberOfLines = 0;
        self.saleNumberLB.numberOfLines = 0;
        self.saleNumberLB.font = [UIFont systemFontOfSize:22];
        self.saleNumberLB.text = self.model.title;
        self.ratio.text = @"";
     //   self.ratio.textColor = self.model.arrowToColor;
        unit.text = @"";
    }
}

@end
