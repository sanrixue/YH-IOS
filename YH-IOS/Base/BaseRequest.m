//
//  BaseRequest.m
//  Chart
//
//  Created by CJG on 16/7/18.
//  Copyright © 2016年 ice. All rights reserved.
//

#import "BaseRequest.h"
#import <MJExtension/MJExtension.h>
#import "AFNetworking.h"
#import "NSDate+Category.h"

#define CurAfnManager [BaseRequest afnManager]

@interface BaseRequest()

@end

@implementation BaseRequest

+ (NSString *)getJsonStringWithDic:(NSDictionary *)data{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+(AFHTTPSessionManager *)afnManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/plain",@"multipart/form-data",@"application/vnd.goa.error",nil];
//
//    {
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"wuyouwei" ofType:@"cer"];
//        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
//        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        // 是否允许,NO-- 不允许无效的证书
//        [securityPolicy setAllowInvalidCertificates:YES];
//        // 设置证书
//        [securityPolicy setPinnedCertificates:certSet];
//        manager.securityPolicy = securityPolicy;
//
//    }
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];//manager.requestSerializer; //[AFJSONRequestSerializer serializer];
    NSDictionary *headerFieldValueDictionary = @{
                                                 @"skip-sign":@"1",
                                                 @"version":@"v1",
                                                 @"time": [NSString stringWithFormat:@"%zd",[NSDate date].timeIntervalSince1970],
                                                 };
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }

    manager.requestSerializer = requestSerializer;
    return manager;
}

+ (void)netWorkStatus:(void (^)(NetWorkStatus))ret{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    ret(NetWorkStatusUnknown);
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    ret(NetWorkStatusNotReachable);
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    ret(NetWorkStatusReachableViaWWAN);
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    ret(NetWorkStatusReachableViaWiFi);
                    break;
                default:
                    break;
            }
    }];
    
}
//* post请求 
+ (void)postRequestWithUrl:(NSString *)url Params:(NSDictionary *)params needHandle:(BOOL)needHandle requestBack:(RequestBack)requestBack{

    DLog(@"\n请求url*****************************************\n%@\n请求参数*************************************\n%@",url,params);
    [CurAfnManager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *jsonStr = nil;
        if (responseObject) {
            jsonStr = ((NSDictionary*)responseObject).mj_JSONString;
        }
        DLog(@"\n url = %@ \n请求结果******************************************\n%@",url,jsonStr);
        requestBack(YES, responseObject, jsonStr);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSError *underError = error.userInfo[@"NSUnderlyingError"];
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"\n请求失败************************************************\n%@",errorStr);
        requestBack(NO, nil, nil);
//        if (needHandle) {
//            [self handelRequestSuccess:NO successBack:nil];
//        }else{
//            requestBack(NO, nil, nil);
//        }

    }];
//    [CurAfnManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *jsonStr = nil;
//        if (responseObject) {
//            jsonStr = ((NSDictionary*)responseObject).mj_JSONString;
//        }
//        DLog(@"\n url = %@ \n请求结果******************************************\n%@",url,jsonStr);
//        requestBack(YES, responseObject, jsonStr);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSError *underError = error.userInfo[@"NSUnderlyingError"];
//        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        DLog(@"\n请求失败************************************************\n%@",errorStr);
//        if (needHandle) {
//            [self handelRequestSuccess:NO successBack:nil];
//        }else{
//            requestBack(NO, nil, nil);
//        }
//    }];
}
//* get请求
+ (void)getRequestWithUrl:(NSString *)url Params:(NSDictionary *)params needHandle:(BOOL)needHandle requestBack:(RequestBack)requestBack{
    DLog(@"\n请求url*****************************************\n%@\n请求参数*************************************\n%@",url,params);
    [CurAfnManager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *jsonStr = nil;
        if (responseObject) {
            jsonStr = ((NSDictionary*)responseObject).mj_JSONString;
        }
        DLog(@"\n请求结果******************************************\n%@",jsonStr);
        requestBack(YES, responseObject, jsonStr);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"\n请求失败************************************************\n%@",errorStr);
         requestBack(NO, nil, nil);
//        if (needHandle) {
//            [self handelRequestSuccess:NO successBack:nil];
//        }else{
//            requestBack(NO, nil, nil);
//        }
    }];
//    [CurAfnManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DLog(@"\n请求结果******************************************\n%@",responseObject);
//        NSString *jsonStr = nil;
//        if (responseObject) {
//            jsonStr = ((NSDictionary*)responseObject).mj_JSONString;
//        }
//        requestBack(YES, responseObject, jsonStr);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        DLog(@"\n请求失败************************************************\n%@",errorStr);        if (needHandle) {
//            [self handelRequestSuccess:NO successBack:nil];
//        }else{
//            requestBack(NO, nil, nil);
//        }
//    }];
}
//
//+ (void)upLoadWithUrl:(NSString *)url Params:(NSDictionary *)params FormData:(void (^)(id))formDataRet Progress:(void (^)(NSProgress *))progress Success:(void (^)(id))success Failed:(void (^)(NSError *))failed{
//    DLog(@"\n请求url*****************************************\n%@\n请求参数*************************************\n%@",url,params);
//    [CurAfnManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        if (formDataRet) {
//            formDataRet(formData);
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        DLog(@"\n请求进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DLog(@"\n请求结果******************************************\n%@",responseObject);
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        DLog(@"\n请求失败************************************************\n%@",errorStr);
//        if (failed) {
//            failed(error);
//        }
//    }];
//}

+ (void)putRequestWithUrl:(NSString *)url Params:(NSDictionary *)params needHandle:(BOOL)needHandle requestBack:(RequestBack)requestBack{
    DLog(@"\n请求url*****************************************\n%@\n请求参数*************************************\n%@",url,params);
    [CurAfnManager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = nil;
        if (responseObject) {
            jsonStr = ((NSDictionary*)responseObject).mj_JSONString;
        }
        DLog(@"\n url = %@ \n请求结果******************************************\n%@",url,jsonStr);
        requestBack(YES, responseObject, jsonStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"\n请求失败************************************************\n%@",errorStr);
                if (needHandle) {
                    [self handelRequestSuccess:NO successBack:nil];
                }else{
        requestBack(NO, nil, nil);
                }
    }];
}
 
+ (void)handelRequestSuccess:(BOOL)success successBack:(void (^)())ret{
//    if (success) {
//        if (ret) {
//            ret();
//        }
//    }else{
//        [GUATool hideAllGifImageHUD];
//    }
}

@end
