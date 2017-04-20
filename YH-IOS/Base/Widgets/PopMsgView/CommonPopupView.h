//
//  CommonPopupView.h
//  ShenghuoJia
//
//  Created by Elwin on 15/7/28.
//  Copyright (c) 2015年 YongHui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CommonPopupViewConfirmBlock)(void);
typedef void (^CommonPopupViewCancelBlock)(void);

@interface CommonPopupView : UIView
{
    BOOL        disableUserInterfaced;
    CGFloat     incressedHeight;
}

@property (nonatomic,copy) CommonPopupViewCancelBlock dismissAction;
@property (nonatomic,copy) CommonPopupViewConfirmBlock confirmAction;
@property (nonatomic,retain) UIControl   *overlayView;;
@property BOOL  touchToDismiss;


- (void)fadeIn;
- (void)fadeOut;
- (void)fadeOutWithoutAnimation;

- (void)showInView:(UIView *)pView withOverlayView:(BOOL)overLay;
- (void)showInView:(UIView*)pView;
- (void)showInViewAtBottom:(UIView*)pView;


- (void)showFromBottomWithView:(UIView *)pView overLayColor:(UIColor *)overLayColor;
- (void)fadeOutToBottom;
- (void)showWithChangedWith:(float)width;
- (void)showWithoutAnimation;
- (void)show;
- (void)showAtBottom;
- (void)dismiss;
- (void)showWithoutKeyBoardNotification:(UIView *)view;
- (void)showWithoutKeyBoardNotification:(UIView *)view withOverLay:(BOOL)overLay;
- (void)keyboardWillChangeFrame:(NSNotification *)notification;

@end
