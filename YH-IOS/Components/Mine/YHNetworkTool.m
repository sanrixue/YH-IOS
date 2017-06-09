//
//  YHNetworkTool.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHNetworkTool.h"
#import "HttpResponse.h"
#import "HttpUtils.h"

@implementation YHNetworkTool

+(instancetype)shareNetWorkTool{
    static YHNetworkTool *_shareInstance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[YHNetworkTool alloc]init];
    });
    return _shareInstance;
}


-(Person *)loadUserInfo{
    /*AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    __block Person* person;
    [manage GET:@"http://192.168.0.137:3000/api/v1/user/1/mine/user_info" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        person = [MTLJSONAdapter modelOfClass:Person.self fromJSONDictionary:responseObject error:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@",error);
    }];*/
    
    HttpResponse *response = [HttpUtils httpGet:@"http://192.168.0.137:3000/api/v1/user/1/mine/user_info"];
    Person *person = [MTLJSONAdapter modelOfClass:Person.self fromJSONDictionary:response.data error:nil];
    return person;
}


@end
