//
//  YHWarningNoticeCell.h
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeWarningModel.h"

@interface YHWarningNoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UIImageView *unReadImageV;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)setNoticeWarningModel:(NoticeWarningModel*)model;

@end
