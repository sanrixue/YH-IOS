//
//  JYBargraphModel.m
//  各种报表
//
//  Created by niko on 17/5/13.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBargraphModel.h"

@interface JYBargraphModel () {
    NSMutableArray <NSNumber *> *sortedIndexList;
}

@end

@implementation JYBargraphModel

- (NSDictionary *)seriesInfo {
    if (!_seriesInfo) {
        _seriesInfo = self.configInfo[@"series"];
    }
    return _seriesInfo;
}

- (NSDictionary *)xAxisInfo {
    if (!_xAxisInfo) {
        _xAxisInfo = self.configInfo[@"xAxis"];
    }
    return _xAxisInfo;
}

- (NSString *)seriesName {
    return self.seriesInfo[@"name"];
}

- (NSString *)xAxisName {
    return self.xAxisInfo[@"name"];
}

- (NSArray *)xAxisData {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[self.xAxisInfo[@"data"] count]];
    for (int i = 0; i < [self.xAxisInfo[@"data"] count]; i++) {
        NSString *name = [self.xAxisInfo[@"data"] objectAtIndex:sortedIndexList ? [sortedIndexList[i] integerValue] : i];
        [temp addObject:name];
    }
    
    return [temp copy];
}

- (NSArray <NSString *> *)seriesData {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[self.seriesInfo[@"data"] count]];
    for (int i = 0; i < [self.seriesInfo[@"data"] count]; i++) {
        NSDictionary *dic = [self.seriesInfo[@"data"] objectAtIndex:sortedIndexList ? [sortedIndexList[i] integerValue] : i];
        [temp addObject:[NSString stringWithFormat:@"%@%.2f", ([dic[@"value"] floatValue] > 0 ? @"+" : @""), [dic[@"value"] floatValue]]];
    }
    return [temp copy];
}

- (NSArray<UIColor *> *)seriesColor {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[self.seriesInfo[@"data"] count]];
    for (int i = 0; i < [self.seriesInfo[@"data"] count]; i++) {
        NSDictionary *dic = [self.seriesInfo[@"data"] objectAtIndex:sortedIndexList ? [sortedIndexList[i] integerValue] : i];
        [temp addObject:[[self class] arrowToColor:[dic[@"color"] integerValue]]];
    }
    return [temp copy];
}

- (void)sortedSeriesList:(JYBargraphModelSortType)type {
    
    NSString *sortKey = @"value";
    NSArray *orginArr = nil;
    if (type == JYBargraphModelSortRatioDown || type == JYBargraphModelSortRatioUp) {
        sortKey = @"value";
        orginArr = self.seriesInfo[@"data"];
    }
    else {
        sortKey = @"pinyin";
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[self.xAxisInfo[@"data"] count]];
        for (NSString *chinese in self.xAxisInfo[@"data"]) {// 不能使用self.xAxisData
            NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
            [mdic setObject:chinese forKey:@"chinese"];
            [mdic setObject:[self chineseToPinyin:chinese] forKey:@"pinyin"];
            [temp addObject:mdic];
        }
        orginArr = [temp copy];
    }
    
    BOOL ascending = NO;
    switch (type) {
        case JYBargraphModelSortRatioUp:
            ascending = YES;
            break;
        case JYBargraphModelSortRatioDown:
            ascending = NO;
            break;
        case JYBargraphModelSortProNameUp:
            ascending = YES;
            break;
        case JYBargraphModelSortProNameDown:
            ascending = NO;
            break;
            
        default:
            break;
    }
    
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:orginArr];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending]];
    [sortedArray sortUsingDescriptors:sortDescriptors];
    
    sortedIndexList = [NSMutableArray arrayWithCapacity:sortedArray.count];
    for (NSDictionary *dic in sortedArray) {
        NSInteger index = [orginArr indexOfObjectIdenticalTo:dic];
        [sortedIndexList addObject:@(index)];
    }
    
    //NSLog(@"%@", sortedIndexList);
}

- (NSString *)chineseToPinyin:(NSString *)chinese {
    NSMutableString *mutableString = [NSMutableString stringWithString:chinese];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    return [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
