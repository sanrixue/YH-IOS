//
//  YHKPIModel.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/22.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHKPIModel.h"

@implementation YHKPIModel

+(NSDictionary*)JSONKeyPathsByPropertyKey{
    return @{
             @"group_name":@"group_name",
             @"data":@"data"
             };
}

+(NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:YHKPIDetailModel.class];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) {
        return nil;
    }
    return self;
}


@end


@implementation YHKPIDetailModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
              @"dashboardType":@"dashboard_type",
              @"title":@"title",
              @"unit":@"unit",
              @"targeturl":@"target_url",
              @"stick":@"is_stick",
              @"memo1":@"memo1",
              @"memo2":@"memo2",
              @"chartData":@"data.chart_data",
              @"hightLightData":@"data.high_light"
             };
}

+(NSValueTransformer *)dashboardTypeJSONTransformer{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"bar":@(DashBoardTypeBar1),
                                                                           @"line":@(DashBoardTypeLine1),
                                                                           @"number":@(DashBoardTypeNumber1),
                                                                           @"ring":@(DashBoardTypeRing1),
                                                                           @"number2":@(DashBoardTypeSignleValue1),
                                                                           @"number3":@(DashBoardTypeSignleLongValue1),
                                                                           @"number1":@(DashBoardTypeNumer11)
                                                                           }];
}

+(NSValueTransformer *)stickJSONTransformer{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+(NSValueTransformer *)hightLightDataJSONTransformer{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:YHKPIDetailDataModel.class];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) {
        return nil;
    }
    return self;
}

-(UIColor *)getMainColor{
    NSArray *colorArray = @[@"#ff0000",@"#f39800",@"#6aa657",@"#ff0000",@"#f39800",@"#6aa657"];
    UIColor *color;
    if (self.hightLightData.arrow >= 0) {
      color =  [UIColor colorWithHexString:colorArray[self.hightLightData.arrow]];
    }
    return color;
}

@end


@implementation YHKPIDetailDataModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"percentage":@"percentage",
             @"number":@"number",
             @"compare":@"compare",
             @"arrow":@"arrow",
             };
}

+(NSValueTransformer *)percentageJSONTransformer{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

@end
