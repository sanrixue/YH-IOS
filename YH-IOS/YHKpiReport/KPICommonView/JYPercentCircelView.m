//
//  JYPercentCircelView.m
//  各种报表
//
//  Created by niko on 17/4/29.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYPercentCircelView.h"

#import "UIColor+Utility.h"

#import "JYCircleProgressView.h"



@implementation JYPercentCircelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initilizedSubView];
    }
    return self;
}

- (void)initilizedSubView {
    
    JYCircleProgressView *circleView = [[JYCircleProgressView alloc] initWithFrame:CGRectMake(0, JYDefaultMargin, JYViewWidth, JYViewHeight * 2.0/ 3.0)];
    circleView.percent = 0;
    circleView.progressWidth = 8;
    circleView.progressBackColor = [UIColor colorWithHexString:@"#E1E5E6"];
    circleView.progressColor = [UIColor colorWithHexString:@"#34AB53"];
    circleView.backgroundColor = [UIColor whiteColor];
    circleView.percent = 0.8;
    circleView.interval = 1;
    [self addSubview:circleView];
    
    
    UILabel *percentLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JYViewWidth, 22)];
    percentLB.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(circleView.bounds) / 2.0);
    percentLB.textAlignment = NSTextAlignmentCenter;
    percentLB.text = [NSString stringWithFormat:@"%.2lf", circleView.percent];
    percentLB.font = [UIFont systemFontOfSize:30];
    percentLB.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:percentLB];
    
    UILabel *unit = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(percentLB.frame) + JYDefaultMargin, JYViewWidth, 20)];
    unit.textAlignment = NSTextAlignmentCenter;
    unit.text = @"%";
    unit.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:unit];
    
    UILabel *groupName = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYViewHeight - 2 * JYDefaultMargin - 20, JYViewWidth, 20)];
    groupName.text = @"第二集群客流";
    groupName.font = [UIFont systemFontOfSize:14];
    groupName.textColor = [UIColor colorWithHexString:@"#323232"];
    [self addSubview:groupName];
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.8;
}


@end
