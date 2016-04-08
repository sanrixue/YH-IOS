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
#import "constant.h"

@interface BaseModel : NSObject

- (NSString *)to_s:(BOOL)isFormat;
- (NSString *)to_s;
- (NSString *)inspect;
- (NSString *)description;

@end

#endif
