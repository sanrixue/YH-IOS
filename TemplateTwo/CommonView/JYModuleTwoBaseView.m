//
//  JYModuleTwoBaseView.m
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseView.h"

@implementation JYModuleTwoBaseView


- (void)setModuleModel:(JYModuleTwoBaseModel *)moduleModel {
    if (![_moduleModel isEqual:moduleModel]) {
        _moduleModel = moduleModel;
        [self refreshSubViewData];
    }
}


- (void)refreshSubViewData {
    
}



- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    return 200.0;
}

@end
