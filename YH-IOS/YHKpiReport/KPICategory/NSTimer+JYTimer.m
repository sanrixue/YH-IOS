//
//  NSTimer+JYTimer.m
//  各种报表
//
//  Created by niko on 17/4/25.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "NSTimer+JYTimer.h"

@implementation NSTimer (JYTimer)

+ (NSTimer *)invocationWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(void))block {
    
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(executeInvocation:) userInfo:[block copy] repeats:YES];
}

+ (void)executeInvocation:(NSTimer *)timer {
    
    void (^block)(void)  = [timer userInfo];
    if (block) {
        block();
    }
}

@end
