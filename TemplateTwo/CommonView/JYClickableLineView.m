//
//  JYClickableLineView.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYClickableLineView.h"
#import "JYClickableLine.h"
#import "JYTrendTypeView.h"
#import "JYChartModel.h"
#import "JYSeriesModel.h"

#define kAxisXViewHeight (40)

@interface JYClickableLineView () <JYClickableLineDelegate> {
    
    
    JYTrendTypeView *arrowView;
    UILabel *timeLB;
    UILabel *unitLB;
    NSArray <UILabel *> *numberLabelList;
    NSArray <UILabel *> *titleLabelList;
    NSArray <UILabel *> *xAxisLabelList;
    NSArray <UILabel *> *yAxisLabelList;
}

@property (nonatomic, strong) JYClickableLine *lineView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) JYChartModel *chartModel;
@property (nonatomic, strong) JYSeriesModel *seriesModel;

@end

@implementation JYClickableLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        numberLabelList = [NSArray array];
        titleLabelList = [NSArray array];
        xAxisLabelList = [NSArray array];
        yAxisLabelList = [NSArray array];
        
        [self initializeSubVeiw];
    }
    return self;
}

- (void)initializeSubVeiw {
    
    [self initializeTitle];
}

- (UIView *)infoView {
    if (!_infoView) {
        
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(unitLB.frame), JYViewWidth, JYViewWidth * 0.9 * 0.7)];
        //infoView.backgroundColor = JYColor_LightGray_White;
        [self addSubview:_infoView];
    }
    return _infoView;
}

- (JYClickableLine *)lineView1 {
    if (!_lineView) {
        _lineView = [[JYClickableLine alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.infoView.bounds)/5, JYDefaultMargin, CGRectGetWidth(self.infoView.bounds) * 4 / 5, CGRectGetHeight(self.infoView.bounds) - kAxisXViewHeight - JYDefaultMargin)];
        _lineView.delegate = self;
        [self.infoView addSubview:_lineView];
    }
    return _lineView;
}

- (JYChartModel *)chartModel {
    if (!_chartModel) {
        _chartModel = (JYChartModel *)self.moduleModel;
    }
    return _chartModel;
}

- (JYSeriesModel *)seriesModel {
    if (!_seriesModel) {
        _seriesModel = self.chartModel.seriesModel;
    }
    return _seriesModel;
}

- (void)initializeTitle {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JYViewWidth, JYViewWidth * 0.9 * 0.3)];
    //titleView.backgroundColor = JYColor_LightGray_White;
    [self addSubview:titleView];
    
    timeLB = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin / 2, 50, 20)];
    timeLB.text = @"W1";
    timeLB.font = [UIFont systemFontOfSize:12];
    timeLB.textColor = JYColor_TextColor_Chief;
    [titleView addSubview:timeLB];
    
    NSArray *titleList = @[@"销售额", @"上周同天", @"变化率"];
    NSMutableArray *numberLB = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *titleLB = [NSMutableArray arrayWithCapacity:3];
    UILabel *title;
    for (int i = 0; i < 3; i++) {
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeLB.frame) + ((3 * JYDefaultMargin) + 80) * i, CGRectGetMaxY(timeLB.frame) + 4, 80, 20)];
        //number.backgroundColor = JYColor_LightGray_White;
        number.adjustsFontSizeToFitWidth = YES;
        [titleView addSubview:number];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(number.frame), CGRectGetMaxY(number.frame), 80, 20)];
        //title.backgroundColor = JYColor_LightGray_White;
        title.text = titleList[i];
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = JYColor_TextColor_Chief;
        [titleView addSubview:title];
        
        
        if (i == 2) {
            CGRect frame = number.frame;
            CGSize size = [number.text boundingRectWithSize:CGSizeMake(100, CGRectGetHeight(number.frame)) options:0 attributes:@{NSFontAttributeName: number.font} context:nil].size;
            number.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, CGRectGetHeight(number.frame));
            
            arrowView = [[JYTrendTypeView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(number.frame) + JYDefaultMargin, CGRectGetMinY(number.frame) +(20 - 15) / 2.0, 15, 15)];
            [titleView addSubview:arrowView];
        }
        [numberLB addObject:number];
        [titleLB addObject:title];
    }
    
    numberLabelList = [numberLB copy];
    titleLabelList = [titleLB copy];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+15, JYViewWidth, 0.5)];
    sepLine.backgroundColor = JYColor_TextColor_Chief;
    [titleView addSubview:sepLine];
    
    unitLB = [[UILabel alloc] initWithFrame:CGRectMake(50 + JYDefaultMargin, CGRectGetMaxY(sepLine.frame) + JYDefaultMargin, 50, 20)];
    unitLB.text = @"万";
    unitLB.font = [UIFont systemFontOfSize:12];
    unitLB.textColor = JYColor_TextColor_Chief;
    [titleView addSubview:unitLB];
}

- (void)initializeAxis {
    
    // 纵坐标
    UIView *axisYView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.infoView.bounds) / 5, CGRectGetHeight(self.infoView.bounds))];
    //axisYView.backgroundColor = JYColor_ArrowColor_Red;
    [self.infoView addSubview:axisYView];
    NSMutableArray *yAxisList = [NSMutableArray arrayWithCapacity:4];
    CGFloat scaleHeight = (CGRectGetHeight(axisYView.bounds) - kAxisXViewHeight) / 4;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, 50, scaleHeight)];
        CGPoint center = label.center;
        center.y = scaleHeight * i + JYDefaultMargin + JYDefaultMargin;
        label.center = center;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = JYColor_TextColor_Chief;
        label.text = self.seriesModel.yAxisDataList[i];//[NSString stringWithFormat:@"%d00,000", 4 - i];
        [axisYView addSubview:label];
        
        [yAxisList addObject:label];
    }
    
    // 横坐标
    UIView *axisXView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView1.frame), CGRectGetWidth(self.infoView.bounds), kAxisXViewHeight)];
    //axisXView.backgroundColor = JYColor_ArrowColor_Yellow;
    [self.infoView addSubview:axisXView];
    NSMutableArray *xAxisList = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < ((JYChartModel *)self.moduleModel).xAxis.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kBarHeight, 30)];
        CGPoint center = label.center;
        center.x = CGPointFromString(self.lineView1.points[i]).x + CGRectGetWidth(axisYView.frame);// + JYDefaultMargin;
        center.y = CGRectGetHeight(axisXView.bounds) / 2.0;
        label.center = center;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.chartModel.xAxis[i];
        label.textColor = JYColor_SubColor_LightGreen;
        [axisXView addSubview:label];
        
        [xAxisList addObject:label];
    }
    
    xAxisLabelList = [xAxisList copy];
    yAxisLabelList = [yAxisList copy];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, JYViewWidth, 0.5)];
    sepLine.backgroundColor = JYColor_TextColor_Chief;
    [axisXView addSubview:sepLine];
}


#pragma mark - <JYClickableLineDelegate>
// 拖拽时数据显示
- (void)clickableLine:(JYClickableLine *)clickableLine didSelected:(NSInteger)index data:(id)data {
    
    // 为保证两条线长度不一致时比较区域内数字有变化
    NSLog(@"index = %zi", index);
    // 更新标题栏区域内容
    if (index >= self.seriesModel.maxLength) return;
    NSString *actualNumber, *targetStr;
    if (index >= self.seriesModel.minLength) {
        if (self.seriesModel.longerLineIndex == NSOrderedSame) {
            actualNumber = self.seriesModel.mainDataList[index];
            targetStr = self.seriesModel.subDataList[index];
        }
        else if (self.seriesModel.longerLineIndex == NSOrderedAscending) {
            actualNumber = self.seriesModel.mainDataList[index];
            targetStr = @"暂无数据";
        }
        else if (self.seriesModel.longerLineIndex == NSOrderedDescending) {
            actualNumber = @"暂无数据";
            targetStr = self.seriesModel.subDataList[index];
        }
    }
    else {
        actualNumber = self.seriesModel.mainDataList[index];
        targetStr = self.seriesModel.subDataList[index];
    }
    
    timeLB.text = self.chartModel.xAxis[index];
    numberLabelList[0].text = actualNumber;
    numberLabelList[1].text = targetStr;
    numberLabelList[2].text = [self.seriesModel floatRatioAtIndex:index];
    numberLabelList[2].textColor = [self.seriesModel mainDataColorList][index];
    arrowView.arrow = [self.seriesModel arrowAtIndex:index];
    
    // 更新横坐标高亮颜色
    [xAxisLabelList enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = JYColor_SubColor_LightGreen;
    }];
    xAxisLabelList[index].textColor = self.seriesModel.mainDataColorList[index];
    
    // 更新箭头大小及位置
    CGRect frame = numberLabelList[2].frame;
    CGSize size = [numberLabelList[2].text boundingRectWithSize:CGSizeMake(100, CGRectGetHeight(numberLabelList[2].frame)) options:0 attributes:@{NSFontAttributeName: numberLabelList[2].font} context:nil].size;
    numberLabelList[2].frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, CGRectGetHeight(numberLabelList[2].frame));
    frame = arrowView.frame;
    frame.origin.x = CGRectGetMaxX(numberLabelList[2].frame) + JYDefaultMargin/2.0;
    arrowView.frame = frame;
    
    // 调用代理，更新外部视图及数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoBaseView:didSelectedAtIndex:data:)]) {
        [self.delegate moduleTwoBaseView:self didSelectedAtIndex:index data:data];
    }
}


- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    return JYViewWidth + 40;
}

- (void)refreshSubViewData {
    
    timeLB.text = [self.chartModel.xAxis lastObject];
    if (self.seriesModel) {
        
        NSMutableDictionary *line0Params = [@{@"color" : JYColor_LineColor_LightBlue,
                                              @"data"  : self.seriesModel.mainDataList} mutableCopy];
        NSMutableDictionary *line1Params = [@{@"color" : JYColor_LineColor_LightPurple,
                                              @"data"  : self.seriesModel.subDataList} mutableCopy];
        NSMutableDictionary *lineParams = [NSMutableDictionary dictionary];
        [lineParams setObject:line0Params forKey:@"line0"];
        [lineParams setObject:line1Params forKey:@"line1"];
        // 线
        self.lineView1.lineParms = lineParams;
    }
    
    [self initializeAxis];
    
    // 坐标刻度内容
    for (int i = 0; i < xAxisLabelList.count; i++) {
        xAxisLabelList[i].text = ((JYChartModel *)self.moduleModel).xAxis[i];
    }
    
    // 更新标题栏区域内容
    
    NSString *actualNumber, *targetStr;
    if (self.seriesModel.longerLineIndex == NSOrderedSame) {
        actualNumber = [self.seriesModel.mainDataList lastObject];
        targetStr = [self.seriesModel.subDataList lastObject];
    }
    else if (self.seriesModel.longerLineIndex == NSOrderedAscending) {
        actualNumber = [self.seriesModel.mainDataList lastObject];
        targetStr = @"暂无数据";
    }
    else if (self.seriesModel.longerLineIndex == NSOrderedDescending) {
        actualNumber = @"暂无数据";
        targetStr = [self.seriesModel.subDataList lastObject];
    }
    // 默认显示最后条数据
    numberLabelList[0].text = actualNumber;// 销售额
    numberLabelList[0].textColor = JYColor_LineColor_LightBlue;
    numberLabelList[1].text = targetStr;// 对比数据
    numberLabelList[1].textColor = JYColor_LineColor_LightPurple;
    numberLabelList[2].text = [self.seriesModel floatRatioAtIndex:self.seriesModel.maxLength];//变化率
    numberLabelList[2].textColor = [self.seriesModel.mainDataColorList lastObject];
    CGRect frame = numberLabelList[2].frame;
    CGSize size = [numberLabelList[2].text boundingRectWithSize:CGSizeMake(100, CGRectGetHeight(numberLabelList[2].frame)) options:0 attributes:@{NSFontAttributeName: numberLabelList[2].font} context:nil].size;
    numberLabelList[2].frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, CGRectGetHeight(numberLabelList[2].frame));
    arrowView.arrow = [self.seriesModel arrowAtIndex:self.seriesModel.maxLength];
    [xAxisLabelList lastObject].textColor = [self.seriesModel.mainDataColorList lastObject];
}


@end


