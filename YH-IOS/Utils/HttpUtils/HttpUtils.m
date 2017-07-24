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
#import "Constant.h"
#import "HttpResponse.h"
#import <UIKit/UIKit.h>
#import "ExtendNSLogFunctionality.h"
#import "Reachability.h"
#import "TFHpple.h"
#import "FileUtils.h"
#import <AFNetworking/AFNetworking.h>
#import <SSZipArchive.h>

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
+ (HttpResponse *)httpGet:(NSString *)urlString header:(NSDictionary *)header timeoutInterval:(NSTimeInterval)timeoutInterval {
    urlString  = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    LogGreen(@"\nPOST:\n%@\n", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    HttpResponse *httpResponse = [[HttpResponse alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:timeoutInterval];
    [request setValue:[self webViewUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    if(header) {
        for(NSString *key in header) {
            [request setValue:header[key] forHTTPHeaderField:key];
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:header options:NSJSONWritingPrettyPrinted error:nil];
        LogGreen(@"\nParams:\n%@\n", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    }
    
    NSError *error;
    NSURLResponse *response;
    httpResponse.received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    httpResponse.response = (NSHTTPURLResponse*)response;
    BOOL isOK   = NSErrorPrint(error, @"Http#get(%fs) %@", timeoutInterval, urlString);
    if(!isOK) {
        [httpResponse.errors addObject:(NSString *)psd([error localizedDescription], @"http get未知错误")];
    }
    LogGreen(@"\nResponse:\n%@\n", httpResponse.string);
    
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
    return [HttpUtils httpGet:urlString header:nil timeoutInterval:8.0];
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
                                                           timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[self webViewUserAgent] forHTTPHeaderField:@"User-Agent"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    [request setHTTPBody:tempJsonData];
    
    NSURLResponse *response;
    HttpResponse *httpResponse = [[HttpResponse alloc] init];
    httpResponse.received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    httpResponse.response = (NSHTTPURLResponse *)response;
    BOOL isOK = NSErrorPrint(error, @"Http#post %@", urlString);
    if(!isOK) {
        [httpResponse.errors addObject:(NSString *)psd([error localizedDescription], @"Http#post未知错误")];
    }
    
    LogGreen(@"\nPOST:\n%@\n", urlString);
    LogGreen(@"\nParams:\n%@\n", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    LogGreen(@"\nResponse:\n%@\n", httpResponse.string);
    
    return httpResponse;
}

/**
 *  动态设置
 *
 *  @return 有网络则为true
 */
+ (BOOL)isNetworkAvailable {
    return [self isNetworkAvailable:5.0];
}

+ (BOOL)isNetworkAvailable:(NSTimeInterval)timeoutInterval {
    // @"http://www.apple.com"
    HttpResponse *httpResponse = [HttpUtils httpGet:kBaseUrl header:nil timeoutInterval:timeoutInterval];
    
    return (httpResponse.statusCode && ([httpResponse.statusCode intValue] == 200));
}

/**
 *  检测当前app网络环境
 *
 *  @return 有网络则为true
 */
+ (BOOL) isNetworkAvailable2 {
    BOOL isExistenceNetwork = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:kBaseUrl];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    
    return isExistenceNetwork;
}

+ (BOOL) isNetworkAvailable3 {
  __block  BOOL isExistenceNetwork = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            isExistenceNetwork = YES;
        }
        else{
            isExistenceNetwork = NO;
        }
    }];
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

/**
 *  清理header信息
 *
 *  @param urlString  链接
 *  @param assetsPath 缓存位置
 */
+ (void)clearHttpResponeHeader:(NSString *)urlString assetsPath:(NSString *)assetsPath {
    NSString *cachedHeaderPath = [assetsPath stringByAppendingPathComponent:kCachedHeaderConfigFileName];
    NSMutableDictionary *cachedHeaderDict = [NSMutableDictionary dictionaryWithContentsOfFile:cachedHeaderPath];
    if(cachedHeaderDict && cachedHeaderDict[urlString]) {
        [cachedHeaderDict removeObjectForKey:urlString];
        [cachedHeaderDict writeToFile:cachedHeaderPath atomically:YES];
    }
}

/**
 *  http#get 时 header  添加If-None-Match，避免静态文件重复加载
 *
 *  @param urlString  链接
 *  @param assetsPath 缓存位置
 *
 *  @return HttpResponse
 */
+ (HttpResponse *)checkResponseHeader:(NSString *)urlString assetsPath:(NSString *)assetsPath {
    NSString *cachedHeaderPath = [assetsPath stringByAppendingPathComponent:kCachedHeaderConfigFileName];
    NSMutableDictionary *cachedHeaderDict = [NSMutableDictionary dictionaryWithContentsOfFile:cachedHeaderPath];
    
    NSString *urlCleanedString = [self urlCleaner:urlString];
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    if(cachedHeaderDict[urlCleanedString]) {
        if(cachedHeaderDict[urlCleanedString][@"Etag"]) {
            header[@"IF-None-Match"] = cachedHeaderDict[urlCleanedString][@"Etag"];
        }
        
        if(cachedHeaderDict[urlCleanedString][@"Last-Modified"]) {
            header[@"If-Modified-Since"] = cachedHeaderDict[urlCleanedString][@"Last-Modified"];
        }
    }
    
    HttpResponse *httpResponse = [self httpGet:urlString header:header timeoutInterval:10.0];
    
    if(![httpResponse.statusCode isEqualToNumber:@(304)]) {
        if(!cachedHeaderDict) {
            cachedHeaderDict = [NSMutableDictionary dictionary];
        }
        
        cachedHeaderDict[urlCleanedString] = httpResponse.response.allHeaderFields;
        [cachedHeaderDict writeToFile:cachedHeaderPath atomically:YES];
    }
    NSLog(@"%@ - %@", urlString, httpResponse.statusCode);
    
    return httpResponse;
}

+ (void)downloadAssetFile:(NSString *)urlString assetsPath:(NSString *)assetsPath {
    NSString *filePath = [assetsPath stringByAppendingPathComponent:[urlString lastPathComponent]];
    
    if(![self checkFileExist:filePath isDir:NO]) {
        [HttpUtils clearHttpResponeHeader:urlString assetsPath:assetsPath];
    }

    HttpResponse *httpResponse = [self checkResponseHeader:urlString assetsPath:assetsPath];
    
    if([httpResponse.statusCode isEqualToNumber:@(200)]) {
        [self writeAssetFile:urlString filePath:filePath assetContent:nil];
        NSString *fileDir = [filePath stringByDeletingPathExtension];
        
        if([self checkFileExist:fileDir isDir:YES]) {
            [self removeFile:fileDir];
        }
        [SSZipArchive unzipFileAtPath:filePath toDestination:assetsPath];
        [self removeFile:filePath];
    }
}
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
+ (NSString *)urlConvertToLocal:(NSString *)urlString content:(NSString *)htmlContent assetsPath:(NSString *)assetsPath writeToLocal:(NSString *)writeToLocal {

    NSError *error = nil;
    NSString *filename = [self urlTofilename:urlString suffix:@".html"][0];
    NSString *filepath = [assetsPath stringByAppendingPathComponent:filename];
    
    NSString *assetLocalPath;
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSMutableDictionary *uniqDict = [NSMutableDictionary dictionary];
    // <script src="../*.js"></script>
    NSArray *elements = [doc searchWithXPathQuery:@"//script"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"src"] && [dict[@"src"] length] > 0 && [dict[@"src"] hasPrefix:@"/javascripts"]) {
            assetLocalPath = [NSString stringWithFormat:@"assets%@", dict[@"src"]];
            uniqDict[dict[@"src"]] = assetLocalPath;
        }
    }
    // <link href="../*.css">
    elements = [doc searchWithXPathQuery:@"//link"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"href"] && [dict[@"href"] length] > 0 && [dict[@"href"] hasPrefix:@"/stylesheets"]) {
            assetLocalPath = [NSString stringWithFormat:@"assets%@", dict[@"href"]];
            uniqDict[dict[@"href"]] = assetLocalPath;
        }
    }
    // <img src="../*.png">
    elements = [doc searchWithXPathQuery:@"//img"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"src"] && [dict[@"src"] length] > 0 && [dict[@"src"] hasPrefix:@"/images"]) {
            assetLocalPath = [NSString stringWithFormat:@"assets%@", dict[@"src"]];
            uniqDict[dict[@"src"]] = assetLocalPath;
        }
    }
    for(id key in uniqDict) {
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:key withString:uniqDict[key]];
    }
    
    [htmlContent writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    return filepath;
}

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
+ (NSString *)urlConvertToLocal2:(NSString *)urlString content:(NSString *)htmlContent assetsPath:(NSString *)assetsPath writeToLocal:(NSString *)writeToLocal {
    
    BOOL isWriteToLocal = [writeToLocal isEqualToString:@"1"];
    
    NSError *error = nil;
    NSString *filename = [self urlTofilename:urlString suffix:@".html"][0];
    NSString *filepath = [assetsPath stringByAppendingPathComponent:filename];

    NSString *assetLocalPath, *tagUrl;
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];

    // <script src="../*.js"></script>
    NSArray *elements = [doc searchWithXPathQuery:@"//script"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && [dict[@"src"] length] > 0) {
            if([dict[@"src"] hasPrefix:@"http://"] || [dict[@"src"] hasPrefix:@"https://"]) {
                tagUrl = dict[@"src"];
            }
            else {
                tagUrl = [HttpUtils urlConcatHyplink:urlString path:dict[@"src"]];
            }
            
            if(isWriteToLocal) {
                assetLocalPath = [self isShouldWrite:tagUrl assetsPath:assetsPath suffix:@".js"];
            }
            else {
                assetLocalPath = tagUrl;
            }
            
            htmlContent = [htmlContent stringByReplacingOccurrencesOfString:dict[@"src"] withString:assetLocalPath];
        }
    }
    
    // <link href="../*.css">
    elements = [doc searchWithXPathQuery:@"//link"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"href"] && [dict[@"href"] length] > 0) {
            if([dict[@"href"] hasPrefix:@"http://"] || [dict[@"href"] hasPrefix:@"https://"]) {
                tagUrl = dict[@"href"];
            }
            else {
                tagUrl = [self urlConcatHyplink:urlString path:dict[@"href"]];
            }
            
            if(isWriteToLocal) {
                assetLocalPath = [self isShouldWrite:tagUrl assetsPath:assetsPath suffix:@".css"];
            }
            else {
                assetLocalPath = tagUrl;
            }
            
            htmlContent = [htmlContent stringByReplacingOccurrencesOfString:dict[@"href"] withString:assetLocalPath];
        }
    }
    
    // <img src="../*.png">
    elements = [doc searchWithXPathQuery:@"//img"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"src"] && [dict[@"src"] length] > 0) {
            if([dict[@"src"] hasPrefix:@"http://"] || [dict[@"src"] hasPrefix:@"https://"]) {
                tagUrl = dict[@"src"];
            }
            else {
                tagUrl = [self urlConcatHyplink:urlString path:dict[@"src"]];
            }
            
            if(isWriteToLocal) {
                NSString *imgExt = [NSString stringWithFormat:@".%@", [tagUrl pathExtension]];
                assetLocalPath = [self isShouldWrite:tagUrl assetsPath:assetsPath suffix:imgExt];
            }
            else {
                assetLocalPath = tagUrl;
            }
            
            htmlContent = [htmlContent stringByReplacingOccurrencesOfString:dict[@"src"] withString:assetLocalPath];
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
    

    [htmlContent writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    return filepath;
}

+ (NSString *)isShouldWrite:(NSString *)tagUrl assetsPath:(NSString *)assetsPath suffix:(NSString *)suffix{
    
    NSString *filename = [self urlTofilename:tagUrl suffix:suffix][0];
    NSString *filepath = [assetsPath stringByAppendingPathComponent:filename];
    
    HttpResponse *httpResponse = [self checkResponseHeader:tagUrl assetsPath:assetsPath];

    if([httpResponse.statusCode isEqualToNumber:@(200)] ||
      ([httpResponse.statusCode isEqualToNumber:@(304)] && ![self checkFileExist:filepath isDir:NO])) {
        
        NSString *assetContent = nil;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            assetContent = httpResponse.string;
        }
        
        [self writeAssetFile:tagUrl filePath:filepath assetContent:assetContent];
    }
    
    return filename;
}

+ (void)writeAssetFile:(NSString *)assetUrl filePath:(NSString *)filePath assetContent:(NSString *)assetContent {
    NSString *assetExt = [filePath pathExtension];
	    
    if([self include:@[@"js", @"css"] object:assetExt]) {
        
        assetContent = assetContent ?: [self httpGet:assetUrl].string;

        [assetContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    else if([self include:@[@"png", @"jpg", @"jpeg", @"gif", @"ico", @"icon", @"zip"] object:assetExt]) {
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:assetUrl]];
        [imageData writeToFile:filePath atomically:YES];
    }
    else {
        NSLog(@"unkown path extension: %@", assetExt);
    }
}

+ (BOOL)include:(NSArray *)array object:(NSString *)object {
    BOOL isInclude = NO;
    for(NSString *item in array) {
        if([item isEqualToString:[object lowercaseString]]) {
            isInclude = YES;
            break;
        }
    }
    
    return isInclude;
}

+ (NSString *)urlCleaner:(NSString *)urlString {
    return [urlString componentsSeparatedByString:@"?"][0];
}

/**
 *  网页链接转换为合法文件名称
 *
 *  @param url    网页链接
 *  @param suffix 文件后缀
 *
 *  @return 合法文件名称
 */
+ (NSArray *)urlTofilename:(NSString *)url suffix:(NSString *)suffix {
    NSArray *blackList = @[@".", @":", @"/", @"?"];
    
    url = [url stringByReplacingOccurrencesOfString:kBaseUrl withString:@""];
    NSArray *parts = [url componentsSeparatedByString:@"?"];
    
    NSString *timestamp = nil;
    if([parts count] > 1) {
        url = parts[0];
        timestamp = parts[1];
    }
    
    
    if([url hasSuffix:suffix]) {
        url = [url stringByDeletingPathExtension];
    }
    
    while([url hasPrefix:@"/"]) {
        url = [url substringWithRange:NSMakeRange(1,url.length-1)];
    }
    
    for(NSString *str in blackList) {
        url = [url stringByReplacingOccurrencesOfString:str withString:@"_"];
    }
    
    if(![url hasSuffix:suffix]) {
        url = [NSString stringWithFormat:@"%@%@", url, suffix];
    }
    
    NSArray *result = [NSArray array];
    if(timestamp) {
        result = @[url, timestamp];
    }
    else {
        result = @[url];
    }
    
    return result;
}

+ (NSString *)htmlWithContentsOfFile:(NSString *)htmlPath {
    NSString *htmlContent;
    return htmlContent;
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

/**
 *  物理删除文件，并返回是否删除成功的布尔值。
 *
 *  @param filePath 待删除的文件路径
 *
 *  @return 是否删除成功的布尔值
 */
+ (BOOL)removeFile:(NSString *)filePath {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL removed = [fileManager removeItemAtPath: filePath error: &error];
    if(error) {
        NSLog(@"<# remove file %@ failed: %@", filePath, [error localizedDescription]);
    }
    
    return removed;
}

+ (NSString *)basePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    return [paths objectAtIndex:0];
}
/**
 *  读取配置档，有则读取。
 *  默认为NSMutableDictionary，若读取后为空，则按JSON字符串转NSMutableDictionary处理。
 *
 *  @param pathname 配置档路径
 *
 *  @return 返回配置信息NSMutableDictionary
 */
+ (NSMutableDictionary*)readConfigFile: (NSString*) pathName {
    NSMutableDictionary *dict = [NSMutableDictionary alloc];
    //NSLog(@"pathname: %@", pathname);
    if([self checkFileExist:pathName isDir:false]) {
        dict = [dict initWithContentsOfFile:pathName];
        // 若为空，则为JSON字符串
        if(!dict) {
            NSError *error;
            BOOL isSuccessfully;
            NSString *descContent = [NSString stringWithContentsOfFile:pathName encoding:NSUTF8StringEncoding error:&error];
            isSuccessfully = NSErrorPrint(error, @"read desc file: %@", pathName);
            if(isSuccessfully) {
                dict= [NSJSONSerialization JSONObjectWithData:[descContent dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
                NSErrorPrint(error, @"convert string into json: \n%@", descContent);
            }
        }
    }
    else {
        dict = [dict init];
    }
    return dict;
}

/**
 *  Http模拟浏览器访问
 *
 *  @return header#user-agent
 */
+ (NSString *)webViewUserAgent {
    NSString *userAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 9_0 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13A340 default-by-hand";
    
    NSString *userAgentPath = [[self basePath] stringByAppendingPathComponent:kUserAgentFileName];
    
    if([self checkFileExist:userAgentPath isDir:NO]) {
        userAgent = [NSString stringWithContentsOfFile:userAgentPath encoding:NSUTF8StringEncoding error:nil];
    }
//    else {
//        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//        [userAgent writeToFile:userAgentPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    }
    
    return userAgent;
}

/**
 *  上传用户图像
 *
 *  @param uploadPath 上传的服务器 地址
 *
 *  @param imagePath  本地的图片地址
 *
 *  @param ImageName  图片名
 */
+ (void)uploadImage:(NSString *)uploadPath withImagePath:(NSString *)imagePath withImageName:(NSString *)imageName {
    NSDictionary *dict = @{@"name":imageName, @"upload_state":@(NO), @"local_path":imagePath};
    NSMutableDictionary *gravatarDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    NSString *gravatarConfigPath = [FileUtils dirPath:kConfigDirName FileName:kGravatarConfigFileName];
    [FileUtils writeJSON:gravatarDict Into:gravatarConfigPath];

    // 测试用 url
 //   NSURL *imageurl = [NSURL URLWithString:@"http:192.168.0.137:3000/api/v1/user/1/render/program"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
 //  AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:imageurl];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    AFHTTPRequestOperation *op = [manager POST:uploadPath parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"gravatar" fileName:imageName mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        NSString *gravatarConfigPath = [FileUtils dirPath:kConfigDirName FileName:kGravatarConfigFileName];
        NSMutableDictionary *gravatar = [FileUtils readConfigFile:gravatarConfigPath];
        gravatar[@"name"] = imageName;
        gravatar[@"upload_state"] = @(YES);
        gravatar[@"gravatar_id"] = responseObject[@"gravatar_id"];
        [FileUtils writeJSON:gravatar Into:gravatarConfigPath];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        NSString *gravatarConfigPath = [FileUtils dirPath:kConfigDirName FileName:kGravatarConfigFileName];
        NSMutableDictionary *gravatar = [FileUtils readConfigFile:gravatarConfigPath];
        gravatar[@"name"] = imageName;
        gravatar[@"upload_state"] = @(NO);
        [FileUtils writeJSON:gravatar Into:gravatarConfigPath];
    }];
    [op start];
}

/**
 *  下载用户图像
 *
 *  @param fileUrl 用于图像的服务器地址
 *
 *  @param savePath 保存到本地的地址
 *
 */
+ (void)downLoadFile:(NSString *)fileUrl withSavePath:(NSString *)savePath{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileUrl]];
    [imageData writeToFile:savePath atomically:YES];
}



@end
