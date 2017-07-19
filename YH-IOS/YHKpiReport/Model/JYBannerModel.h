//
//  JYBannerModel.h
//  各种报表
//
//  Created by niko on 17/5/13.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"

@interface JYBannerModel : JYModuleTwoBaseModel

@property (nonatomic, strong, readonly) NSString *date;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) id info;

@end
