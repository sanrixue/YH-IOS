//
//  JYSaleView.m
//  各种报表
//
//  Created by niko on 17/4/29.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYSaleView.h"


@interface JYSaleView () {
    UILabel *unit;
}

@property (nonatomic, strong) UILabel *groupNameLB;
@property (nonatomic, strong) UILabel *saleNumberLB;


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
    
    unit = [[UILabel alloc] initWithFrame:CGRectMake(JYViewWidth - 30, JYViewHeight - 30, 30, 30)];
    unit.text = @"元";
    unit.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:unit];
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.8;
}

- (void)setModel:(JYDashboardModel *)model {
    if (![_model isEqual:model]) {
        _model = model;
        
        [self refreshSubViewData];
    }
}

- (UILabel *)groupNameLB {
    if (!_groupNameLB) {
        _groupNameLB = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin, JYViewWidth, 20)];
        _groupNameLB.text = @"第二集群实时数据";
        _groupNameLB.textColor = [UIColor colorWithRed:0.28 green:0.29 blue:0.29 alpha:1.00];
    }
    return _groupNameLB;
}

- (UILabel *)saleNumberLB {
    if (!_saleNumberLB) {
        _saleNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.groupNameLB.frame) + 21, JYViewWidth, 56)];
        _saleNumberLB.text = @"25.3";
        _saleNumberLB.textAlignment = NSTextAlignmentCenter;
        _saleNumberLB.font = [UIFont systemFontOfSize:30];
        _saleNumberLB.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _saleNumberLB;
}

- (void)refreshSubViewData {
    self.groupNameLB.text = self.model.title;
    self.saleNumberLB.text = self.model.saleNumber;
    unit.text = self.model.percentage ? @"%" : self.model.unit;    
}

@end
