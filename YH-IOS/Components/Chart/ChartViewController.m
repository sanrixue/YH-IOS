//
//  ChartViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//


#import "ChartViewController.h"
#import "DashboardViewController.h"
#import "APIHelper.h"

static NSString *const kDashbaordSegueIdentifer = @"ChartToDashboardSegueIdentifier";

@interface ChartViewController ()
@property (assign, nonatomic) BOOL isInnerLink;
@property (weak, nonatomic) IBOutlet UILabel *labelTheme;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic)  NSString *reportID;
@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bannerView.backgroundColor = [UIColor colorWithHexString:YH_COLOR];
    
    self.isInnerLink = !([self.link hasPrefix:@"http://"] || [self.link hasPrefix:@"https://"]);
    self.urlString = self.isInnerLink ? [NSString stringWithFormat:@"%@%@", BASE_URL, self.link] : self.link;
    self.labelTheme.text = self.bannerName;
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [self.bridge registerHandler:@"refreshBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
        
        [self loadHtml];
    }];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadHtml];
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
}

#pragma mark - UIWebview pull down to refresh
-(void)handleRefresh:(UIRefreshControl *)refresh {
    if(self.isInnerLink) {
        NSString *reportDataUrlString = [APIHelper reportDataUrlString:@"1" reportID:self.reportID];
        
        [HttpUtils clearHttpResponeHeader:reportDataUrlString assetsPath:self.assetsPath];
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
    }
    [self loadHtml];
    [refresh endRefreshing];
}

#pragma mark - status bar settings
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - assistant methods
- (void)loadHtml {
    [self clearBrowserCache];
    
    self.isInnerLink ? [self loadInnerLink] : [self loadOuterLink];
}
- (void)loadOuterLink {
    [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}
- (void)loadInnerLink {
    [self showLoading];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([HttpUtils isNetworkAvailable]) {

            // format: /mobil/:report_id/report
            NSArray *components = [self.link componentsSeparatedByString:@"/"];
            self.reportID = components[2];
            [APIHelper reportData:@"1" reportID:self.reportID];
            
            HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
            
            NSString *htmlPath, *htmlContent;
            if([httpResponse.statusCode isEqualToNumber:@(200)]) {
                htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:URL_WRITE_LOCAL];
            }
            else {
                NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
                htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
            }
            
            htmlContent = [self stringWithContentsOfFile:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                
                [alert addButton:@"刷新" actionBlock:^(void) {
                    [self loadHtml];
                }];
                
                [alert showError:self title:@"温馨提示" subTitle:@"网络环境不稳定" closeButtonTitle:@"先这样" duration:0.0f];
            });
        }
    });
}

#pragma mark - ibaction block
- (IBAction)actionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        self.browser.delegate = nil;
        self.browser = nil;
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
        self.bridge = nil;
    }];
}

- (IBAction)actionWriteComment:(UIButton *)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    UITextField *textField = [alert addTextField:@"想说点什么呢~"];

    [alert addButton:@"确认"
     validationBlock:^BOOL {
         BOOL isValid = (textField.text && textField.text.length > 0);
         if(!isValid) {
             [self showProgressHUD:@"需说些什么，好提交"];
             self.progressHUD.mode = MBProgressHUDModeText;
             [self.progressHUD hide:YES afterDelay:2.0];
         }
         
         return isValid;
     }
     actionBlock:^(void) {
         NSLog(@"%@", textField.text);
         // 隐藏键盘
         [textField resignFirstResponder];
         [self showProgressHUD:@"提交中..."];
         
         [self.progressHUD hide:YES];
     }];
    
    NSString *subTitle = [NSString stringWithFormat:@"对【%@】有什么看法?", self.bannerName];
    [alert showInfo:self title:@"发表评论" subTitle:subTitle closeButtonTitle:@"取消" duration:0.0f];
}
# pragma mark - 登录界面不支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
#pragma mark - 屏幕旋转 刷新页面
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self loadHtml];
}


@end
