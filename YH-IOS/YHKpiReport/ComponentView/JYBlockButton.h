//
//  JYCloseButton.h
//  各种报表
//
//  Created by niko on 17/4/27.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callHander)(BOOL isSelected);

@class JYBlockButton;
@interface JYCallbackButtonHelper : NSObject


@property (nonatomic, copy) void(^handler)(BOOL isSelected);
@property (nonatomic, weak) JYBlockButton *button;

- (void)callBtnhandler;


@end




@interface JYBlockButton : UIButton

@property (nonatomic, copy) void(^handler)(BOOL isSelected);

@end
