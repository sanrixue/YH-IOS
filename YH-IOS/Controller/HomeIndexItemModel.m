//
//  HomeIndexItemModel.m
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "HomeIndexItemModel.h"

@implementation HomeIndexItemSizeModel


@end

@implementation HomeIndexItemModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"items":@"HomeIndexItemModel"
             };
}

- (HomeIndexItemModel *)selctItem{
    for (HomeIndexItemModel* item in self.items) {
        if (item.select) {
            return item;
        }
    }
    if (self.items) {
        self.items[0].select = YES;
        return self.items[0];
    }
    return nil;
}
@end


