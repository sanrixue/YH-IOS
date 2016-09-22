//
//  CommentViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/11.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "CommentViewController.h"
#import "APIHelper.h"

@interface CommentViewController ()
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    self.labelTheme.textColor = [UIColor colorWithHexString:kBannerTextColor];
    [self idColor];
    
    self.labelTheme.text = self.bannerName;
    self.urlString = [NSString stringWithFormat:kCommentMobilePath, kBaseUrl, [FileUtils currentUIVersion], self.objectID, @(self.commentObjectType)];
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Response for message from ObjC");
    }];
    
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName]   = @"JS异常";
                logParams[kObjIDALCName]    = self.objectID;
                logParams[kObjTypeALCName]  = @(self.commentObjectType);
                logParams[kObjTitleALCName] = [NSString stringWithFormat:@"评论页面/%@/%@", self.bannerName, data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    [self.bridge registerHandler:@"writeComment" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kObjTitleAPCCName] = self.bannerName;
        params[kUserNameAPCCName] = self.user.userName;
        params[kContentAPCCName]  = data[@"content"];
        BOOL isCreatedSuccessfully = [APIHelper writeComment:self.user.userID objectType:@(self.commentObjectType) objectID:self.objectID params:params];
        
        if(!isCreatedSuccessfully) {
            return;
        }
        
        [self loadHtml];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName]   = @"发表/评论";
                logParams[kObjTitleALCName] = self.bannerName;
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadHtml];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebview pull down to refresh
-(void)handleRefresh:(UIRefreshControl *)refresh {
    [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
    [self loadHtml];
    [refresh endRefreshing];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName]   = @"刷新/评论页面/浏览器";
        logParams[kObjTitleALCName] = self.urlString;
        [APIHelper actionLog:logParams];
    });
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
    self.labelTheme = nil;
}


#pragma mark - action methods
- (IBAction)actionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.browser stopLoading];
        [self.browser cleanForDealloc];
        self.browser.delegate = nil;
        self.browser = nil;
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
        self.bridge = nil;
        self.labelTheme = nil;
    }];
}

- (void)loadHtml {
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        [self _loadHtml];
    }
    else if(deviceState == StateForbid) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert addButton:kIAlreadyKnownText actionBlock:^(void) {
            [self jumpToLogin];
        }];
        
        [alert showError:self title:kWarningTitleText subTitle:kAppForbiedUseText closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)_loadHtml {
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
        
        __block NSString *htmlPath;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:kIsUrlWrite2Local];
        }
        else {
            NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
            htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
        });
    });
}

# pragma mark - 支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}
@end
