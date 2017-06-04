//
//  YH_ScrollTitleLineAndBarVC.h
//  SwiftCharts
//
//  Created by CJG on 17/4/10.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHBaseViewController.h"
#import "HomeIndexModel.h"

@interface YH_ScrollTitleLineAndBarVC : YHBaseViewController
/** 选中第几个回调 */
@property (nonatomic, strong) CommonBack selectBack;

- (void)setWithData:(NSArray*)dataList curModel:(HomeIndexModel*)model animation:(BOOL)animation;

@end
