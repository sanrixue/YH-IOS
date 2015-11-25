//
//  ViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "LoginViewController.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "const.h"
#import <SSZipArchive.h>
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (strong, nonatomic) NSString *loginUrlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.browser.delegate = self;
    
    self.loginUrlString = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_PATH];
    self.assetsPath = [FileUtils dirPaths:@[ASSETS_DIRNAME, LOGIN_DIRNAME]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadHtml)];
    tapGesture.numberOfTapsRequired = 3;
    tapGesture.numberOfTouchesRequired = 1;
    [self.browser addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadHtml];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

/**
 *  core methods - 所有网络链接都缓存至本地
 *
 *  @param webView        <#webView description#>
 *  @param request        <#request description#>
 *  @param navigationType <#navigationType description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    
    if ([requestString hasPrefix:@"http://"] || [requestString hasPrefix:@"https://"]) {
        
        NSString *htmlPath = [HttpUtils urlConvertToLocal:requestString assetsPath:self.assetsPath];
        NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
        
        [_progressHUD hide:YES];
        return NO;
    }
    else if ([requestString hasPrefix:@"file://"]) {

    }
    
    return YES;
}

- (void)loadHtml {
    NSURL *url = [NSURL URLWithString:self.loginUrlString];
    NSString *assetsPath = [FileUtils dirPaths:@[ASSETS_DIRNAME, LOGIN_DIRNAME]];
    NSString *htmlName = [HttpUtils urlTofilename:[url.pathComponents componentsJoinedByString:@"/"] suffix:@".html"];
    NSString *htmlPath = [assetsPath stringByAppendingPathComponent:htmlName];
    
    [self showProgressHUD:@"loading..."];
    
    if([FileUtils checkFileExist:htmlPath isDir:NO]) {
        NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.browser loadRequest:[NSURLRequest requestWithURL:url]];
        
        [_progressHUD hide: YES];
    });
}

- (void)showProgressHUD:(NSString *)text {
    _progressHUD = [MBProgressHUD showHUDAddedTo:_browser animated:YES];
    _progressHUD.labelText = text;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}
@end
