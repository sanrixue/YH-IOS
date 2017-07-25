//
//  MineControllerHeaderView.m
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineControllerHeaderView.h"

@interface MineControllerHeaderView ()



@end

@implementation MineControllerHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self sd_addSubviews:@[self.btn1,self.btn2,self.btn3,self.lightView,self.lineView]];
        NSArray* btns = self.btns;
        NSArray* titles = @[@"公告预警",@"数据学院",@"个人信息"];
        CGFloat width = SCREEN_WIDTH/3.0;
        for (int i=0; i<btns.count; i++) {
            UIButton* button = btns[i];
            button.tag = i+1;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"bcbcbc"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"32414b"] forState:UIControlStateSelected];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(44);
                make.bottom.mas_equalTo(self);
                make.left.mas_equalTo(self).offset(i*width);
            }];
            [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                if (self.clickBack) {
                    self.clickBack(sender);
                }
            }];
        }
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)updateWithScale:(CGFloat)scale{
    if (scale>=0 && scale<=2.0) {
        self.lightView.centerX = ((SCREEN_WIDTH/3.0)/2.0) + SCREEN_WIDTH*2/3.0*scale/2.0;
    }
}

- (NSArray<UIButton *> *)btns{
    if (!_btns) {
        _btns = @[self.btn1,self.btn2,self.btn3];
    }
    return _btns;
}

- (UIButton *)btn1{
    if (!_btn1) {
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btn1;
}

- (UIButton *)btn3{
    if (!_btn3) {
        _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btn3;
}

- (UIButton *)btn2{
    if (!_btn2) {
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btn2;
}

- (UIView *)lightView{
    if (!_lightView) {
        _lightView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/3.0)/2.0-12, 64-7, 24, 3)];
        [_lightView cornerRadius:1.5];
        _lightView.backgroundColor = [UIColor colorWithHexString:@"00a4e9"];
    }
    return _lightView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    }
    return _lineView;
}


@end
