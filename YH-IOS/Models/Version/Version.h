//
//  SlideUtils.h
//  iSearch
//
//  Created by lijunjie on 15/6/22.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//

#ifndef iSearch_Version_h
#define iSearch_Version_h
#import "BaseModel.h"
/**
 *  版本控件:
 *    1. fir.im获取最新版本，并写入本地
 *    2. 对比当前app版本
 *    3. 不一致则提示更新
 *
 */
@interface Version : BaseModel

// firm.im attributes
@property (nonatomic, strong) NSString *latest;
@property (nonatomic, strong) NSString *insertURL;
@property (nonatomic, strong) NSString *changeLog;
// local attribute
@property (nonatomic, strong) NSString *current;
@property (nonatomic, strong) NSString *build;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *suport;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *sdkName;
@property (nonatomic, strong) NSString *bundleID;

// backup
@property (nonatomic, strong) NSString *path; // config path
@property (nonatomic, strong) NSMutableDictionary *dict;

// local fields
@property (nonatomic, strong) NSMutableArray *errors;
@property (nonatomic, strong) NSString *dbVersion;
@property (nonatomic, strong) NSString *fileSystemSize;
@property (nonatomic, strong) NSString *fileSystemFreeSize;
@property (nonatomic, strong) NSString *localCreatedDate;
@property (nonatomic, strong) NSString *localUpdatedDate;


// instance methods
- (NSString *)simpleDescription;
+ (NSString *)machine;
+ (NSString *)machineHuman;
- (BOOL)isUpgrade;

@end
#endif
