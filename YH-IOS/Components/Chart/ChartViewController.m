//
//  ChartViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "FileUtils.h"
#import "HttpUtils.h"
#import "const.h"
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"
#import "ChartViewController.h"

static NSString *const kDashbaordSegueIdentifer = @"ChartToDashboardSegueIdentifier";

@interface ChartViewController ()
@property WebViewJavascriptBridge* bridge;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (strong, nonatomic) NSString *chartUrlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (weak, nonatomic) IBOutlet UILabel *labelTheme;

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.chartUrlString = [NSString stringWithFormat:@"%@%@", BASE_URL, CHART_PATH];
    self.assetsPath = [FileUtils dirPaths:@[ASSETS_DIRNAME, CHART_DIRNAME]];
    
    self.labelTheme.text = self.chartTheme;
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
- (void)loadHtml {
    NSURL *url = [NSURL URLWithString:self.chartUrlString];
    NSString *htmlName = [HttpUtils urlTofilename:[url.pathComponents componentsJoinedByString:@"/"] suffix:@".html"];
    NSString *htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
    
    [self showProgressHUD:@"loading..."];
    
    if([FileUtils checkFileExist:htmlPath isDir:NO]) {
        NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([HttpUtils isNetworkAvailable]) {
            [self.browser loadRequest:[NSURLRequest requestWithURL:url]];
        }
        [_progressHUD hide: YES];
    });
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)actionBack:(id)sender {
    [self performSegueWithIdentifier:kDashbaordSegueIdentifer sender:nil];
}

- (void)showProgressHUD:(NSString *)text {
    _progressHUD = [MBProgressHUD showHUDAddedTo:_browser animated:YES];
    _progressHUD.labelText = text;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}@end
