//
//  PushDevice.m
//  YH-IOS
//
//  Created by li hao on 17/3/29.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "PushDevice.h"

@implementation PushDevice

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.deviceID = dict[@"id"];
        self.deviceName = dict[@"name"];
        self.device_os = dict[@"os"];
        self.os_version = dict[@"os_version"];
        self.uuid = dict[@"uuid"];
        self.device_token  =dict[@"device_token"];
        self.created_at = dict[@"created_at"];
    }
    return self;
}

@end
