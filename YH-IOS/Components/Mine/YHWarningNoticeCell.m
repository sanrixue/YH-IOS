//
//  YHWarningNoticeCell.m
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHWarningNoticeCell.h"

@interface YHWarningNoticeCell ()

@end

@implementation YHWarningNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNoticeWarningModel:(NoticeWarningModel *)model{
    _unReadImageV.hidden = model.see;
    _topLab.text = model.title;
    _centerLab.attributedText = [NSString strToAttriWithStr:model.abstracts];
    _bottomLab.text = model.time;
    [self setupAutoHeightWithBottomView:_bottomLab bottomMargin:15];
}

@end
