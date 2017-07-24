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

NSInteger defaultLimit = 15;

@interface YHHttpRequestAPI : NSObject

+ (void)yh_getNoticeWarningListWithTypes:(NSArray<NSString*>*)types
                                    page:(NSInteger)page
                                   finish:(YHHttpRequestBlock)finish;

@end
