//
//  APIUtils.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "APIHelper.h"
#import "const.h"
#import "HttpUtils.h"
#import "FileUtils.h"
#import "HttpResponse.h"

@implementation APIHelper

+ (NSString *)reportDataUrlString:(NSString *)groupID reportID:(NSString *)reportID  {
    NSString *urlPath = [NSString stringWithFormat:API_DATA_PATH, groupID, reportID];
    return [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
}

+ (void)reportData:(NSString *)groupID reportID:(NSString *)reportID {
    NSString *urlString = [self reportDataUrlString:groupID reportID:reportID];
    
    NSString *userspacePath = [FileUtils userspace];
    NSString *assetsPath = [userspacePath stringByAppendingPathComponent:HTML_DIRNAME];
    
    NSString *reportDataFileName = [NSString stringWithFormat:REPORT_DATA_FILENAME, groupID, reportID];
    NSString *reportDataFilePath = [assetsPath stringByAppendingPathComponent:reportDataFileName];
    
    if(![FileUtils checkFileExist:reportDataFilePath isDir:NO]) {
        [HttpUtils clearHttpResponeHeader:urlString assetsPath:assetsPath];
    }
    
    HttpResponse *httpResponse = [HttpUtils checkResponseHeader:urlString assetsPath:assetsPath];
    
    if([httpResponse.statusCode isEqualToNumber:@(200)]) {
       // || reponse body is empty when 304
       //([httpResponse.statusCode isEqualToNumber:@(304)] && ![FileUtils checkFileExist:reportDataFilePath isDir:NO])) {
        
        if(httpResponse.string) {
            NSError *error = nil;
            [httpResponse.string writeToFile:reportDataFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            if(error) {
                NSLog(@"%@ - %@", error.description, reportDataFilePath);
            }
        }
    }
}

/**
 *  登录验证
 *
 *  @param username <#username description#>
 *  @param password <#password description#>
 *
 *  @return error msg when authentication failed
 */

+ (NSString *)userAuthentication:(NSString *)username password:(NSString *)password {
    NSString *urlPath = [NSString stringWithFormat:API_USER_PATH, @"IOS", username, password];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
    
    NSString *alertMsg = @"";
    
    HttpResponse *httpResponse = [HttpUtils httpGet:urlString];
    if(httpResponse.statusCode && [httpResponse.statusCode isEqualToNumber:@(200)]) {
        NSString *configPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
        [httpResponse.data writeToFile:configPath atomically:YES];
    }
    else {
        alertMsg = [NSString stringWithFormat:@"%@", httpResponse.data[@"info"]];
    }
    return alertMsg;
}

/**
 *  创建评论
 *
 *  @param userID     <#userID description#>
 *  @param objectType <#objectType description#>
 *  @param objectID   <#objectID description#>
 *  @param params     <#params description#>
 *
 *  @return 是否创建成功
 */
+ (BOOL)writeComment:(NSString *)userID objectType:(NSNumber *)objectType objectID:(NSNumber *)objectID params:(NSMutableDictionary *)params {
    NSString *urlPath = [NSString stringWithFormat:API_COMMENT_PATH, userID, objectID, objectType];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    
    return [httpResponse.statusCode isEqual:@(201)];
}
@end
