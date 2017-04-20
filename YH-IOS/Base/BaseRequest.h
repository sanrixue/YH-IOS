//
//  BaseRequest.h
//  Chart
//
//  Created by CJG on 16/7/18.
//  Copyright © 2016年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@protocol AFMultipartFormData;

typedef NS_ENUM(NSInteger, NetWorkStatus) {
    NetWorkStatusUnknown          = -1,  // 未知
    NetWorkStatusNotReachable     = 0,   // 无连接
    NetWorkStatusReachableViaWWAN = 1,   // 3G
    NetWorkStatusReachableViaWiFi = 2,   // WiFi
};

typedef void(^RequestBack)(BOOL requestSuccess, id response, NSString* responseJson);

@interface BaseRequest : NSObject

+ (AFHTTPSessionManager *)afnManager;
/** 字典转json字符串 */
+ (NSString *)getJsonStringWithDic:(NSDictionary *)data;

/** 检查网络状态 */
+ (void)netWorkStatus:(void(^)(NetWorkStatus))ret;

/** 上传数据 */
+ (void)upLoadWithUrl:(NSString*)url
               Params:(NSDictionary*)params
             FormData:(void (^)(id<AFMultipartFormData> formData))formDataRet
             Progress:(void(^)(NSProgress* progress))progress
              Success:(void(^)(id response))success
               Failed:(void(^)(NSError *error))failed;

/** Post请求 */
+ (void)postRequestWithUrl:(NSString*)url
                    Params:(NSDictionary*)params
                needHandle:(BOOL)needHandle
               requestBack:(RequestBack)requestBack;

/** Put请求 */
+ (void)putRequestWithUrl:(NSString*)url
                    Params:(NSDictionary*)params
                needHandle:(BOOL)needHandle
               requestBack:(RequestBack)requestBack;

/** GET请求 */
+ (void)getRequestWithUrl:(NSString*)url
                   Params:(NSDictionary*)params
               needHandle:(BOOL)needHandle
              requestBack:(RequestBack)requestBack;

/** 处理请求失败成功的统一方法 */
+ (void)handelRequestSuccess:(BOOL)success
                 successBack:(void(^)())ret;

@end
