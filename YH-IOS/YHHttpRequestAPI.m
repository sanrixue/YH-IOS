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
#import "ArticlesModel.h"

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
    NSDictionary* dic = @{
                          @"page":@(page),
                          @"type":typeStr,
                          @"limit":defaultLimit
                          };
    NSString* url = [NSString stringWithFormat:@"%@/api/v1/user/%@/notices",kBaseUrl,[self user].userID];
//    url = [url stringByAppendingString:[NSString stringWithFormat:@"?page=%zd&limit=%@&type=%@",page,defaultLimit,typeStr]];
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        NoticeWarningModel* model = [NoticeWarningModel mj_objectWithKeyValues:[dic valueForKey:@"key"]];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_getNoticeWarningDetailWithNotice_id:(NSString *)notice_id finish:(YHHttpRequestBlock)finish{
    NSString* url = [NSString stringWithFormat:@"%@/api/v1/user/%@/notice/%@",kBaseUrl,[self user].userID,notice_id];
    [BaseRequest getRequestWithUrl:url Params:nil needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        NoticeWarningDetailModel* model = [NoticeWarningDetailModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_getArticleListWithKeyword:(NSString *)keyword page:(NSInteger)page finish:(YHHttpRequestBlock)finish{
    NSString* url = [NSString stringWithFormat:@"%@/api/v1/user/%@/page/%zd/limit/%@/articles",kBaseUrl,[self user].userID,page,defaultLimit];
    NSDictionary* dic = @{
                          @"keyword":SafeText(keyword)
                          };
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ArticlesModel* model = [ArticlesModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_collectArticleWithArticleId:(NSString *)identifier isFav:(BOOL)isFav finish:(YHHttpRequestBlock)finish{
        NSString* url = [NSString stringWithFormat:@"%@/api/v1/user/%@/article/%@/favourite_status/%@",kBaseUrl,[self user].userID,identifier,isFav ? @"1":@"2"];
    [BaseRequest postRequestWithUrl:url Params:nil needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ArticlesModel* model = [ArticlesModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

@end
