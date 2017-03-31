//
//  UserInfoModel.h
//  YH-IOS
//
//  Created by li hao on 17/3/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property(nonatomic,strong) NSString* BarCodeScan_md5;
@property(nonatomic,strong) NSString* advertisement_md5;
@property(nonatomic,strong) NSArray* analyse_ids;
@property(nonatomic,strong) NSArray* app_ids;
@property(nonatomic,strong) NSString* assets_md5;
@property(nonatomic,assign) BOOL device_state;
@property(nonatomic,strong) NSString* device_uuid;
@property(nonatomic,strong) NSString* fonts_md5;
@property(nonatomic,strong) NSString* gesture_password;
@property(nonatomic,strong) NSString* gravator;
@property(nonatomic,assign) NSInteger group_id;
@property(nonatomic,strong) NSString* group_name;
@property(nonatomic,strong) NSString* images_md5;
@property(nonatomic,strong) NSString* iavascripts_md5;
@property(nonatomic,assign) BOOL is_login;
@property(nonatomic,strong) NSArray* kpi_ids;
@property(nonatomic,strong) NSString* loading_md5;
@property(nonatomic,strong) NSString* local_BarCodeScan_md5;
@property(nonatomic,strong) NSString* local_assets_md5;
@property(nonatomic,strong) NSString* local_fonts_md5;
@property(nonatomic,strong) NSString* local_images_md5;
@property(nonatomic,strong) NSString* local_javascripts_md5;
@property(nonatomic,strong) NSString* local_loading_md5;
@property(nonatomic,strong) NSString* local_stylesheets_md5;
@property(nonatomic,strong) NSString* role_name;
@property(nonatomic,assign) NSInteger role_id;
@property(nonatomic,strong) NSArray* store_ids;
@property(nonatomic,strong) NSString* stylesheets_md5;
@property(nonatomic,assign) BOOL use_gesture_password;
@property(nonatomic,strong) NSString* javascripts_md5;
@property(nonatomic,assign) NSInteger user_device_id;
@property(nonatomic,assign) NSInteger user_id;
@property(nonatomic,strong) NSString* user_md5;
@property(nonatomic,strong) NSString* user_name;
@property(nonatomic,strong) NSString* user_num;

-(instancetype)initWithDict:(NSDictionary*)userdict;

@end
