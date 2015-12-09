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
@end
