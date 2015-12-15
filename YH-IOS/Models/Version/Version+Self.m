//
//  Version+Self.m
//  iSearch
//
//  Created by lijunjie on 15/7/9.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Version+Self.h"
#import "AFNetworking.h"

#define VERSION_URL @"https://tems.takeda.com.cn/iSearch/iSearch.plist"

@implementation Version (Self)

- (void)checkUpdate:(void(^)())successBlock FailBloc:(void(^)())failBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:VERSION_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* plistData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *error;
        NSPropertyListFormat format;
        NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
        
        self.insertURL = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", VERSION_URL];
        self.changeLog = plist[@"items"][0][@"metadata"][@"changelog"];
        self.changeLog = self.changeLog ?: @"未设置";
        [self updateTimestamp];
        // setLatest is trick
        self.latest = plist[@"items"][0][@"metadata"][@"version"];
        
        if([self isUpgrade] && successBlock) {
            successBlock();
        } else {
            NSLog(@"lastestVersion: %@, current version: %@", self.latest, self.current);
            if(failBlock) {
                failBlock();
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failBlock();
    }];
}
@end