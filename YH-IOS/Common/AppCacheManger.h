//
//  AppCacheManger.h
//  Chart
//
//  Created by CJG on 16/8/5.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCacheManger : NSObject
/** 获取沙盒路径 */
+ (NSString*)getCachesPath;

+ (float)getCacheSize;

+ (void)cleanCache:(void(^)())finish;

/** 保存图片到沙盒 成功返回YES*/
+ (BOOL)saveImage:(UIImage*)image name:(NSString*)name;

@end
