//
//  ChartHudView.m
//  SwiftCharts
//
//  Created by CJG on 17/4/12.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "ChartHudView.h"

@implementation ChartHudView

+ (instancetype)showInView:(UIView *)view delegate:(id)delegate{
    ChartHudView *hud = [self viewWithXibName:nil owner:nil];
    [view addSubview:hud];
    [hud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    return hud;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = RGB(255, 255, 255, 0.9);
    self.closeBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self removeFromSuperview];
    }];
    [self.closeBtn addGestureRecognizer:tap];
    self.textView.userInteractionEnabled = NO;
}

@end
