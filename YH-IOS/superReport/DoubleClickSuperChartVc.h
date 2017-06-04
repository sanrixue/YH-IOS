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
#import "UMSocialControllerService.h"

@interface DoubleClickSuperChartVc : YHBaseViewController<UMSocialUIDelegate>
@property (nonatomic, strong) CommonBack sortBack;
@property (nonatomic, strong) NSString* titleString;
@property (nonatomic, strong) NSArray<TableDataBaseItemModel*>* keyArray;
@property (nonatomic, assign) BOOL isdownImage;
@property (nonatomic, assign) BOOL isSort;
@property (nonatomic, strong) NSString* bannerName;
@property (nonatomic, assign) NSInteger lineNumber;
- (void)setWithSuperModel:(SuperChartMainModel*)superModel column:(NSInteger)column;

@end
