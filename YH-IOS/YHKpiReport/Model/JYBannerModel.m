//
//  JYBannerModel.m
//  各种报表
//
//  Created by niko on 17/5/13.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBannerModel.h"

@implementation JYBannerModel

- (NSString *)date {
    return self.configInfo[@"date"];
}

- (NSString *)title {
    return self.configInfo[@"title"];
}

- (id)info {
    return self.configInfo[@"info"];
}

@end
