//
//  TentacleView.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@protocol ResetDelegate <NSObject>

- (BOOL)resetPassword:(NSString *)result;

@end

@protocol VerificationDelegate <NSObject>

- (BOOL)verification:(NSString *)result;

@end

@protocol TouchBeginDelegate <NSObject>

- (void)gestureTouchBegin;

@end



@interface TentacleView : UIView

@property (nonatomic,strong) NSArray * buttonArray;

@property (nonatomic,assign) id<VerificationDelegate> rerificationDelegate;

@property (nonatomic,assign) id<ResetDelegate> resetDelegate;

@property (nonatomic,assign) id<TouchBeginDelegate> touchBeginDelegate;

/*
 1: Verify
 2: Reset
 */
@property (nonatomic,assign) NSInteger style;

- (void)enterArgin;

@end
