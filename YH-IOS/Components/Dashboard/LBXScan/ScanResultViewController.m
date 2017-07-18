//
//  ScanResultViewController.m
//  YH-IOS
//
//  Created by lijunjie on 16/06/07.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "ScanResultViewController.h"
#import "APIHelper.h"
#import "SelectStoreViewController.h"
#import "DropViewController.h"
#import "DropTableViewCell.h"
#import "UMSocial.h"
#import "ManualInputViewController.h"
#import "SubLBXScanViewController.h"
#import "DropTableViewCell.h"
#import "DropViewController.h"
#import "CommentViewController.h"

static NSString *const kReportSelectorSegueIdentifier = @"ToReportSelectorSegueIdentifier";

@interface ScanResultViewController() <UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,DropViewDelegate,DropViewDataSource,UIPopoverPresentationControllerDelegate,UMSocialDataDelegate,UMSocialUIDelegate> {
    NSMutableDictionary *betaDict;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBannerView;
@property (strong, nonatomic) NSString *htmlContent;
@property (strong, nonatomic) NSString *htmlPath;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) NSArray *dropMenuTitles;
@property (strong, nonatomic) NSArray *dropMenuIcons;
@property (strong, nonatomic)     NSString *storeID;
@property (strong, nonatomic) NSString *javascriptPath;

@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       self.storeID = @"-1";
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"DashboardViewController - Response for message from ObjC");
    }];
    [self.bridge registerHandler:@"refreshBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
        
        [self loadHtml];
    }];
    [self idColor];
     [self addWebViewJavascriptBridge];
    self.htmlPath = [FileUtils sharedDirPath:kBarCodeScanFolderName FileName:kBarCodeScanFileName];
    self.htmlContent = [NSString stringWithContentsOfFile:self.htmlPath encoding:NSUTF8StringEncoding error:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"Banner-Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Banner-Setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(dropTableView:)];
    [self clearBrowserCache];
    [self loadHtml];
}

- (void)addWebViewJavascriptBridge {
    
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
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        // [self showLoading:LoadingRefresh];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName]   = @"JS异常";
                logParams[kObjTitleALCName] = [NSString stringWithFormat:@"扫码页面/%@", data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    

    [self.bridge registerHandler:@"searchItems" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *reportDataFileName = [NSString stringWithFormat:@"store_%@_barcode_%@_attachment", self.storeID, self.codeInfo];
        NSString *javascriptFolder = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
        self.javascriptPath = [javascriptFolder stringByAppendingPathComponent:reportDataFileName];
        NSString *searchItemsPath = [NSString stringWithFormat:@"%@.search_items", self.javascriptPath];
        
        [data[@"items"] writeToFile:searchItemsPath atomically:YES];
        
        /**
         *  判断筛选的条件: data[@"items"] 数组不为空
         *  报表第一次加载时，此处为判断筛选功能的关键点
         */
     
    }];

    
    [self.bridge registerHandler:@"selectedItem" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *reportDataFileName = [NSString stringWithFormat:@"store_%@_barcode_%@_attachment", self.storeID, self.codeInfo];
        NSString *javascriptFolder = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
        self.javascriptPath = [javascriptFolder stringByAppendingPathComponent:reportDataFileName];
        NSString *selectedItemPath = [NSString stringWithFormat:@"%@.selected_item", self.javascriptPath];
        NSString *selectedItem = NULL;
        if([FileUtils checkFileExist:selectedItemPath isDir:NO]) {
            selectedItem = [NSString stringWithContentsOfFile:selectedItemPath encoding:NSUTF8StringEncoding error:nil];
        }
        responseCallback(selectedItem);
    }];
    
    // UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //[refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    //[self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
}


//标识点
- (void)idColor {
    UIView* idView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50,34, 30, 10)];
    //idView.backgroundColor = [UIColor redColor];
    [self.navigationController.navigationBar addSubview:idView];
    
    UIImageView* idColor0 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 4, 4)];
    idColor0.layer.cornerRadius = 2;
    [idView addSubview:idColor0];
    
    UIImageView* idColor1 = [[UIImageView alloc]initWithFrame:CGRectMake(6, 1, 4, 4)];
    idColor1.layer.cornerRadius = 1;
    [idView addSubview:idColor1];
    
    UIImageView* idColor2 = [[UIImageView alloc]initWithFrame:CGRectMake(12, 1, 4, 4)];
    idColor2.layer.cornerRadius = 1;
    [idView addSubview:idColor2];
    
    UIImageView* idColor3 = [[UIImageView alloc]initWithFrame:CGRectMake(18, 1, 4, 4)];
    idColor3.layer.cornerRadius = 1;
    [idView addSubview:idColor3];
    
    UIImageView* idColor4 = [[UIImageView alloc]initWithFrame:CGRectMake(24, 1, 4, 4)];
    idColor4.layer.cornerRadius = 1;
    [idView addSubview:idColor4];
    
    
    NSArray *colors = @[@"00ffff", @"ffcd0a", @"fd9053", @"dd0929", @"016a43", @"9d203c", @"093db5", @"6a3906", @"192162", @"000000"];
    
    NSArray *colorViews = @[idColor0, idColor1, idColor2, idColor3, idColor4];
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


-(void)backAction{
    [super dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE_VIEW" object:nil userInfo:nil];
        [self.browser stopLoading];
        [self.browser cleanForDealloc];
        self.browser.delegate = nil;
        self.browser = nil;
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
        self.bridge = nil;
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
}

#pragma mark - assistant methods
- (void)loadHtml {
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        [self loadInnerLink];
    }
    else if(deviceState == StateForbid) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:kIAlreadyKnownText actionBlock:^(void) {
            [self jumpToLogin];
        }];
        
        [alert showError:self title:kWarmTitleText subTitle:kAppForbiedUseText closeButtonTitle:nil duration:0.0f];
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
    
    NSString *cacheJsonPath = [FileUtils dirPath:kCachedDirName FileName:kBarCodeResultFileName];
    NSMutableDictionary *cacheDict = [FileUtils readConfigFile:cacheJsonPath];
    
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    if ((!cacheDict[@"store"] || !cacheDict[@"store"][@"id"]) &&
        userDict[kStoreIDsCUName] && [userDict[kStoreIDsCUName] count] > 0) {
        
        cacheDict[@"store"] = userDict[kStoreIDsCUName][0];
        [FileUtils writeJSON:cacheDict Into:cacheJsonPath];
    }
    else {
        // 缓存的门店信息可能过期，判断是否在用户权限门店列表中（user.plist）
        BOOL isExpired = YES;
        NSDictionary *storeDict = [NSDictionary dictionary];
        for(NSInteger i = 0, len = [userDict[kStoreIDsCUName] count]; i < len; i++) {
            storeDict = userDict[kStoreIDsCUName][i];
            if(storeDict[@"name"] && storeDict[@"id"] && ([storeDict[@"id"] integerValue] == [cacheDict[@"store"][@"id"] integerValue])) {
                isExpired = NO;
                break;
            }
        }
        
        if(isExpired) {
            cacheDict[@"store"] = userDict[kStoreIDsCUName][0];
            [FileUtils writeJSON:cacheDict Into:cacheJsonPath];
        }
    }
    
    _storeID = cacheDict[@"store"][@"id"];
    self.title = cacheDict[@"store"][@"name"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      BOOL jsonFormateRight = [APIHelper barCodeScan:self.user.userNum group:self.user.groupID role:self.user.roleID store:_storeID code:self.codeInfo type:self.codeType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            if (jsonFormateRight) {
                [self.browser loadHTMLString:[self htmlContentWithTimestamp] baseURL:[NSURL fileURLWithPath:self.htmlPath]];
            }
            else {
                [self showLoading:LoadingRefresh];
            }
        });
    });
}


// 新版扫一扫加载的代码

- (void)loadInnerLink {
    /**
     *  only inner link clean browser cache
     */
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    
    NSString *cacheJsonPath = [FileUtils dirPath:kCachedDirName FileName:kBarCodeResultFileName];
    NSMutableDictionary *cacheDict = [FileUtils readConfigFile:cacheJsonPath];
    
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    if ((!cacheDict[@"store"] || !cacheDict[@"store"][@"id"]) &&
        userDict[kStoreIDsCUName] && [userDict[kStoreIDsCUName] count] > 0) {
        
        cacheDict[@"store"] = userDict[kStoreIDsCUName][0];
        [FileUtils writeJSON:cacheDict Into:cacheJsonPath];
    }
    else {
        // 缓存的门店信息可能过期，判断是否在用户权限门店列表中（user.plist）
        BOOL isExpired = YES;
        NSDictionary *storeDict = [NSDictionary dictionary];
        for(NSInteger i = 0, len = [userDict[kStoreIDsCUName] count]; i < len; i++) {
            storeDict = userDict[kStoreIDsCUName][i];
            if(storeDict[@"name"] && storeDict[@"id"] && ([storeDict[@"id"] integerValue] == [cacheDict[@"store"][@"id"] integerValue])) {
                isExpired = NO;
                break;
            }
        }
        
        if(isExpired) {
          //  cacheDict[@"store"] = userDict[kStoreIDsCUName][0];
            cacheDict[@"store"] = @"9275";
            [FileUtils writeJSON:cacheDict Into:cacheJsonPath];
        }
    }
    
   _storeID = cacheDict[@"store"][@"id"];
   // _storeID = @"9318";
    self.title = cacheDict[@"store"][@"name"];
      [self showLoading:LoadingLoad];
    
    /*
     * format: /mobile/v1/group/:group_id/template/:template_id/report/:report_id
     * deprecated
     * format: /mobile/report/:report_id/group/:group_id
     */
  //  NSArray *components = [self.urlString componentsSeparatedByString:@"/"];
    self.urlString = [NSString stringWithFormat:@"%@/mobile/v2/store/%@/barcode/%@/view",kBaseUrl,self.storeID,self.codeInfo];
    
    /**
     * 内部报表具有筛选功能时
     *   - 如果用户已选择，则 banner 显示该选项名称
     *   - 未设置时，默认显示筛选项列表中第一个
     *
     *  初次加载时，判断筛选功能的条件还未生效
     *  此处仅在第二次及以后才会生效
     */
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIHelper reportScodeData:[self.storeID numberValue] barcodeID:self.codeInfo];
        
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
           // [MRProgressOverlayView dismissOverlayForView:self.browser animated:YES];
            
        });
    });
}


#pragma mark
- (void)initDropMenu {
    NSMutableArray *tmpTitles = [NSMutableArray array];
    NSMutableArray *tmpIcons = [NSMutableArray array];
    [tmpTitles addObject:kDropShareText];
    [tmpIcons addObject:@"Subject-Share"];
    [tmpTitles addObject:kDropSearchText];
    [tmpIcons addObject:@"Subject-Search"];
    [tmpTitles addObject:kDropRefreshText];
    [tmpIcons addObject:@"Subject-Refresh"];
    self.dropMenuTitles = [NSArray arrayWithArray:tmpTitles];
    self.dropMenuIcons = [NSArray arrayWithArray:tmpIcons];
}

#pragma mark - action methods

/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender
 */
-(void)dropTableView:(UIBarButtonItem *)sender {
    [self initDropMenu];
   /* SelectStoreViewController *select = [[SelectStoreViewController alloc] init];
    UINavigationController* selectCtrl = [[UINavigationController alloc]initWithRootViewController:select];
    [self.navigationController presentViewController:selectCtrl animated:YES completion:nil];
    [self initDropMenu];*/
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, 150, 150);
    dropTableViewController.preferredContentSize = CGSizeMake(150,self.dropMenuTitles.count*150/4);
    dropTableViewController.dataSource = self;
    dropTableViewController.delegate = self;
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.barButtonItem = self.navigationItem.rightBarButtonItem;
    popover.delegate = self;
    [popover setSourceRect:sender.customView.frame];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kDropViewColor];
    [self presentViewController:dropTableViewController animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(NSInteger)numberOfPagesIndropView:(DropViewController *)flowView{
    return self.dropMenuTitles.count;
}

-(UITableViewCell *)dropView:(DropViewController *)flowView cellForPageAtIndex:(NSIndexPath *)index{
    DropTableViewCell*  cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dorpcell"];
    cell.tittleLabel.text = self.dropMenuTitles[index.row];
    cell.iconImageView.image = [UIImage imageNamed:self.dropMenuIcons[index.row]];
    
    UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
    cellBackView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = cellBackView;
    cell.tittleLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

-(void)dropView:(DropViewController *)flowView didTapPageAtIndex:(NSIndexPath *)index{
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *itemName = self.dropMenuTitles[index.row];
        
        if([itemName isEqualToString:kDropSearchText]) {
            SelectStoreViewController *select = [[SelectStoreViewController alloc] init];
            UINavigationController* selectCtrl = [[UINavigationController alloc]initWithRootViewController:select];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /*
                 * 用户行为记录, 单独异常处理，不可影响用户体验
                 */
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName] = @"点击/扫码/筛选";
                [APIHelper actionLog:logParams];
            });
            [self.navigationController presentViewController:selectCtrl animated:YES completion:nil];
        }
        else if([itemName isEqualToString:kDropShareText]) {
            [self actionWebviewScreenShot];
        }
        else if ([itemName isEqualToString:kDropRefreshText]) {
            [self loadInnerLink];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /*
                 * 用户行为记录, 单独异常处理，不可影响用户体验
                 */
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName] = @"刷新/扫码/浏览器";
                [APIHelper actionLog:logParams];
            });
        }
    }];
    
}

- (void)actionWebviewScreenShot {
    UIImage *image;
    NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kBetaConfigFileName];
    betaDict = [FileUtils readConfigFile:settingsConfigPath];
    if (!betaDict[@"image_within_screen"] && [betaDict[@"image_within_screen"] boolValue]) {
        image = [self saveWebViewAsImage];
    }
    else {
        image = [self getImageFromCurrentScreen];
    }
    // End the graphics context
    UIGraphicsEndImageContext();
    
#pragma todo# 分享文字
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.title = kWeiXinShareText;
    [UMSocialData defaultData].extConfig.qqData.url = kBaseUrl;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMAppId
                                      shareText:NULL
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession]
                                       delegate:self];
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
    if (boundsSize.height > kScreenHeight * 3) {
        boundsSize.height = kScreenHeight * 3;
    }
    UIGraphicsBeginImageContextWithOptions(boundsSize ,NO, 0.0);
    CGPoint savedContentOffset = scrollview.contentOffset;
    CGRect savedFrame = scrollview.frame;
    scrollview.contentOffset = CGPointZero;
    scrollview.frame = CGRectMake(0,0, boundsSize.width, boundsSize.height);
    
    // 将scrollView的layer渲染到上下文中
    [scrollview.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    scrollview.contentOffset = savedContentOffset;
    scrollview.frame = savedFrame;
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    UIImage *fullImage = [UIImage imageWithData:imageData];
    return fullImage;
}

- (NSString *)htmlContentWithTimestamp {
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000 + arc4random()];
    NSString *newHtmlContent = [self.htmlContent stringByReplacingOccurrencesOfString:@"TIMESTAMP" withString:timestamp];

    return newHtmlContent;
}

#pragma mark - ibaction block
- (IBAction)actionBack:(id)sender {
    [super dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE_VIEW" object:nil userInfo:nil];
        [self.browser stopLoading];
        [self.browser cleanForDealloc];
        self.browser.delegate = nil;
        self.browser = nil;
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
        self.bridge = nil;
    }];
}


#pragma mark - UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    @try {
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName]   = [NSString stringWithFormat:@"微信分享(%d)", fromViewControllerType];
        logParams[kScreenshotType] = ( betaDict[@"image_within_screen"]  && [betaDict[@"image_within_screen"] boolValue]) ? @"screenIamge" : @"allImage";
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
        logParams[kScreenshotType] = ( betaDict[@"image_within_screen"]&& [betaDict[@"image_within_screen"] boolValue]) ? @"screenIamge" : @"allImage";
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
@end
