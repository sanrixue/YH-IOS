//
//  HttpUtils.h
//  iLogin
//
//  Created by lijunjie on 15/5/5.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//
//  说明:
//  处理网络相关的代码合集.

#ifndef iSearch_HttpUtils_h
#define iSearch_HttpUtils_h
@class HttpResponse;

#import <UIKit/UIKit.h>
@interface HttpUtils : NSObject
/**
 *  Http#Get功能代码封装
 *
 *  服务器响应处理:
 *  dict{HTTP_ERRORS, HTTP_RESPONSE, HTTP_RESONSE_DATA}
 *  HTTP_ERRORS: 与服务器交互中出现错误，此值不空时，不需再使用其他值
 *  HTTP_RESPONSE: 服务器响应的内容
 *  HTTP_RESPOSNE_DATA: 服务器响应内容转化为NSDictionary
 *
 *  @return Http#Get HttpResponse
 */
+ (HttpResponse *)httpGet:(NSString *)urlString header:(NSDictionary *)header timeoutInterval:(NSTimeInterval)timeoutInterval;


/**
 *  应用从服务器获取数据，设置超时时间为: 15.0秒
 *
 *  @param urlString 服务器链接
 *
 *  @return Http#Get HttpResponse
 */
+ (HttpResponse *)httpGet:(NSString *)urlString;


/**
 *  Http#Post功能代码封装
 *
 *  @param urlString URL
 *  @param Params    参数，格式param1=value1&param2=value2
 *
 *  @return Http#Post 响应内容
 */
+ (HttpResponse *)httpPost:(NSString *)urlString Params:(NSMutableDictionary *)params;

/**
 *  动态设置
 *
 *  @return 有网络则为true
 */
+ (BOOL)isNetworkAvailable:(NSTimeInterval)timeoutInterval;
+ (BOOL)isNetworkAvailable;


/**
 *  检测当前app网络环境
 *
 *  @return 有网络则为true
 */
+ (BOOL)isNetworkAvailable2;
+ (BOOL)isNetworkAvailable3;
+ (NSString *) networkType;
/**
 *  网页链接转换成本地html
 *
 *  @param urlString    网页链接
 *  @param assetsPath   本地存放位置
 *  @param writeToLocal
 *      YES: 所有js/css/img文件写到本地，html使用相对本地链接
 *      NO:  所有js/css/img链接转换为绝对路径链接
 *
 *  @return html路径
 */ 
+ (NSString *)urlConvertToLocal:(NSString *)urlString content:(NSString *)htmlContent assetsPath:(NSString *)assetsPath writeToLocal:(NSString *)writeToLocal;

/**
 *  网页链接转换为合法文件名称
 *
 *  @param url    网页链接
 *  @param suffix 文件后缀
 *
 *  @return 合法文件名称
 */
+ (NSArray *)urlTofilename:(NSString *)url suffix:(NSString *)suffix;

+ (NSString *)urlConcatHyplink:(NSString *)urlString path:(NSString *)path;
+ (BOOL) checkFileExist: (NSString*) pathname isDir: (BOOL) isDir;


+ (void)downloadAssetFile:(NSString *)urlString assetsPath:(NSString *)assetsPath;


/**
 *  清理header信息
 *
 *  @param urlString  链接
 *  @param assetsPath 缓存位置
 */
+ (void)clearHttpResponeHeader:(NSString *)urlString assetsPath:(NSString *)assetsPath;

/**
 *  http#get时header添加If-None-Match，避免表态文件重复加载
 *
 *  @param urlString  链接
 *  @param assetsPath 缓存位置
 *
 *  @return HttpResponse
 */
+ (HttpResponse *)checkResponseHeader:(NSString *)urlString assetsPath:(NSString *)assetsPath;
/**
 *  Http模拟浏览器访问
 *
 *  @return header#user-agent
 */
+ (NSString *)webViewUserAgent;

+ (void)uploadImage :(NSString *)uploadPath withImagePath:(NSString *)imagePath withImageName: (NSString *)imageName;
+ (void)downLoadFile:(NSString *)fileUrl withSavePath:(NSString *)savePath;

// 测试是否有网络

@end

#endif
