//
//  User.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/9.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "User.h"
#import "FileUtils.h"

@implementation User

- (User *)init {
    if(self = [super init]) {
        NSString *configPath = [User configPath];
        if([FileUtils checkFileExist:configPath isDir:NO]) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:configPath];
            
            self.userName   = dict[@"user_name"];
            self.userNum    = dict[@"user_num"];
            self.password   = dict[@"user_md5"];
            self.gravatar   = dict[@"gravatar"];
            self.userID     = dict[@"user_id"];
            self.roleID     = dict[@"role_id"];
            self.roleName   = dict[@"role_name"];
            self.groupID    = dict[@"group_id"];
            self.groupName  = dict[@"group_name"];
            self.kpiIDs     = dict[@"kpi_ids"];
            self.analyseIDs = dict[@"analyse_ids"];
            self.appIDs     = dict[@"app_ids"];
            self.deviceID   = dict[@"user_device_id"];
        }
    }
    
    return self;
}

+ (NSString *)configPath {
    return [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
}

/**
 *  消息推送，当前设备的标签
 *
 *  @return 标签组
 */
+ (NSArray *)APNsTags {
    NSString *configPath = [User configPath];
    NSArray *tags = @[];
    if([FileUtils checkFileExist:configPath isDir:NO]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        tags = @[dict[@"role_name"], dict[@"group_name"]];
    }
    
    return tags;
}
/**
 *  消息推送，当前设备的别名
 *
 *  @return 别名组
 */
+ (NSString *)APNsAlias {
    NSString *configPath = [User configPath];
    NSString *alias = @"";
    if([FileUtils checkFileExist:configPath isDir:NO]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        alias = [NSString stringWithFormat:@"%@@%@", dict[@"user_name"], dict[@"user_num"]];
    }
    
    return alias;
}

@end
