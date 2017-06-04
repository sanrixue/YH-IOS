//
//  NSObject+NSObject.m
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "NSObject+NSObject.h"

@implementation NSObject (NSObject)

+ (NSMutableArray *)sortArray:(NSArray *)array key:(NSString *)keyPath down:(BOOL)down{
    NSMutableArray *sortArr = [NSMutableArray arrayWithArray:array];
    for (int i=0 ; i<sortArr.count; i++) {
        for (int j = 0; j < sortArr.count-1; j++) {
            
              NSNumber* value1 = [sortArr[j] valueForKeyPath:keyPath];
              NSNumber* value2 = [sortArr[j+1] valueForKeyPath:keyPath];
            
            if ([value1 isKindOfClass:[NSString class]]) {
                value1 = [(NSString*)value1 removeString:@","];
                value1 = [(NSString*)value1 removeString:@"%"];
               // value1 = [(NSString*)value1 removeString:@"-"];
                value2 = [(NSString*)value2 removeString:@","];
                value2 = [(NSString*)value2 removeString:@"%"];
              //  value2 = [(NSString*)value2 removeString:@"-"];
                if (down) {
                    if (((NSString*)value1).floatValue<((NSString*)value2).floatValue) {
                        [sortArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                    }
                }else{
                    if (((NSString*)value1).floatValue>((NSString*)value2).floatValue) {
                        [sortArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                    }
                }
                
            }else{
                if (down) {
                    if (value1.doubleValue<value2.doubleValue) {
                        [sortArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                    }
                }else{
                    if (value1.doubleValue>value2.doubleValue) {
                        [sortArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                    }
                }
            }
        }
    }
    return sortArr;
}

+ (void)setValue:(id)value keyPath:(NSString *)keyPath deafaultValue:(id)deafaultValue index:(NSInteger)index inArray:(NSArray *)array{
    if (index<array.count && index>=0) {
        for (int i=0; i<array.count; i++) {
            id model = array[i];
            [model setValue:i==index?value:deafaultValue forKeyPath:keyPath];
        }
    }
}

+ (id)getObjectInArray:(NSArray *)array keyPath:(NSString *)keyPath equalValue:(id)value{
    for (int i=0; i<array.count; i++) {
        id objc = array[i];
        id objcValue = [objc valueForKeyPath:keyPath];
        if ([objcValue isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
            if ([objcValue isEqualToString:value]) {
                return objc;
            }
        }
        if (objcValue == value && value!=nil) {
            return objc;
        }
    }
    return nil;
}

/**
 是否全部对象值都等于value
 
 @param value   值
 @param array   对象数组
 @param keyPath 属性名
 
 @return 是否
 */
+ (BOOL)isAllObjcEqualValue:(id)value
                      array:(NSArray*)array
                    keyPath:(NSString*)keyPath{
    if (!array.count) {
        DLog(@"是一个空数组  方法:%s",__func__);
        return NO;
    }
    for (id objc in array) {
        id objcValue = [objc valueForKeyPath:keyPath];
        if ([objcValue isKindOfClass:[NSString class]]) {
            if (![value isEqualToString:objc]) {
                return NO;
            }
        }else{
            if (((NSNumber*)value).doubleValue != ((NSNumber*)objcValue).doubleValue) {
                return NO;
            }
        }
    }
    return YES;
}

@end
