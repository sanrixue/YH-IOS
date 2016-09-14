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

static NSString *const kReportSelectorSegueIdentifier = @"ToReportSelectorSegueIdentifier";

@interface ScanResultViewController() <UINavigationBarDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBannerView;
@property (strong, nonatomic) NSString *htmlContent;
@property (strong, nonatomic) NSString *barCodePath;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  被始化页面样式
     */
    [self idColor];
    self.bannerView.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    self.labelTheme.textColor = [UIColor colorWithHexString:kBannerTextColor];
    
    self.barCodePath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"BarCodeScan"];
    NSString *htmlPath = [self.barCodePath stringByAppendingPathComponent:@"scan_bar_code.html"];
    self.htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];

    [self.selectBtn addTarget:self action:@selector(actionJumpToSelectStoreViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self loadHtml];
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
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)_loadHtml {
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    
    NSString *cachedPath = [FileUtils dirPath:CACHED_DIRNAME];
    NSString *cacheJsonPath = [cachedPath stringByAppendingPathComponent:BARCODE_RESULT_FILENAME
                               ];
    NSMutableDictionary *cacheDict = [FileUtils readConfigFile:cacheJsonPath];
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    NSString *storeID = @"-1";
    if ((!cacheDict[@"store"] || !cacheDict[@"store"][@"id"]) &&
        userDict[@"store_ids"] && [userDict[@"store_ids"] count] > 0) {
        
        cacheDict[@"store"] = userDict[@"store_ids"][0];
        [FileUtils writeJSON:cacheDict Into:cachedPath];
    }
    
    storeID = cacheDict[@"store"][@"id"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIHelper barCodeScan:self.user.userNum group:self.user.groupID role:self.user.roleID store:storeID code:self.codeInfo type:self.codeType];
        
        [self.browser stopLoading];
        [NSThread sleepForTimeInterval:1.0f];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            [self.browser loadHTMLString:[self htmlContentWithTimestamp] baseURL:[NSURL fileURLWithPath:self.barCodePath]];
        });
    });
}

- (void)actionJumpToSelectStoreViewController {
    SelectStoreViewController *select = [[SelectStoreViewController alloc] init];
    [self presentViewController:select animated:YES completion:nil];
}

- (NSString *)htmlContentWithTimestamp {
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000 + arc4random()];
    NSString *newHtmlContent = [self.htmlContent stringByReplacingOccurrencesOfString:@"TIMESTAMP" withString:timestamp];

    return newHtmlContent;
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

@end
