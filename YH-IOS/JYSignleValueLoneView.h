//
//  JYSignleValueLoneView.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/21.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHKPIModel.h"

@interface JYSignleValueLoneView : UIView

@property(nonatomic, strong)UILabel *titleLable;
@property(nonatomic, strong)UILabel *valueLable;
@property(nonatomic, strong)UILabel *utilLable;
@property(nonatomic, strong)UILabel *warnLable;
@property(nonatomic, strong)UILabel *detailUtilLable;
@property(nonatomic, strong)UILabel *detailWarnLable;
@property(nonatomic, strong)UIView *seperLine2;
@property(nonatomic, assign)BOOL isShow;

@property (nonatomic, copy) YHKPIDetailModel *model;

-(id)initWithFrame:(CGRect)frame withShow:(BOOL)isShow;

@end
