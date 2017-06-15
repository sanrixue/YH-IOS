//
//  MyQuestion.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/14.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyQuestion :MTLModel<MTLJSONSerializing>

@property (nonatomic, assign)int requestID;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, assign)BOOL status;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong)NSArray *photos;


@end
