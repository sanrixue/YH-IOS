//
//  DoubleClickSuperChartVc.h
//  SwiftCharts
//
//  Created by CJG on 17/4/25.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHBaseViewController.h"
#import "SuperChartModel.h"
#import "SuperChartMainModel.h"

@interface DoubleClickSuperChartVc : YHBaseViewController
@property (nonatomic, strong) CommonBack sortBack;
@property (nonatomic, strong) NSString* titleString;
@property (nonatomic, strong) NSArray<TableDataBaseItemModel*>* keyArray;
@property (nonatomic, assign) BOOL isdownImage;

- (void)setWithSuperModel:(SuperChartMainModel*)superModel column:(NSInteger)column;

@end
