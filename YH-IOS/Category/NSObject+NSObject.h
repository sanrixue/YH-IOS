//
//  NSObject+NSObject.h
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject)
/**
 根据key在数组冒泡排序,return为copy的

 @param array   数组
 @param keyPath 属性名
 @param down    是否降序列

 @return return value description
 */
+ (NSMutableArray*)sortArray:(NSArray*)array
                  key:(NSString*)keyPath
                 down:(BOOL)down; 
/**
 给数组元素制定下标对象的某个属性赋值

 @param value         设置的值
 @param keyPath       属性名
 @param deafaultValue 默认值
 @param index         下标
 @param array         数组
 */
+ (void)setValue:(id)value
         keyPath:(NSString*)keyPath
   deafaultValue:(id)deafaultValue
           index:(NSInteger)index
         inArray:(NSArray*)array;
/**
 从数组中返回属性值为value的对象,只支持基本类型和string类型

 @param array   数组
 @param keyPath 属性名
 @param value   值

 @return 对象
 */
+ (id)getObjectInArray:(NSArray*)array
               keyPath:(NSString*)keyPath
            equalValue:(id)value;

/**
 是否全部对象值都等于value

 @param value   值
 @param array   对象数组
 @param keyPath 属性名

 @return 是否
 */
+ (BOOL)isAllObjcEqualValue:(id)value
               array:(NSArray*)array
             keyPath:(NSString*)keyPath;

@end
