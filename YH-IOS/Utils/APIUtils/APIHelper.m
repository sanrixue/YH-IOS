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
#import "Version.h"
#import "OpenUDID.h"

@implementation APIHelper

+ (NSString *)reportDataUrlString:(NSNumber *)groupID reportID:(NSString *)reportID  {
    NSString *urlPath = [NSString stringWithFormat:API_DATA_PATH, groupID, reportID];
    return [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
}

#pragma todo: pass assetsPath as parameter
+ (void)reportData:(NSNumber *)groupID reportID:(NSString *)reportID {
    NSString *urlString = [self reportDataUrlString:groupID reportID:reportID];
    
    NSString *userspacePath = [FileUtils userspace];
    NSString *assetsPath = [userspacePath stringByAppendingPathComponent:HTML_DIRNAME];
    
    NSString *reportDataFileName = [NSString stringWithFormat:REPORT_DATA_FILENAME, groupID, reportID];
    NSString *javascriptPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
    javascriptPath = [javascriptPath stringByAppendingPathComponent:reportDataFileName];
    
    if(![FileUtils checkFileExist:javascriptPath isDir:NO]) {
        [HttpUtils clearHttpResponeHeader:urlString assetsPath:assetsPath];
    }
    
    HttpResponse *httpResponse = [HttpUtils checkResponseHeader:urlString assetsPath:assetsPath];
    
    if([httpResponse.statusCode isEqualToNumber:@(200)]) {
       // || reponse body is empty when 304
       //([httpResponse.statusCode isEqualToNumber:@(304)] && ![FileUtils checkFileExist:reportDataFilePath isDir:NO])) {
        
        if(httpResponse.string) {
            NSError *error = nil;
            [httpResponse.string writeToFile:javascriptPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            if(error) {
                NSLog(@"%@ - %@", error.description, javascriptPath);
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
    
    NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
    deviceDict[@"device"] = @{
            @"name": [[UIDevice currentDevice] name],
            @"platform": @"ios",
            @"os": [Version machineHuman],
            @"os_version": [[UIDevice currentDevice] systemVersion],
            @"uuid": [OpenUDID value]
        };

    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:deviceDict];
    
    if(httpResponse.data[@"code"] && [httpResponse.data[@"code"] isEqualToNumber:@(200)]) {
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];

        userDict[@"user_id"]     = httpResponse.data[@"user_id"];
        userDict[@"user_name"]   = httpResponse.data[@"user_name"];
        userDict[@"group_id"]    = httpResponse.data[@"group_id"];
        userDict[@"group_name"]  = httpResponse.data[@"group_name"];
        userDict[@"role_id"]     = httpResponse.data[@"role_id"];
        userDict[@"role_name"]   = httpResponse.data[@"role_name"];
        userDict[@"kpi_ids"]     = httpResponse.data[@"kpi_ids"];
        userDict[@"app_ids"]     = httpResponse.data[@"app_ids"];
        userDict[@"analyse_ids"] = httpResponse.data[@"analyse_ids"];
        userDict[@"is_login"]    = @(YES);
        userDict[@"device_uuid"]     = httpResponse.data[@"device_uuid"];
        userDict[@"device_state"]    = httpResponse.data[@"device_state"];
        userDict[@"user_device_id"]  = httpResponse.data[@"user_device_id"];
        userDict[@"user_md5"]        = password;
        [userDict writeToFile:userConfigPath atomically:YES];
        
        NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
        [userDict writeToFile:settingsConfigPath atomically:YES];
    }
    else if(httpResponse.data[@"code"] && ([httpResponse.data[@"code"] isEqualToNumber:@(400)] || [httpResponse.data[@"code"] isEqualToNumber:@(0)])) {
        alertMsg = @"请确认网络环境.";
    }
    else {
        if(httpResponse.data[@"info"]) {
            alertMsg = [NSString stringWithFormat:@"%@", httpResponse.data[@"info"]];
        }
        else {
            alertMsg = [NSString stringWithFormat:@"未知错误: %@", httpResponse.statusCode];
        }
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
+ (BOOL)writeComment:(NSNumber *)userID objectType:(NSNumber *)objectType objectID:(NSNumber *)objectID params:(NSMutableDictionary *)params {
    NSString *urlPath = [NSString stringWithFormat:API_COMMENT_PATH, userID, objectID, objectType];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    
    return [httpResponse.statusCode isEqual:@(201)];
}

/**
 *  用户锁屏数据
 *
 *  @param userDeviceID 设备ID
 *  @param passcode     锁屏信息
 *  @param state        是否锁屏
 */
+ (void)screenLock:(NSString *)userDeviceID passcode:(NSString *)passcode state:(BOOL)state {
    NSString *urlPath = [NSString stringWithFormat:API_SCREEN_LOCK_PATH, userDeviceID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"screen_lock_state"] = @(state);
    params[@"screen_lock_type"]  = @"4位数字";
    params[@"screen_lock"]       = passcode;
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    NSLog(@"%@", httpResponse.statusCode);
}

/**
 *  检测设备是否在服务器端被禁用
 *
 *
 *  @return 是否可用
 */
+ (DeviceState)deviceState {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    NSString *urlPath = [NSString stringWithFormat:API_DEVICE_STATE_PATH, userDict[@"user_device_id"]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
    HttpResponse *httpResponse = [HttpUtils httpGet:urlString];
    

//    userDict[@"device_state"]  = httpResponse.data[@"device_state"];
//    [userDict writeToFile:userConfigPath atomically:YES];
//    
//    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
//    [userDict writeToFile:settingsConfigPath atomically:YES];
    
    
    DeviceState deviceState = [httpResponse.statusCode integerValue];
    if(deviceState == StateOK) {
        deviceState = [httpResponse.data[@"device_state"] boolValue] ? StateOK : StateForbid;
    }
    
    return deviceState;
}

/**
 *  重置用户登陆密码
 *
 *  @param userID      用户ID
 *  @param newPassword 新密码
 *
 *  @return 服务器响应
 */
+ (HttpResponse *)resetPassword:(NSNumber *)userID newPassword:(NSString *)newPassword {
    NSString *urlPath = [NSString stringWithFormat:API_RESET_PASSWORD_PATH, userID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"password"] = newPassword;
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    
    return httpResponse;
}

/**
 *  记录用户行为操作
 *
 *  @param params 用户行为操作
 */
+ (void)actionLog:(NSMutableDictionary *)param {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    param[@"user_id"] = userDict[@"user_id"];
    param[@"user_name"] = userDict[@"user_name"];
    param[@"user_device_id"] = userDict[@"user_device_id"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action_log"] = param;
    
    NSMutableDictionary *userParams = [NSMutableDictionary dictionary];
    userParams[@"user_name"] = userDict[@"user_name"];
    userParams[@"user_pass"] = userDict[@"user_md5"];
    
    params[@"user"] = userParams;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, API_ACTION_LOG__PATH];
    [HttpUtils httpPost:urlString Params:params];
}
@end
