//
//  JYModulTwoModel.h
//  各种报表
//
//  Created by niko on 17/5/21.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"
#import "JYStatementModel.h"

@interface JYModuleTwoModel : JYModuleTwoBaseModel

@property (nonatomic, strong, readonly) NSArray <JYStatementModel *> *statementModelList;
@property (nonatomic, strong, readonly) NSArray <NSString *> *statementTitleList;
@property (nonatomic, strong, readonly) NSString *title;


@end
