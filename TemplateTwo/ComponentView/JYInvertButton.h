//
//  JYInvertButton.h
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 排序反转按钮 */
@interface JYInvertButton : UIView

@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, copy) void (^inverHandler)(NSString *type, BOOL selected);

- (void)recoverIconTransform;

@end
