//
//  ListPage.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/16.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ListPage.h"


@class ListItem;
@class ListPage;
@implementation ListPageList

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"category":@"category",
             @"listpage":@"data"
             };
}

+(NSValueTransformer *)listpageJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ListPage class]];
}



-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) {
        return nil;
    }
    return self;
}

@end

@implementation ListPage

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"group_name":@"group_name",
             @"listData":@"data"
             };
}


+(NSValueTransformer *)listDataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ListItem class]];
}

@end

@implementation ListItem

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemID":@"id",
             @"listName":@"name",
             @"linkPath":@"link_path",
             @"icon_link":@"icon_link",
             @"group_id":@"group_id",
             @"icon":@"icon",
             @"health_value":@"health_value",
           //  @"group_order":@"group_order",
           //  @"item_order":@"item_order",
             @"created_at":@"created_at"
             };
}



@end
