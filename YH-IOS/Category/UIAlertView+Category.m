//
//  UIAlertView+Category.m
//  haofang
//
//  Created by Aim on 14-4-28.
//  Copyright (c) 2014年 iflysoft. All rights reserved.
//

#import "UIAlertView+Category.h"
#import "NSString+Category.h"

@implementation UIAlertView (Category)

+ (void)showAlert:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate{
    if (message.trim.length>0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:delegate
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex {
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}
@end
