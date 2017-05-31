//
//  JYLandscapeBarView.m
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYLandscapeBarView.h"
#import "JYLandscapeBar.h"
#import "JYInvertButton.h"
#import "JYBlockButton.h"

@interface JYLandscapeBarView () {
    JYLandscapeBar *bar;
    UIView *titleView;
}

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation JYLandscapeBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubVeiw];
    }
    self.layer.borderColor = [UIColor clearColor].CGColor;
    return self;
}

- (void)dealloc {
    
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[];
    }
    return _dataSource;
}

- (void)initializeSubVeiw {
    
    [self initializeTitle];
    [self initializeAxis];
}

- (void)initializeTitle {
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JYViewWidth, 40)];
    [self addSubview:titleView];
    
    for (int i = 0; i < 2; i++) {
        JYInvertButton *inverBtn = [[JYInvertButton alloc] initWithFrame:CGRectMake(JYViewWidth / 3.0 * i, 0, JYViewWidth / 3.0 / (i + 1), 40)];
        inverBtn.typeName = @[@"增长率", @"商品"][i];
        [inverBtn setInverHandler:^(NSString *type) {
            NSLog(@"inver %@", type);
        }];
        [titleView addSubview:inverBtn];
    }
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), JYViewWidth, 0.5)];
    sepLine.backgroundColor = JYColor_TextColor_Gray;
    [titleView addSubview:sepLine];

}

- (void)initializeAxis {
    
    bar = [[JYLandscapeBar alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetMaxY(titleView.frame), CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.frame))];
    //bar.backgroundColor = JYColor_ArrowColor_Yellow;
    [self addSubview:bar];
    
    UIView *proInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(bar.frame), JYViewWidth / 2.0, CGRectGetHeight(bar.frame))];
    [self addSubview:proInfoView];
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        
        UIImageView *IV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_greenarrow"]];
        IV.frame = CGRectMake(0, 0  , 10, 10);
        [proInfoView addSubview:IV];
        CGPoint center = IV.center;
        center.y = CGPointFromString(bar.pionts[i]).y;
        IV.center = center;
        IV.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
        
        UIButton *proName = [UIButton buttonWithType:UIButtonTypeCustom];
        proName.frame = CGRectMake(CGRectGetMaxX(IV.frame) + JYDefaultMargin / 2.0, 0, 110, kBarHeight);
        [proName addTarget:self action:@selector(clickActive:) forControlEvents:UIControlEventTouchUpInside];
        proName.tag = -10000 + i;
        [proName setTitle:self.dataSource[i] forState:UIControlStateNormal];
        [proName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        proName.titleLabel.font = [UIFont systemFontOfSize:13];
        proName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        proName.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [proInfoView addSubview:proName];
        
        center = proName.center;
        center.y = CGPointFromString(bar.pionts[i]).y;
        proName.center = center;
        
        UILabel *ratio = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(proName.frame) + JYDefaultMargin, CGRectGetMinY(proName.frame), 50, kBarHeight)];
        ratio.text = @"+100%";
        ratio.textColor = JYColor_TextColor_Gray;
        ratio.font = [UIFont systemFontOfSize:12];
        [proInfoView addSubview:ratio];
    }
}

- (void)clickActive:(UIButton *)sender {
    NSInteger i = sender.tag + 10000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoBaseView:didSelectedAtIndex:data:)]) {
        [self.delegate moduleTwoBaseView:self didSelectedAtIndex:i data:self.dataSource[i]];
    }
}

- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    
    return CGRectGetHeight(bar.frame) + CGRectGetHeight(titleView.frame);
}

@end
