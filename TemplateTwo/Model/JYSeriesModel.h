//
//  JYSeriesModel.h
//  各种报表
//
//  Created by niko on 17/5/13.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYSeriesModel : JYBaseModel

@property (nonatomic, strong, readonly) NSString *mainSeriesTitle;
@property (nonatomic, strong, readonly) NSString *subSeriesTitle;
@property (nonatomic, strong, readonly) NSArray *mainDataList;
@property (nonatomic, strong, readonly) NSArray *subDataList;
@property (nonatomic, strong, readonly) NSArray <UIColor *> *mainDataColorList;
@property (nonatomic, strong, readonly) NSArray *mainDataArrowList;
@property (nonatomic, strong, readonly) NSArray *yAxisDataList;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) NSInteger minLength;
/*
 使用mainDataList.count 和 subDataList.count 比较，
 main.count大NSOrderedAscending，否返回NSOrderedDescending或NSOrderedSame
 */
@property (nonatomic, assign) NSComparisonResult longerLineIndex;

- (NSString *)floatRatioAtIndex:(NSInteger)idx;
- (TrendTypeArrow)arrowAtIndex:(NSInteger)idx;

@end
