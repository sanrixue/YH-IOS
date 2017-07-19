//
//  JYSubSheetView.m
//  各种报表
//
//  Created by niko on 17/5/18.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYSubSheetView.h"
#import "JYSheetView.h"

@interface JYSubSheetView ()

@property (nonatomic, strong) JYSheetView *sheetView;
@property (nonatomic, strong) UILabel *sheetTitleLabel;
@property (nonatomic, strong) UIButton *closePageBtn;

@end

@implementation JYSubSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.sheetTitleLabel];
    }
    return self;
}

- (JYSheetView *)sheetView {
    if (!_sheetView) {
        
        _sheetView = [[JYSheetView alloc] initWithFrame:CGRectMake(JYDefaultMargin * 2, CGRectGetMaxY(self.sheetTitleLabel.frame), JYScreenWidth - JYDefaultMargin * 2 * 2, JYViewHeight - CGRectGetMaxY(self.sheetTitleLabel.frame))];
        _sheetView.flexibleHeight = YES;
    }
    return _sheetView;
}

- (UILabel *)sheetTitleLabel {
    if (!_sheetTitleLabel) {
        _sheetTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, JYScreenWidth, 44)];
        //_sheetTitleLabel.textColor = JYColor_TextColor_Chief;
        _sheetTitleLabel.textAlignment = NSTextAlignmentCenter;
        _sheetTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _sheetTitleLabel;
}

- (UIButton *)closePageBtn {
    if (!_closePageBtn) {
        _closePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closePageBtn.frame = CGRectMake((JYViewWidth - 36)/2, JYViewHeight - 36 - 30, 36, 36);
        [_closePageBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
        [_closePageBtn addTarget:self action:@selector(closeSubSheetView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closePageBtn;
}

- (void)setSheetModel:(JYSheetModel *)sheetModel {
    if (![_sheetModel isEqual:sheetModel]) {
        _sheetModel = sheetModel;
    }
    self.sheetTitleLabel.text = _sheetModel.sheetTitle;
    self.sheetView.moduleModel = _sheetModel;
    
    [self addSubview:_sheetView];
    [self addSubview:self.closePageBtn];
}

- (void)showSubSheetView {
    
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

- (void)closeSubSheetView {
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:0.25 animations:^{
        frame.origin.y = JYScreenHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
