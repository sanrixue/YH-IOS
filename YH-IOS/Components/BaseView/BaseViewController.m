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
    
    self.user = [[User alloc] init];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:HTML_DIRNAME];
    }
}

#pragma  mark - assistant methods

- (NSString *)stringWithContentsOfFile:(NSString *)htmlPath {
    NSError *error = nil;
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"%@ - %@", error.description, htmlPath);
    }
    
    NSString *from, *to, *timestamp = TimeStamp;
    for(NSString *ext in @[@"js", @"css", @"png", @"gif"]) {
        from = [NSString stringWithFormat:@".%@\"", ext];
        to = [NSString stringWithFormat:@".%@?%@\"", ext, timestamp];
        
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:from withString:to options:NSCaseInsensitiveSearch range:NSMakeRange(0, htmlContent.length)];
    }
    
    return htmlContent;
}


- (void)clearBrowserCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *domain = [[NSURL URLWithString:self.urlString] host];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:domain]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
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


#pragma mark - status bar settings
- (BOOL)prefersStatusBarHidden {
    return NO;
}

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

@end
