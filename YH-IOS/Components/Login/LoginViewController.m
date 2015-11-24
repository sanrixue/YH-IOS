//
//  ViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "LoginViewController.h"
#import "FileUtils.h"
#import <SSZipArchive.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *browser;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.browser.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadHtml)];
    tapGesture.numberOfTapsRequired = 3;
    tapGesture.numberOfTouchesRequired = 1;
    [self.browser addGestureRecognizer:tapGesture];
    
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"YH-HTML" ofType:@"zip"];
    NSString *basePath = [FileUtils basePath];
    NSString *htmlDir = [basePath stringByAppendingPathComponent:@"YH-HTML"];
    if(![FileUtils checkFileExist:htmlDir isDir:YES]) {
        
        if([FileUtils checkFileExist:zipPath isDir:NO]) {
            [SSZipArchive unzipFileAtPath:zipPath toDestination:basePath];
        }
        else {
            NSLog(@"zip file not exist: %@", zipPath);
        }
    }
    
    NSString *htmlPath = [htmlDir stringByAppendingPathComponent:@"login.html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.browser loadHTMLString:htmlContent baseURL:[NSURL URLWithString:htmlPath]];
    
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

    }
    else if ([requestString hasPrefix:@"file://"]) {

    }
    
    return YES;
}
- (void)loadHtml {
    NSString *basePath = [FileUtils basePath];
    NSString *htmlPath = [basePath stringByAppendingPathComponent:@"login.html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", htmlContent);
    [self.browser loadHTMLString:htmlContent baseURL:[[NSBundle mainBundle] bundleURL]];
//    [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]]];
}
@end
