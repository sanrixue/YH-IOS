//
//  BaseView.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.assetsPath = [FileUtils dirPath:HTML_DIRNAME];
}
- (void)showLoading {
    [self showLoading:NO];
}
- (void)showLoading:(BOOL)isLogin {
    NSString *loadingPath = [FileUtils loadingPath: isLogin];
    NSString *loadingContent = [NSString stringWithContentsOfFile:loadingPath encoding:NSUTF8StringEncoding error:nil];
    [self.browser loadHTMLString:loadingContent baseURL:[NSURL URLWithString:loadingPath]];
    
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void)showProgressHUD:(NSString *)text {
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.browser animated:YES];
    self.progressHUD.labelText = text;
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
#pragma mark - status bar settings

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self showProgressHUD:@"收到IOS系统，内存警告."];
    self.progressHUD.mode = MBProgressHUDModeText;
    [self.progressHUD hide:YES afterDelay:2.0];
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
}
@end
