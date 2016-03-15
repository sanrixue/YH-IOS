//
//  ChartViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//


#import "SubjectViewController.h"
#import "APIHelper.h"
#import "CommentViewController.h"

static NSString *const kCommentSegueIdentifier = @"ToCommentSegueIdentifier";

@interface SubjectViewController ()
@property (assign, nonatomic) BOOL isInnerLink;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) NSString *reportID;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBannerView;
@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  被始化页面样式
     */
    self.bannerView.backgroundColor = [UIColor colorWithHexString:YH_COLOR];
    [self idColor];
    
    /**
     *  服务器内链接需要做缓存、点击事件处理；
     */
    self.isInnerLink = !([self.link hasPrefix:@"http://"] || [self.link hasPrefix:@"https://"]);
    
    self.urlString = self.link;
    if(self.isInnerLink) {
        /*
         * /mobil/report/:report_id/group/:group_id
         * eg: /mobile/repoprt/1/group/%@
         */
        NSString *urlPath = [NSString stringWithFormat:self.link, self.user.groupID];
        self.urlString =[NSString stringWithFormat:@"%@%@", BASE_URL,urlPath];
    }
    self.labelTheme.text = self.bannerName;
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ChartViewController - ObjC received message from JS: %@", data);
        responseCallback(@"ChartViewController - Response for message from ObjC");
    }];
    
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[@"action"] = @"JS异常";
                logParams[@"obj_id"] = self.objectID;
                logParams[@"obj_type"] = @(self.commentObjectType);
                logParams[@"obj_title"] = [NSString stringWithFormat:@"主题页面/%@/%@", self.bannerName, data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*
     * 主题页面,允许横屏
     */
    [self setAppAllowRotation:YES];
    
    /**
     *  横屏时，隐藏标题栏，增大可视区范围
     */
    [self checkInterfaceOrientation: [[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    /*
     * 其他页面,禁用横屏
     */
    [self setAppAllowRotation:NO];
}

- (void)dealloc {
    [self.browser cleanForDealloc];
    [self.browser stopLoading];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"刷新/主题页面/浏览器";
            logParams[@"obj_title"] = self.urlString;
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
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
    NSString *appendParams = [NSString stringWithFormat:@"?userid=%@&timestamp=%@", self.user.userID, TimeStamp];
    
    if([self.urlString containsString:@"?"]) {
        self.urlString = [self.urlString stringByReplacingOccurrencesOfString:@"?" withString:appendParams];
    }
    else {
        self.urlString = [NSString stringWithFormat:@"%@%@", self.urlString, appendParams];
    }
    
    NSLog(@"%@", self.urlString);
    [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)loadInnerLink {
    [self showLoading:LoadingLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
        });
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

- (IBAction)actionWriteComment:(UIButton *)sender {
    [self performSegueWithIdentifier:kCommentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(self.isInnerLink) {
        [self loadHtml];
        [self.browser stopLoading];
    }
    
    if([segue.identifier isEqualToString:kCommentSegueIdentifier]) {
        CommentViewController *commentViewController = (CommentViewController *)segue.destinationViewController;
        commentViewController.bannerName        = self.bannerName;
        commentViewController.commentObjectType = self.commentObjectType;
        commentViewController.objectID          = self.objectID;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"点击/主题页面/评论";
            [APIHelper actionLog:logParams];
        });
    }
}

# pragma mark - 支持旋转
- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - 屏幕旋转 刷新页面
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self checkInterfaceOrientation:toInterfaceOrientation];

    [self loadHtml];
}

/**
 *  横屏时，隐藏标题栏，增大可视区范围
 *
 *  @param interfaceOrientation 设备屏幕放置方向
 */
- (void)checkInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation);
    
    //self.bannerView.hidden = isLandscape;
    [[UIApplication sharedApplication] setStatusBarHidden:isLandscape withAnimation:NO];
    
    self.layoutConstraintBannerView.constant = (isLandscape ? -55 : 0);
    [self.view layoutIfNeeded];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

#pragma mark - bug#fix
/**
 
     2015-12-25 10:08:20.848 YH-IOS[52214:1924885] http://izoom.mobi/demo/upload.html?userid=3026
     2015-12-25 10:08:27.117 YH-IOS[52214:1924885] Passed in type public.item doesn't conform to either public.content or public.data. If you are exporting a new type, please ensure that it conforms to an appropriate parent type.
     2015-12-25 10:08:27.189 YH-IOS[52214:1924885] the behavior of the UICollectionViewFlowLayout is not defined because:
     2015-12-25 10:08:27.190 YH-IOS[52214:1924885] the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values.
     2015-12-25 10:08:30.497 YH-IOS[52214:1924885] Warning: Attempt to present <UIImagePickerController: 0x7f857a84b000> on <ChartViewController: 0x7f857b8daa60> whose view is not in the window hierarchy!
 *
 *  @return <#return value description#>
 */
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if(self.presentedViewController) {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

#pragma mark - UIWebview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        NSLog(@"request: %@", url);
        if (![[url scheme] hasPrefix:@";file"]) {
            [[UIApplication sharedApplication] openURL:url];
            return NO;
        }
    }
    
    return YES;
}
@end
