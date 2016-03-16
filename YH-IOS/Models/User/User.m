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
            self.userID     = dict[@"user_id"];
            self.roleID     = dict[@"role_id"];
            self.roleName   = dict[@"role_name"];
            self.groupID    = dict[@"group_id"];
            self.groupName  = dict[@"group_name"];
            self.kpiIDs     = dict[@"kpi_ids"];
            self.analyseIDs = dict[@"analyse_ids"];
            self.appIDs     = dict[@"app_ids"];
        }
    }
    
    return self;
}

+ (NSString *)configPath {
    return [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
}

@end
