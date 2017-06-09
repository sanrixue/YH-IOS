//
//  Person.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface Person : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *userNamer;
@property (nonatomic, strong, readonly) NSString *userRole;
@property (nonatomic, strong, readonly) NSString *groupId;
@property (nonatomic, strong, readonly) NSString *lastlocation;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *days;
@property (nonatomic, strong) NSString *readed_num;
@property (nonatomic, strong) NSString *precent;
@property (nonatomic, strong) NSURL *icon;

@end
