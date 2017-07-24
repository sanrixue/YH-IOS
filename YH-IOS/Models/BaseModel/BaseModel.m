//
//  BaseModel.m
//  iSearch
//
//  Created by lijunjie on 15/6/27.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "BaseModel.h"


@implementation BaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"identifier":@"id"
             };
}

+ (BOOL)handleResult:(id)model{
    if (model && [model isKindOfClass:[BaseModel class]]) {
        BaseModel* base = model;
        if ([base.code isEqualToString:@"200"]) {
            return YES;
        }else{
            // to do show hud message
            
            DLog(@"message ===  %@",base.message);
            return NO;
        }
    }
    return NO;
}

- (BOOL)isNoMore{
    if (self.total_page == self.curr_page) {
        return YES;
    }
    return NO;
}

- (NSString *)to_s:(BOOL)isFormat {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    NSString *pName, *pValue;
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        pName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        pValue = [self valueForKey:pName];
        [keys addObject:[NSString stringWithFormat:@"%@: %@", pName,pValue]];
    }
    free(properties);
    
    NSString *joinStr = [keys componentsJoinedByString:(isFormat ? @",\n" : @",")];
    NSString *output = [NSString stringWithFormat:@"#<%@ %@>", self.class, joinStr];
    return output;
}

- (NSString *)to_s {
    return [self to_s:NO];
}

- (NSString *)inspect {
    return [self to_s];
}

- (NSDictionary *)mapPropertiesToDictionary {
    // 用以存储属性（key）及其值（value）
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    // 获取当前类对象类型
    Class cls = [self class];
    // 获取类对象的成员变量列表，ivarsCount为成员个数
    uint ivarsCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarsCount);
    // 遍历成员变量列表，其中每个变量为Ivar类型的结构体
    const Ivar *ivarsEnd = ivars + ivarsCount;
    for (const Ivar *ivarsBegin = ivars; ivarsBegin < ivarsEnd; ivarsBegin++) {
        Ivar const ivar = *ivarsBegin;
        //　获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        /*
         若此变量声明为属性，则变量名带下划线前缀'_'
         比如 @property (nonatomic, copy) NSString *name;则 key = _name;
         为方便查看属性变量，在此特殊处理掉下划线前缀
         */
        if ([key hasPrefix:@"_"]) key = [key substringFromIndex:1];
        //　获取变量值
        id value = [self valueForKey:key];
        // 处理属性未赋值属性，将其转换为null，若为nil，插入将导致程序异常
        [dictionary setObject:value ? value : [NSNull null]
                       forKey:key];
    }
    return dictionary;
}
- (NSString *)description {
    NSMutableString *str = [NSMutableString string];
    // NSString *className = NSStringFromClass([self class]);
    NSDictionary *dic = [self mapPropertiesToDictionary];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"%@ = %@\n", key, obj];
    }];
    return str;
}

@end
