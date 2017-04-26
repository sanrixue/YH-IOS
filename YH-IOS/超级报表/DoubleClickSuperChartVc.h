//
//  DoubleClickSuperChartVc.h
//  SwiftCharts
//
//  Created by CJG on 17/4/25.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "BaseViewController.h"
#import "SuperChartModel.h"

@interface DoubleClickSuperChartVc : BaseViewController
@property (nonatomic, strong) CommonBack sortBack;

- (void)setWithSuperModel:(SuperChartModel*)superModel column:(NSInteger)column;

@end
