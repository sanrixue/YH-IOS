//
//  HomeIndexDetailListCell.m
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "HomeIndexDetailListCell.h"
#import "YH_BarView.h"
#import "HomeIndexModel.h"

@interface HomeIndexDetailListCell ()
@property (nonatomic, strong) YH_BarView* BarView;


@end

@implementation HomeIndexDetailListCell

+ (CGFloat)heightForSelf{
    return 25;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [AppColor app_8color];
    _nameBtn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    _valueBtn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    [_nameBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.BarView];
    [self.BarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.valueBtn.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self).offset(-25);
    }];
}

- (void)setItem:(HomeIndexItemModel*)item{
    [self.nameBtn setTitle:item.name forState:UIControlStateNormal];
    HomeIndexItemModel *selectItem = item.selctItem;
    self.nameBtn.selected = item.select;
    self.valueBtn.selected = item.select;
    [self.valueBtn setTitle:[NSString stringWithFormat:@"%.2f",selectItem.main_data.data] forState:UIControlStateNormal];
    self.BarView.barColor = [UIColor colorWithHexString:selectItem.state.color];
    if ( _maxData>0) {
        self.BarView.scale = selectItem.main_data.data/_maxData;
    }else{
        self.BarView.scale = 0;
    }

}

- (void)btnAction:(UIButton*)sender{
    if (self.btnClickBack) {
        self.btnClickBack(self);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (YH_BarView *)BarView{
    if (!_BarView) {
        _BarView = [[YH_BarView alloc] init];
    }
    return _BarView;
}

@end
