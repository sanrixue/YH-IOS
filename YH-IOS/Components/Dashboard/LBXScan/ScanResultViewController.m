//
//  ScanResultViewController.m
//  YH-IOS
//
//  Created by lijunjie on 16/06/07.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "ScanResultViewController.h"
#import "APIHelper.h"

@interface ScanResultViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBannerView;
@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  被始化页面样式
     */
    self.bannerView.backgroundColor = [UIColor colorWithHexString:YH_COLOR];
    [self idColor];
    
    [self loadHtml];
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
}

#pragma mark - assistant methods
- (void)loadHtml {
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        [self _loadHtml];
    }
    else if(deviceState == StateForbid) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"知道了" actionBlock:^(void) {
            [self jumpToLogin];
        }];
        
        [alert showError:self title:@"温馨提示" subTitle:@"您被禁止在该设备使用本应用" closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)_loadHtml {
    /**
     *  only inner link clean browser cache
     */
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIHelper barCodeScan:self.user.userID code:self.codeInfo type:self.codeType];
        
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"bar_code_scan_result" ofType:@"html"];
        NSString *htmlContent = [self stringWithContentsOfFile:htmlPath];
        [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
    });
}

#pragma mark - ibaction block
- (IBAction)actionBack:(id)sender {
    [super dismissViewControllerAnimated:YES completion:^{
        [self.browser stopLoading];
        [self.browser cleanForDealloc];
        self.browser.delegate = nil;
        self.browser = nil;
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
        self.bridge = nil;
    }];
}

@end
