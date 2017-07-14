//
//  YHLocation.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/13.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHLocation : NSObject

@property(nonatomic, strong) NSString *userLongitude;
@property(nonatomic, strong) NSString *userlatitude;

+(instancetype)shareInstance;


-(void)startLocation;


@end
