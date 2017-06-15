//
//  PSMessageDialog.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/11.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PSMessageDialog : NSObject

/// 黑底白字
+ (void)showMessageDialog:(NSString *)msg;

/// 白底黑字
+ (void)showMessageDialogWithBlackText:(NSString *)msg;

@end
