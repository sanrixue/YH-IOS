//
//  JYSheetModel.m
//  各种报表
//
//  Created by niko on 17/5/15.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYSheetModel.h"

@interface JYSheetModel () {
    NSMutableArray *sortIndexList;
}

@property (nonatomic, strong) NSArray <JYMainDataModel *> *originMainDataList;

@end

@implementation JYSheetModel


- (NSArray <JYMainDataModel *> *)originMainDataList {
    if (!_originMainDataList) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[self.params[@"data"] count]];
        for (int i = 0; i < [self.params[@"data"] count]; i++) {
            NSDictionary *dic = self.params[@"data"][i];
            JYMainDataModel *mainData = [JYMainDataModel modelWithParams:dic];
            [temp addObject:mainData];
        }
        _originMainDataList = [temp copy];
    }
    return _originMainDataList;
}

- (NSArray<NSString *> *)headNames {
    return self.params[@"head"];
}

- (JYDetailChartType)chartType {
    return JYDetailChartTypeTables;
}

- (NSArray<JYMainDataModel *> *)mainDataModelList {
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[self.originMainDataList count]];
    for (int i = 0; i < [self.originMainDataList count]; i++) {
        JYMainDataModel *mainData = self.originMainDataList[sortIndexList ? [sortIndexList[i] integerValue] : i];
        [temp addObject:mainData];
    }
    _mainDataModelList = [temp copy];
    return _mainDataModelList;
}


// TODO: 排序，
/*
 1.取出对应列所有数据，组装成一个数组originList，2.对取出的数组进行按需排序sortList，3.逐一查找sortList在originList中对应的位置，并记录在sortIndexList中,
 4.如果sortList有相同数据，查找originList的下一个数据，直到找到相同数据，并记录位置，5.根据sortIndexList重新组装mianDataModelList，组装成功返回；
 */

- (void)sortMainDataListWithSection:(NSInteger)section ascending:(BOOL)ascending {
    
    NSLog(@"第%zi列 %@", section, (ascending ? @"升序" : @"降序"));
    
    // 原始数组
    NSArray <JYMainDataModel *> *originMainData = self.originMainDataList;
    // 获取原数据的section位置的数组
    NSMutableArray <NSNumber *> *mainDataAtSectionList = [NSMutableArray arrayWithCapacity:originMainData.count];
    // 从原始数组中提取出要排序列的一组数组，即提取出排序列数组
    for (int i = 0; i < originMainData.count; i++) {
        [mainDataAtSectionList addObject:@([originMainData[i].dataList[section + 1] floatValue])];
    }
    // 排序列数组进行排序，生成排后列数组
    NSArray *sortedMainDataAtSectionList = [mainDataAtSectionList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];;
        if (!ascending) {
            if (result != NSOrderedSame) {
                result = result * (-1);
            }
        }
        return result;
    }];
    
    // 记录 “排后列数组” 的每个数据在原 “排序列数组” 中的位置
    sortIndexList = [NSMutableArray arrayWithCapacity:mainDataAtSectionList.count];
    for (int i = 0; i < sortedMainDataAtSectionList.count; i++) {
        NSNumber *sortNumber = sortedMainDataAtSectionList[i];
        NSInteger index = [mainDataAtSectionList indexOfObjectIdenticalTo:sortNumber];// indexOfObjectIdenticalTo 比较内存地址
        // 当sortNumber为0时，0的内存地址均相同，因此采用向后查找的方式继续查找
        if ([sortIndexList containsObject:@(index)]) {
            for (NSInteger j = ++index; j < sortedMainDataAtSectionList.count; j++) {
                if ([[mainDataAtSectionList objectAtIndex:j] isEqual:sortNumber]) {
                    [sortIndexList addObject:@(index)];
                    break;
                }
            }
            continue;
        }
        [sortIndexList addObject:@(index)];
    }
    
    
    NSLog(@"%@", sortIndexList);
}



@end


