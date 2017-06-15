//
//  Notice.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MessageNotice.h"

@implementation MessageNotice

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"title",
             @"abstracts":@"abstracts",
             @"time":@"time",
             @"content":@"content",
             @"noticeID":@"id",
             @"noticeType":@"type",
             @"see":@"see"
             };
}

+(NSValueTransformer *)seeJSONTransformer {
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
