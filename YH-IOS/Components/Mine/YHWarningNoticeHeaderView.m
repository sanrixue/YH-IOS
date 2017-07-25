//
//  YHWarningNoticeHeaderView.m
//  YH-IOS
//
//  Created by cjg on 2017/7/25.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHWarningNoticeHeaderView.h"
#import "BaseModel.h"

@interface YHWarningNoticeHeaderView ()

@property (nonatomic, strong) UIButton* btn1;
@property (nonatomic, strong) UIButton* btn2;
@property (nonatomic, strong) UIButton* btn3;
@property (nonatomic, strong) UIButton* btn4;

@property (nonatomic, strong) UILabel* titleLab;

@property (nonatomic, strong) NSArray<UIButton*>* btns;


@end

@implementation YHWarningNoticeHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btns = @[_btn1,_btn2,_btn3,_btn4];
        
        [self sd_addSubviews:@[self.titleLab,_btn1,_btn2,_btn3,_btn4]];
        
        for (int i=0; i<_btns.count; i++) {
            UIButton* button = [_btns objectAtIndex:i];
            button.tag = i+1;
            [button.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"4688b5"] forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithHexString:@"ebf8fd"] forState:UIControlStateSelected];
            [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                if (self.clickBlock) {
                    self.clickBlock(sender);
                }
            }];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(56, 24));
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(self.mas_right).offset(-(15+i*60));
            }];
        }
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(15);
            make.top.bottom.mas_equalTo(self);
        }];
        
    }
    return self;
}

- (void)setWithBaseModels:(NSArray *)array{
    for (int i=0; i<array.count; i++) {
        BaseModel* model = array[i];
        UIButton* button = [self viewWithTag:i+1];
        button.selected = model.isSelected;
        [button setTitle:model.message forState:UIControlStateNormal];
        [button setBorderColor:button.selected ? [UIColor colorWithHexString:@"4688b5"]:[UIColor colorWithHexString:@"e6e6e6"] width:0.5 cornerRadius:3];
    }
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"筛选: ";
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = UIColorHex(@"32414b");
    }
    return _titleLab;
}




@end
