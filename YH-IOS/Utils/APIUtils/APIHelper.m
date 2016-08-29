//
//  APIUtils.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "APIHelper.h"
#import "Constants.h"
#import "HttpUtils.h"
#import "FileUtils.h"
#import "Version.h"
#import "OpenUDID.h"

@implementation APIHelper

+ (NSString *)reportDataUrlString:(NSNumber *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID  {
    return[NSString stringWithFormat:API_DATA_PATH, kBaseUrl, groupID, templateID, reportID];
}

#pragma todo: pass assetsPath as parameter
+ (void)reportData:(NSNumber *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID {
    NSString *urlString = [self reportDataUrlString:groupID templateID:templateID reportID:reportID];
    
    NSString *userspacePath = [FileUtils userspace];
    NSString *assetsPath = [userspacePath stringByAppendingPathComponent:HTML_DIRNAME];
    
    NSString *reportDataFileName = [NSString stringWithFormat:REPORT_DATA_FILENAME, groupID, templateID, reportID];
    NSString *javascriptPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
    javascriptPath = [javascriptPath stringByAppendingPathComponent:reportDataFileName];
    
    if(![FileUtils checkFileExist:javascriptPath isDir:NO]) {
        [HttpUtils clearHttpResponeHeader:urlString assetsPath:assetsPath];
    }
    
    HttpResponse *httpResponse = [HttpUtils checkResponseHeader:urlString assetsPath:assetsPath];
    
    if([httpResponse.statusCode isEqualToNumber:@(200)] && httpResponse.string) {
        NSError *error = nil;
        [httpResponse.string writeToFile:javascriptPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if(error) { NSLog(@"%@ - %@", error.description, javascriptPath); }
        
        NSString *searchItemsPath = [NSString stringWithFormat:@"%@.search_items", javascriptPath];
        if([FileUtils checkFileExist:searchItemsPath isDir:NO]) {
            [FileUtils removeFile:searchItemsPath];
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
+ (NSString *)userAuthentication:(NSString *)usernum password:(NSString *)password {
    NSString *urlString = [NSString stringWithFormat:API_USER_PATH, kBaseUrl, @"IOS", usernum, password];
    NSString *alertMsg = @"";
    
    NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
    deviceDict[@"device"] = @{
        @"name": [[UIDevice currentDevice] name],
        @"platform": @"ios",
        @"os": [Version machineHuman],
        @"os_version": [[UIDevice currentDevice] systemVersion],
        @"uuid": [OpenUDID value]
    };
    deviceDict[@"app_version"] = [NSString stringWithFormat:@"i%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];

    HttpResponse *response = [HttpUtils httpPost:urlString Params:deviceDict];
    
    if(response.data[@"code"] && [response.data[@"code"] isEqualToNumber:@(200)]) {
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];

        userDict[@"user_id"]     = response.data[@"user_id"];
        userDict[@"user_name"]   = response.data[@"user_name"];
        userDict[@"user_num"]    = response.data[@"user_num"];
        userDict[@"group_id"]    = response.data[@"group_id"];
        userDict[@"group_name"]  = response.data[@"group_name"];
        userDict[@"role_id"]     = response.data[@"role_id"];
        userDict[@"role_name"]   = response.data[@"role_name"];
        userDict[@"kpi_ids"]     = response.data[@"kpi_ids"];
        userDict[@"app_ids"]     = response.data[@"app_ids"];
        userDict[@"analyse_ids"] = response.data[@"analyse_ids"];
        userDict[@"store_ids"]   = response.data[@"store_ids"];
        userDict[@"is_login"]    = @(YES);
        userDict[@"device_uuid"]    = response.data[@"device_uuid"];
        userDict[@"device_state"]   = response.data[@"device_state"];
        userDict[@"user_device_id"] = response.data[@"user_device_id"];
        userDict[@"assets_md5"]      = response.data[@"assets_md5"];
        userDict[@"loading_md5"]     = response.data[@"loading_md5"];
        userDict[@"fonts_md5"]       = response.data[@"assets"][@"fonts_md5"];
        userDict[@"images_md5"]      = response.data[@"assets"][@"images_md5"];
        userDict[@"stylesheets_md5"] = response.data[@"assets"][@"stylesheets_md5"];
        userDict[@"javascripts_md5"] = response.data[@"assets"][@"javascripts_md5"];
        userDict[@"user_md5"]        = password;
        
        /**
         *  rewrite screen lock info into
         */
        [userDict writeToFile:userConfigPath atomically:YES];
        
        NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
        if([FileUtils checkFileExist:settingsConfigPath isDir:NO]) {
            NSMutableDictionary *settingsDict = [FileUtils readConfigFile: settingsConfigPath];
            if(settingsDict[@"use_gesture_password"]) {
                userDict[@"use_gesture_password"] = settingsDict[@"use_gesture_password"];
            } else {
                userDict[@"use_gesture_password"] = @(NO);
            }
            
            if(settingsDict[@"gesture_password"]) {
                userDict[@"gesture_password"] = settingsDict[@"gesture_password"];
            } else {
                userDict[@"gesture_password"] = @"";
            }
        } else {
            userDict[@"use_gesture_password"] = @(NO);
            userDict[@"gesture_password"] = @"";
        }
        [userDict writeToFile:userConfigPath atomically:YES];
        [userDict writeToFile:settingsConfigPath atomically:YES];

        // 第三方消息推送，设备标识
        [APIHelper pushDeviceToken: userDict[@"device_uuid"]];

    } else if(response.data && response.data[@"info"]) {
        alertMsg = [NSString stringWithFormat:@"%@", response.data[@"info"]];
    } else if(response.errors.count) {
        alertMsg = [response.errors componentsJoinedByString:@"\n"];
    } else {
        alertMsg = [NSString stringWithFormat:@"未知错误: %@", response.statusCode];
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
    NSString *urlString = [NSString stringWithFormat:API_COMMENT_PATH, kBaseUrl, userID, objectID, objectType];
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    
    return [httpResponse.statusCode isEqual:@(201)];
}

/**
 *  消息推送， 设备标识
 *
 *  @param deviceUUID  设备ID
 *
 *  @return 服务器是否更新成功
 */
+ (BOOL)pushDeviceToken:(NSString *)deviceUUID {
    NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:PUSH_CONFIG_FILENAME];
    NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
    
    if([pushDict[@"push_valid"] boolValue] && pushDict[@"push_device_token"] && [pushDict[@"push_device_token"] length] == 64) return YES;
    if(!pushDict[@"push_device_token"] || [pushDict[@"push_device_token"] length] != 64) return NO;
    
    NSString *urlString = [NSString stringWithFormat:API_PUSH_DEVICE_TOKEN_PATH, kBaseUrl, deviceUUID, pushDict[@"push_device_token"]];
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:[NSMutableDictionary dictionary]];

    pushDict[@"push_valid"] = @(httpResponse.data[@"valid"] && [httpResponse.data[@"valid"] boolValue]);
    [pushDict writeToFile:pushConfigPath atomically:YES];
    
    return [pushDict[@"push_valid"] boolValue];
}

/**
 *  用户锁屏数据
 *
 *  @param userDeviceID 设备ID
 *  @param passcode     锁屏信息
 *  @param state        是否锁屏
 */
+ (void)screenLock:(NSString *)userDeviceID passcode:(NSString *)passcode state:(BOOL)state {
    NSString *urlString = [NSString stringWithFormat:API_SCREEN_LOCK_PATH, kBaseUrl, userDeviceID];
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
    
    NSString *urlString = [NSString stringWithFormat:API_DEVICE_STATE_PATH, kBaseUrl, userDict[@"user_device_id"]];
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
    NSString *urlString = [NSString stringWithFormat:API_RESET_PASSWORD_PATH, kBaseUrl, userID];
    
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
    // TODO: 避免服务器压力
    NSString *action = param[@"action"];
    
    if(action == nil) {
        return;
    }
    if(![action isEqualToString:@"登录"] && ![action isEqualToString:@"解屏"] &&
       ![action containsString:@"微信分享"] && ![action isEqualToString:@"点击/主页面/浏览器"]) {
        return;
    }
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    param[@"user_id"] = userDict[@"user_id"];
    param[@"user_name"] = userDict[@"user_name"];
    param[@"user_device_id"] = userDict[@"user_device_id"];
    param[@"app_version"] = [NSString stringWithFormat:@"i%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action_log"] = param;
    
    NSMutableDictionary *userParams = [NSMutableDictionary dictionary];
    userParams[@"user_name"] = userDict[@"user_name"];
    userParams[@"user_pass"] = userDict[@"user_md5"];
    
    params[@"user"] = userParams;
    NSString *urlString = [NSString stringWithFormat:API_ACTION_LOG_PATH, kBaseUrl];
    [HttpUtils httpPost:urlString Params:params];
}

/**
 *  二维码扫描
 *
 *  @param userNum    用户编号
 *  @param groupID    群组ID
 *  @param roleID     角色ID
 *  @param storeID    门店ID
 *  @param codeString 条形码信息
 *  @param codeType   条形码或二维码
 */
+ (void)barCodeScan:(NSString *)userNum group:(NSNumber *)groupID  role:(NSNumber *)roleID store:(NSString *)storeID code:(NSString *)codeInfo type:(NSString *)codeType {
    
    NSString * urlstring = [NSString stringWithFormat:API_BARCODE_SCAN_PATH, kBaseUrl, groupID, roleID, userNum, storeID, codeInfo, codeType];
    
    HttpResponse *response = [HttpUtils httpGet:urlstring];
    NSString *responseString = response.string;
    if(!response.data[@"code"] || ![response.data[@"code"] isEqualToNumber:@(200)]) {
        responseString = @"{\"chart\": \"[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]\", \"tabs\": [{ title: \"提示\", table: { length: 1, \"1\": [\"获取数据失败！\"]}}]}";
    }
    [FileUtils barcodeScanResult:responseString];
}
@end
