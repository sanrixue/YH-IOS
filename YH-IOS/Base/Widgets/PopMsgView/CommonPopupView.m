//
//  CommonPopupView.m
//  ShenghuoJia
//
//  Created by Elwin on 15/7/28.
//  Copyright (c) 2015年 YongHui. All rights reserved.
//

#import "CommonPopupView.h"


@interface CommonPopupView()
- (void)initIt;
- (NSInteger)getKeyBoardHeight:(NSNotification *)notification;
@property (nonatomic, strong)UIView *showFromView;
@property (nonatomic, assign)CGRect selfOrginFrame;
@end

@implementation CommonPopupView

@synthesize touchToDismiss = _touchToDismiss;
@synthesize dismissAction = _dismissAction;
@synthesize confirmAction = _confirmAction;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initIt];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initIt];
}

- (void)initIt
{
    _selfOrginFrame = self.frame;
    incressedHeight = 0.0f;
    disableUserInterfaced = NO;
    self.touchToDismiss = YES;
    self.layer.cornerRadius = 1.0f;
    self.clipsToBounds = TRUE;
    [self regNotification];
}

- (void)dealloc
{
    [self unregNotification];
}

#pragma mark - animations
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];

}
- (void)fadeOut
{
    _showFromView = nil;

    //    dispatch_async(dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
    //    });
}
- (void)fadeOutWithoutAnimation
{
    _showFromView = nil;

    self.alpha = 0.0;
    [_overlayView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)pView withOverlayView:(BOOL)overLay{
    _showFromView = pView;
    _overlayView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, pView.frame.size.width, pView.frame.size.height)];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    if (overLay) {
        [pView addSubview:_overlayView];
    }
    if(self.touchToDismiss)
    {
        [_overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];
        [pView addSubview:_overlayView];
    }
    [pView addSubview:self];
    [pView bringSubviewToFront:self];
    
    self.center = CGPointMake(pView.bounds.size.width/2.0f,pView.bounds.size.height/2.0f);
    
    [self fadeIn];
}

- (void)showInView:(UIView*)pView
{
    [self showInView:pView withOverlayView:NO];
    
}

- (void)showInViewAtBottom:(UIView*)pView
{
    _showFromView = pView;
    _overlayView = [[UIControl alloc] initWithFrame:pView.frame];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    
    if(self.touchToDismiss)
    {
        [_overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    [pView addSubview:_overlayView];
    [pView addSubview:self];
    [pView bringSubviewToFront:self];
    
    
    self.center = CGPointMake(pView.bounds.size.width/2.0f,pView.frame.size.height - self.frame.size.height/2);
    [self fadeIn];
}

- (void)showWithoutKeyBoardNotification:(UIView *)view
{
    [self unregNotification];
    [self showInView:view withOverlayView:YES];
}

- (void)showWithoutKeyBoardNotification:(UIView *)view withOverLay:(BOOL)overLay
{
    [self unregNotification];
    [self showInView:view withOverlayView:overLay];
}
- (void)show
{
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    
    if(self.touchToDismiss)
    {
        [_overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIWindow *keywindow = [AppDelegate shareAppdelegate].window;
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    [keywindow bringSubviewToFront:self];
    _showFromView = keywindow;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + incressedHeight);
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,keywindow.bounds.size.height/2.0f);
    
    [self fadeIn];
    
}

- (void)showFromBottomWithView:(UIView *)pView overLayColor:(UIColor *)overLayColor;
{
    _showFromView = pView;

    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];

    _showFromView = pView;
    
    if (overLayColor) {
        _overlayView.backgroundColor = overLayColor;
    }
    
    if(self.touchToDismiss)
    {
        [_overlayView addTarget:self
                         action:@selector(fadeOutToBottom)
               forControlEvents:UIControlEventTouchUpInside];
    }
//    float scale = self.frame.size.width/self.frame.size.height;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);

    
    [pView addSubview:_overlayView];
    [pView addSubview:self];
    [pView bringSubviewToFront:self];
    
    self.center = CGPointMake(pView.bounds.size.width/2.0f,pView.frame.size.height + self.frame.size.height/2);
    
    self.transform = CGAffineTransformMakeScale(1, 1);
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.center = CGPointMake(pView.bounds.size.width/2.0f,pView.frame.size.height - self.frame.size.height/2);        
    }];
}

- (void)fadeOutToBottom
{
    if (_dismissAction) {
        _dismissAction();
    }
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.center = CGPointMake(self.center.x,_showFromView.frame.size.height+self.frame.size.height/2);

        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
            _showFromView = nil;

        }
    }];}

- (void)showWithChangedWith:(float)width
{
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    
    if(self.touchToDismiss)
    {
        [_overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIWindow *keywindow = [AppDelegate shareAppdelegate].window;
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    [keywindow bringSubviewToFront:self];
    _showFromView = keywindow;

    float scale = self.frame.size.width/self.frame.size.height;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, width/scale + incressedHeight);
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,keywindow.bounds.size.height/2.0f);
    
    [self fadeIn];
}

- (void)showWithoutAnimation
{
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    
    if(self.touchToDismiss)
    {
        [_overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIWindow *keywindow = [AppDelegate shareAppdelegate].window;
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    [keywindow bringSubviewToFront:self];
    _showFromView = keywindow;

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + incressedHeight);
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,keywindow.bounds.size.height/2.0f);
    self.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    self.alpha = 1.0f;
    [UIView commitAnimations];
    //        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    //        self.alpha = 0;
    //        [UIView animateWithDuration:.35 animations:^{
    //            self.alpha = 1;
    //            self.transform = CGAffineTransformMakeScale(1, 1);
    //        }];
}

- (void)showAtBottom
{
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    
    if(self.touchToDismiss)
    {
        [_overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIWindow *keywindow = [AppDelegate shareAppdelegate].window;
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    [keywindow bringSubviewToFront:self];
    
    _showFromView = keywindow;

    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,keywindow.frame.size.height - self.frame.size.height/2);
    [self fadeIn];
}

- (void)dismiss
{
    [CurAppDelegate.window setUserInteractionEnabled:YES];
    if (_dismissAction) {
        _dismissAction();
    }
    if(disableUserInterfaced)
        return;
    [self fadeOut];
}


#pragma mark - keyboard notification
- (NSInteger)getKeyBoardHeight:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSInteger keyboardHeight = keyboardFrameBeginRect.size.height;
    return keyboardHeight;
}

- (void)keyboardWillShowAction:(NSNotification *)notification
{
    UIView *keywindow;
    if (!_showFromView) {
        keywindow = [AppDelegate shareAppdelegate].window;
    }
    keywindow = _showFromView;
    NSInteger keyboardHeight;
    keyboardHeight = [self getKeyBoardHeight:notification];
    
    NSDictionary* keyboardInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    NSInteger movement = MAX(0,(self.frame.origin.y+self.frame.size.height + keyboardHeight) - keywindow.frame.size.height);
    
    DLog(@"movement=========%d",movement);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.center = CGPointMake(self.center.x, self.center.y - movement);
        
        [UIView commitAnimations];
    });
}


#pragma mark - reg & unreg notification

- (void)regNotification
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];


}

- (void)unregNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - notification handler

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    DLog(@">>>>>>>frame:%@",NSStringFromCGRect(self.frame));
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    yOffset = fabs(yOffset);
    CGFloat heightToBottom =_showFromView.frame.size.height - (self.frame.size.height/2 + _showFromView.frame.size.height/2);
    if(heightToBottom > yOffset) {
        return;
    }
    if(endKeyboardRect.origin.y - beginKeyboardRect.origin.y < yOffset) {
        //上升
        yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y + heightToBottom;
    }
    else {
        //下降
        yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y - heightToBottom;
    }
    DLog(@"=====%f",yOffset);
    [UIView animateWithDuration:duration animations:^{

        self.center = CGPointMake(self.center.x, self.center.y + yOffset) ;//self.center.y+yOffset);
        DLog(@">>>>>>>frame:%@=================",NSStringFromCGRect(self.frame));

    }];
}


@end
