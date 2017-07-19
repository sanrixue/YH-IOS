//
//  JYPortraitBarView.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYPortraitBarView.h"
#import "JYPortraitBar.h"
#import "JYChartModel.h"
#import "JYTrendTypeView.h"

#define kAxisXViewHeight (40)

@interface JYPortraitBarView () <JYPortraitBarDelegate> {
    
    NSArray <UILabel *> *xAxisList;
    UILabel *timeLB;
    UILabel *unitLB;
    NSArray <UILabel *> *numberLBList;
    NSArray <UILabel *> *titleLBList;
}

@property (nonatomic, strong) JYPortraitBar *portraitBar;
@property (nonatomic, strong) JYChartModel *chartModel;
@property (nonatomic, strong) UIView *axisView;
@property (nonatomic, strong) UIView *xAxisView;
@property (nonatomic, strong) UIView *yAxisView;
@property (nonatomic, strong) JYTrendTypeView *arrowView;

@end


@implementation JYPortraitBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubVeiw];
    }
    return self;
}

- (void)initializeSubVeiw {
    
    [self initializeTitle];
    //[self initializeAxis];
}

- (JYPortraitBar *)portraitBar {
    if (!_portraitBar) {
        _portraitBar = [[JYPortraitBar alloc] init];
        _portraitBar.selectColor = @[JYColor_LineColor_LightOrange, JYColor_LineColor_LightPurple];
        _portraitBar.normalColor = JYColor_ArrowColor_Unkown;
    }
    return _portraitBar;
}

- (UIView *)axisView {
    if (!_axisView) {
        _axisView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(unitLB.frame), JYViewWidth, JYViewHeight*0.7)];
        [self addSubview:_axisView];
    }
    return _axisView;
}

// 横坐标
- (UIView *)xAxisView {
    if (!_xAxisView) {
        _xAxisView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.portraitBar.frame), CGRectGetWidth(self.axisView.bounds), kAxisXViewHeight)];
        [self.axisView addSubview:_xAxisView];
    }
    return _xAxisView;
}

// 纵坐标
- (UIView *)yAxisView {
    if (!_yAxisView) {
        _yAxisView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.axisView.bounds) / 5, CGRectGetHeight(self.axisView.bounds))];
        [self.axisView addSubview:_yAxisView];
    }
    return _yAxisView;
}

- (JYChartModel *)chartModel {
    if (!_chartModel) {
        _chartModel = (JYChartModel *)self.moduleModel;
    }
    return _chartModel;
}

- (JYTrendTypeView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[JYTrendTypeView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numberLBList[2].frame), CGRectGetMinY(numberLBList[2].frame) + (20 - 15) / 2.0, 15, 15)];
    }
    return _arrowView;
}

- (void)initializeTitle {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JYViewWidth, JYViewHeight * 0.3)];
    [self addSubview:titleView];
    
    timeLB = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin / 2, 50, 20)];
    timeLB.font = [UIFont systemFontOfSize:12];
    timeLB.textColor = JYColor_TextColor_Chief;
    [titleView addSubview:timeLB];
    
    UILabel *title;
    NSMutableArray *numbers = [NSMutableArray arrayWithCapacity:3], *titles = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 3; i++) {
        
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeLB.frame) + ((3 * JYDefaultMargin) + 50) * i, CGRectGetMaxY(timeLB.frame) + 4, 50, 20)];
        number.textColor = JYColor_TextColor_Chief;
        number.adjustsFontSizeToFitWidth = YES;
        [titleView addSubview:number];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(number.frame), CGRectGetMaxY(number.frame), 50, 20)];
        title.text = @"周环比";
        title.textColor = JYColor_TextColor_Chief;
        title.font = [UIFont systemFontOfSize:12];
        [titleView addSubview:title];
        
        [numbers addObject:number];
        [titles addObject:title];
    }
    numberLBList = [numbers copy];
    titleLBList = [titles copy];
    numberLBList[0].textColor = JYColor_LineColor_LightOrange;
    numberLBList[1].textColor = JYColor_LineColor_LightPurple;
    
    [self addSubview:self.arrowView];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+JYDefaultMargin, JYViewWidth, 0.5)];
    sepLine.backgroundColor = JYColor_TextColor_Chief;
    [titleView addSubview:sepLine];
    
    unitLB = [[UILabel alloc] initWithFrame:CGRectMake(50 + JYDefaultMargin, CGRectGetMaxY(sepLine.frame) + JYDefaultMargin, 50, 20)];
    unitLB.text = @"万";
    unitLB.font = [UIFont systemFontOfSize:12];
    unitLB.textColor = JYColor_TextColor_Chief;
    [titleView addSubview:unitLB];
}

- (void)initializeAxis {
    
    self.portraitBar.frame = CGRectMake(CGRectGetWidth(self.axisView.bounds) / 5, 0, CGRectGetWidth(self.axisView.bounds) * 4 / 5, CGRectGetHeight(self.axisView.bounds) - kAxisXViewHeight - JYDefaultMargin);
    self.portraitBar.delegate = self;
    if (![self.axisView.subviews containsObject:self.portraitBar]) {
        [self.axisView addSubview:self.portraitBar];
    }
    
    [self addxAixs];
    [self addyAxis];
}

- (void)addxAixs {
       
    for (int i = 0; i < self.portraitBar.pionts.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kBarHeight * 2, kAxisXViewHeight)];
        CGPoint center = label.center;
        center.x = CGPointFromString(self.portraitBar.pionts[i]).x + CGRectGetWidth(self.yAxisView.frame) + JYDefaultMargin;
        label.center = center;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = JYColor_TextColor_Chief;
        label.text = self.chartModel.xAxis[i];//[NSString stringWithFormat:@"第%d周", i];
        [self.xAxisView addSubview:label];
    }
    // 添加点击
    for (int i = 0; i < self.portraitBar.pionts.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, kBarHeight * 2, CGRectGetHeight(self.portraitBar.bounds));
        [btn addTarget:self action:@selector(clickActive:) forControlEvents:UIControlEventTouchUpInside];
        CGPoint center = btn.center;
        btn.tag = -10000 + i;
        center.x = CGPointFromString(self.portraitBar.pionts[i]).x;
        btn.center = center;
        [self.portraitBar addSubview:btn];
    }
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, JYViewWidth, 0.5)];
    sepLine.backgroundColor = JYColor_TextColor_Chief;
    [self.xAxisView addSubview:sepLine];
}

- (void)addyAxis {
    
    CGFloat scaleHeight = (CGRectGetHeight(self.yAxisView.bounds) - kAxisXViewHeight) / 4;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, scaleHeight * i, 50, scaleHeight)];
        label.text = self.chartModel.seriesModel.yAxisDataList[i];//[NSString stringWithFormat:@"第%d周", i];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = JYColor_TextColor_Chief;
        CGPoint center = label.center;
        center.y = scaleHeight * i + JYDefaultMargin;
        label.center = center;
        [self.yAxisView addSubview:label];
    }
}

- (void)refreshSubViewData {
    self.portraitBar.model = self.chartModel.seriesModel;
    
    [self initializeAxis];
    
    timeLB.text = [self.chartModel.xAxis lastObject];
    NSString *number1, *number2, *ratio;
    NSMutableArray *selectedData = [NSMutableArray arrayWithArray:self.chartModel.seriesModel.mainDataList];
    
    if (self.chartModel.seriesModel.longerLineIndex == NSOrderedAscending) {
        number1 = [self.chartModel.seriesModel.mainDataList lastObject];
        number2 = @"暂无数据";
        ratio = @"暂无数据";
    }
    else if (self.chartModel.seriesModel.longerLineIndex == NSOrderedDescending) {
        number1 = @"暂无数据";
        number2 = [self.chartModel.seriesModel.subDataList lastObject];
        ratio = @"暂无数据";
        for (int i = 0; i <  self.chartModel.seriesModel.subDataList.count - selectedData.count; i++) {
            [selectedData addObject:@"0"];
        }
    }
    else {
        number1 = [self.chartModel.seriesModel.mainDataList lastObject];
        number2 = [self.chartModel.seriesModel.subDataList lastObject];
        ratio = [self.chartModel.seriesModel floatRatioAtIndex:self.chartModel.seriesModel.maxLength];
    }

    
    numberLBList[0].text = [NSString stringWithFormat:@"%@", number1];
    numberLBList[1].text = number2;
    numberLBList[2].text = ratio;
    self.arrowView.arrow = [self.chartModel.seriesModel arrowAtIndex:self.chartModel.seriesModel.maxLength];
    
    titleLBList[0].text = self.chartModel.seriesModel.mainSeriesTitle;
    titleLBList[1].text = self.chartModel.seriesModel.subSeriesTitle;
    
}


- (void)clickActive:(UIButton *)sender {
    
    NSInteger idx = sender.tag + 10000;
    NSString *number1, *number2, *ratio;
    NSMutableArray *selectedData = [NSMutableArray arrayWithArray:self.chartModel.seriesModel.mainDataList];
    if (idx >= self.chartModel.seriesModel.minLength) {
        if (self.chartModel.seriesModel.longerLineIndex == NSOrderedAscending) {
            number1 = self.chartModel.seriesModel.mainDataList[idx];
            number2 = @"暂无数据";
            ratio = @"暂无数据";
        }
        else if (self.chartModel.seriesModel.longerLineIndex == NSOrderedDescending) {
            number1 = @"暂无数据";
            number2 = self.chartModel.seriesModel.subDataList[idx];
            ratio = @"暂无数据";
            NSInteger selectedDataCount = selectedData.count;
            for (int i = 0; i < self.chartModel.seriesModel.subDataList.count - selectedDataCount; i++) {
                [selectedData addObject:@"0"];
            }
        }
    }
    else {
        number1 = self.chartModel.seriesModel.mainDataList[idx];
        number2 = self.chartModel.seriesModel.subDataList[idx];
        ratio = [self.chartModel.seriesModel floatRatioAtIndex:idx];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoBaseView:didSelectedAtIndex:data:)]) {
        [self.delegate moduleTwoBaseView:self didSelectedAtIndex:idx data:selectedData[idx]];
    }
    // TODO: 更新指标数据
    timeLB.text = self.chartModel.xAxis[idx];
    numberLBList[0].text = [NSString stringWithFormat:@"%@", number1];
    numberLBList[1].text = number2;
    numberLBList[2].text = ratio;
    self.arrowView.arrow = [self.chartModel.seriesModel arrowAtIndex:idx];
    
    // 更新bar的选中状态
    self.portraitBar.selectedIndex = idx;
}

- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    return JYViewWidth + 20;
}

#pragma mark - <JYPortraitBarDelegate>
- (void)portraitBar:(JYPortraitBar *)bar refreshWidth:(CGFloat)width {
    [self addxAixs];
}

@end
