//
//  UserInfoModel.m
//  YH-IOS
//
//  Created by li hao on 17/3/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

-(instancetype)initWithDict:(NSDictionary *)userdict{
    self  = [super init];
    if (self) {
        self.BarCodeScan_md5 = userdict[@"BarCodeScan_md5"];
        self.advertisement_md5 = userdict[@"advertisement_md5"];
        self.analyse_ids = userdict[@"analyse_ids"];
        self.app_ids = userdict[@"app_ids"];
        self.assets_md5 = userdict[@"assets_md5"];
        self.device_state = [userdict[@"device_state"] boolValue];
        self.device_uuid = userdict[@"device_uuid"];
        self.fonts_md5 = userdict[@"fonts_md5"];
        self.gesture_password = userdict[@"gesture_password"];
        self.gravator = userdict[@"gravatar"];
        self.group_id = [userdict[@"group_id"] integerValue];
        self.group_name = userdict[@"group_name"];
        self.images_md5 = userdict[@"images_md5"];
        self.is_login = [userdict[@"is_login"] boolValue];
        self.javascripts_md5 = userdict[@"javascripts_md5"];
        self.kpi_ids = userdict[@"kpi_ids"];
        self.loading_md5 = userdict[@"loading_md5"];
        self.local_BarCodeScan_md5 = userdict[@"local_BarCodeScan_md5"];
        self.local_assets_md5 = userdict[@"local_assets_md5"];
        self.local_fonts_md5 = userdict[@"local_fonts_md5"];
        self.local_images_md5 = userdict[@"local_images_md5"];
        self.local_javascripts_md5 = userdict[@"local_javascripts_md5"];
        self.local_loading_md5 = userdict[@"local_loading_md5"];
        self.local_stylesheets_md5 = userdict[@"local_stylesheets_md5"];
        self.role_id = [userdict[@"role_id"] integerValue];
        self.role_name = userdict[@"role_name"];
        self.store_ids = userdict[@"store_ids"];
        self.stylesheets_md5 = userdict[@"stylesheets_md5"];
        self.use_gesture_password = userdict[@"use_gesture_password"];
        self.user_device_id = [userdict[@"user_device_id"] integerValue];
        self.user_id = [userdict[@"user_id"] integerValue];
        self.user_md5 = userdict[@"user_md5"];
        self.user_name = userdict[@"user_name"];
        self.user_num = userdict[@"user_num"];
                         
    }
    return self;
}
@end
