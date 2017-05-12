//
//  JYHomeViewController.m
//  各种报表
//
//  Created by niko on 17/4/28.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYHomeViewController.h"

#import "JYDashboardModel.h"

#import "JYPagedFlowView.h"
#import "JYNotifyView.h"
#import "JYTopSinglePage.h"
#import "JYFallsView.h"
#import "SubjectViewController.h"
#import "HomeIndexVC.h"
#import "SuperChartVc.h"
#import "ViewUtils.h"
#import "HttpResponse.h"
#import "HttpUtils.h"
#import "User.h"

#define kJYNotifyHeight 30

@interface JYHomeViewController () <UITableViewDelegate, UITableViewDataSource, PagedFlowViewDelegate, PagedFlowViewDataSource, JYNotifyDelegate, JYFallsViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate> {
    
    CGFloat bottomViewHeight;
    NSArray *dataListTop;
    NSArray *dataListButtom;
    NSArray *dataList;
}

@property (nonatomic, strong) UITableView *rootTBView;

@property (nonatomic, strong) JYNotifyView *notifyView;
@property (nonatomic, copy) NSArray *pages;
@property (nonatomic, strong) JYPagedFlowView *pageView;
@property (nonatomic, strong) JYFallsView *fallsView;
@property (nonatomic, strong) MJRefreshGifHeader *header;
@property (nonatomic, strong) User* user;


@end

@implementation JYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = JYColor_LightGray_White;
    
    [self loadData];
   // self.edgesForExtendedLayout = UIRectEdgeNone;
    
    bottomViewHeight = JYVCHeight;
    
    [self.view addSubview:self.notifyView];
    [self.view addSubview:self.rootSCView];
    
    _header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _header.lastUpdatedTimeLabel.hidden = YES;
    self.rootTBView.mj_header = _header;
    
}

-(void)loadNewData{
    [self.rootTBView.mj_header beginRefreshing];
    [self loadData];
    [self.rootTBView reloadData];
   // _rootTBView = [[UITableView alloc] initWithFrame:CGRectMake(0, kJYNotifyHeight, JYVCWidth, JYVCHeight - (kJYNotifyHeight)) style:UITableViewStylePlain];
    [_rootTBView.mj_header endRefreshing];
}


- (void)loadData {
    // 数据准备
    _user = [[User alloc]init];
    NSString *kpiUrl = [NSString stringWithFormat:@"%@/mobile/v2/data/group/%@/role/%@/kpi",kBaseUrl,self.user.groupID,self.user.roleID];
    HttpResponse *response = [HttpUtils httpGet:kpiUrl header:nil timeoutInterval:10];
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"kpi_data" ofType:@"json"];
  //  NSData *data = [NSData dataWithContentsOfFile:path];
    NSData *data = response.received;
    NSArray *arraySource = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"data"];
    NSMutableArray<JYDashboardModel *> *arr = [NSMutableArray arrayWithCapacity:arraySource.count];
    [arraySource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JYDashboardModel *model = [JYDashboardModel modelWithParams:obj];
        [arr addObject:model];
    }];
    
    dataList = [arr copy];
    
    NSMutableArray<JYDashboardModel *> *topList = [NSMutableArray array];
    NSMutableArray<JYDashboardModel *> *buttomList = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(JYDashboardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.stick) {
            [topList addObject:obj];
        }
        else {
            [buttomList addObject:obj];
        }
    }];
    dataListTop = [topList copy];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];// 数据分组
    for (int i = 0; i < buttomList.count; i++) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[dic objectForKey:buttomList[i].groupName]];
        [arr addObject:buttomList[i]];
        [dic setObject:arr forKey:buttomList[i].groupName];
    }
    dataListButtom = [dic allValues];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
  /*  self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 70, 40)];
    UIImage *imageback = [UIImage imageNamed:@"Banner-Back"];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 15, 25)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 50, 25)];
    backLabel.text = @"返回";
    backLabel.textColor = [UIColor whiteColor];
    [backBtn addSubview:backLabel];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
  //  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Subject-Refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(refreshView)];
    self.title =self.bannerTitle;*/
    

}


- (void)backAction{
    if (self.navigationController && self.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIScrollView *)rootSCView {
    
    if (!_rootTBView) {
        //给通知视图预留40height
        _rootTBView = [[UITableView alloc] initWithFrame:CGRectMake(0, kJYNotifyHeight + 64, JYVCWidth, JYVCHeight - (kJYNotifyHeight + 64 + 40)) style:UITableViewStylePlain];
        _rootTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootTBView.showsVerticalScrollIndicator = NO;
        _rootTBView.dataSource = self;
        _rootTBView.delegate = self;
        _rootTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootTBView.backgroundColor = JYColor_LightGray_White;
    }
    return _rootTBView;
}

- (JYNotifyView *)notifyView {
    if (!_notifyView) {
        NSArray *nots = @[@"暂无数据"];
        _notifyView = [[JYNotifyView alloc] initWithFrame:CGRectMake(0, 64, JYVCWidth, kJYNotifyHeight - 2)];
        _notifyView.notifications = nots;
        _notifyView.delegate = self;
        _notifyView.interval = 2.0;
        _notifyView.notifyColor = [UIColor colorWithHexString:@"#999"];
        _notifyView.closeBtnColor = [UIColor colorWithRed:0.84 green:0.30 blue:0.19 alpha:1.00];
    }
    return _notifyView;
}

// ************************************ 滚动部分 **************************************
- (JYPagedFlowView *)pageView {
    if (!_pageView) {
        _pageView = [[JYPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, JYVCWidth, kJYPageHeight)];
        _pageView.delegate = self;
        _pageView.dataSource = self;
        _pageView.backgroundColor = JYColor_LightGray_White;
        _pageView.minimumPageAlpha = 0.8;
        _pageView.minimumPageScale = 0.87;
    }
    return _pageView;
}

- (NSArray *)pages {
    NSMutableArray *temp = [NSMutableArray array];
    if (!_pages) {
        for (int i = 0; i < dataListTop.count; i++) {
            JYTopSinglePage *singlePage = [[JYTopSinglePage alloc] init];
            singlePage.backgroundColor = [UIColor whiteColor];
            singlePage.layer.cornerRadius = JYDefaultMargin;
            singlePage.model = dataListTop[i];
            [temp addObject:singlePage];
        }
        _pages = [temp copy];
    }
    return _pages;
}

// ************************************ 平铺部分 **************************************

- (JYFallsView *)fallsView {
    if (!_fallsView) {
        
        _fallsView = [[JYFallsView alloc] initWithFrame:CGRectMake(0, 0, JYVCWidth, JYVCHeight)];
        _fallsView.dataSource = dataListButtom;
        _fallsView.delegate = self;
    }
    return _fallsView;
}

#pragma mark - < UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([dataListTop count] >0 || dataListTop != nil) {
       return indexPath.section == 0 ? kJYPageHeight : bottomViewHeight;
    }
    else{
        return indexPath.section == 0 ? 0: bottomViewHeight;
    }
}

#pragma mark - <UITableViewDelegate>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = JYColor_LightGray_White;
    if (indexPath.section == 0) {
        if ([dataListTop count] >0 || dataListTop != nil){
          [cell.contentView addSubview:self.pageView];
        }
        else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.height = 0;
        }
    }
    else {
        [cell.contentView addSubview:self.fallsView];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

#pragma mark - <PagedFlowViewDataSource>
- (NSInteger)numberOfPagesInFlowView:(JYPagedFlowView *)flowView {
    return dataListTop.count;
}

- (UIView *)flowView:(JYPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    return self.pages[index];
}

#pragma mark - <PagedFlowViewDelegate>
- (CGSize)sizeForPageInFlowView:(JYPagedFlowView *)flowView {
    return CGSizeMake(JYVCWidth - JYDefaultMargin * 6, kJYPageHeight - JYDefaultMargin);
}

- (void)flowView:(JYPagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index {
    NSLog(@"seleted index:%zi", index);
    JYDashboardModel *model = dataListTop[index];
    NSLog(@"%@",model.targeturl);
    NSString *targetString = [NSString stringWithFormat:@"%@",model.targeturl];
    if (![model.targeturl hasPrefix:@"http"]) {
        targetString = [NSString stringWithFormat:@"/%@",model.targeturl];
    }
    [self jumpToDetailView:targetString viewTitle:model.title];
    
}

#pragma mark - <JYNotifyDelegate>
- (void)notifyView:(JYNotifyView *)notify didSelected:(NSInteger)idx selectedData:(id)data {
    NSLog(@"seleted index:%zi data:%@", idx, data);
}

- (void)closeNotifyView:(JYNotifyView *)notify {
    CGRect frame = self.rootTBView.frame;
    frame.origin.y = 64;
    frame.size.height += 40;
    [UIView animateWithDuration:0.5 animations:^{
        self.rootTBView.frame = frame;
    }];
}

#pragma mark - <JYFallsViewDelegate>
- (void)fallsView:(JYFallsView *)fallsView refreshHeight:(CGFloat)height {
    bottomViewHeight = height;
    CGRect frame = self.fallsView.frame;
    frame.size.height = height;
    self.fallsView.frame = frame;
    [self.rootTBView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)fallsView:(JYFallsView *)fallsView didSelectedItemAtIndex:(NSInteger)idx data:(id)data{
    NSLog(@"seleted index:%zi data:%@", idx, data);
    JYDashboardModel *model = data;
    NSLog(@"%@",model.targeturl);
     NSString *targetString = [NSString stringWithFormat:@"%@",model.targeturl];
    if (![model.targeturl hasPrefix:@"http"]) {
      targetString = [NSString stringWithFormat:@"/%@",model.targeturl];
    }
    [self jumpToDetailView:targetString viewTitle:model.title];
}


-(void)jumpToDetailView:(NSString*)targeturl viewTitle:(NSString*)title{
    if ([targeturl isEqualToString:@""] || targeturl == nil) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"该功能正在开发中"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
       SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
       subjectView.bannerName =title;
       subjectView.link = targeturl;
    // subjectView.objectID = data[@"objectID"];
       if ([targeturl rangeOfString:@"template/3/"].location != NSNotFound) {
          [MRProgressOverlayView showOverlayAddedTo:self.view title:@"加载中" mode:MRProgressOverlayViewModeIndeterminate animated:YES];
          NSArray * models = [HomeIndexModel homeIndexModelWithJson:nil withUrl:targeturl];
        
          HomeIndexVC *vc = [[HomeIndexVC alloc] init];
          vc.bannerTitle = title;
          vc.dataLink = targeturl;
          [vc setWithHomeIndexArray:models];
          [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
          if (models.count <= 0 || !models) {
             [ViewUtils showPopupView:self.view Info:@"数据为空"];
         }
         else{
             UINavigationController *rootchatNav = [[UINavigationController alloc]initWithRootViewController:vc];
             [self presentViewController:rootchatNav animated:YES completion:nil];
         }
        
     }
     else if ([targeturl rangeOfString:@"template/5/"].location != NSNotFound) {
         SuperChartVc *superChaerCtrl = [[SuperChartVc alloc]init];
         superChaerCtrl.bannerTitle = title;
         superChaerCtrl.dataLink = targeturl;
         UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
         [self presentViewController:superChartNavCtrl animated:YES completion:nil];
     }
    /* else if ([data[@"link"] rangeOfString:@"template/"].location != NSNotFound){
     if ([data[@"link"] rangeOfString:@"template/5/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/1/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/2/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/3/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/4/"].location == NSNotFound) {
     SCLAlertView *alert = [[SCLAlertView alloc] init];
     [alert addButton:@"下一次" actionBlock:^(void) {}];
     [alert addButton:@"立刻升级" actionBlock:^(void) {
     NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     [[UIApplication sharedApplication] openURL:url];
     }];
     [alert showSuccess:self title:@"温馨提示" subTitle:@"您当前的版本暂不支持该模块，请升级之后查看" closeButtonTitle:nil duration:0.0f];
     }
     }*/
       else if ([targeturl rangeOfString:@"whatever/group/1/original/kpi"].location != NSNotFound){
          JYHomeViewController *jyHome = [[JYHomeViewController alloc]init];
          jyHome.bannerTitle = title;
          jyHome.dataLink = targeturl;
          UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:jyHome];
          [self presentViewController:superChartNavCtrl animated:YES completion:nil];
      }
      else{ //跳转事件
          [self.navigationController presentViewController:subjectView animated:YES completion:nil];
      }
    }
}
@end




