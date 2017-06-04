//
//  MainViewController.h
//  YH-IOS
//
//  Created by li hao on 17/4/11.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTHPasscodeViewController.h"

@interface MainViewController : UIViewController<LTHPasscodeViewControllerDelegate>

#pragma mark - LTHPasscode delegate methods
- (void)passcodeWasEnteredSuccessfully;
- (BOOL)didPasscodeTimerEnd;
- (NSString *)passcode;
- (void)savePasscode:(NSString *)passcode;

@end
