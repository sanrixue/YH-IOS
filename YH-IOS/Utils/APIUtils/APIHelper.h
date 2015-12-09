//
//  APIUtils.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIHelper : NSObject
+ (NSString *)reportDataUrlString:(NSString *)groupID reportID:(NSString *)reportID ;
+ (void)reportData:(NSString *)groupID reportID:(NSString *)reportID;

/**
 *  登录验证
 *
 *  @param username <#username description#>
 *  @param password <#password description#>
 *
 *  @return error msg when authentication failed
 */

+ (NSString *)userAuthentication:(NSString *)username password:(NSString *)password;
@end
