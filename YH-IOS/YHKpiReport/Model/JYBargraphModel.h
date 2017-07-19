//
//  JYBargraphModel.h
//  各种报表
//
//  Created by niko on 17/5/13.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"

typedef NS_ENUM(NSUInteger, JYBargraphModelSortType) {
    JYBargraphModelSortNone = 0,
    JYBargraphModelSortProNameUp,
    JYBargraphModelSortProNameDown,
    JYBargraphModelSortRatioUp,
    JYBargraphModelSortRatioDown,
};

@interface JYBargraphModel : JYModuleTwoBaseModel

@property (nonatomic, copy) NSDictionary *seriesInfo;
@property (nonatomic, copy) NSDictionary *xAxisInfo;
@property (nonatomic, strong, readonly) NSString *seriesName;
@property (nonatomic, strong, readonly) NSArray <NSString *> *seriesData;
@property (nonatomic, strong, readonly) NSArray <UIColor *> *seriesColor;
@property (nonatomic, strong, readonly) NSString *xAxisName;
@property (nonatomic, strong, readonly) NSArray *xAxisData;

- (void)sortedSeriesList:(JYBargraphModelSortType)type;

@end
