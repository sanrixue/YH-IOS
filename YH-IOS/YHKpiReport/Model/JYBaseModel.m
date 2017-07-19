//
//  JYBaseModel.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseModel.h"

@implementation JYBaseModel

+ (instancetype)modelWithParams:(id)params {
    
    JYBaseModel *model = [[self alloc] init];
    if (model) {
        model.params = [model safeObject:params];
    }
    return model;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>\n%@", [self class], &self, self.params];
}

- (id)safeObject:(id)obj {
    id safeObj;
    if ([obj isKindOfClass:[NSArray class]]) {
        safeObj = [self safeArray:obj];
    }
    else if ([obj isKindOfClass:[NSDictionary class]]) {
        safeObj = [self safeDictionary:obj];
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        safeObj = [self safeString:obj];
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        safeObj = [self safeNumber:obj];
    }
    else if ([obj isKindOfClass:[NSData class]]) {
        safeObj = [self safeData:obj];
    }
    else if ([obj isKindOfClass:[NSDate class]]) {
        safeObj = [self safeDate:obj];
    }
    else if ([obj isKindOfClass:[NSNull class]]) {
        safeObj = @"";
    }
    
    
    return safeObj;
}

- (NSDictionary *)safeDictionary:(id)obj {
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:((NSDictionary *)obj).count];
    for (NSString *key in [(NSDictionary *)obj allKeys]) {
        id safeObj = [self safeObject:[(NSDictionary *)obj objectForKey:key]];
        [temp setObject:safeObj forKey:key];
    }
    
    return [temp copy];
}

- (NSArray *)safeArray:(id)obj {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:((NSArray *)obj).count];
    for (id tempObj in (NSArray *)obj) {
        id safeObj = [self safeObject:tempObj];
        [temp addObject:safeObj];
    }
    
    return [temp copy];
}


/************************************************************************************************
 一下基本类型的对象如果写成nil，那么数组的长度可能发生变化;
 默认取最小值
 */
- (NSString *)safeString:(id)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        obj = @"";
    }
    return obj;
}

- (NSNumber *)safeNumber:(id)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        obj = @(NSNotFound);
    }
    return obj;
}

- (NSData *)safeData:(id)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        obj = [NSData data];
    }
    return obj;
}

- (NSDate *)safeDate:(id)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        obj = [NSDate date];
    }
    return obj;
}

- (BOOL)safeBool:(id)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        obj = @(0);
    }
    return obj;
}


- (UIColor *)arrowToColor {
    
    return [[self class] arrowToColor:self.arrow];
}

+ (UIColor *)arrowToColor:(TrendTypeArrow)arrow {
    UIColor *color;
    
    switch (arrow) {
        case TrendTypeArrowUpRed:
        case TrendTypeArrowDownRed:
            color = JYColor_ArrowColor_Red;
            break;
            
        case TrendTypeArrowUpGreen:
        case TrendTypeArrowDownGreen:
            color = JYColor_ArrowColor_Green;
            break;
            
        case TrendTypeArrowUpYellow:
        case TrendTypeArrowDownYellow:
            color = JYColor_ArrowColor_Yellow;
            break;
            
        case TrendTypeArrowNoArrow:
            color = JYColor_ArrowColor_Unkown;
            break;
            
        default:
            color = [UIColor lightGrayColor]; // 灰色表示未定义
            break;
    }
    
    return color;
}


@end
