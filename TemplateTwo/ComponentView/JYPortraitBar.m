//
//  JYPortraitBar.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYPortraitBar.h"
#import "JYSeriesModel.h"

@interface JYPortraitBar () {
    
    CGFloat maxValue;
    CGFloat minValue;
    CGFloat centerLineX;
    CGFloat barWidth;
    
    NSArray <NSArray<CAShapeLayer *> *> *barList;
}

@property (nonatomic, strong) NSArray <NSArray <NSString *> *> *dataSource;
@property (nonatomic, strong) NSMutableArray <NSMutableArray *> *pointList;
@property (nonatomic, strong) JYSeriesModel *seriesModel;

@end

@implementation JYPortraitBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        maxValue = 0.0;
        barWidth = kBarHeight;
        _normalColor = JYColor_ArrowColor_Green;
        _selectColor = @[JYColor_ArrowColor_Red, JYColor_LineColor_LightBlue];
        _dataSource = [NSArray array];
    }
    return self;
}

- (JYSeriesModel *)seriesModel {
    if (!_seriesModel) {
        _seriesModel = (JYSeriesModel *)self.model;
    }
    return _seriesModel;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self formatDataSource];
}

- (void)refreshSubViewData {
    if (self.seriesModel) {
        self.dataSource = @[self.seriesModel.mainDataList, self.seriesModel.subDataList];
    }
}

- (void)setDataSource:(NSArray *)dataSource {
    if (![dataSource isEqual:_dataSource]) {
        _dataSource = dataSource;
        [self setNeedsDisplay];
    }
}

- (void)setSelectColor:(NSArray<UIColor *> *)selectColor {
    if (![_selectColor isEqual:selectColor]) {
        _selectColor = selectColor;
        
        for (int i = 0; i < barList.count; i++) {
            if (barList.count > 0 && barList[i].count > 0) {
                [barList[i] lastObject].strokeColor = selectColor[i].CGColor;
            }
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    for (int i = 0; i < barList.count; i++) {
        for (int j = 0; j < barList[i].count; j++) {
            barList[i][j].strokeColor = self.normalColor.CGColor;
        }
    }
    for (int i = 0; i < barList.count; i++) {
        if (selectedIndex < barList[i].count) {
            barList[i][selectedIndex].strokeColor = self.selectColor[i].CGColor;
        }
    }
}

- (void)setNormalColor:(UIColor *)normalColor {
    if (![_normalColor isEqual:normalColor]) {
        _normalColor = normalColor;
        
        for (int i = 0; i < barList.count; i++) {
            for (int j = 0; j < barList.count; j++) {
                if (j == self.selectedIndex) continue;
                barList[i][j].strokeColor = self.normalColor.CGColor;
            }
        }
    }
}

- (void)drawBarViewWithPoints:(NSArray <NSArray *> *)points {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    barList = nil;
    
    NSMutableArray <NSArray<CAShapeLayer *> *> *tempBarList = [NSMutableArray arrayWithCapacity:points.count];
    for (NSInteger i = 0; i < points.count; i++) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int j = 0; j < self.pointList[i].count; j++) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(CGPointFromString(points[i][j]).x, JYViewHeight)];
            [path addLineToPoint:CGPointFromString(points[i][j])];
            
            CAShapeLayer *shape = [CAShapeLayer layer];
            shape.strokeStart = 0.0;
            shape.strokeEnd = 1.0;
            shape.lineWidth = barWidth;
            shape.strokeColor = self.normalColor.CGColor;
            shape.fillColor = [UIColor clearColor].CGColor;
            shape.path = path.CGPath;
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.duration = 0.5;
            animation.fromValue = @(0.0);
            animation.toValue = @(1.0);
            [shape addAnimation:animation forKey:nil];
            
            [self.layer addSublayer:shape];
            
            [temp addObject:shape];
        }
        [tempBarList addObject:temp];
    }
    
    if (tempBarList) {
        if (self.seriesModel.longerLineIndex == NSOrderedAscending) {
            [tempBarList[0] lastObject].strokeColor = self.selectColor[0].CGColor;
        }
        else if (self.seriesModel.longerLineIndex == NSOrderedDescending) {
            [tempBarList[1] lastObject].strokeColor = self.selectColor[1].CGColor;
        }
        else {
            [tempBarList[1] lastObject].strokeColor = self.selectColor[1].CGColor;
            [tempBarList[0] lastObject].strokeColor = self.selectColor[0].CGColor;
        }
    }
    
    barList = [tempBarList copy];
}

- (void)formatDataSource {
    
    // 数据大于5个时，铺面整个页面
    if (self.seriesModel.maxLength >= 5) {
        barWidth = JYViewWidth / (self.seriesModel.maxLength * 2 * 1.5);
    }
    
    [self.dataSource enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat value = [[obj stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
            maxValue = value > maxValue ? value : maxValue;
        }];
    }];
    
    self.pointList = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    
    // 计算各值对应的坐标
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        NSMutableArray *bars = [NSMutableArray array];
        for (int j = 0; j < self.dataSource[i].count; j++) {
            CGFloat value = [[self.dataSource[i][j] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
            CGFloat barX = JYDefaultMargin + (barWidth + barWidth + barWidth) * j + i * (barWidth + 0.5);
            CGFloat barY = 0.0;
            barY = JYViewHeight - (JYViewHeight * (value / maxValue));
            
            [bars addObject:NSStringFromCGPoint(CGPointMake(barX, barY))];
        }
        [self.pointList addObject:bars];
    }
    
    
    [self drawBarViewWithPoints:[self.pointList copy]];
    
    // 整个view宽度更新
    CGRect frame = self.frame;
    if (self.dataSource.count >= 5) {
        frame.size.width = CGPointFromString([[self.pointList firstObject] lastObject]).x + barWidth / 2 + JYDefaultMargin;
        self.frame = frame;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(portraitBar:refreshWidth:)]) {
        [self.delegate portraitBar:self refreshWidth:frame.size.width];
    }
}


- (NSArray *)pionts {
    if (self.pointList.count > 0) {
        return self.seriesModel.longerLineIndex == NSOrderedAscending ? [self.pointList firstObject] : [self.pointList lastObject];
    }
    return [self.pointList copy];
}

@end
