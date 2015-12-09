//
//  User.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/9.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *roleID;
@property (strong, nonatomic) NSArray *kpiIDs;
@property (strong, nonatomic) NSArray *analyseIDs;
@property (strong, nonatomic) NSArray *appIDs;

+ (NSString *)configPath;
@end
