//
//  YHInstituteListCell.m
//  YH-IOS
//
//  Created by cjg on 2017/7/25.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHInstituteListCell.h"

@interface YHInstituteListCell ()



@end

@implementation YHInstituteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView sd_addSubviews:@[self.iconImageV,self.titleLab,self.favBtn,self.tagLab,self.lineView]];
    [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.mas_equalTo(self).offset(15);
        make.left.mas_equalTo(self).offset(15);
    }];
    [_favBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageV);
        make.size.mas_equalTo(CGSizeMake(30, 20));
        make.right.mas_equalTo(self).offset(-10);
    }];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageV);
        make.left.mas_equalTo(_iconImageV.mas_right).offset(15);
        make.right.mas_equalTo(_favBtn.mas_left).offset(-10);
    }];
    [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLab);
        make.bottom.mas_equalTo(_iconImageV);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.mas_equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithArticle:(ArticlesModel *)model{
    _titleLab.text = model.title;
    _favBtn.selected = model.favorite;
    _tagLab.text = model.tagInfo;
}

- (UIImageView *)iconImageV{
    if (!_iconImageV) {
        _iconImageV = [[UIImageView alloc] init];
    }
    return _iconImageV;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [AppColor app_6color];
        _titleLab.font = [UIFont boldSystemFontOfSize:15];
        _titleLab.numberOfLines = 1;
    }
    return _titleLab;
}

- (UIButton *)favBtn{
    if (!_favBtn) {
        _favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favBtn setImage:@"icon_nocollect".imageFromSelf forState:UIControlStateNormal];
        [_favBtn setImage:@"icon_collecting".imageFromSelf forState:UIControlStateSelected];
        MJWeakSelf;
        [_favBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (weakSelf.favBack) {
                weakSelf.favBack(sender);
            }
        }];
    }
    return _favBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorHex(e6e6e6);
    }
    return _lineView;
}

- (UILabel *)tagLab{
    if (!_tagLab) {
        _tagLab = [[UILabel alloc] init];
        _tagLab.font = [UIFont systemFontOfSize:11];
        _tagLab.textColor = UIColorHex(72b54d);
    }
    return _tagLab;
}


@end
