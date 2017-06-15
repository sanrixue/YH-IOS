//
//  MyQuestion.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/14.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MyQuestion.h"

@implementation MyQuestion

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"requestID":@"id",
             @"content":@"content",
             @"status":@"status",
             @"time":@"time",
             @"photos":@"photo"
             };
}

+(NSValueTransformer *)statusJSONTransformer{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) {
        return nil;
    }
    return self;
}

@end
