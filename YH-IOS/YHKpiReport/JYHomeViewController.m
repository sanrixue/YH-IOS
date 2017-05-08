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

#define kJYPageHeight 218
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


@end

@implementation JYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = JYColor_LightGray_White;
    
    [self loadData];
    
    bottomViewHeight = JYVCHeight;
    
    [self.view addSubview:self.notifyView];
    [self.view addSubview:self.rootSCView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
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
    self.title = self.bannerTitle;
}

- (void)backAction{
    if (self.navigationController && self.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)loadData {
    // 数据准备
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kpi_data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
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
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < buttomList.count; i++) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[dic objectForKey:buttomList[i].groupName]];
        [arr addObject:buttomList[i]];
        [dic setObject:arr forKey:buttomList[i].groupName];
    }
    dataListButtom = [dic allValues];
}

- (UIScrollView *)rootSCView {
    
    if (!_rootTBView) {
        //给通知视图预留40height
        _rootTBView = [[UITableView alloc] initWithFrame:CGRectMake(0, kJYNotifyHeight + 64, JYVCWidth, JYVCHeight - (kJYNotifyHeight + 64 + 49)) style:UITableViewStylePlain];
        _rootTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootTBView.showsVerticalScrollIndicator = NO;
        _rootTBView.dataSource = self;
        _rootTBView.delegate = self;
        _rootTBView.backgroundColor = JYColor_LightGray_White;
    }
    return _rootTBView;
}

- (JYNotifyView *)notifyView {
    if (!_notifyView) {
        NSArray *nots = @[@"模板3配置成功", @"模板5配置成功", @"KPI 页面配置成功"];
        _notifyView = [[JYNotifyView alloc] initWithFrame:CGRectMake(0, 64, JYVCWidth, kJYNotifyHeight - 2)];
        _notifyView.notifications = nots;
        _notifyView.delegate = self;
        _notifyView.interval = 2.0;
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
        for (int i = 0; i < dataList.count; i++) {
            JYTopSinglePage *singlePage = [[JYTopSinglePage alloc] init];
            singlePage.backgroundColor = [UIColor whiteColor];
            singlePage.layer.cornerRadius = JYDefaultMargin;
            singlePage.model = dataList[i];
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
    return indexPath.section == 0 ? kJYPageHeight : bottomViewHeight;
}

#pragma mark - <UITableViewDelegate>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = JYColor_LightGray_White;
    }
    
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.pageView];
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
    return dataList.count;
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
}

@end




