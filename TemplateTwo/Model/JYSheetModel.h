//
//  JYSheetModel.h
//  各种报表
//
//  Created by niko on 17/5/15.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"
#import "JYMainDataModel.h"

@interface JYSheetModel : JYModuleTwoBaseModel

@property (nonatomic, copy) NSString *sheetTitle;
@property (nonatomic, strong, readonly) NSArray <NSString *> *headNames;
@property (nonatomic, strong) NSArray <JYMainDataModel *> *mainDataModelList;

- (void)sortMainDataListWithSection:(NSInteger)section ascending:(BOOL)ascending;


@end
