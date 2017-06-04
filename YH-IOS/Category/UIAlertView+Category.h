//
//  UIAlertView+Category.h
//  haofang
//
//  Created by Aim on 14-4-28.
//  Copyright (c) 2014年 iflysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Category)

+ (void)showAlert:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate;

// hides alert sheet or popup. use this method when you need to explicitly dismiss the alert.
// it does not need to be called if the user presses on a button
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex;
@end
