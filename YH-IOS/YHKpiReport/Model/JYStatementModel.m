//
//  JYStatementModel.m
//  各种报表
//
//  Created by niko on 17/5/21.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYStatementModel.h"

@interface JYStatementModel () {
    
}


@end

@implementation JYStatementModel

- (NSArray<JYModuleTwoBaseModel *> *)viewModelList {
    // 数据准备
    if (!_viewModelList) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in self.params[@"parts"]) {
            
            JYModuleTwoBaseModel *viewModule = [JYModuleTwoBaseModel moduleTwoBaseModelWithParams:dic];
            [arr addObject:viewModule];
        }
        _viewModelList = [arr copy];
    }
    return _viewModelList;
}

- (NSArray *)statementTitle {
    return [self.params objectForKey:@"title"];
}

@end
