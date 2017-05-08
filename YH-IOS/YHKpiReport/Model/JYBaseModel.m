//
//  JYBaseModel.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseModel.h"

@implementation JYBaseModel

+ (instancetype)modelWithParams:(NSDictionary *)params {
    
    JYBaseModel *model = [[self alloc] init];
    if (model) {
        model.params = params;
    }
    return model;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> \n%@", [self class], &self, self.params];
}

@end
