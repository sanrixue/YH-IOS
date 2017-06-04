//
//  JYClickableLine.h
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseComponentView.h"

@class JYClickableLine;
@protocol JYClickableLineDelegate <NSObject>

- (void)clickableLine:(JYClickableLine *)clickableLine didSelected:(NSInteger)index data:(id)data;
- (void)clickableLine:(JYClickableLine *)clickableLine didSelected:(CGPoint)keyPoint;

@end

@interface JYClickableLine : JYBaseComponentView

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) id <JYClickableLineDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *points;
@property (nonatomic, strong) UIColor *lineColor;

- (void)findNearestKeyPointOfPoint:(CGPoint)point;

@end
