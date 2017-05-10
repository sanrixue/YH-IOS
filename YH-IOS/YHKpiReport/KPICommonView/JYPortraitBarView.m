//
//  JYPortraitBarView.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYPortraitBarView.h"
#import "JYPortraitBar.h"

#define kAxisXViewHeight (40)

@interface JYPortraitBarView ()

@property (nonatomic, strong) NSArray *dataSource;

@end


@implementation JYPortraitBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubVeiw];
    }
    return self;
}


- (JYModuleTwoBaseModel *)moduleModel {
    return [JYModuleTwoBaseModel modelWithParams:@{@"data": @{@"data": @[@"0.9", @"0.9", @"0.9", @"0.8", @"0.1", @"0.169", @"0.23", @"0.283"]}}];
}


- (void)initializeSubVeiw {
    
    [self initializeTitle];
    [self initializeAxis];
    
}

- (void)initializeTitle {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JYViewWidth, JYViewHeight * 0.3)];
    [self addSubview:titleView];
    
    UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, JYDefaultMargin / 2, 50, 20)];
    timeLB.text = @"第三周";
    timeLB.font = [UIFont systemFontOfSize:12];
    [titleView addSubview:timeLB];
    
    UILabel *title;
    for (int i = 0; i < 3; i++) {
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeLB.frame) + ((3 * JYDefaultMargin) + 50) * i, CGRectGetMaxY(timeLB.frame) + 4, 50, 20)];
        number.text = @"2030";
        [titleView addSubview:number];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(number.frame), CGRectGetMaxY(number.frame), 50, 20)];
        title.text = @"指标1";
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
    [self addSubview:infoView];
    
    JYPortraitBar *portraitBar = [[JYPortraitBar alloc] initWithFrame:CGRectMake(CGRectGetWidth(infoView.bounds) / 5, JYDefaultMargin, CGRectGetWidth(infoView.bounds) * 4 / 5, CGRectGetHeight(infoView.bounds) - kAxisXViewHeight - JYDefaultMargin)];
    portraitBar.model = self.moduleModel.commponentModel;
    [infoView addSubview:portraitBar];
    
    // 添加点击
    for (int i = 0; i < portraitBar.pionts.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, kBarHeight, CGRectGetHeight(portraitBar.bounds));
        [btn addTarget:self action:@selector(clickActive:) forControlEvents:UIControlEventTouchUpInside];
        CGPoint center = btn.center;
        btn.tag = -10000 + i;
        center.x = CGPointFromString(portraitBar.pionts[i]).x;
        btn.center = center;
        [portraitBar addSubview:btn];
    }
    
    // 纵坐标
    UIView *axisYView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(infoView.bounds) / 5, CGRectGetHeight(infoView.bounds))];
    [infoView addSubview:axisYView];
    CGFloat scaleHeight = (CGRectGetHeight(axisYView.bounds) - kAxisXViewHeight) / 4;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, 50, scaleHeight)];
        CGPoint center = label.center;
        center.y = scaleHeight * i + JYDefaultMargin;
        label.center = center;
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"第%d周", i];
        [axisYView addSubview:label];
    }
    
    // 横坐标
    UIView *axisXView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(portraitBar.frame), CGRectGetWidth(infoView.bounds), kAxisXViewHeight)];
    [infoView addSubview:axisXView];
    for (int i = 0; i < portraitBar.pionts.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kBarHeight * 2, 30)];
        CGPoint center = label.center;
        center.x = CGPointFromString(portraitBar.pionts[i]).x + CGRectGetWidth(axisYView.frame) + JYDefaultMargin;
        center.y = CGRectGetHeight(axisXView.bounds) / 2.0;
        label.center = center;
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"第%d周", i];
        [axisXView addSubview:label];
    }
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, JYViewWidth, 0.5)];
    sepLine.backgroundColor = JYColor_TextColor_Gray;
    [axisXView addSubview:sepLine];
}

- (void)clickActive:(UIButton *)sender {
    NSInteger i = sender.tag + 10000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoBaseView:didSelectedAtIndex:data:)]) {
        [self.delegate moduleTwoBaseView:self didSelectedAtIndex:i data:self.moduleModel.commponentModel.chartData[i]];
    }
}

- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    return JYViewWidth * 0.9;
}

@end
