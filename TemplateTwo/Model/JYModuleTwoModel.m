//
//  JYModulTwoModel.m
//  各种报表
//
//  Created by niko on 17/5/21.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoModel.h"

@implementation JYModuleTwoModel

- (NSArray<JYStatementModel *> *)statementModelList {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.params[@"data"]) {
        JYStatementModel *model = [JYStatementModel modelWithParams:dic];
        [array addObject:model];
    }
    return [array copy];
}

- (NSArray<NSString *> *)statementTitleList {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.params[@"data"]) {
        [array addObject:[dic objectForKey:@"title"]];
    }
    return [array copy];
}


- (NSString *)title {
    return self.params[@"name"];
}

@end
