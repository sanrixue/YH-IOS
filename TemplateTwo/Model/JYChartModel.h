//
//  JYChartModel.h
//  各种报表
//
//  Created by niko on 17/5/13.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"
#import "JYSeriesModel.h"

@interface JYChartModel : JYModuleTwoBaseModel

@property (nonatomic, strong, readonly) JYSeriesModel *seriesModel;
@property (nonatomic, strong, readonly) NSArray <NSString *> *legend;
@property (nonatomic, strong, readonly) NSArray <NSString *> *xAxis;




@end
