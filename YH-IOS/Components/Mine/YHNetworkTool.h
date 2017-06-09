//
//  YHNetworkTool.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"


@interface YHNetworkTool : NSObject

+(instancetype)shareNetWorkTool;

-(Person *)loadUserInfo;

@end
