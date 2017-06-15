//
//  zoomPopup.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface zoomPopup : NSObject

@property (nonatomic) CGFloat borderSize;
@property (nonatomic, strong) UIColor* borderColor;
@property (nonatomic) CGFloat shadowRadius;
@property  (nonatomic) CGFloat backGroundAlpha;
@property  (nonatomic) BOOL showCloseButton;
@property  (nonatomic) NSInteger blurRadius;


+ (zoomPopup*) sharedInstance;


+(void) initWithMainview: (UIView*) mainView andStartRect: (CGRect) rect;
+(void) showPopup: (UIView*) popupView ;
+(void) closePopup;

+(void) setBorderSize: (CGFloat) borderSize;
+(void)  setBorderColor: ( UIColor*) borderColor;
+(void) setShadowRadius: ( CGFloat) shadowRadius;
+(void) setBackgroundAlpha: (CGFloat) backGroundAlpha;
+(void) showCloseButton: (BOOL) showCloseButton;


-(id) initWithMainview: (UIView*) mainView andStartRect: (CGRect) rect;
-(void) showPopup: (UIView*) popupView ;
-(void) closePopup;

@end
