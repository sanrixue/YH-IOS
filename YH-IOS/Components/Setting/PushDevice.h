//
//  PushDevice.h
//  YH-IOS
//
//  Created by li hao on 17/3/29.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushDevice : NSObject

@property(nonatomic,strong) NSString* deviceID;
@property(nonatomic,strong) NSString* deviceName;
@property(nonatomic,strong) NSString* os_version;
@property(nonatomic,strong) NSString* uuid;
@property(nonatomic,strong) NSString* device_token;
@property(nonatomic,strong) NSString* created_at;
@property(nonatomic,strong) NSString* device_os;

-(instancetype)initWithDict:(NSDictionary*)dict;


@end
