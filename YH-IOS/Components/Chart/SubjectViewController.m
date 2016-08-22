//
//  ChartViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//


#import "SubjectViewController.h"
#import "UMSocial.h"
#import "APIHelper.h"
#import "FileUtils+Report.h"
#import "CommentViewController.h"
#import "ReportSelectorViewController.h"

static NSString *const kCommentSegueIdentifier = @"ToCommentSegueIdentifier";
static NSString *const kReportSelectorSegueIdentifier = @"ToReportSelectorSegueIdentifier";

@interface SubjectViewController ()
@property (assign, nonatomic) BOOL isInnerLink;
@property (assign, nonatomic) BOOL isSupportSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) NSString *reportID;
@property (strong, nonatomic) NSString *templateID;
@property (strong, nonatomic) NSString *javascriptPath;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBannerView;
@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  被始化页面样式
     */
    [self idColor];
    self.bannerView.backgroundColor = [UIColor colorWithHexString:YH_COLOR];
    
    /**
     *  服务器内链接需要做缓存、点击事件处理；
     */
    self.isInnerLink = !([self.link hasPrefix:@"http://"] || [self.link hasPrefix:@"https://"]);
    self.urlString = self.link;
    
    self.browser.delegate = self;
    if(self.isInnerLink) {
        /*
         * /mobil/report/:report_id/group/:group_id
         * eg: /mobile/repoprt/1/group/%@
         */
        NSString *urlPath = [NSString stringWithFormat:self.link, self.user.groupID];
        self.urlString =[NSString stringWithFormat:@"%@%@", kBaseUrl, urlPath];
    }
    else {
        /*
         *  外部链接，支持手势放大缩小
         */
        self.browser.scalesPageToFit = YES;
        self.browser.contentMode = UIViewContentModeScaleAspectFit;
    }
    self.labelTheme.text = self.bannerName;
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ChartViewController - ObjC received message from JS: %@", data);
        responseCallback(@"ChartViewController - Response for message from ObjC");
    }];
    [self addWebViewJavascriptBridge];
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
    
    [self displayBannerViewButtonsOrNot];
    [self loadHtml];
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
    [self addWebViewJavascriptBridge];
    
    if(self.isInnerLink) {
        NSString *reportDataUrlString = [APIHelper reportDataUrlString:self.user.groupID templateID:self.templateID reportID:self.reportID];
        
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

- (void)displayBannerViewButtonsOrNot {
    self.btnShare.hidden = !kSubjectShare;
    self.btnComment.hidden = !kSubjectComment;
    self.btnSearch.hidden = YES;
    
    if(!kSubjectComment && !kSubjectShare) {
        self.btnSearch.frame = self.btnComment.frame; // CGRectMake(CGRectGetMaxX(self.btnSearch.frame) + 30, 0, 30, 55);
    }
}
- (void)addWebViewJavascriptBridge {
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
    
    [self.bridge registerHandler:@"searchItems" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *reportDataFileName = [NSString stringWithFormat:REPORT_DATA_FILENAME, self.user.groupID, self.templateID, self.reportID];
        NSString *javascriptFolder = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
        self.javascriptPath = [javascriptFolder stringByAppendingPathComponent:reportDataFileName];
        NSString *searchItemsPath = [NSString stringWithFormat:@"%@.search_items", self.javascriptPath];
        
        if(![FileUtils checkFileExist:searchItemsPath isDir:NO]) {
            [data[@"items"] writeToFile:searchItemsPath atomically:YES];
            
            /**
             *  判断筛选的条件: data[@"items"] 数组不为空
             *  报表第一次加载时，此处为判断筛选功能的关键点
             */
            self.isSupportSearch = [FileUtils reportIsSupportSearch:self.user.groupID templateID:self.templateID reportID:self.reportID];
            if(self.isSupportSearch) {
                [self displayBannerTitleAndSearchIcon];
            }
        }
    }];
    
    [self.bridge registerHandler:@"selectedItem" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *selectedItemPath = [NSString stringWithFormat:@"%@.selected_item", self.javascriptPath];
        NSString *selectedItem = NULL;
        if([FileUtils checkFileExist:selectedItemPath isDir:NO]) {
            selectedItem = [NSString stringWithContentsOfFile:selectedItemPath encoding:NSUTF8StringEncoding error:nil];
        }
        responseCallback(selectedItem);
    }];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
}

#pragma mark - assistant methods
- (void)loadHtml {
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        self.isInnerLink ? [self loadInnerLink] : [self loadOuterLink];
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

- (void)loadOuterLink {
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSString *appendParams = [NSString stringWithFormat:@"?user_num=%@&timestamp=%@", self.user.userNum, timestamp];
    
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
    /**
     *  only inner link clean browser cache
     */
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    
    /*
     * format: /mobile/v1/group/:group_id/template/:template_id/report/:report_id
     * deprecated
     * format: /mobile/report/:report_id/group/:group_id
     */
    NSArray *components = [self.link componentsSeparatedByString:@"/"];
    self.templateID = components[6];
    self.reportID = components[8];
    
    /**
     * 内部报表具有筛选功能时
     *   - 如果用户已选择，则 banner 显示该选项名称
     *   - 未设置时，默认显示筛选项列表中第一个
     *
     *  初次加载时，判断筛选功能的条件还未生效
     *  此处仅在第二次及以后才会生效
     */
    self.isSupportSearch = [FileUtils reportIsSupportSearch:self.user.groupID templateID:self.templateID reportID:self.reportID];
    if(self.isSupportSearch) {
        [self displayBannerTitleAndSearchIcon];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIHelper reportData:self.user.groupID templateID:self.templateID reportID:self.reportID];
        
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

- (void)displayBannerTitleAndSearchIcon {
    self.btnSearch.hidden = NO;
    
    NSString *reportSelectedItem = [FileUtils reportSelectedItem:self.user.groupID templateID:self.templateID reportID:self.reportID];
    if(reportSelectedItem == NULL || [reportSelectedItem length] == 0) {
        NSArray *reportSearchItems = [FileUtils reportSearchItems:self.user.groupID templateID:self.templateID reportID:self.reportID];
        if([reportSearchItems count] > 0) {
            reportSelectedItem = [reportSearchItems firstObject];
        }
        else {
            reportSelectedItem = [NSString stringWithFormat:@"%@(NONE)", self.labelTheme.text];
        }
    }
    self.labelTheme.text = reportSelectedItem;
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

- (IBAction)actionDisplaySearchItems:(id)sender {
    [self performSegueWithIdentifier:kReportSelectorSegueIdentifier sender:nil];
}

- (IBAction)actionWebviewScreenShot:(id)sender {
    UIWebView *webView = self.browser;
    
    // Setup the Image context. Special handling for retina.
    if ([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f) {
        UIGraphicsBeginImageContextWithOptions(webView.frame.size, NO, 2.0f);
    }
    else {
        UIGraphicsBeginImageContext(webView.frame.size);
    }
    
    // Render the web view
    [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Get the image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the graphics context
    UIGraphicsEndImageContext();
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.title = @"图表截图分享";
    [UMSocialData defaultData].extConfig.qqData.url = kBaseUrl;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMAppId
                                      shareText:self.bannerName
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession]
                                       delegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(self.isInnerLink) {
        [self loadHtml];
        [self.browser stopLoading];
    }
    
    if([segue.identifier isEqualToString:kCommentSegueIdentifier]) {
        CommentViewController *viewController = (CommentViewController *)segue.destinationViewController;
        viewController.bannerName        = self.bannerName;
        viewController.commentObjectType = self.commentObjectType;
        viewController.objectID          = self.objectID;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"点击/主题页面/评论";
            [APIHelper actionLog:logParams];
        });
    }
    else if([segue.identifier isEqualToString:kReportSelectorSegueIdentifier]) {
        ReportSelectorViewController *viewController = (ReportSelectorViewController *)segue.destinationViewController;
        viewController.bannerName  = self.bannerName;
        viewController.groupID     = self.user.groupID;
        viewController.reportID    = self.reportID;
        viewController.templateID  = self.templateID;
    }
}

#pragma mark - UIWebview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    /**
     *  忽略 NSURLErrorDomain 错误 - 999
     */
    if([error code] == NSURLErrorCancelled) return;
    
    NSLog(@"dvc: %@", error.description);
}

# pragma mark - 支持旋转 屏幕旋转 刷新页面
- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

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

#pragma mark - UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    @try {
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[@"action"] = [NSString stringWithFormat:@"微信分享(%d)", fromViewControllerType];
        logParams[@"obj_id"] = self.objectID;
        logParams[@"obj_type"] = @(self.commentObjectType);
        logParams[@"obj_title"] = self.bannerName;
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

// 下面得到分享完成的回调
// {
//    data = {
//        wxsession = "";
//    };
//    responseCode = 200;
//    responseType = 5;
//    thirdPlatformResponse = "<SendMessageToWXResp: 0x136479db0>";
//    viewControllerType = 3;
// }
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    @try {
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[@"action"] = [NSString stringWithFormat:@"微信分享完成(%d)", response.viewControllerType];
        logParams[@"obj_id"] = self.objectID;
        logParams[@"obj_type"] = @(self.commentObjectType);
        logParams[@"obj_title"] = self.bannerName;
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
@end
