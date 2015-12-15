//
//  Version+Self.m
//  iSearch
//
//  Created by lijunjie on 15/7/9.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Version+Pgyer.h"
#import "const.h"
#import <AFNetworking.h>


@implementation Version (Pgyer)

- (void)checkUpdate:(void(^)())successBlock FailBloc:(void(^)())failBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:PGYER_INFO_URL parameters:(@{@"shortcut":PGYER_SHORTCUT, @"_api_key": PGYER_APP_KEY}) success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"code"] isEqual: @0]) {
            self.latest = responseObject[@"data"][@"appVersion"];
            
            successBlock();
        }
        else {
            failBlock();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.errors addObject:error];

        failBlock();
    }];
}
@end