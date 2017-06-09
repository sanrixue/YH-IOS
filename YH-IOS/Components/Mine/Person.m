//
//  Person.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "Person.h"

@implementation Person

+(NSDictionary*)JSONKeyPathsByPropertyKey {
   return  @{
       @"userNamer":@"user_name",
       @"userRole":@"role",
       @"groupId":@"group",
       @"lastlocation":@"location",
       @"time":@"time",
       @"days":@"days",
       @"readed_num":@"readed_num",
       @"precent":@"percent",
       @"icon":@"icon"
       };
}

+(NSValueTransformer *)iconJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) {
        return nil;
    }
    return self;
}


@end
