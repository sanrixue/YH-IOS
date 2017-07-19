//
//  JYHelpInfoView.m
//  各种报表
//
//  Created by niko on 17/5/20.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYHelpInfoView.h"

@interface JYHelpInfoView ()

@property (nonatomic, strong) UILabel *helpTitleLabel;
@property (nonatomic, strong) UIButton *closePageBtn;
@property (nonatomic, strong) UITextView *helpInfoView;

@end

@implementation JYHelpInfoView




- (void)layoutSubviews {
    [self addSubview:self.helpTitleLabel];
    [self addSubview:self.closePageBtn];
}

- (UITextView *)helpInfoView {
    if (!_helpInfoView) {
        _helpInfoView = [[UITextView alloc] initWithFrame:CGRectMake(JYDefaultMargin * 2, CGRectGetMaxY(self.helpTitleLabel.frame), JYScreenWidth - JYDefaultMargin * 2 * 2, JYViewHeight - CGRectGetMaxY(self.helpTitleLabel.frame))];
        _helpInfoView.editable = NO;
        [self addSubview:_helpInfoView];
    }
    return _helpInfoView;
}

- (UILabel *)helpTitleLabel {
    if (!_helpTitleLabel) {
        _helpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, JYScreenWidth, 44)];
        _helpTitleLabel.textColor = JYColor_TextColor_Chief;
        _helpTitleLabel.textAlignment = NSTextAlignmentCenter;
        _helpTitleLabel.font = [UIFont boldSystemFontOfSize:15];
        _helpTitleLabel.text = @"图标说明";
    }
    return _helpTitleLabel;
}

- (UIButton *)closePageBtn {
    if (!_closePageBtn) {
        _closePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closePageBtn.frame = CGRectMake((JYViewWidth - 36)/2, JYViewHeight - 36 - 30, 36, 36);
        [_closePageBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
        [_closePageBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closePageBtn;
}

- (void)setHelpInfo:(NSString *)helpInfo {
    self.helpInfoView.text = helpInfo;
}

- (void)setHelpTitle:(NSString *)helpTitle {
    self.helpTitleLabel.text = helpTitle;
}

- (void)show {
    
    self.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    __block CGRect frame = self.frame;
    frame.origin.y = JYScreenHeight;
    self.frame = frame;
    [UIView animateWithDuration:0.25 animations:^{
        frame.origin.y = 0;
        self.frame = frame;
    }];
}

- (void)close {
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:0.25 animations:^{
        frame.origin.y = JYScreenHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
