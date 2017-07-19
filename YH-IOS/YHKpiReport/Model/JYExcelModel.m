//
//  JYExcelModel.m
//  各种报表
//
//  Created by niko on 17/5/15.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYExcelModel.h"

@implementation JYExcelModel

- (NSArray<NSDictionary *> *)excelConfig {
    return self.params[@"config"];
}

- (NSArray *)sheetNames {
    NSMutableArray *sheets = [NSMutableArray arrayWithCapacity:[self.excelConfig count]];
    for (int i = 0; i < [self.excelConfig count]; i++) {
        [sheets addObject:(self.excelConfig[i][@"title"])];
    }
    return sheets;
}

- (NSArray<JYSheetModel *> *)sheetList {
    if (!_sheetList) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.excelConfig.count];
        for (NSDictionary *dic in self.excelConfig) {
            JYSheetModel *sheetModel = [JYSheetModel modelWithParams:dic[@"table"]];
            sheetModel.sheetTitle = dic[@"title"];
            [temp addObject:sheetModel];
        }
        _sheetList = [temp copy];
    }
    return _sheetList;
}


@end
