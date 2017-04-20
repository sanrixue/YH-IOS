//
//  DataManager.m
//  JinXiaoEr
//
//  Created by CJG on 16/12/23.
//
//

#import "DataManager.h"

@implementation DataManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.role_type = UserTypeDriver;
    }
    return self;
}

+ (instancetype)shareInstance{
    ShareInstanceWithClass(DataManager);
}





@end
