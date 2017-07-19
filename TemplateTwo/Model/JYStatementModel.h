//
//  JYStatementModel.h
//  各种报表
//
//  Created by niko on 17/5/21.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"

@interface JYStatementModel : JYModuleTwoBaseModel

@property (nonatomic, strong, readonly) NSArray *statementTitle;
@property (nonatomic, strong) NSArray <JYModuleTwoBaseModel *> *viewModelList;

@end
