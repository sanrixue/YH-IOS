//
//  SelectDataModel.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SelectDataModel.h"

@implementation SelectDataModel

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"titles":@"titles",
             @"infos":@"infos",
             @"deep":@"max_deep"
             };
}

+(NSValueTransformer *)infosJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SelectDataModel class]];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) {
        return nil;
    }
    return self;
}

@end

@implementation SelectDataSecondModel

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"titles":@"titles",
             @"infos":@"infos"
             };
}

@end
