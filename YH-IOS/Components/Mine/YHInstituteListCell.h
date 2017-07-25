//
//  YHInstituteListCell.h
//  YH-IOS
//
//  Created by cjg on 2017/7/25.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticlesModel.h"

@interface YHInstituteListCell : UITableViewCell

@property (nonatomic, strong) CommonBack favBack;

@property (nonatomic, strong) UIImageView* iconImageV;
@property (nonatomic, strong) UILabel* titleLab;
@property (nonatomic, strong) UIButton* favBtn;
@property (nonatomic, strong) UILabel* tagLab;
@property (nonatomic, strong) UIView* lineView;

- (void)setWithArticle:(ArticlesModel*)model;

@end
