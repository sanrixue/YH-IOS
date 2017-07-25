//
//  ArticlesModel.m
//  YH-IOS
//
//  Created by cjg on 2017/7/25.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ArticlesModel.h"

@implementation ArticlesModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"list":@"ArticlesModel"
             };
}

- (BOOL)isNoMore{
    if (self.currPage == self.totalPage) {
        return YES;
    }
    if (self.totalPage == 1) {
        return YES;
    }
    return NO;
}

@end
