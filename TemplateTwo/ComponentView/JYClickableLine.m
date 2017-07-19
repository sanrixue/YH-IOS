//
//  JYClickableLine.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYClickableLine.h"

@interface JYClickableLine () {
    
    
    __block CGFloat maxValue;
    CGFloat margin;
}

@property (nonatomic, strong) NSArray <CAShapeLayer *> * linelayerList; // 折线列表
@property (nonatomic, strong) NSArray <UIColor *> *lineColorList; // 多条折线的颜色列表
@property (nonatomic, strong) NSArray <NSArray <NSNumber *> *> *dataSource; // 多条折线的关键点处理前列表
@property (nonatomic, strong) NSArray <NSArray <NSString *> *> *keyPointsList; // 关键点处理后列表
@property (nonatomic, strong) NSArray <UIView *> *flagPointList; // 圆圈⭕️列表

@end

@implementation JYClickableLine

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self addGesture];
    }
    return self;
}

- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    [self addGestureRecognizer:pan];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self addLine];
}

//- (void)setDataList:(NSArray *)dataList {
//    if (![_dataList isEqual:dataList]) {
//        _dataList = dataList;
//        self.dataSource = dataList;
//    }
//}

- (void)setLineParms:(NSDictionary<NSString *,NSDictionary *> *)lineParms {
    if (![_lineParms isEqual:lineParms]) {
        
        NSMutableArray *lineColorListTemp = [NSMutableArray array];
        NSMutableArray *lineDataListTemp = [NSMutableArray array];
        for (NSDictionary *dic in [lineParms allValues]) {
            [lineColorListTemp addObject:dic[@"color"]];
            [lineDataListTemp addObject:dic[@"data"]];
        }
        self.lineColorList = [lineColorListTemp copy];
        self.dataSource = [lineDataListTemp copy];
    }
}

- (NSArray<UIView *> *)flagPointList {
    if (!_flagPointList) {
        NSMutableArray *flagTemp = [NSMutableArray array];
        for (UIColor *lineColor in self.lineColorList) {
            UIView *flagPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            flagPoint.layer.cornerRadius = 10;
            flagPoint.backgroundColor = [lineColor appendAlpha:0.15];
            flagPoint.hidden = YES;
            
            UIView *point = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 10, 10)];
            point.backgroundColor = [UIColor whiteColor];
            point.layer.cornerRadius = 5;
            point.layer.borderWidth = 2;
            point.layer.borderColor = lineColor.CGColor;
            [flagPoint addSubview:point];
            
            [self addSubview:flagPoint];
            [flagTemp addObject:flagPoint];
        }
        _flagPointList = [flagTemp copy];
    }
    return _flagPointList;
}

- (void)setDataSource:(NSArray<NSArray<NSNumber *> *> *)dataSource {
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;
        [self formatterPoints];
        
        [self setNeedsDisplay];
    }
}

- (void)setLineColorList:(NSArray<UIColor *> *)lineColorList {
    if (![_lineColorList isEqual:lineColorList]) {
        _lineColorList = lineColorList;
        
        for (int i = 0; i < self.linelayerList.count; i++) {
            CAShapeLayer *line = self.linelayerList[i];
            line.strokeColor = self.lineColorList[i].CGColor;
        }
    }
    [self setNeedsDisplay];
}


- (void)formatterPoints {
    
    NSInteger keyPointCountMax = 0;
    for (NSArray *keyPoints in self.dataSource) {
        keyPointCountMax = keyPoints.count > keyPointCountMax ? keyPoints.count : keyPointCountMax;
    }
    margin = CGRectGetWidth(self.frame) / (keyPointCountMax - 1);
    maxValue = 0.0;
    
    for (NSArray *lineData in self.dataSource) {
        for (NSNumber *number in lineData) {
            maxValue = maxValue > [number floatValue] ? maxValue : [number floatValue];
        }
    }
    
    NSMutableArray *keyPointsListTemp = [NSMutableArray array];
    for (NSArray *keyPoints in self.dataSource) {
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:keyPoints.count];
        for (int i = 0; i < keyPoints.count; i++) {
            CGFloat y = CGRectGetHeight(self.frame) * (1 - [keyPoints[i] floatValue] / maxValue) + JYViewHeight * 0.1;
            CGFloat x = (margin * i + JYDefaultMargin * 2) * 0.9; // 按比率缩小x轴，避免标记点显示不全的问题
            
            CGPoint point = CGPointMake(x, y);
            [points addObject:NSStringFromCGPoint(point)];
        }
        [keyPointsListTemp addObject:[points copy]];
    }
    
    self.keyPointsList = [keyPointsListTemp copy];
}

- (NSArray *)points {
    NSInteger keyPointCountMax = [self.dataSource firstObject].count, maxLineIndex = 0;
    for (int i = 0; i < self.dataSource.count; i++) {
        maxLineIndex = self.dataSource[i].count > keyPointCountMax ? i : maxLineIndex;
    }
    return [self.keyPointsList[maxLineIndex] copy];
}

- (void)addLine {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (int i = 0; i < self.keyPointsList.count; i++) {
        NSArray *pointList = self.keyPointsList[i];
        UIBezierPath *layerPath = [UIBezierPath bezierPath];
        for (int i = 0; i < pointList.count; i++) {
            CGPoint point = CGPointFromString(pointList[i]);
            if (i == 0) {
                [layerPath moveToPoint:point];
            }
            [layerPath addLineToPoint:point];
        }
        layerPath.lineJoinStyle = kCGLineJoinRound;
        CAShapeLayer *linelayer = [CAShapeLayer layer];
        linelayer.lineWidth = 2;
        linelayer.strokeEnd = 0.0;
        linelayer.strokeEnd = 1.0;
        linelayer.path = layerPath.CGPath;
        linelayer.fillColor = [UIColor clearColor].CGColor;
        linelayer.strokeColor = (self.lineColorList[i] ?: [UIColor whiteColor]).CGColor;
        linelayer.lineCap = kCALineCapSquare;
        linelayer.lineJoin = kCALineJoinMiter;
        [self.layer addSublayer:linelayer];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0.0;
        animation.toValue = @1.0;
        animation.duration = 0.5;
        [linelayer addAnimation:animation forKey:nil];
    }
    
    [self performSelector:@selector(showFlagPoint) withObject:nil afterDelay:0.6];
}

- (void)showFlagPoint {
    
    NSInteger maxLength = 0, maxIndex = 0;
    for (int i = 0; i < self.flagPointList.count; i++) {
        maxIndex = self.dataSource[i].count > maxLength ? i : maxIndex;
        self.flagPointList[i].center = CGPointFromString([self.keyPointsList[i] lastObject]);
    }
    
    self.flagPointList[maxIndex].hidden = NO;
}

- (void)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    [self findNearestKeyPointOfPoint:[gestureRecognizer locationInView:self]];
}

// 寻找最近的点
- (void)findNearestKeyPointOfPoint:(CGPoint)point {
    
    if (point.x < 0) { // 超出左边界不处理
        return;
    }
    
    CGPoint keyPoint = CGPointMake(NSIntegerMax, NSIntegerMax);
    for (NSInteger i = 0; i < self.keyPointsList.count; i++) {
        self.flagPointList[i].hidden = NO;
        
        for (int j = 0; j < self.keyPointsList[i].count; j++) {
            NSString *pointStr = self.keyPointsList[i][j];
            keyPoint = CGPointFromString(pointStr);
            if (fabs(keyPoint.x - point.x) < margin / 2) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(clickableLine:didSelected:data:)]) {
                    [self.delegate clickableLine:self didSelected:j data:self.dataSource[i][j]];
                }
                
                //NSLog(@"the nearest point is index at %zi", i + 1);
                [UIView animateWithDuration:0.25 animations:^{
                    self.flagPointList[i].center = keyPoint;
                }];
                break;
            }
        }
    }
    
    int index = 0;
    for (NSArray<NSString *> *points in self.keyPointsList) {
        CGPoint lastPoint = CGPointFromString([points lastObject]);
        if ((lastPoint.x < keyPoint.x)) {
            self.flagPointList[index].hidden = YES;
        }
        index++;
    }
}

@end
