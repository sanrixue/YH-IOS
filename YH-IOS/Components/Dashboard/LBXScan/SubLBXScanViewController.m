//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "SubLBXScanViewController.h"
#import "MyQRViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import <SCLAlertView.h>
#import "ScanResultViewController.h"
#import "ManualInputViewController.h"

@interface SubLBXScanViewController ()
@end

@implementation SubLBXScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    self.isOpenInterestRect = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isQQSimulator) {
        [self drawBottomItems];
        [self drawTitle];
        [self.view bringSubviewToFront:_topTitle];
    }
    else {
        _topTitle.hidden = YES;
    }
}

// 标题
- (void)drawTitle {
    if (_topTitle) return;
    
    self.topTitle = [[UILabel alloc]init];
    _topTitle.bounds = CGRectMake(0, 0, 145, 40);
    _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 40);
    
    // 3.5 inch iphone
    if ([UIScreen mainScreen].bounds.size.height <= 568 ) {
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
        _topTitle.font = [UIFont systemFontOfSize:14];
    }
    
    _topTitle.textAlignment = NSTextAlignmentCenter;
    _topTitle.numberOfLines = 0;
    _topTitle.text = @"扫一扫";
    _topTitle.textColor = [UIColor whiteColor];
    
    [self.view addSubview:_topTitle];
    
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

- (void)drawBottomItems {
    if (_bottomItemsView) return;
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-130,
                                                                      CGRectGetWidth(self.view.frame), 130)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(60, 60);
    self.btnFlash = [[UIButton alloc] init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnFlash setTitle:@"开灯" forState:UIControlStateNormal];
    _btnFlash.titleLabel.font = [UIFont systemFontOfSize:14];
    _btnFlash.layer.borderWidth = 1;
    _btnFlash.layer.cornerRadius = 30;
    _btnFlash.layer.borderColor = [UIColor whiteColor].CGColor;
   //  [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc] init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setTitle:@"相册" forState:UIControlStateNormal];
    _btnPhoto.titleLabel.font = [UIFont systemFontOfSize:14];
    _btnPhoto.layer.borderWidth = 1;
    _btnPhoto.layer.cornerRadius = 30;
    _btnPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
   // [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
   // [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btnManualInput = [[UIButton alloc] init];
    _btnManualInput.bounds = _btnFlash.bounds;
    _btnManualInput.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) *3/4 , CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnManualInput setTitle:@"手工录入" forState:UIControlStateNormal];
    _btnManualInput.titleLabel.font = [UIFont systemFontOfSize:14];
    _btnManualInput.layer.cornerRadius = 30;
    _btnManualInput.layer.borderWidth = 1;
    _btnManualInput.layer.borderColor = [UIColor whiteColor].CGColor;
    [_btnManualInput setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // [_btnManualInput setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
    //[_btnManualInput setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor÷"] forState:UIControlStateHighlighted];
    [_btnManualInput addTarget:self action:@selector(manualInput) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
    [_bottomItemsView addSubview:_btnManualInput];
}

- (void)showError:(NSString*)str {
    [[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil] show];
}


- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array {
    
    if (array.count < 1) {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    LBXScanResult *scanResult = array[0];
    NSString *strResult = scanResult.strScanned;
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    // 声音提醒
    [LBXScanWrapper systemSound];
    
    // NSString *message = [NSString stringWithFormat:@"info: %@\ntype: %@", scanResult.strScanned, scanResult.strBarCodeType];
    // [[[UIAlertView alloc] initWithTitle:@"扫描结果" message:message delegate:nil cancelButtonTitle:@"晓得了" otherButtonTitles:nil] show];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanResultViewController *scanResultVC = (ScanResultViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ScanResultViewController"];
    scanResultVC.codeInfo = scanResult.strScanned;
    scanResultVC.codeType = scanResult.strBarCodeType;
    [self presentViewController:scanResultVC animated:YES completion:nil];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult {
    strResult = strResult ?: @"识别失败";
    
    __weak __typeof(self) weakSelf = self;
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert addButton:@"知道了" actionBlock:^(void) {
        //点击完，继续扫码
        [weakSelf reStartDevice];
    }];
    [alert showInfo:self title:@"扫码内容" subTitle:strResult closeButtonTitle:nil duration:0.0f];
}


#pragma mark -底部功能项

//打开相册
- (void)openPhoto {
    if ([LBXScanWrapper isGetPhotoPermission]) {
        [self openLocalPhoto];
    }
    else {
        [self showError:@"请到设置->隐私中开启本程序相册权限"];
    }
}

//开关闪光灯
- (void)openOrCloseFlash {
    [super openOrCloseFlash];
    
  //  NSString *imageName = [NSString stringWithFormat:@"CodeScan.bundle/qrcode_scan_btn_flash_%@", self.isOpenFlash ? @"down" : @"nor"];
  //  [_btnFlash setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

#pragma mark -底部功能项

- (void)myQRCode {
    MyQRViewController *vc = [MyQRViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

// 手动输入
- (void)manualInput {
    ManualInputViewController *manualInput = [[ManualInputViewController alloc]init];
    manualInput.fromViewController = @"click";
    [self presentViewController:manualInput animated:YES completion:nil];
}

@end
