//
//  SelectDataModel.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SelectDataModel.h"

@implementation SelectDataModel

-(id)initWithFirst:(NSString *)firstsection withSeconArray:(NSDictionary*) secondArray{
    self = [self init];
    if (!self) {
        return nil;
    }
    self.firstSection = firstsection;
    self.seconSection = [[NSMutableArray alloc]init];
    [self.seconSection addObject:secondArray];
    return self;
    
}
@end
