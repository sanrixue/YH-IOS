//
//  JYExcelModel.h
//  各种报表
//
//  Created by niko on 17/5/15.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"
#include "JYSheetModel.h"

@interface JYExcelModel : JYModuleTwoBaseModel

@property (nonatomic, strong, readonly) NSArray <NSDictionary *> *excelConfig;
@property (nonatomic, strong, readonly) NSArray *sheetNames;
@property (nonatomic, strong) NSArray <JYSheetModel *> *sheetList;



@end
