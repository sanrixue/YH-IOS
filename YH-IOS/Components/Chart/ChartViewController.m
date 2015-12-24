//
//  ChartViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//


#import "ChartViewController.h"
#import "APIHelper.h"
#import "CommentViewController.h"

static NSString *const kCommentSegueIdentifier = @"ToCommentSegueIdentifier";

@interface ChartViewController ()
@property (assign, nonatomic) BOOL isInnerLink;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic)  NSString *reportID;
@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bannerView.backgroundColor = [UIColor colorWithHexString:YH_COLOR];
    [self idColor];
    
    self.isInnerLink = !([self.link hasPrefix:@"http://"] || [self.link hasPrefix:@"https://"]);
    
    self.urlString = self.link;
    if(self.isInnerLink) {
        /*
           /mobil/report/:report_id/group/:group_id
           eg: /mobile/repoprt/1/group/%@
         */
        NSString *urlPath = [NSString stringWithFormat:self.link, self.user.groupID];
        self.urlString =[NSString stringWithFormat:@"%@%@", BASE_URL,urlPath];
    }
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
    
    [self.bridge registerHandler:@"pageTabIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *tabIndexConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:TABINDEX_CONFIG_FILENAME];
        NSMutableDictionary *tabIndexDict = [FileUtils readConfigFile:tabIndexConfigPath];
        
        NSString *action = data[@"action"], *pageName = data[@"pageName"];
        NSNumber *tabIndex = data[@"tabIndex"];
        
        if([action isEqualToString:@"store"]) {
            tabIndexDict[pageName] = tabIndex;
            
            [tabIndexDict writeToFile:tabIndexConfigPath atomically:YES];
        }
        else if([action isEqualToString:@"restore"]) {
            tabIndex = tabIndexDict[pageName] ?: @(0);
            
            responseCallback(tabIndex);
        }
        else {
            NSLog(@"unkown action %@", action);
        }
    }];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.

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
        NSString *reportDataUrlString = [APIHelper reportDataUrlString:self.user.groupID reportID:self.reportID];
        
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
    
    if([HttpUtils isNetworkAvailable]) {
        if([APIHelper deviceState]) {
            [self _loadHtml];
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:@"知道了" actionBlock:^(void) {
                [self jumpToLogin];
            }];
            [alert showError:self title:@"温馨提示" subTitle:@"您被禁止在该设备使用本应用" closeButtonTitle:nil duration:0.0f];
        }
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
}

- (void)_loadHtml {
    [self clearBrowserCache];
    
    self.isInnerLink ? [self loadInnerLink] : [self loadOuterLink];
}
- (void)loadOuterLink {
    if([self.urlString containsString:@"?"]) {
        self.urlString = [self.urlString stringByReplacingOccurrencesOfString:@"?" withString:[NSString stringWithFormat:@"?userid=%@&", self.user.userID]];
    }
    else {
        self.urlString = [NSString stringWithFormat:@"%@?userid=%@", self.urlString, self.user.userID];
    }
    NSLog(@"%@", self.urlString);
    [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}
- (void)loadInnerLink {
    [self showLoading];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([HttpUtils isNetworkAvailable]) {

            // format: /mobil/report/:report_id/group/:group_id
            NSArray *components = [self.link componentsSeparatedByString:@"/"];
            self.reportID = components[3];
            [APIHelper reportData:self.user.groupID reportID:self.reportID];
            
            HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
            
            __block NSString *htmlPath;
            if([httpResponse.statusCode isEqualToNumber:@(200)]) {
                htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:URL_WRITE_LOCAL];
            }
            else {
                NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
                htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *htmlContent = [self stringWithContentsOfFile:htmlPath];
                [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[FileUtils sharedPath]]];
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
    [self performSegueWithIdentifier:kCommentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kCommentSegueIdentifier]) {
        CommentViewController *commentViewController = (CommentViewController *)segue.destinationViewController;
        commentViewController.bannerName        = self.bannerName;
        commentViewController.commentObjectType = self.commentObjectType;
        commentViewController.objectID          = self.objectID;
    }
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
