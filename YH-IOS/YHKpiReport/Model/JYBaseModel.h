//
//  JYBaseModel.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYBaseModel : NSObject

@property (nonatomic, copy) NSDictionary *params;

+ (instancetype)modelWithParams:(NSDictionary *)params;

@end
