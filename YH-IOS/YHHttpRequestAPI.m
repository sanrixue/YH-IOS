//
//  YHHttpRequestAPI.m
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHHttpRequestAPI.h"
#import "User.h"
#import "NoticeWarningModel.h"

@implementation YHHttpRequestAPI

+ (User*)user{
    return [[User alloc] init];
}

+ (void)yh_getNoticeWarningListWithTypes:(NSArray<NSString *> *)types page:(NSInteger)page finish:(YHHttpRequestBlock)finish{
    NSString *typeStr = [[NSString alloc] init];
    for (NSString* str in types) {
        typeStr = [typeStr stringByAppendingString:str];
        if (types.count && [types lastObject] != str) {
            typeStr = [typeStr stringByAppendingString:@","];
        }
    }
    NSString* url = [NSString stringWithFormat:@"%@/api/v1/user/%@/type/%@/page/%zd/limit/%zd/notices",kBaseUrl,[self user].userID,typeStr,page,defaultLimit];
    [BaseRequest getRequestWithUrl:url Params:nil needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        NoticeWarningModel* model = [NoticeWarningModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

@end
