//
//  JYTopSinglePage.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYTopSinglePage.h"

#import "JYTrendTypeView.h"
#import "JYCurveLineView.h"
#import "JYCircleProgressView.h"
#import "JYHistogram.h"


@interface JYTopSinglePage () {
    
    JYTrendTypeView *trendType;
    UILabel *groupName;
    UILabel *title;
    UILabel *money;
    UILabel *ratio;
    UILabel *unit;
}

@property (nonatomic, strong) JYCurveLineView *curveLine;
@property (nonatomic, strong) JYHistogram *histogram;
@property (nonatomic, strong) JYCircleProgressView *progress;
@property (nonatomic, strong) JYBaseComponentView *numberView;
@property (nonatomic, strong) JYBaseComponentView *componentView;


@end

@implementation JYTopSinglePage

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initilizeSubView];
    }
    return self;
}

- (void)setModel:(JYDashboardModel *)model {
    if (![_model isEqual:model]) {
        _model = model;
    }
}

- (void)initilizeSubView {
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin, 200, 30)];
   // title.text = @"第二集群实时数据";
    [self addSubview:title];
    
    // 所属组
    groupName = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, CGRectGetMaxY(title.frame), 200, 18)];
   // groupName.text = @"商行实时销售";
    groupName.font = [UIFont systemFontOfSize:12];
    [self addSubview:groupName];
    
    money = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, CGRectGetMaxY(groupName.frame) + JYDefaultMargin, 200, 18)];
   // money.text = @"23.5";
    money.font = [UIFont systemFontOfSize:17];
    money.textColor = JYColor_ArrowColor_Red;
    [self addSubview:money];
    
    unit = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, CGRectGetMaxY(groupName.frame) + JYDefaultMargin, 200, 18)];
  //  unit.text = @"万";
    unit.font = [UIFont systemFontOfSize:17];
    unit.textColor = JYColor_ArrowColor_Red;
    [self addSubview:unit];
    
    trendType = [[JYTrendTypeView alloc] initWithFrame:CGRectMake(JYViewWidth - JYDefaultMargin - 20, JYDefaultMargin, 20, 20)];
    trendType.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:trendType];
    
    ratio = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(trendType.frame) - 200 - 10, CGRectGetMaxY(trendType.frame) + JYDefaultMargin, 200, 18)];
    ratio.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
   // ratio.text = @"-1.04";
    ratio.textAlignment = NSTextAlignmentRight;
    [self addSubview:ratio];
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.8;

}

- (JYBaseComponentView *)componentView {
    if (!_componentView) {
        _componentView = [[JYBaseComponentView alloc] init];
    }
    return _componentView;
}

- (JYCurveLineView *)curveLine {
    if (!_curveLine) {
        _curveLine = [[JYCurveLineView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(ratio.frame) + JYDefaultMargin, JYScreenWidth * 0.88, 218 - CGRectGetMaxY(ratio.frame) - 2 * JYDefaultMargin)];
        _curveLine.interval = 2.0;
        _curveLine.lineColor = [UIColor colorWithHexString:@"#40BBD5"];
        //_curveLine.lineColor = [UIColor blueColor];
        [self addSubview:_curveLine];
    }
    return _curveLine;
}

- (JYHistogram *)histogram {
    if (!_histogram) {
        _histogram = [[JYHistogram alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(money.frame) + JYDefaultMargin, JYScreenWidth * 0.88, 218 - CGRectGetMaxY(ratio.frame) - 2 * JYDefaultMargin)];
        _histogram.barColor = [UIColor colorWithHexString:@"#40BBD5"];
        _histogram.lastBarColor = [UIColor colorWithHexString:@"#FBBC05"];
        [self addSubview:_histogram];
    }
    return _histogram;
}

- (JYCircleProgressView *)progress {
    if (!_progress) {
        _progress = [[JYCircleProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(ratio.frame) + JYDefaultMargin, JYScreenWidth * 0.88, kJYPageHeight - CGRectGetMaxY(ratio.frame) - 2 * JYDefaultMargin)];
        _progress.progressColor = [UIColor colorWithHexString:@"#FBBC05"];
        _progress.progressBackColor = [UIColor colorWithHexString:@"#E1E5E6"];
       // _progress.percent = [[self.model.floatRate substringFromIndex:2] floatValue];
        _progress.percent = [self.model.saleNumber floatValue]/[self.model.hightLightData[@"compare"] floatValue];
        _progress.progressWidth = 8;
        _progress.interval = 1;
        [self addSubview:_progress];
    }
    return _progress;
}

- (JYBaseComponentView *)numberView {
    if (!_numberView) {
        _numberView = [[JYBaseComponentView alloc] init];
    }
    return _numberView;
}

- (void)refreshSubViewData {
    
    trendType.arrow = self.model.arrow;
    groupName.text = self.model.groupName;
    title.text = self.model.title;
    
    money.text = self.model.saleNumber;
    money.textColor = self.model.arrowToColor;
    
    unit.text = self.model.unit;
    unit.textColor = self.model.arrowToColor;
    
    ratio.text = self.model.floatRate;
    ratio.textColor = self.model.arrowToColor;
    
    CGFloat width = JYViewWidth;
    CGFloat height = JYViewHeight - CGRectGetMaxY(ratio.frame) - 2 * JYDefaultMargin;
    
    
    // !!!: 根据数据指定显示特定图标
    DashBoardType type = self.model.dashboardType;
    switch (type) {
        case DashBoardTypeBar:
            self.componentView = self.histogram;
            break;
        case DashBoardTypeLine:
            self.componentView = self.curveLine;
            break;
        case DashBoardTypeRing: {
            self.componentView = self.progress;
            width = JYViewHeight - CGRectGetMaxY(ratio.frame) - 2 * JYDefaultMargin;
            width = height;
            ratio.text = nil;
        } break;
        case DashBoardTypeNumber:
            self.componentView = self.numberView;
            break;
            
        default:
            break;
    }
    
    self.componentView.backgroundColor = [UIColor clearColor];
    self.componentView.model = self.model;
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(ratio.frame) + JYDefaultMargin, width, height);
    if (self.model.dashboardType == DashBoardTypeBar) {
        frame.origin.y += (CGRectGetHeight(money.frame) + JYDefaultMargin / 2);
        frame.size.height -= (CGRectGetHeight(money.frame) + JYDefaultMargin / 2);
    }
    self.componentView.frame = frame;
    CGPoint center = self.componentView.center;
    center.x = CGRectGetWidth(self.bounds) / 2;
    self.componentView.center = center;
    
    [self.componentView refreshSubViewData];
    
    [self relayoutSubView];
}

- (void)relayoutSubView {
    
    CGSize size = [money.text boundingRectWithSize:CGSizeMake(200, 18) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size;
    CGRect frame = money.frame;
    frame.size = size;
    money.frame = frame;
    
    frame = unit.frame;
    frame.origin.x = CGRectGetMaxX(money.frame) + JYDefaultMargin;
    unit.frame = frame;
    
    if (self.model.dashboardType == DashBoardTypeNumber || self.model.dashboardType == DashBoardTypeRing) {
        CGFloat width = JYViewWidth;
        CGFloat height = JYViewHeight - CGRectGetMaxY(ratio.frame) - 2 * JYDefaultMargin;
        CGRect frame = CGRectMake(0, CGRectGetMaxY(ratio.frame) + JYDefaultMargin, width, height);
        money.frame = frame;
        money.textAlignment = NSTextAlignmentCenter;
        
        money.font = [UIFont systemFontOfSize:30];
        
        frame = CGRectMake(JYViewWidth - 200 - JYDefaultMargin, JYViewHeight - 18 - JYDefaultMargin, 200, 18);
        unit.frame = frame;
        unit.textAlignment = NSTextAlignmentRight;
        unit.textColor = JYColor_TextColor_Gray;
    }
    
}



@end
