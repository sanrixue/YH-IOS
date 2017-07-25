//
//  YHHttpRequestAPI.h
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

typedef void(^YHHttpRequestBlock)( BOOL success, id model, NSString* jsonObjc);

#define defaultLimit @"15"

@interface YHHttpRequestAPI : NSObject
/**
 获取消息警告列表接口

 @param types @[1,2,3,4]自由组合
 @param page page description
 @param finish finish description
 */
+ (void)yh_getNoticeWarningListWithTypes:(NSArray<NSString*>*)types
                                    page:(NSInteger)page
                                   finish:(YHHttpRequestBlock)finish;

/**
 获取公告预警详情

 @param notice_id identifier
 @param finish finish description
 */
+ (void)yh_getNoticeWarningDetailWithNotice_id:(NSString*)notice_id
                                        finish:(YHHttpRequestBlock)finish;

/**
 获取数据学院文章列表

 @param keyword keyword description
 @param finish finish description
 */
+ (void)yh_getArticleListWithKeyword:(NSString*)keyword
                                page:(NSInteger)page
                              finish:(YHHttpRequestBlock)finish;

+ (void)yh_collectArticleWithArticleId:(NSString*)identifier
                                 isFav:(BOOL)isFav
                              finish:(YHHttpRequestBlock)finish;

@end
