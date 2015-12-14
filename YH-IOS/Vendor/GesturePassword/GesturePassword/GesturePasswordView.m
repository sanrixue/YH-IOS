//
//  GesturePasswordView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"
#import "FileUtils.h"
#import "const.h"

@implementation GesturePasswordView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
}
@synthesize imgView;
@synthesize forgetButton;
@synthesize changeButton;
@synthesize cancelButton;

@synthesize tentacleView;
@synthesize state;
@synthesize gesturePasswordDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-160, frame.size.height/2-80, 320, 320)];
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            
            NSInteger distance = 320/3;
            NSInteger size = distance/1.5;
            NSInteger margin = size/4;
            GesturePasswordButton * gesturePasswordButton = [[GesturePasswordButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance, size, size)];
            [gesturePasswordButton setTag:i];
            [view addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y=0;
        [self addSubview:view];
        tentacleView = [[TentacleView alloc]initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
        [self addSubview:tentacleView];
        
        state = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, frame.size.height/2-120, 280, 30)];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:14.f]];
        [self addSubview:state];
        
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-35, frame.size.width/2-80, 70, 70)];
        imgView.image = [UIImage imageNamed:@"AppIcon"];
        
        [imgView setBackgroundColor:[UIColor whiteColor]];
        [imgView.layer setCornerRadius:35];
        [imgView.layer setBorderColor:[UIColor grayColor].CGColor];
        [imgView.layer setBorderWidth:1];
        [imgView.layer setMasksToBounds:YES];
            
        [self addSubview:imgView];
        
        forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2-150, frame.size.height/2+220, 120, 30)];
        [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgetButton setTitle:@"忘记了密码？" forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchDown];
        [self addSubview:forgetButton];
        
        changeButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2+30, frame.size.height/2+220, 120, 30)];
        [changeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [changeButton setTitle:@"修改手势密码" forState:UIControlStateNormal];
        [changeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchDown];
        [self addSubview:changeButton];

        cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2+30, frame.size.height/2+220, 120, 30)];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"放弃修改" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:cancelButton];
        
        UIGraphicsBeginImageContext(self.frame.size);
        [[UIImage imageNamed:@"background"] drawInRect:self.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//
//    CGFloat colors[] =
//    {
//        125 / 255.0,  255 / 255.0, 95 / 255.0, 1.00,
//        83 / 255.0, 169 / 255.0, 63 / 255.0, 1.00,
//    };
//    CGGradientRef gradient = CGGradientCreateWithColorComponents
//    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
//    CGColorSpaceRelease(rgb);
//    CGContextDrawLinearGradient(context, gradient,CGPointMake
//                                (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
//                                kCGGradientDrawsBeforeStartLocation);
//}

- (void)gestureTouchBegin {
    [self.state setText:@""];
}

-(void)forget{
    [gesturePasswordDelegate forget];
}

-(void)change{
    [gesturePasswordDelegate change];
}

- (void)cancel {
    [gesturePasswordDelegate cancel];
}

- (void)setIsChangeGesturePassword:(BOOL)isChangeGesturePassword {

    forgetButton.hidden = isChangeGesturePassword;
    changeButton.hidden = isChangeGesturePassword;
    cancelButton.hidden = !isChangeGesturePassword;
    if(isChangeGesturePassword) {
        [self bringSubviewToFront:cancelButton];
    }
    else {
        [self bringSubviewToFront:changeButton];
    }

    _isChangeGesturePassword = isChangeGesturePassword;
}

@end
