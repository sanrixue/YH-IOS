//
//  JYTrendView.m
//  各种报表
//
//  Created by niko on 17/4/28.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYTrendView.h"

#import "JYCurveLineView.h"
#import "JYTrendTypeView.h"

@implementation JYTrendView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initilizeSubView];
    }
    return self;
}

- (void)initilizeSubView {
    
    UILabel *groupName = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin, 200, 30)];
    groupName.text = @"第二集群实时数据";
    [self addSubview:groupName];
    
    UILabel *typeName = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, CGRectGetMaxY(groupName.frame), 200, 18)];
    typeName.text = @"商行实时销售";
    typeName.font = [UIFont systemFontOfSize:12];
    [self addSubview:typeName];
    
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, CGRectGetMaxY(typeName.frame) + JYDefaultMargin, 200, 18)];
    money.text = @"23.5 万";
    money.textColor = [UIColor redColor];
    [self addSubview:money];
    
    JYTrendTypeView *trendType = [[JYTrendTypeView alloc] initWithFrame:CGRectMake(JYScreenWidth - 2 * (25 +  JYDefaultMargin * 2), JYDefaultMargin, 20, 20)];
    [self addSubview:trendType];
    
    UILabel *ratio = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(trendType.frame) - 200 - 10, CGRectGetMaxY(trendType.frame) + JYDefaultMargin, 200, 18)];
    ratio.text = @"-1.04";
    ratio.textAlignment = NSTextAlignmentRight;
    [self addSubview:ratio];
    
    JYCurveLineView *curveLine = [[JYCurveLineView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(ratio.frame) + JYDefaultMargin, JYScreenWidth * 0.88, 218 - CGRectGetMaxY(ratio.frame) - 2 * JYDefaultMargin)];
//    curveLine.dataSource = @[@"20", @"0", @"7", @"3", @"23", @"12", @"20"];
    curveLine.interval = 2.0;
    curveLine.lineColor = [UIColor colorWithHexString:@"#40BBD5"];
    [self addSubview:curveLine];
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.8;
}




@end


