//
//  YH_LineAndBarVc.h
//  SwiftCharts
//
//  Created by CJG on 17/4/10.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YH_LineAndBarVc : YHBaseViewController
/** 选中回调, number类型 */
@property (nonatomic, strong) CommonBack selectBack;

- (void)setWithLineData:(NSArray*)lineData barData:(NSArray*)barData animation:(BOOL)animation;
@end
