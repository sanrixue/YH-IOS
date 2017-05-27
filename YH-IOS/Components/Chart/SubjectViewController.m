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
#import "DropTableViewCell.h"
#import "DropViewController.h"


static NSString *const kCommentSegueIdentifier        = @"ToCommentSegueIdentifier";
static NSString *const kReportSelectorSegueIdentifier = @"ToReportSelectorSegueIdentifier";

@interface SubjectViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UINavigationControllerDelegate,UIWebViewDelegate>
{
    NSMutableDictionary *betaDict;
    NSString *originlink;
}

@property (assign, nonatomic) BOOL isInnerLink;
@property (assign, nonatomic) BOOL isSupportSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) NSString *reportID;
@property (strong, nonatomic) NSString *templateID;
@property (strong, nonatomic) NSString *javascriptPath;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBannerView;
@property (strong, nonatomic) NSArray *dropMenuTitles;
@property (strong, nonatomic) NSArray *dropMenuIcons;
@property (strong, nonatomic) NSMutableArray *dropMenuLinks;
@property (assign, nonatomic) BOOL isLoadFinish;
@property (strong, nonatomic) NSMutableArray *webArray;
@property (strong, nonatomic) NSMutableDictionary *titieDict;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *SettingBtn;
@property (assign, nonatomic) BOOL isDropMenu;
@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    self.isLoadFinish = NO;
    self.isDropMenu = NO;
    [self initTitleDictionary];
    /**
     * 被始化页面样式
     */
    [self idColor];
    // self.link = @"http://123.56.91.131:8090/syp_v1_direction";
    self.isInnerLink = [self.link hasPrefix:@"offline://"] || (![self.link hasPrefix:@"http"] && ![self.link hasPrefix:@"https"]);
    self.bannerView.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    self.labelTheme.textColor = [UIColor colorWithHexString:@"000000"];
    /**
     * 服务器内链接需要做缓存、点击事件处理；
     */
    self.urlString   = self.link;
    self.webArray = [[NSMutableArray alloc]init];
    [self.webArray addObject:self.link];
    self.browser.delegate = self;
    originlink = self.link;
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
    [self.idView setHidden:YES];
    // self.labelTheme.text = self.bannerName;
    [self loadHtml];
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"SubjectViewController - Response for message from ObjC");
    }];
    [self addWebViewJavascriptBridge];
    [self.SettingBtn setImage:[UIImage imageNamed:@"subRefresh"] forState:UIControlStateNormal];
}



- (void)initTitleDictionary {
    NSDictionary *titleDictionary = @{@"devices.html":@"设备巡检列表",@"device.new.html":@"新建巡检工单",@"device.view.html":@"设备巡检报告",@"meters.html":@"仪表盘读取列表",@"meter.view.html":@"仪表盘读数明细",@"meter.new.html":@"新建仪表盘",@"opers.html":@"运营巡检记录",@"oper.view.html":@"运营巡检详情",@"oper.new.html":@"新建运营巡检",@"repairs.html":@"设备维修列表",@"repair.view.html":@"设备维修明细",@"repair.new.html":@"设备维修新建",@"list.html":@"待办列表",@"maintain.execute.html":@"工程报修",@"oper.signin.html":@"运营巡检签收",@"complaint.execute.html": @"投诉详情",@"device.execute.html": @"设备巡检计划工单",@"oper.execute.html":@"运营巡检",@"repair.execute.html": @"设备维修",@"repair.signin.html":@"设备维修明细",@"sales.input.execute.html":@"销售录入审批",@"notice.view.html": @"公告明细",@"notices.html":@"公告",@"repair.new-from-device.execute.html":@"新建设备维修" ,@"repair.new.html" :@"设备维修新建",@"repair.new.without-back.html":@"设备维修新建"};
    self.titieDict = [titleDictionary mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, kBannerHeight - 1, [[UIScreen mainScreen]bounds].size.width, 1)];
    seperateView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.bannerView addSubview:seperateView];
    
    /*
     * 主题页面,允许横屏
     */
    [self setAppAllowRotation:NO];
    if (![self.link hasPrefix:@"offline://"]) {
        [self handleRefresh];
    }
    
    /**
     *  横屏时，隐藏标题栏，增大可视区范围
     */
    // [self checkInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    [self displayBannerViewButtonsOrNot];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.idView setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.browser stopLoading];
    [self.idView setHidden:YES];
    [self.browser stringByEvaluatingJavaScriptFromString:@"localStorage.clear()"];
    
    /*
     * 其他页面,禁用横屏
     */
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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

-(void)handleRefresh {
    [self addWebViewJavascriptBridge];
    [self checkAssetsUpdate];
    
    if(self.isInnerLink) {
        NSString *reportDataUrlString = [APIHelper reportDataUrlString:self.user.groupID templateID:self.templateID reportID:self.reportID];
        
        [HttpUtils clearHttpResponeHeader:reportDataUrlString assetsPath:self.assetsPath];
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
    }
    
    [self loadHtml];
    //[refresh endRefreshing];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName]   = @"刷新/主题页面/浏览器";
            logParams[kObjTitleALCName] = self.urlString;
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
        // [self showLoading:LoadingRefresh];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName]   = @"JS异常";
                logParams[kObjIDALCName]    = self.objectID;
                logParams[kObjTypeALCName]  = @(self.commentObjectType);
                logParams[kObjTitleALCName] = [NSString stringWithFormat:@"主题页面/%@/%@", self.bannerName, data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    [self.bridge registerHandler:@"refreshBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
        [self checkAssetsUpdate];
        [self handleRefresh];
    }];
    
    [self.bridge registerHandler:@"addSubjectMenuItems" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSMutableArray *tmpTitles = [NSMutableArray array];
        NSMutableArray *tmpLinks = [NSMutableArray array];
        NSArray *menuItems  = data[@"menu_items"];
        for (NSDictionary* menuItem in menuItems) {
            [tmpTitles addObject:menuItem[@"title"]];
            [tmpLinks addObject:menuItem[@"link"]];
        }
        [tmpTitles addObject:@"刷新"];
        [tmpLinks addObject:@"000"];
        self.dropMenuTitles = [NSMutableArray arrayWithArray:tmpTitles];
        self.dropMenuLinks = [NSMutableArray arrayWithArray:tmpLinks];
        if ([self.dropMenuTitles count] >1) {
            self.isDropMenu = YES;
            [self.SettingBtn setImage:[UIImage imageNamed:@"Banner-Setting"] forState:UIControlStateNormal];
        }
        else{
            self.isDropMenu = NO;
            [self.SettingBtn setImage:[UIImage imageNamed:@"subRefresh"] forState:UIControlStateNormal];
        }
    }];
    
    
    [self.bridge registerHandler:@"pageTabIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *behaviorPath = [FileUtils dirPath:kConfigDirName FileName:kBehaviorConfigFileName];
        NSMutableDictionary *behaviorDict = [FileUtils readConfigFile:behaviorPath];
        
        NSString *action = data[@"action"], *pageName = data[@"pageName"];
        NSNumber *tabIndex = data[@"tabIndex"];
        
        if([action isEqualToString:@"store"]) {
            behaviorDict[kReportUBCName][pageName] = tabIndex;
            [behaviorDict writeToFile:behaviorPath atomically:YES];
        }
        else if([action isEqualToString:@"restore"]) {
            tabIndex = behaviorDict[kReportUBCName] && behaviorDict[kReportUBCName][pageName] ? behaviorDict[kReportUBCName][pageName] : @(0);
            
            responseCallback(tabIndex);
        }
        else {
            NSLog(@"unkown action %@", action);
        }
    }];
    
    
    [self.bridge registerHandler:@"checkVersion" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        /*UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
         message:@"中间件版本过低"
         preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
         handler:^(UIAlertAction * action) {}];
         
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];*/
        NSLog(@"%@",data);
    }];
    
    [self.bridge registerHandler:@"searchItems" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *reportDataFileName = [NSString stringWithFormat:kReportDataFileName, self.user.groupID, self.templateID, self.reportID];
        NSString *javascriptFolder = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
        self.javascriptPath = [javascriptFolder stringByAppendingPathComponent:reportDataFileName];
        NSString *searchItemsPath = [NSString stringWithFormat:@"%@.search_items", self.javascriptPath];
        
        [data[@"items"] writeToFile:searchItemsPath atomically:YES];
        NSMutableArray *tmpTitles = [NSMutableArray array];
        NSMutableArray *tmpIcons = [NSMutableArray array];
        if(kSubjectShare) {
            [tmpTitles addObject:kDropShareText];
            [tmpIcons addObject:@"Subject-Share"];
        }
        if(self.isSupportSearch) {
            [tmpTitles addObject:kDropSearchText];
            [tmpIcons addObject:@"Subject-Search"];
        }
        [tmpTitles addObject:kDropRefreshText];
        [tmpIcons addObject:@"Subject-Refresh"];
        self.dropMenuTitles = [NSArray arrayWithArray:tmpTitles];
        self.dropMenuIcons = [NSArray arrayWithArray:tmpIcons];
        if (self.dropMenuTitles.count > 1) {
            self.isDropMenu = YES;
            [self.SettingBtn setImage:[UIImage imageNamed:@"Banner-Setting"] forState:UIControlStateNormal];
        }
        /**
         *  判断筛选的条件: data[@"items"] 数组不为空
         *  报表第一次加载时，此处为判断筛选功能的关键点
         */
        self.isSupportSearch = [FileUtils reportIsSupportSearch:self.user.groupID templateID:self.templateID reportID:self.reportID];
        if(self.isSupportSearch) {
            [self displayBannerTitleAndSearchIcon];
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
    
    [self.bridge registerHandler:@"goBackBehavior" handler:^(id data, WVJBResponseCallback responseCallback){
        [self.browser goBack];
    }];
    
    
    [self.bridge registerHandler:@"pageLink" handler:^(id data, WVJBResponseCallback responseCallback) {
        //  self.labelTheme.text = data[@"bannerName"];
        if ([data[@"link"] isEqualToString:@""]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"该功能正在开发中"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        // 获取的链接为初始链接，清空栈，并加载第一个链接
        else if ([data[@"link"] isEqualToString:originlink]){
            [_webArray removeAllObjects];
            self.link = data[@"link"];
            [self.webArray addObject:data[@"link"]];
            [self loadHtml];
            return ;
        }
        // 如果获取的链接是内部连接
        else if([data[@"link"] hasPrefix:@"offline://"]) {
            // 返回至首页
            if ([data[@"link"] isEqualToString:@"offline:////"]){
                [self actionBack:self.SettingBtn];
                return ;
            }
            //连接栈中存在该链接，pop 至该链接处，在返回
            else if ([_webArray containsObject:data[@"link"]]) {
                NSInteger i = [_webArray indexOfObject:data[@"link"]];
                NSInteger end = [_webArray count];
                NSRange range = {i,end};
                [_webArray removeObjectsInRange:range];
            }
            /* if (![self.link isEqualToString:data[@"link"]]) {
             self.link = data[@"link"];
             [self.webArray addObject:self.link];
             }*/
            self.link = data[@"link"];
            [_webArray addObject:data[@"link"]];
            [self loadInnerLink];
        }
        else {
            self.link = data[@"link"];
            [self.webArray addObject:data[@"link"]];
            [self loadHtml];
        }
    }];
    
    [self.bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        //  self.labelTheme.text = data[@"bannerName"];
        if ([data[@"link"] isEqualToString:@""]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"该功能正在开发中"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        // 获取的链接为初始链接，清空栈，并加载第一个链接
        else if ([data[@"link"] isEqualToString:originlink]){
            [_webArray removeAllObjects];
            self.link = data[@"link"];
            [self.webArray addObject:data[@"link"]];
            [self loadHtml];
            return ;
        }
        // 如果获取的链接是内部连接
        else if([data[@"link"] hasPrefix:@"offline://"]) {
            // 返回至首页
            if ([data[@"link"] isEqualToString:@"offline:////"]){
                [self actionBack:self.SettingBtn];
                return ;
            }
            //连接栈中存在该链接，pop 至该链接处，在返回
            else if ([_webArray containsObject:data[@"link"]]) {
                NSInteger i = [_webArray indexOfObject:data[@"link"]];
                NSInteger end = [_webArray count];
                NSRange range = {i,end};
                [_webArray removeObjectsInRange:range];
            }
            /* if (![self.link isEqualToString:data[@"link"]]) {
             self.link = data[@"link"];
             [self.webArray addObject:self.link];
             }*/
            self.link = data[@"link"];
            [_webArray addObject:data[@"link"]];
            [self loadInnerLink];
        }
        else {
            self.link = data[@"link"];
            [self.webArray addObject:data[@"link"]];
            [self loadHtml];
        }
    }];
    
    
    [self.bridge registerHandler:@"setBannerTitle" handler:^(id data, WVJBResponseCallback responseCallback){
        self.labelTheme.text = data[@"title"];
    }];
    
    
    [self.bridge registerHandler:@"toggleShowBanner" handler:^(id data, WVJBResponseCallback responseCallback){
        if ([data[@"state"] isEqualToString:@"show"]) {
            [self.SettingBtn setHidden:NO];
            [self.backBtn setHidden:NO];
        }
        else {
            [self.SettingBtn setHidden:YES];
            [self.backBtn setHidden:YES];
        }
    }];
    
    [self.bridge registerHandler:@"showAlert" handler:^(id data, WVJBResponseCallback responseCallback){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:data[@"title"]
                                                                       message:data[@"content"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    

    
    [self.bridge registerHandler:@"showAlertAndRedirect" handler:^(id data, WVJBResponseCallback responseCallback){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:data[@"title"]
                                                                       message:data[@"content"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  self.link = data[@"redirectUrl"];
                                                                  if ([data[@"cleanStack"] boolValue]) {
                                                                      [self.webArray removeAllObjects];
                                                                  }
                                                                  [self.webArray addObject:self.link];
                                                                  
                                                                  [self loadHtml];
                                                              }];
        
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    [self.bridge registerHandler:@"showAlertAndRedirectWithCleanStack" handler:^(id data, WVJBResponseCallback responseCallback){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:data[@"title"]
                                                                       message:data[@"content"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  self.link = data[@"redirectUrl"];
                                                                  if ([data[@"cleanStack"] boolValue]) {
                                                                      [self.webArray removeAllObjects];
                                                                      [self.webArray addObject:self.link];
                                                                  }
                                                                  [self loadInnerLink];
                                                              }];
        
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    // UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //[refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    //[self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
}

#pragma mark - assistant methods
- (void)loadHtml {
    self.isInnerLink = [self.link hasPrefix:@"offline://"] || (![self.link hasPrefix:@"http"] && ![self.link hasPrefix:@"https"]);
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        self.isInnerLink ? [self loadInnerLink] : [self loadOuterLink];
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

- (void)clearAllUIWebViewData {
    // Clear the webview cache...
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self removeApplicationLibraryDirectoryWithDirectory:@"Caches"];
    [self removeApplicationLibraryDirectoryWithDirectory:@"WebKit"];
    // Empty the cookie jar...
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    [self removeApplicationLibraryDirectoryWithDirectory:@"Cookies"];
}

- (void)removeApplicationLibraryDirectoryWithDirectory:(NSString *)dirName {
    NSString *dir = [[[[NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES) lastObject]stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:dirName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        [[NSFileManager defaultManager] removeItemAtPath:dir error:nil];
    }
}

- (void)loadOuterLink {
    //NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    // NSString *splitString = [self.urlString containsString:@"?"] ? @"&" : @"?";
    //   NSString *appendParams = [NSString stringWithFormat:@"user_num=%@&timestamp=%@", self.user.userNum, timestamp];
    //  self.urlString = [NSString stringWithFormat:@"%@", self.urlString];
    NSLog(@"%@", self.urlString);
    [self setCookie];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.link]];
    if ([[[[NSUserDefaults standardUserDefaults]dictionaryRepresentation]allKeys]containsObject:@"cookie"]) {
        //获取cookies：程序起来之后，uiwebview加载url之前获取保存好的cookies，并设置cookies，
        /*NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookie"];
         NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
         [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
         [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
         NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
         [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];*/
        //  [request addValue:[self readCurrentCookie] forHTTPHeaderField:@"Cookie"];
    }
    [self.browser loadRequest:request];
    // self.isLoadFinish = !self.browser.isLoading;
}

- (void)loadInnerLink {
    /**
     *  only inner link clean browser cache
     */
    [self clearBrowserCache];
    self.isDropMenu = NO;
    [self.SettingBtn setImage:[UIImage imageNamed:@"subRefresh"] forState:UIControlStateNormal];
    
    // [self showLoading:LoadingLoad];
    
    /*
     * format: /mobile/v1/group/:group_id/template/:template_id/report/:report_id
     * deprecated
     * format: /mobile/report/:report_id/group/:group_id
     */
    if ([self.link hasPrefix:@"offline"]) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        if ([self.link isEqualToString:@"offline:////"]) {
            [self actionBack:self.SettingBtn];
        }
        else if ([self.link isEqualToString:@"offline:///"]){
            self.link = originlink;
            [_webArray removeAllObjects];
            [_webArray addObject:self.link];
            
        }
        NSArray *components = [self.link componentsSeparatedByString:@"://"];
        NSString *filePath = [[[FileUtils sharedPath] stringByAppendingPathComponent:@"offline_pages"] stringByAppendingPathComponent:components[1]];
        if (![FileUtils checkFileExist:filePath isDir:NO]) {
            [self showProgressHUD:@"找不到文件路径"];
        }
        NSString *htmlCotent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseUrl = [NSURL fileURLWithPath:[[[FileUtils sharedPath] stringByAppendingPathComponent:@"offline_pages"] stringByAppendingPathComponent:@"/"]];
        NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000 + arc4random()];
        NSString *newHtmlContent = [htmlCotent stringByReplacingOccurrencesOfString:@"TIMESTAMP" withString:timestamp];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.browser loadHTMLString:newHtmlContent baseURL:baseUrl];
        });
        //[self.browser loadHTMLString:newHtmlContent baseURL:baseUrl];
        
    }
    else {
        [self showLoading:LoadingLoad];
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
                self.isLoadFinish = !self.browser.isLoading;
            });
        });
    }
}

#pragma mark - UIWebview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([[url scheme] hasPrefix:@";file"]) {
            [[UIApplication sharedApplication] openURL:url];
            return NO;
        }
    }
    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        NSLog(@"表单提交");
    }
    
    // 添加url 到栈中
    //NSMutableURLRequest *urlreuqest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    // NSString *urlstring = [NSString stringWithFormat:@"%@",[[[url relativeString] componentsSeparatedByString:@"/"] lastObject]];
    
    // 头部
    /* if (![[url absoluteString] hasPrefix:@"http"] || ![[url absoluteString] hasPrefix:@"https"] || ![[url absoluteString] hasPrefix:@"offline"]) {
     //NSArray *components = [[url absoluteString] componentsSeparatedByString:@"/"];
     NSArray *titieArray = [self.titieDict allKeys];
     NSInteger titieValueNumber = 0;
     if ([titieArray containsObject:[[self.link componentsSeparatedByString:@"://"] lastObject]]) {
     titieValueNumber = [titieArray indexOfObject:[[self.link componentsSeparatedByString:@"://"] lastObject]];
     self.labelTheme.text =_titieDict[titieArray[titieValueNumber]];
     }
     else if([self.link hasPrefix:@"offline://"]){
     self.labelTheme.text = [[self.link componentsSeparatedByString:@"://"] lastObject];
     }
     else{
     self.labelTheme.text = self.bannerName;
     }
     }*/
    //request = [urlreuqest copy];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    //[self.browser loadRequest:request];
    return YES;
}

/*
 - (NSString *)getbannerName:(NSString *)htmllink {
 NSString *bannerstring;
 NSArray *titieArray = [self.titieDict allKeys];
 NSInteger titieValueNumber = 0;
 if ([titieArray containsObject:[[self.link componentsSeparatedByString:@"://"] lastObject]]) {
 titieValueNumber = [titieArray indexOfObject:[[self.link componentsSeparatedByString:@"://"] lastObject]];
 bannerstring =_titieDict[titieArray[titieValueNumber]];
 }
 else {
 bannerstring = [[htmllink componentsSeparatedByString:@"/"] lastObject];
 }
 return bannerstring;
 }
 */

- (NSString*)readCurrentCookie{
    /* NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookie"];
     NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
     [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
     [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
     // NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];*/
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    [cookieString appendFormat:@"%@=%@",@"sessionid",userDict[@"sessionid"]];
    return cookieString;
}

- (void)setCookie{
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    //[cookieProperties setObject:@"user_cookie" forKey:NSHTTPCookieName];
    // [cookieProperties setObject:userDict[@"sessionid"] forKey:NSHTTPCookieValue];
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    
    NSArray *cookies = [NSArray arrayWithObjects:@"sessionid",userDict[@"sessionid"] ,nil];
    [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookie"];
}

- (void)deleteCookie{
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookieAry = [cookieJar cookiesForURL: [NSURL URLWithString: self.urlString]];
    
    for (cookie in cookieAry) {
        
        [cookieJar deleteCookie: cookie];
        
    }
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
- (IBAction)dropTableView:(UIButton *)sender {
    _isDropMenu ? [self showTableView:sender] : [self handleRefresh];
    //  [self handleRefresh];
}

#pragma mark
- (void)initDropMenu {
    NSMutableArray *tmpTitles = [NSMutableArray array];
    NSMutableArray *tmpIcons = [NSMutableArray array];
    if(kSubjectShare) {
        [tmpTitles addObject:kDropShareText];
        [tmpIcons addObject:@"Subject-Share"];
    }
    if(kSubjectComment) {
        [tmpTitles addObject:kDropCommentText];
        [tmpIcons addObject:@"Subject-Comment"];
    }
    if(self.isSupportSearch) {
        [tmpTitles addObject:kDropSearchText];
        [tmpIcons addObject:@"Subject-Search"];
    }
    [tmpTitles addObject:kDropRefreshText];
    [tmpIcons addObject:@"Subject-Refresh"];
    self.dropMenuTitles = [NSArray arrayWithArray:tmpTitles];
    self.dropMenuIcons = [NSArray arrayWithArray:tmpIcons];
}

/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender
 */
-(void)showTableView:(UIButton *)sender {
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, 150, 150 / 4 * self.dropMenuTitles.count);
    dropTableViewController.modalPresentationStyle = UIModalPresentationPopover;
    [dropTableViewController setPreferredContentSize:CGSizeMake(150, 150 / 4 * self.dropMenuTitles.count)];
    dropTableViewController.view.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    dropTableViewController.dropTableView.delegate = self;
    dropTableViewController.dropTableView.dataSource =self;
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.delegate = self;
    [popover setSourceRect:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 12, sender.frame.size.width, sender.frame.size.height)];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    [self presentViewController:dropTableViewController animated:YES completion:nil];
}
# pragma mark - UITableView Delgate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dropMenuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dorpcell"];
    if (!cell) {
        cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dorpcell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.dropMenuTitles[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    // cell.iconImageView.image = [UIImage imageNamed:self.dropMenuIcons[indexPath.row]];
    
    UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
    //  cellBackView.backgroundColor = [UIColor darkGrayColor];
    cell.selectedBackgroundView = cellBackView;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150 / 4;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *itemName = self.dropMenuTitles[indexPath.row];
        
        if([itemName isEqualToString:kDropCommentText]) {
            [self actionWriteComment];
        }
        else if([itemName isEqualToString:kDropSearchText]) {
            [self actionDisplaySearchItems];
        }
        else if([itemName isEqualToString:kDropShareText]) {
            [self actionWebviewScreenShot];
        }
        else if ([itemName isEqualToString:kDropRefreshText]){
            [self handleRefresh];
        }
        else if (indexPath.row == (self.dropMenuTitles.count - 1)) {
            [self handleRefresh];
        }
        else {
            self.isDropMenu = NO;
            [self.SettingBtn setImage:[UIImage imageNamed:@"subRefresh"] forState:UIControlStateNormal];
            self.link = self.dropMenuLinks[indexPath.row];
            
            /**
             * 服务器内链接需要做缓存、点击事件处理；
             */
            self.urlString   = self.link;
            [_webArray addObject:self.link];
            [self loadHtml];
        }
    }];
}

#pragma mark - ibaction block
- (IBAction)actionBack:(id)sender {
    if ([self.webArray count] > 1 ) {
        [self.webArray removeLastObject];
        self.link =[_webArray lastObject];
        [self loadHtml];
    }
    else {
        [super dismissViewControllerAnimated:YES completion:^{
            [self.browser stopLoading];
            [self clearBrowserCache];
            [self.browser cleanForDealloc];
            self.browser.delegate = nil;
            self.browser = nil;
            [self.progressHUD hide:YES];
            self.progressHUD = nil;
            self.bridge = nil;
        }];
    }
}

- (void)actionWriteComment{
    [self performSegueWithIdentifier:kCommentSegueIdentifier sender:nil];
}

- (void)actionDisplaySearchItems {
    [self performSegueWithIdentifier:kReportSelectorSegueIdentifier sender:nil];
}

- (void)actionWebviewScreenShot{
    if (self.isLoadFinish) {
        @try {
            UIImage *image;
            NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kBetaConfigFileName];
            betaDict = [FileUtils readConfigFile:settingsConfigPath];
            if (!betaDict[@"image_within_screen"] || [betaDict[@"image_within_screen"] boolValue]) {
                image = [self saveWebViewAsImage];
            }
            else {
                image = [self getImageFromCurrentScreen];
            }
            dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1ull *NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
                [UMSocialData defaultData].extConfig.title = kWeiXinShareText;
                [UMSocialData defaultData].extConfig.qqData.url = kBaseUrl;
                [UMSocialSnsService presentSnsIconSheetView:self
                                                     appKey:kUMAppId
                                                  shareText:self.bannerName
                                                 shareImage:image
                                            shareToSnsNames:@[UMShareToWechatSession]
                                                   delegate:self];
            });
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"分享提示"
                                                                       message:@"正在加载数据，请稍后分享"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  self.isLoadFinish = self.browser.isLoading;
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (UIImage *)getImageFromCurrentScreen {
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)saveWebViewAsImage {
    UIScrollView *scrollview = self.browser.scrollView;
    UIImage *image = nil;
    CGSize boundsSize = self.browser.scrollView.contentSize;
    if (boundsSize.height > kScreenHeight * 6) {
        boundsSize.height = kScreenHeight * 6;
    }
    UIGraphicsBeginImageContextWithOptions(boundsSize ,NO, 0.0);
    CGPoint savedContentOffset = scrollview.contentOffset;
    CGRect savedFrame = scrollview.frame;
    scrollview.contentOffset = CGPointZero;
    scrollview.frame = CGRectMake(0,0, boundsSize.width, boundsSize.height);
    [scrollview.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    scrollview.contentOffset = savedContentOffset;
    scrollview.frame = savedFrame;
    UIGraphicsEndImageContext();
    return image;
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
            logParams[kActionALCName] = @"点击/主题页面/评论";
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
    NSDictionary *browerDict = [FileUtils readConfigFile:[FileUtils dirPath:kConfigDirName FileName:kBetaConfigFileName]];
    self.isLoadFinish = YES;
    if ([browerDict[@"allow_brower_copy"] boolValue]) {
        return;
    }
    // self.browser.delegate = nil;
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    /**
     *  忽略 NSURLErrorDomain 错误 - 999
     */
    if([error code] == NSURLErrorCancelled) {
        return;
    }
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
    [self loadHtml];
}

/**
 *  横屏时，隐藏标题栏，增大可视区范围
 *
 *  @param interfaceOrientation 设备屏幕放置方向
 */
- (void)checkInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation);
    
    self.bannerView.hidden = isLandscape;
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


#pragma mark - UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    @try {
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName]   = [NSString stringWithFormat:@"微信分享(%d)", fromViewControllerType];
        logParams[kObjIDALCName]    = self.objectID;
        logParams[kObjTypeALCName]  = @(self.commentObjectType);
        logParams[kObjTitleALCName] = self.bannerName;
        logParams[kScreenshotType] = ( betaDict[@"image_within_screen"] && [betaDict[@"image_within_screen"] boolValue]) ? @"screenIamge" : @"allImage";
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
        logParams[kActionALCName]   = [NSString stringWithFormat:@"微信分享完成(%d)", response.viewControllerType];
        logParams[kObjIDALCName]    = self.objectID;
        logParams[kObjTypeALCName]  = @(self.commentObjectType);
        logParams[kObjTitleALCName] = self.bannerName;
        logParams[kScreenshotType] = ( betaDict[@"image_within_screen"] && [betaDict[@"image_within_screen"] boolValue]) ? @"screenIamge" : @"allImage";
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
@end
