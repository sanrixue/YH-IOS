//
//  JYMainDataModel.h
//  各种报表
//
//  Created by niko on 17/5/15.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"

@class JYSubDataModlel;

@interface JYMainDataModel : JYModuleTwoBaseModel


@property (nonatomic, strong, readonly) NSArray *dataList;
@property (nonatomic, strong) NSArray <JYSubDataModlel *> *subDataList;


@end
