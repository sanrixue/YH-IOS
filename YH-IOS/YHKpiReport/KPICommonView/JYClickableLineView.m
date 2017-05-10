//
//  JYClickableLineView.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYClickableLineView.h"
#import "JYClickableLine.h"

#define kAxisXViewHeight (40)

@interface JYClickableLineView () <JYClickableLineDelegate> {
    JYClickableLine *lineView1;
    JYClickableLine *lineView2;
}

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation JYClickableLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubVeiw];
    }
    return self;
}

- (void)initializeSubVeiw {
    
    [self initializeTitle];
    [self initializeAxis];
    
}

- (void)initializeTitle {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JYViewWidth, JYViewHeight * 0.3)];
    //titleView.backgroundColor = JYColor_LightGray_White;
    [self addSubview:titleView];
    
    UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin / 2, 50, 20)];
    timeLB.text = @"W3";
    timeLB.font = [UIFont systemFontOfSize:12];
    [titleView addSubview:timeLB];
    
    UILabel *title;
    for (int i = 0; i < 3; i++) {
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeLB.frame) + ((3 * JYDefaultMargin) + 50) * i, CGRectGetMaxY(timeLB.frame) + 4, 50, 20)];
        //number.backgroundColor = JYColor_LightGray_White;
        number.text = @"2030";
        [titleView addSubview:number];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(number.frame), CGRectGetMaxY(number.frame), 50, 20)];
        //title.backgroundColor = JYColor_LightGray_White;
        title.text = @"昨天";
        title.font = [UIFont systemFontOfSize:12];
        [titleView addSubview:title];
        
        
        if (i == 2) {
            UIImageView *IV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_greenarrow"]];
            IV.frame = CGRectMake(CGRectGetMaxX(number.frame), CGRectGetMinY(number.frame) + (20 - 15) / 2.0, 15, 15);
            [titleView addSubview:IV];
        }
    }
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+15, JYViewWidth, 0.5)];
    sepLine.backgroundColor = JYColor_TextColor_Gray;
    [titleView addSubview:sepLine];
}

- (void)initializeAxis {
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, JYViewHeight*0.3, JYViewWidth, JYViewHeight*0.7)];
    //infoView.backgroundColor = JYColor_LightGray_White;
    [self addSubview:infoView];
    
    lineView1 = [[JYClickableLine alloc] initWithFrame:CGRectMake(CGRectGetWidth(infoView.bounds)/5, JYDefaultMargin, CGRectGetWidth(infoView.bounds) * 4 / 5, CGRectGetHeight(infoView.bounds)-kAxisXViewHeight-JYDefaultMargin)];
    //portraitBar.backgroundColor = JYColor_LightGray_White;
    lineView1.dataList = @[@"0.1", @"0.3", @"0.2", @"0.93", @"0.124", @"0.45"];
    lineView1.delegate = self;
    lineView1.lineColor = JYColor_ArrowColor_Red;
    [infoView addSubview:lineView1];
    
    lineView2 = [[JYClickableLine alloc] initWithFrame:CGRectMake(CGRectGetWidth(infoView.bounds)/5, JYDefaultMargin, CGRectGetWidth(infoView.bounds) * 4 / 5, CGRectGetHeight(infoView.bounds)-kAxisXViewHeight-JYDefaultMargin)];
    //portraitBar.backgroundColor = JYColor_LightGray_White;
    lineView2.dataList = @[@"9329", @"328", @"3211", @"169", @"543", @"383"];
    lineView2.delegate = self;
    lineView2.lineColor = JYColor_ArrowColor_Yellow;
    [infoView addSubview:lineView2];
    
    // 纵坐标
    UIView *axisYView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(infoView.bounds) / 5, CGRectGetHeight(infoView.bounds))];
    //axisYView.backgroundColor = JYColor_ArrowColor_Red;
    [infoView addSubview:axisYView];
    CGFloat scaleHeight = (CGRectGetHeight(axisYView.bounds) - kAxisXViewHeight) / 4;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, 50, scaleHeight)];
        CGPoint center = label.center;
        center.y = scaleHeight * i + JYDefaultMargin + JYDefaultMargin;
        label.center = center;
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"第%d周", i];
        [axisYView addSubview:label];
    }
    
    // 横坐标
    UIView *axisXView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView1.frame), CGRectGetWidth(infoView.bounds), kAxisXViewHeight)];
    //axisXView.backgroundColor = JYColor_ArrowColor_Yellow;
    [infoView addSubview:axisXView];
    for (int i = 0; i < lineView1.points.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kBarHeight * 2, 30)];
        CGPoint center = label.center;
        center.x = CGPointFromString(lineView1.points[i]).x + CGRectGetWidth(axisYView.frame);// + JYDefaultMargin;
        center.y = CGRectGetHeight(axisXView.bounds) / 2.0;
        label.center = center;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"W%d", i];
        [axisXView addSubview:label];
    }
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, JYViewWidth, 0.5)];
    sepLine.backgroundColor = JYColor_TextColor_Gray;
    [axisXView addSubview:sepLine];
}


#pragma mark - <JYClickableLineDelegate>
- (void)clickableLine:(JYClickableLine *)clickableLine didSelected:(NSInteger)index data:(id)data {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoBaseView:didSelectedAtIndex:data:)]) {
        [self.delegate moduleTwoBaseView:self didSelectedAtIndex:index data:data];
    }
}

- (void)clickableLine:(JYClickableLine *)clickableLine didSelected:(CGPoint)keyPoint {
    if ([lineView2 isEqual:clickableLine]) {
        [lineView1 findNearestKeyPointOfPoint:keyPoint];
    }
    else if ([lineView1 isEqual:clickableLine]) {
        [lineView2 findNearestKeyPointOfPoint:keyPoint];
    }
}

- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    return JYViewWidth * 0.9;
}

@end


