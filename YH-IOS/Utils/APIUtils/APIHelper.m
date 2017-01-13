//
//  APIUtils.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "APIHelper.h"
#import "Constant.h"
#import "HttpUtils.h"
#import "FileUtils.h"
#import "Version.h"
#import "OpenUDID.h"
#import <SSZipArchive/SSZipArchive.h>
@implementation APIHelper

+ (NSString *)reportDataUrlString:(NSNumber *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID  {
    return[NSString stringWithFormat:kReportDataAPIPath, kBaseUrl, groupID, templateID, reportID];
}

#pragma todo: pass assetsPath as parameter
+ (void)reportData:(NSNumber *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID {
    NSString *urlString = [self reportDataUrlString:groupID templateID:templateID reportID:reportID];
    
    NSString *assetsPath = [FileUtils dirPath:kHTMLDirName];
    NSString *javascriptPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
    
    HttpResponse *httpResponse = [HttpUtils checkResponseHeader:urlString assetsPath:assetsPath];
    if ([httpResponse.statusCode isEqualToNumber:@(200)]) {
        NSDictionary *httpHeader = [httpResponse.response allHeaderFields];
        NSString *disposition = httpHeader[@"Content-Disposition"];
        NSArray *array = [disposition componentsSeparatedByString:@"\""];
        NSString *cacheFilePath = array[1];
        NSString *reportFileName = [cacheFilePath stringByReplacingOccurrencesOfString:@".js.zip" withString:@".js"];
        NSString *cachePath = [FileUtils dirPath:kCachedDirName];
        NSString *fullFileCachePath = [cachePath stringByAppendingPathComponent:cacheFilePath];
        javascriptPath = [javascriptPath stringByAppendingPathComponent:reportFileName];
        [httpResponse.received writeToFile:fullFileCachePath atomically:YES];
        [SSZipArchive unzipFileAtPath:fullFileCachePath toDestination: cachePath];
        [FileUtils removeFile:fullFileCachePath];
        if ([FileUtils checkFileExist:javascriptPath isDir:NO]) {
            [FileUtils removeFile:javascriptPath];
        }
        [[NSFileManager defaultManager] copyItemAtPath:[cachePath stringByAppendingPathComponent:reportFileName] toPath:javascriptPath error:nil];
        [FileUtils removeFile:[cachePath stringByAppendingPathComponent:reportFileName]];
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
    NSString *urlString = [NSString stringWithFormat:kUserAuthenticateAPIPath, kBaseUrl, @"IOS", usernum, password];
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
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];

        userDict[kUserIDCUName]     = response.data[@"user_id"];
        userDict[kUserNameCUName]   = response.data[@"user_name"];
        userDict[kUserNumCUName]    = response.data[@"user_num"];
        userDict[kGroupIDCUName]    = response.data[@"group_id"];
        userDict[kGroupNameCUName]  = response.data[@"group_name"];
        userDict[kRoleIDCUName]     = response.data[@"role_id"];
        userDict[kRoleNameCUName]   = response.data[@"role_name"];
        userDict[kKPIIDsCUName]     = response.data[@"kpi_ids"];
        userDict[kAppIDSCUName]     = response.data[@"app_ids"];
        userDict[kAnalyseIDsCUName] = response.data[@"analyse_ids"];
        userDict[kStoreIDsCUName]   = response.data[@"store_ids"];
        userDict[kIsLoginCUName]    = @(YES);
        userDict[kDeviceUUIDCUName] = response.data[@"device_uuid"];
        userDict[kDeviceStateCUName]  = response.data[@"device_state"];
        userDict[kUserDeviceIDCUName] = response.data[@"user_device_id"];
        userDict[kGravatarCUName]    = response.data[@"gravatar"];
        userDict[kPasswordCUName]    = password;
        userDict[@"assets_md5"]      = response.data[@"assets_md5"];
        userDict[@"loading_md5"]     = response.data[@"loading_md5"];
        userDict[@"BarCodeScan_md5"] = response.data[@"BarCodeScan_md5"];
        userDict[@"advertisement_md5"] = response.data[@"advertisement_md5"];
        userDict[@"fonts_md5"]       = response.data[@"assets"][@"fonts_md5"];
        userDict[@"images_md5"]      = response.data[@"assets"][@"images_md5"];
        userDict[@"stylesheets_md5"] = response.data[@"assets"][@"stylesheets_md5"];
        userDict[@"javascripts_md5"] = response.data[@"assets"][@"javascripts_md5"];
        
        /**
         *  rewrite screen lock info into
         */
        [userDict writeToFile:userConfigPath atomically:YES];
        
        
        userDict[kIsUseGesturePasswordCUName] = @(NO);
        userDict[kGesturePasswordCUName]      = @"";
        NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
        if([FileUtils checkFileExist:settingsConfigPath isDir:NO]) {
            NSMutableDictionary *settingsDict = [FileUtils readConfigFile: settingsConfigPath];
            
            userDict[kIsUseGesturePasswordCUName] = @(NO);
            if(settingsDict[kIsUseGesturePasswordCUName]) {
                userDict[kIsUseGesturePasswordCUName] = settingsDict[kIsUseGesturePasswordCUName];
            }
            
            userDict[kGesturePasswordCUName] = @"";
            if(settingsDict[kGesturePasswordCUName]) {
                userDict[kGesturePasswordCUName] = settingsDict[kGesturePasswordCUName];
            }
        }
        [userDict writeToFile:userConfigPath atomically:YES];
        [userDict writeToFile:settingsConfigPath atomically:YES];

        // 第三方消息推送，设备标识
        [APIHelper pushDeviceToken:userDict[kDeviceUUIDCUName]];

    }
    else if(response.data && response.data[@"info"]) {
        alertMsg = [NSString stringWithFormat:@"%@", response.data[@"info"]];
    }
    else if(response.errors.count) {
        alertMsg = [response.errors componentsJoinedByString:@"\n"];
    }
    else {
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
    NSString *urlString = [NSString stringWithFormat:kCommentAPIPath, kBaseUrl, userID, objectID, objectType];
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
    NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kPushConfigFileName];
    NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
    
    if(pushDict[@"device_uuid"] && ![pushDict[@"device_uuid"] isEqualToString:deviceUUID]) {
        pushDict[@"push_valid"] = @(NO);
    }
    
    if([pushDict[@"push_valid"] boolValue] && pushDict[@"push_device_token"] && [pushDict[@"push_device_token"] length] == 64) {
        return YES;
    }
    if(!pushDict[@"push_device_token"] || [pushDict[@"push_device_token"] length] != 64) {
        return NO;
    }
    
    NSString *urlString = [NSString stringWithFormat:kPushDeviceTokenAPIPath, kBaseUrl, deviceUUID, pushDict[@"push_device_token"]];
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:[NSMutableDictionary dictionary]];

    pushDict[@"device_uuid"] = deviceUUID;
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
    NSString *urlString = [NSString stringWithFormat:kScreenLockAPIPath, kBaseUrl, userDeviceID];
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
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    NSString *urlString = [NSString stringWithFormat:kDeviceStateAPIPath, kBaseUrl, userDict[kUserDeviceIDCUName]];
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
    NSString *urlString = [NSString stringWithFormat:kResetPwdAPIPath, kBaseUrl, userID];
    
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
    // TODO: 避免服务器压力，过滤操作由服务器来处理
    NSString *action = param[kActionALCName];
    
    if(action == nil) { return; }

    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    param[kUserIDCUName]       = userDict[kUserIDCUName];
    param[kUserNameCUName]     = userDict[kUserNameCUName];
    param[kUserDeviceIDCUName] = userDict[kUserDeviceIDCUName];
    param[kAppVersionCUName]   = [NSString stringWithFormat:@"i%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kActionLogALCName] = param;
    
    NSMutableDictionary *userParams = [NSMutableDictionary dictionary];
    userParams[kUserNameALCName] = userDict[kUserNameCUName];
    userParams[kPasswordALCName] = userDict[kPasswordCUName];
    params[kUserALCName]         = userParams;
    NSString *urlString = [NSString stringWithFormat:kActionLogAPIPath, kBaseUrl];
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
+ (BOOL)barCodeScan:(NSString *)userNum group:(NSNumber *)groupID  role:(NSNumber *)roleID store:(NSString *)storeID code:(NSString *)codeInfo type:(NSString *)codeType {
    NSString * urlstring = [NSString stringWithFormat:kBarCodeScanAPIPath, kBaseUrl, groupID, roleID, userNum, storeID, codeInfo, codeType];
    
    HttpResponse *response = [HttpUtils httpGet:urlstring];
    NSString *responseString = response.string;
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    BOOL isJsonRight;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err || (dic.count == 0)) {
        isJsonRight = NO;
    }
    else {
        [FileUtils barcodeScanResult:responseString];
        isJsonRight = YES;
    }
    return isJsonRight;
}

+ (HttpResponse *)findPassword:(NSString *)userNum withMobile:(NSString *)moblieNum {
    
    NSString *urlString = [NSString stringWithFormat:KFindPwdAPIPath, kBaseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_num"] = userNum;
    params[@"mobile"] = moblieNum;
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    
    return httpResponse;
}

@end
