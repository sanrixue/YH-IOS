//
//  SelectDataModel.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SelectDataSecondModel;
@class SelectDataThreeModel;

@interface SelectDataModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong)NSString *titles;
@property (nonatomic, strong)NSArray<SelectDataModel *> *infos;
@property (nonatomic, assign) int parentNodeID;
@property (nonatomic, assign) int nodeID;
@property (nonatomic, assign) int deep;

@end

@interface SelectDataSecondModel : NSObject

@property (nonatomic, strong)NSString *titles;
@property (nonatomic, strong)NSArray  *infos;

@end


