//
//  JYSubDataModlel.h
//  各种报表
//
//  Created by niko on 17/5/15.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"

@class JYMainDataModel;

@interface JYSubDataModlel : JYModuleTwoBaseModel

@property (nonatomic, strong) JYMainDataModel *mainDataModel;

@end
