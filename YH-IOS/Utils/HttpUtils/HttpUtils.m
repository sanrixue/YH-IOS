//
//  HttpUtils.m
//  iLogin
//
//  Created by lijunjie on 15/5/5.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"
#import "HttpUtils.h"
#import "const.h"
#import "HttpResponse.h"
#import <UIKit/UIKit.h>
#import "ExtendNSLogFunctionality.h"
#import "Reachability.h"
#import "TFHpple.h"

@interface HttpUtils()

@end

@implementation HttpUtils


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
+ (HttpResponse *)httpGet:(NSString *)urlString timeoutInterval:(NSTimeInterval)timeoutInterval {
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    HttpResponse *httpResponse = [[HttpResponse alloc] init];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:timeoutInterval];
    NSError *error;
    NSURLResponse *response;
    httpResponse.received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    httpResponse.response = (NSHTTPURLResponse*)response;
    BOOL isOK   = NSErrorPrint(error, @"Http#get %@", urlString);
    if(!isOK) {
        [httpResponse.errors addObject:(NSString *)psd([error localizedDescription], @"http get未知错误")];
    }

    return httpResponse;
}


/**
 *  应用从服务器获取数据，设置超时时间为: 15.0秒
 *
 *  @param urlString 服务器链接
 *
 *  @return Http#Get HttpResponse
 */
+ (HttpResponse *)httpGet:(NSString *)urlString {
    return [HttpUtils httpGet:urlString timeoutInterval:15.0];
}

/**
 *  Http#Post功能代码封装
 *  application/x-www-form-urlencoded
 *
 *  @param urlString URL
 *  @param Params    参数，格式param1=value1&param2=value2
 *
 *  @return Http#Post 响应内容
 */
+ (HttpResponse *)httpPost:(NSString *)urlString Params:(NSMutableDictionary *)params {
    urlString  = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    //params     = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:3.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    [request setHTTPBody:tempJsonData];
    
    NSURLResponse *response;
    HttpResponse *httpResponse = [[HttpResponse alloc] init];
    httpResponse.received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    httpResponse.response = (NSHTTPURLResponse *)response;
    BOOL isOK   = NSErrorPrint(error, @"Http#post %@", urlString);
    if(!isOK) {
        [httpResponse.errors addObject:(NSString *)psd([error localizedDescription], @"http get未知错误")];
    }


    return httpResponse;
}

/**
 *  动态设置
 *
 *  @return 有网络则为true
 */
+ (BOOL)isNetworkAvailable {
    return [self isNetworkAvailable:2.0];
}

+ (BOOL)isNetworkAvailable:(NSTimeInterval)timeoutInterval {
    // @"http://www.apple.com"
    HttpResponse *httpResponse = [HttpUtils httpGet:BASE_URL timeoutInterval:timeoutInterval];
    
    return (httpResponse.statusCode && ([httpResponse.statusCode intValue] == 200));
}

/**
 *  检测当前app网络环境
 *
 *  @return 有网络则为true
 */
+ (BOOL) isNetworkAvailable2 {
    BOOL isExistenceNetwork = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    
    return isExistenceNetwork;
}
/**
 *  有网络环境时的网络类型
 *
 *  @return 网络类型字符串
 */
+ (NSString *)networkType {
    NSString *_netWorkType = @"无";
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            break;
        case ReachableViaWiFi:
            _netWorkType = @"wifi";
            break;
        case ReachableViaWWAN:
            _netWorkType = @"3g";
            break;
    }
    
    return _netWorkType;
}

+ (NSString*)HttpRquest:(NSString *)urlString {
    
    NSLog(@"%@", urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSMutableString *result = [[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    return result;
}

/**
 *  网页链接转换成本地html
 *
 *  @param urlString  网页链接
 *  @param assetsPath 本地存放位置
 *
 *  @return html路径
 */
+ (NSString *)urlConvertToLocal:(NSString *)urlString assetsPath:(NSString *)assetsPath {
    
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString *htmlContent = [self HttpRquest:urlString];
    NSString *filename, *filepath;
    
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    // <script src="../*.js"></script>
    NSArray *elements = [doc searchWithXPathQuery:@"//script"];
    NSString *tagUrl, *tagContent;
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && [dict[@"src"] length] > 0) {
            if([dict[@"src"] hasPrefix:@"http://"] || [dict[@"src"] hasPrefix:@"https://"]) {
                NSLog(@"yes: %@", dict[@"src"]);
                tagUrl = dict[@"src"];
            }
            else {
                NSLog(@"no: %@", dict[@"src"]);
                tagUrl = [self urlConcatHyplink:urlString path:dict[@"src"]];
            }
            
            filename = [self urlTofilename:[tagUrl lastPathComponent] suffix:@".js"];
            
            filepath = [assetsPath stringByAppendingPathComponent:filename];
            if(![self checkFileExist:filepath isDir:NO]) {
                tagContent = [self HttpRquest:tagUrl];
                [tagContent writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            }
            htmlContent = [htmlContent stringByReplacingOccurrencesOfString:dict[@"src"] withString:filename];
        }
    }
    
    // <link href="../*.css">
    elements = [doc searchWithXPathQuery:@"//link"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && [dict[@"type"] isEqualToString:@"text/css"] && dict[@"href"]) {
            if([dict[@"href"] hasPrefix:@"http://"] || [dict[@"href"] hasPrefix:@"https://"]) {
                NSLog(@"yes: %@", dict[@"href"]);
                tagUrl = dict[@"href"];
            }
            else {
                NSLog(@"no: %@", dict[@"href"]);
                tagUrl = [self urlConcatHyplink:urlString path:dict[@"href"]];
            }
            
            filename = [self urlTofilename:[tagUrl lastPathComponent] suffix:@".css"];
            filepath = [htmlContent stringByAppendingPathComponent:filename];
            if(![self checkFileExist:filepath isDir:NO]) {
                tagContent = [self HttpRquest:tagUrl];
                [tagContent writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            }
            htmlContent = [htmlContent stringByReplacingOccurrencesOfString:dict[@"href"] withString:filename];
        }
    }
    
    // <img src="../*.png">
    elements = [doc searchWithXPathQuery:@"//img"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"src"] && [dict[@"src"] length] > 0) {
            if([dict[@"src"] hasPrefix:@"http://"] || [dict[@"src"] hasPrefix:@"https://"]) {
                NSLog(@"yes: %@", dict[@"src"]);
                tagUrl = dict[@"src"];
            }
            else {
                NSLog(@"no: %@", dict[@"src"]);
                tagUrl = [self urlConcatHyplink:urlString path:dict[@"src"]];
            }
            
            filename = [self urlTofilename:[tagUrl lastPathComponent] suffix:[NSString stringWithFormat:@".%@", [tagUrl pathExtension]]];
            filepath = [assetsPath stringByAppendingPathComponent:filename];
            if(![self checkFileExist:filepath isDir:NO]) {
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tagUrl]];
                [imageData writeToFile:filepath atomically:YES];
            }
            htmlContent = [htmlContent stringByReplacingOccurrencesOfString:dict[@"src"] withString:filename];
        }
    }
    
     //<a href="../.."></a>
    NSMutableArray *links = [NSMutableArray array];
    elements = [doc searchWithXPathQuery:@"//a"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"href"] && [dict[@"href"] length] > 0) {
            if([dict[@"href"] hasPrefix:@"http://"] || [dict[@"href"] hasPrefix:@"https://"]) {
                // nothind to do
            }
            else {
                if(![links containsObject:dict[@"href"]]) {
                    [links addObject:dict[@"href"]];
                }
            }
        }
    }
    for(NSString *href in links) {
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:href withString:[self urlConcatHyplink:urlString path:href]];
    }
    
    filename = [self urlTofilename:[url.pathComponents componentsJoinedByString:@"/"] suffix:@".html"];
    filepath = [assetsPath stringByAppendingPathComponent:filename];
    [htmlContent writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    return filepath;
}
/**
 *  网页链接转换为合法文件名称
 *
 *  @param url    网页链接
 *  @param suffix 文件后缀
 *
 *  @return 合法文件名称
 */
+ (NSString *)urlTofilename:(NSString *)url suffix:(NSString *)suffix {
    for(NSString *str in @[@".", @":", @"/", @"?"]) {
        url = [url stringByReplacingOccurrencesOfString:str withString:@"_"];
    }
    if(![url hasSuffix:suffix]) {
        url = [NSString stringWithFormat:@"%@%@", url, suffix];
    }
    return url;
}

+ (NSString *)urlConcatHyplink:(NSString *)urlString path:(NSString *)path {
    
    if([path hasPrefix:@"/"]) {
        NSURL *url = [NSURL URLWithString:urlString];
        urlString = [urlString stringByReplacingOccurrencesOfString:url.relativePath withString:path];
    }
    else {
        urlString = [NSString stringWithFormat:@"%@/../%@", urlString, path];
    }
    return urlString;
}

+ (BOOL) checkFileExist: (NSString*) pathname isDir: (BOOL) isDir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:pathname isDirectory:&isDir];
    return isExist;
}
@end