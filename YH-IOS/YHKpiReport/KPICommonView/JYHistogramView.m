//
//  JYHistogramView.m
//  各种报表
//
//  Created by niko on 17/4/29.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYHistogramView.h"

#import "UIColor+Utility.h"

#import "JYHistogram.h"
#import "JYTrendTypeView.h"



@interface JYHistogramView () {
    JYHistogram *histogram;
    UILabel *groupType;
    JYTrendTypeView *trendType;
    UILabel *ratio;
    UILabel *money;
    UILabel *unit;
}

@end

@implementation JYHistogramView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initilizeSubView];
    }
    return self;
}

- (void)setModel:(YHKPIDetailModel *)model {
    if (![_model isEqual:model]) {
        _model = model;
        
        [self refreshSubViewData];
    }
}

- (void)initilizeSubView {
    
   // CGFloat width = (JYScreenWidth - JYDefaultMargin * 5) / 2;
    histogram = [[JYHistogram alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin	, JYViewWidth - 2 * JYDefaultMargin, JYViewHeight / 2.0)];
    histogram.dataSource = @[@"2", @"5", @"7", @"3", @"33", @"12", @"10"];
    histogram.lastBarColor = [UIColor colorWithHexString:@"#FBBC05"];
    histogram.barColor = [UIColor colorWithHexString:@"#40BBD5"];
    histogram.interval = 1;
    [self addSubview:histogram];
    
    groupType = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin + CGRectGetMaxY(histogram.frame), 120 , 40)];
   // groupType.text = @"第二集群月累计同店比";
    groupType.numberOfLines = 2;
    groupType.textColor = [UIColor colorWithHexString:@"#323232"];
    groupType.adjustsFontSizeToFitWidth = YES;
    groupType.font = [UIFont systemFontOfSize:14];
    [self addSubview:groupType];
    
    
    trendType = [[JYTrendTypeView alloc] initWithFrame:CGRectMake(JYViewWidth - JYDefaultMargin - 20, CGRectGetMinY(groupType.frame), 15, 15)];
    [self addSubview:trendType];
    
    ratio = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(trendType.frame) - 200, CGRectGetMaxY(trendType.frame) + JYDefaultMargin, 200, 20)];
    ratio.text = @"+0.04";
    ratio.textColor = [UIColor colorWithHexString:@"#FBBC05"];
    ratio.textAlignment = NSTextAlignmentRight;
    [self addSubview:ratio];
    
    money = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(groupType.frame) + JYDefaultMargin, JYViewWidth, 42)];
    money.text = @"2,353";
    money.textColor = [UIColor colorWithHexString:@"#FBBC05"];
    money.font = [UIFont systemFontOfSize:30];
    money.adjustsFontSizeToFitWidth = YES;
    money.textAlignment = NSTextAlignmentCenter;
    [self addSubview:money];
    
    unit = [[UILabel alloc] initWithFrame:CGRectMake(JYViewWidth - 30, CGRectGetHeight(self.frame) - 30, 30, 30)];
    unit.text = @"万";
    unit.font = [UIFont systemFontOfSize:13];
    unit.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:unit];
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.8;
}

- (void)refreshSubViewData {
    
    histogram.dataSource = self.model.chartData;
  //  histogram.lastBarColor= self.model.arrowToColor;
    groupType.text = self.model.title;
  //  trendType.arrow = self.model.arrow;
    ratio.text = self.model.floatRate;
 //   ratio.textColor = self.model.arrowToColor;
    money.text = self.model.saleNumber;
  //  money.textColor = self.model.arrowToColor;
    unit.text = self.model.percentage ? @"%" : self.model.unit;
    
}

@end
