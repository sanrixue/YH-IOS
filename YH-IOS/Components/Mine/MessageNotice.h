//
//  Notice.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface MessageNotice : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *abstracts;
@property (nonatomic, strong)NSString *time;
@property (nonatomic, assign)int noticeID;
@property (nonatomic, assign)int noticeType;
@property (nonatomic, assign)BOOL see;
@property (nonatomic, strong,readonly) NSString *content;

@end
