//
//  MyQRViewController.m
//  LBXScanDemo
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "MyQRViewController.h"
#import "User.h"
#import "Version.h"
#import "LBXScanWrapper.h"
#import <ZYCornerRadius/UIImageView+CornerRadius.h>

@interface MyQRViewController ()

//二维码
@property (nonatomic, strong) UIView *qrView;
@property (nonatomic, strong) UIImageView* qrImgView;

@end

@implementation MyQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    [self drawTitle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //二维码
    CGFloat width = CGRectGetWidth(self.view.frame)*5/6;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - width)/2, (CGRectGetHeight(self.view.frame)-width)/2, width, width)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowRadius = 2;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.5;
    
    self.qrImgView = [[UIImageView alloc]init];
    _qrImgView.bounds = CGRectMake(0, 0, CGRectGetWidth(view.frame)-12, CGRectGetWidth(view.frame)-12);
    _qrImgView.center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2);
    [view addSubview:_qrImgView];
    self.qrView = view;
    
    [self createQR1];
}

// 标题
- (void)drawTitle {
    UILabel *topTitle = [[UILabel alloc]init];
    topTitle.bounds = CGRectMake(0, 0, 145, 40);
    topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 40);
    
    // 3.5 inch iphone
    if ([UIScreen mainScreen].bounds.size.height <= 568 ) {
        topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
        topTitle.font = [UIFont systemFontOfSize:14];
    }
    
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.numberOfLines = 0;
    topTitle.text = @"我的二维码";
    topTitle.textColor = [UIColor whiteColor];
    
    [self.view addSubview:topTitle];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.bounds = CGRectMake(145, 0, 40, 40);
    btn.center = CGPointMake(CGRectGetWidth(self.view.frame)-50, 40);
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionDismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (IBAction)actionDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createQR1 {
    _qrImgView.image = [LBXScanWrapper createQRWithString:[self userQRCode] size:_qrImgView.bounds.size];
    
    UIImageView* imageView = [self roundCornerWithImage:[UIImage imageNamed:@"AppIcon"] size:CGSizeMake(30, 30)];
    [LBXScanWrapper addImageViewLogo:_qrImgView centerLogoImageView:imageView logoSize:CGSizeMake(30, 30)];
}

- (UIImageView*)roundCornerWithImage:(UIImage*)logoImg size:(CGSize)size {
    //logo圆角
    UIImageView *backImage = [[UIImageView alloc] initWithCornerRadiusAdvance:6.0f rectCornerType:UIRectCornerAllCorners];
    backImage.frame = CGRectMake(0, 0, size.width, size.height);
    backImage.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logImage = [[UIImageView alloc] initWithCornerRadiusAdvance:6.0f rectCornerType:UIRectCornerAllCorners];
    logImage.image =logoImg;
    CGFloat diff  =2;
    logImage.frame = CGRectMake(diff, diff, size.width - 2 * diff, size.height - 2 * diff);
    [backImage addSubview:logImage];
    
    return backImage;
}

- (NSString *)userQRCode {
    User *user = [[User alloc] init];
    Version *version = [[Version alloc] init];

    return [NSString stringWithFormat:@"id=%@&name=%@&num=%@&app=%@(%@)&device=%@", user.userID, user.userNum, user.userNum, version.current, version.build, user.deviceID];
}
@end
