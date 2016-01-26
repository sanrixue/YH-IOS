//
//  BaseView.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [[User alloc] init];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:HTML_DIRNAME];
    }
}

#pragma  mark - assistant methods
- (void)idColor {
    NSArray *colors = @[@"ffffff", @"ffcd0a", @"fd9053", @"dd0929", @"016a43", @"9d203c", @"093db5", @"6a3906", @"192162", @"000000"];
    NSArray *colorViews = @[self.idColor0, self.idColor1, self.idColor2, self.idColor3, self.idColor4];
    NSString *userID = [NSString stringWithFormat:@"%@", self.user.userID];
    
    
    NSString *color;
    NSInteger userIDIndex, numDiff = colorViews.count - userID.length;
    UIImageView *imageView;
    
    numDiff = numDiff < 0 ? 0 : numDiff;
    for(NSInteger i = 0; i < colorViews.count; i++) {
        color = colors[0];
        if(i >= numDiff) {
            userIDIndex = [[NSString stringWithFormat:@"%c", [userID characterAtIndex:i-numDiff]] integerValue];
            color = colors[userIDIndex];
        }
        imageView = colorViews[i];
        imageView.image = [self imageWithColor:[UIColor colorWithHexString:color] size:CGSizeMake(5.0, 5.0)];
        imageView.layer.cornerRadius = 2.5f;
        imageView.layer.masksToBounds = YES;
        imageView.hidden = NO;
    }
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.idView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bannerView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-10.0f]];
}

- (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
    [color setFill];
    [rPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
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


- (void)jumpToLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    userDict[@"is_login"] = @(NO);
    [userDict writeToFile:userConfigPath atomically:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.view.window.rootViewController = loginViewController;
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
