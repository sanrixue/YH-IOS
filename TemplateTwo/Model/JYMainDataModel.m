//
//  JYMainDataModel.m
//  各种报表
//
//  Created by niko on 17/5/15.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYMainDataModel.h"
#import "JYSubDataModlel.h"

@implementation JYMainDataModel


- (NSArray *)dataList {
    return self.params[@"main_data"];
}

- (NSArray<JYSubDataModlel *> *)subDataList {
    if (![[self.params objectForKey:@"sub_data"] isKindOfClass:[NSArray class]]) {
        return @[];
    }
    NSArray *subData = [NSArray arrayWithArray:[self.params objectForKey:@"sub_data"]];
    NSMutableArray <JYSubDataModlel *> *temp = [NSMutableArray arrayWithCapacity:subData.count];
    for (NSDictionary *dic in subData) {
        JYSubDataModlel *subData = [JYSubDataModlel modelWithParams:dic];
        [temp addObject:subData];
    }
    
    return [temp copy];
}

@end
