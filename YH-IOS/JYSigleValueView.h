//
//  JYSigleValueView.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/20.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHKPIModel.h"

@interface JYSigleValueView : UIView

@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UILabel *valueLable;
@property(nonatomic,strong)UILabel *utilLable;
@property(nonatomic,strong)UILabel *rateLable;
@property(nonatomic,strong)UILabel *warnLable;
@property(nonatomic,strong)UIImageView *warnIamgeView;

@property (nonatomic, copy) YHKPIDetailModel *model;

@end
