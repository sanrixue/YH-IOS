//
//  APIUtils.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponse.h"

@interface APIHelper : NSObject

+(NSString*)getJsonDataWithZip:(NSNumber *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID;
+ (NSString *)reportDataUrlString:(NSNumber *)groupID templateID:(NSString *)tempalteID reportID:(NSString *)reportID ;
+ (void)reportData:(NSNumber *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID;

/**
 *  登录验证
 *
 *  @param username <#username description#>
 *  @param password <#password description#>
 *
 *  @return error msg when authentication failed
 */

+ (NSString *)userAuthentication:(NSString *)username password:(NSString *)password coordinate:(NSString *)coordinate;

+ (NSString *)userAuthentication:(NSString *)username password:(NSString *)password;

/**
 * 删除用户和设备的关联
 */
+ (void)deleteUserDevice:(NSString *)platform withDeviceID:(NSString*)deviceid;
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
+ (BOOL)writeComment:(NSNumber *)userID objectType:(NSNumber *)objectType objectID:(NSNumber *)objectID params:(NSMutableDictionary *)params;

/**
 *  消息推送， 设备标识
 *
 *  @param deviceUUID  设备ID
 *
 *  @return 服务器是否更新成功
 */
+ (BOOL)pushDeviceToken:(NSString *)deviceUUID;

/**
 *  用户锁屏数据
 *
 *  @param userDeviceID 设备ID
 *  @param passcode     锁屏信息
 *  @param state        是否锁屏
 */
+ (void)screenLock:(NSString *)userDeviceID passcode:(NSString *)passcode state:(BOOL)state;

/**
 *  检测设备是否在服务器端被禁用
 *
 *
 *  @return 是否可用
 */
+ (DeviceState)deviceState;

/**
 *  重置用户登陆密码
 *
 *  @param userID      用户ID
 *  @param newPassword 新密码
 *
 *  @return 服务器响应
 */
+ (HttpResponse *)resetPassword:(NSNumber *)userID newPassword:(NSString *)newPassword;

/**
 *  记录用户行为操作
 *
 *  @param params 用户行为操作
 */
+ (void)actionLog:(NSMutableDictionary *)param;

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
+ (BOOL)barCodeScan:(NSString *)userNum group:(NSNumber *)groupID  role:(NSNumber *)roleID store:(NSString *)storeID code:(NSString *)codeInfo type:(NSString *)codeType;

+ (HttpResponse *)findPassword:(NSString *)userNum withMobile:(NSString *)moblieNum;

+ (void)reportScodeData:(NSNumber *)storeID barcodeID:(NSString *)barcodeID;

@end
