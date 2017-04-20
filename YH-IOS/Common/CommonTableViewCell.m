//
//  CommonTableViewCell.m
//  JinXiaoEr
//
//  Created by CJG on 17/3/28.
//
//

#import "CommonTableViewCell.h"

@implementation CommonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self.contentView addSubview:self.leftLab];
    [self.contentView addSubview:self.rightImageV];
    [self.contentView addSubview:self.rightLab];
    [self.contentView addSubview:self.lineView];
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
    }];
    [_rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.rightImageV.mas_left).offset(-5);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    return self;
}

- (void)setTitleStyle:(BOOL)set{
    if (set) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _leftLab.font = [UIFont boldSystemFontOfSize:14];
        _rightLab.hidden = YES;
        _rightImageV.hidden = YES;
    }else{
        _leftLab.font = [UIFont systemFontOfSize:12];
        _rightLab.hidden = 0;
        _rightImageV.hidden = 0;
    }
}

- (void)updateLeftPadding:(CGFloat)padding{
    [_leftLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(padding);
    }];
}




- (UILabel *)leftLab{
    if (!_leftLab) {
        _leftLab = [[UILabel alloc] init];
        [_leftLab style1];
    }
    return _leftLab;
}

- (UILabel *)rightLab{
    if (!_rightLab) {
        _rightLab = [[UILabel alloc] init];
        [_rightLab style1];
        _rightLab.textAlignment = NSTextAlignmentRight;
    }
    return _rightLab;
}

- (UIImageView *)rightImageV{
    if (!_rightImageV) {
        _rightImageV = [[UIImageView alloc] initWithImage:@"right_back".imageFromSelf];
//        _rightImageV.backgroundColor = [UIColor redColor];
    }
    return _rightImageV;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [AppColor grayBackgroudColor];
    }
    return _lineView;
}

@end
