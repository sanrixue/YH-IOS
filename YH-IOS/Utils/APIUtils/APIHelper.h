//
//  APIUtils.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIHelper : NSObject
+ (NSString *)reportDataUrlString:(NSNumber *)groupID reportID:(NSString *)reportID ;
+ (void)reportData:(NSNumber *)groupID reportID:(NSString *)reportID;

/**
 *  登录验证
 *
 *  @param username <#username description#>
 *  @param password <#password description#>
 *
 *  @return error msg when authentication failed
 */

+ (NSString *)userAuthentication:(NSString *)username password:(NSString *)password;


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
+ (BOOL)deviceState;
@end
