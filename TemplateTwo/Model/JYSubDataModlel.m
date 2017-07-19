//
//  JYSubDataModlel.m
//  各种报表
//
//  Created by niko on 17/5/15.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYSubDataModlel.h"
#import "JYMainDataModel.h"

@implementation JYSubDataModlel

- (JYMainDataModel *)mainDataModel {
    if (!_mainDataModel) {
        _mainDataModel = [JYMainDataModel modelWithParams:self.params];
    }
    return _mainDataModel;
}

@end
