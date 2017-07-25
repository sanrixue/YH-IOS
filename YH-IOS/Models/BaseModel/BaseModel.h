//
//  BaseModel.h
//  iSearch
//
//  Created by lijunjie on 15/6/27.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//

#ifndef iSearch_BaseModel_h
#define iSearch_BaseModel_h
#import <UIKit/UIKit.h>
#import "Constant.h"

@interface BaseModel : NSObject

@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, assign) NSInteger curr_page;
@property (nonatomic, assign) NSInteger total_page;
@property (nonatomic, assign) BOOL isSelected;


+ (BOOL)handleResult:(id)model;

- (BOOL)isNoMore;

- (NSString *)to_s:(BOOL)isFormat;
- (NSString *)to_s;
- (NSString *)inspect;
- (NSString *)description;

@end

#endif
