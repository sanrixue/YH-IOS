//
//  NSTimer+JYTimer.h
//  各种报表
//
//  Created by niko on 17/4/25.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (JYTimer)

+ (NSTimer *)invocationWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(void))block;

@end
