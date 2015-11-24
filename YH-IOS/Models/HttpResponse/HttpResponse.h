//
//  HttpResponse.h
//  iSearch
//
//  Created by lijunjie on 15/7/13.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//
#import "BaseModel.h"

@interface HttpResponse : BaseModel

@property (nonatomic, strong) NSData *received;          // 服务器返回原始内容
@property (nonatomic, strong) NSMutableDictionary *data; // response => json
@property (nonatomic, strong) NSString *string;          // response => string
@property (nonatomic, strong) NSMutableArray *errors;    // 服务器交互中出现错误
@property (nonatomic, strong) NSHTTPURLResponse *response;   // 响应头部信息

// parse response
@property (nonatomic, strong) NSString  *URL;
@property (nonatomic, strong) NSNumber  *statusCode;
@property (nonatomic, strong) NSNumber  *contentLength;
@property (nonatomic, strong) NSString  *contentType;
@property (nonatomic, strong) NSString  *chartset;
@property (nonatomic, strong) NSString  *server;
@property (nonatomic, strong) NSString  *xPoweredBy;
@property (nonatomic, strong) NSString  *date;

// instance methods
- (BOOL)isValid;
- (NSString *)receivedString;

// suit for Url+Param.h
- (BOOL)isSuccessfullyPostActionLog;
@end
