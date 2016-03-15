//
//  FileUtils.h
//  iContent
//
//  Created by lijunjie on 15/5/11.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//
//  说明:
//  处理File相关的代码合集.

#ifndef iContent_FileUtils_h
#define iContent_FileUtils_h

#import <UIKit/UIKit.h>
#import "const.h"

/**
 *  处理File相关的代码块合集
 */
@interface FileUtils : NSObject

+ (NSString *)basePath;
+ (NSString *)userspace;
+ (NSString *)loadingPath:(LoadingType)loadingType;
/**
 *  公共资源放在此目录下
 *
 *  @return 目录路径
 */
+ (NSString *)sharedPath;
/**
 *  传递目录名取得沙盒中的绝对路径(一级),不存在则创建，请慎用！
 *
 *  @param dirName  目录名称，不存在则创建
 *
 *  @return 沙盒中的绝对路径
 */
+ (NSString *)dirPath: (NSString *)dirName;

/**
 *  传递目录名取得沙盒中的绝对路径(一级),不存在则创建，一次性创建多层，请慎用！
 *
 *  @param dirName  目录名称，不存在则创建
 *
 *  @return 沙盒中的绝对路径
 */
+ (NSString *)dirPaths:(NSArray *)dirNames;
/**
 *  传递目录名取得沙盒中的绝对路径(二级)
 *
 *  @param dirName  目录名称，不存在则创建
 *  @param fileName 文件名称或二级目录名称
 *
 *  @return 沙盒中的绝对路径
 */
+ (NSString *)dirPath: (NSString *)dirName FileName:(NSString*) fileName;

/**
 *  检测目录路径、文件路径是否存在
 *
 *  @param pathname 沙盒中的绝对路径
 *  @param isDir    是否是文件夹类型
 *
 *  @return 布尔类型，存在即TRUE，否则为FALSE
 */
+ (BOOL) checkFileExist: (NSString*) pathname isDir: (BOOL) isDir;

/**
 *  读取配置档，有则读取。
 *  默认为NSMutableDictionary，若读取后为空，则按JSON字符串转NSMutableDictionary处理。
 *
 *  @param pathname 配置档路径
 *
 *  @return 返回配置信息NSMutableDictionary
 */
+ (NSMutableDictionary*) readConfigFile: (NSString*) pathName;



/**
 *  打印沙盒目录列表, 相当于`tree ./`， 测试时可以用到
 */
//+ (void) printDir: (NSString *)dirName;

/**
 *  物理删除文件，并返回是否删除成功的布尔值。
 *
 *  @param filePath 待删除的文件路径
 *
 *  @return 是否删除成功的布尔值
 */
+ (BOOL) removeFile:(NSString *)filePath;


/**
 *  文件体积大小转化为可读文字；
 *
 *  831106     => 811.6K
 *  8311060    =>   7.9M
 *  83110600   =>  79.3M
 *  831106000  =>  792.6M
 *
 *  @param fileSize 文件体积大小
 *
 *  @return 可读数字，保留一位小数，追加单位
 */
+ (NSString *)humanFileSize:(NSString *)fileSize;


/**
 *  NSMutableDictionary写入本地文件
 *
 *  @param data     JSON
 *  @param filePath 目标文件
 */
+ (void) writeJSON:(NSMutableDictionary *)data
              Into:(NSString *) slidePath;



/**
 *  计算指定文件路径的文件大小
 *
 *  @param filePath 文件绝对路径
 *
 *  @return 文件体积
 */
+ (NSString *)fileSize:(NSString *)filePath;
/**
 *  计算指定文件夹路径的文件体积
 *
 *  @param folderPath 文件夹路径
 *
 *  @return 文件夹体积
 */
+ (NSString *)folderSize:(NSString *)folderPath;
/**
 *  遍历文件夹文件，计算文件夹大小
 *
 *  @param basePath 文件夹
 *
 *  @return 文件夹大小
 */
+ (NSNumber *)dirFileSize:(NSString *)basePath;

+ (NSNumber *)appDocutmentSize;

/**
 *  界面切换时保存数据
 *
 *  @param dict 数据
 *  @param fileName 文件名称
 */
+ (void)shareData:(NSDictionary *)dict fileName:(NSString *)fileName;

/**
 *  @param fileName 文件名称
 */
+ (NSDictionary *)shareData:(NSString *)fileName;

@end


#endif
