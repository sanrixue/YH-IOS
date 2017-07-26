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
#import "ResetPasswordViewController.h"
#import "User.h"
#import "SDCycleScrollView.h"
#import "YHKPIModel.h"
#import "SubjectOutterViewController.h"


#define kJYNotifyHeight 40

@interface JYHomeViewController () <UITableViewDelegate, UITableViewDataSource, PagedFlowViewDelegate, PagedFlowViewDataSource, JYNotifyDelegate, JYFallsViewDelegate,SDCycleScrollViewDelegate> {
    
    CGFloat bottomViewHeight;
    NSArray *dataListTop;
    NSMutableArray *dataListButtom;
    NSArray *dataList;
    SDCycleScrollView *_cycleScrollView;
}

@property (nonatomic, strong) UITableView *rootTBView;

@property (nonatomic, strong) JYNotifyView *notifyView;
@property (nonatomic, copy) NSArray *pages;
@property (nonatomic, strong) JYPagedFlowView *pageView;
@property (nonatomic, strong) JYFallsView *fallsView;
@property (nonatomic, strong) MJRefreshGifHeader *header;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSMutableArray* noticeArray;
@property (nonatomic, strong) NSArray *dropMenuTitles;
@property (nonatomic, strong) NSArray *dropMenuIcons;
@property (nonatomic, strong) UITableView *dropMenu;
@property (nonatomic, strong) NSMutableArray* titleArray;
@property (nonatomic, strong) NSArray<YHKPIModel *> * modelKpiArray;
@property (nonatomic, strong) YHKPIModel* modeltop;

@end

@implementation JYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [[User alloc]init];
    // Do any additional setup after loading the view.
    //self.automaticallyAdjustsScrollViewInsets = YES;
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _noticeArray = [[NSMutableArray alloc]init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    dataListButtom = [NSMutableArray new];
    self.tabBarController.tabBar.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9f"];
    self.navigationController.navigationBar.backgroundColor =[UIColor colorWithHexString:@"#f9f9f9f"];
    [self loadData];
    [self getData];
   // self.edgesForExtendedLayout = UIRectEdgeNone;
    [self idColor];
    bottomViewHeight = JYVCHeight;
    
    //UIView *topIamgeView = [self addHeaderView];
    //[self.view addSubview:topIamgeView];
    //[self.view addSubview:self.notifyView];
    [self.view addSubview:self.rootSCView];
    
    _header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _header.lastUpdatedTimeLabel.hidden = YES;
   self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.rootTBView.mj_header = _header;
    //原始推送跳转
    /*if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receiveRemote"] boolValue]) {
        self.tabBarController.selectedIndex = 3;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"receiveRemote"];
    }*/
    [self noteToChangePwd];
    
}

-(void)loadNewData{
    [self.rootTBView.mj_header beginRefreshing];
    [self getData];
   // [self.rootTBView reloadData];
   // _rootTBView = [[UITableView alloc] initWithFrame:CGRectMake(0, kJYNotifyHeight, JYVCWidth, JYVCHeight - (kJYNotifyHeight)) style:UITableViewStylePlain];
    [_rootTBView.mj_header endRefreshing];
}



- (void)loadData {
    // 数据准备
   /* _user = [[User alloc]init];
    _titleArray = [[NSMutableArray alloc]init];
    NSString *kpiUrl = [NSString stringWithFormat:@"%@/api/v1/group/%@/role/%@/kpi",kBaseUrl2,self.user.groupID,self.user.roleID];
   // NSString *kpiUrl = @"http://yonghui-test.idata.mobi/api/v1/group/165/role/7/kpi";
    NSData *data;
     NSString *javascriptPath = [[FileUtils userspace] stringByAppendingPathComponent:@"HTML"];
     NSString*fileName =  [HttpUtils urlTofilename:kpiUrl suffix:@".kpi"][0];
     javascriptPath = [javascriptPath stringByAppendingPathComponent:fileName];
     
     if ([HttpUtils isNetworkAvailable2]) {
        HttpResponse *reponse = [HttpUtils httpGet:kpiUrl];
        if ([FileUtils checkFileExist:javascriptPath isDir:NO]) {
            [FileUtils removeFile:javascriptPath];
        }
         data = reponse.received;
         [reponse.received writeToFile:javascriptPath atomically:YES];
       }
    else{
        data= [NSData dataWithContentsOfFile:javascriptPath];
     }
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"kpi_data" ofType:@"json"];
  //  NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *arraySource = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"data"];
    NSArray *demolArray = [MTLJSONAdapter modelsOfClass:YHKPIModel.class fromJSONArray:arraySource error:nil];
    self.modelKpiArray = [demolArray copy];
    NSArray *arraySource1 = arraySource[1][@"data"];
    NSMutableArray<JYDashboardModel *> *arr = [NSMutableArray arrayWithCapacity:arraySource.count];
    [arraySource1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JYDashboardModel *model = [JYDashboardModel modelWithParams:obj];
        [arr addObject:model];
       // [_titleArray addObject:model.groupName];
    }];
      dataList = [NSMutableArray new];
    [dataList arrayByAddingObjectsFromArray:arr];
    
    NSArray *arraySource2 = arraySource[2][@"data"];
    NSMutableArray<JYDashboardModel *> *arr1 = [NSMutableArray arrayWithCapacity:arraySource.count];
    [arraySource2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JYDashboardModel *model = [JYDashboardModel modelWithParams:obj];
        [arr1 addObject:model];
        // [_titleArray addObject:model.groupName];
    }];
    
    [dataList arrayByAddingObjectsFromArray:arr1];
    
    // NSArray *arraySource2 = arraySource[0][@"data"];
    NSMutableArray<JYDashboardModel *> *topList = [NSMutableArray array];
    NSMutableArray<JYDashboardModel *> *buttomList = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(JYDashboardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.stick) {
            [topList addObject:obj];
        }
        else {
            [buttomList addObject:obj];
            if (![_titleArray containsObject:obj.groupName]) {
          //      [_titleArray addObject:obj.groupName];
            }
        }
    }];
    dataListTop = [topList copy];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];// 数据分组
    for (int i = 0; i < buttomList.count; i++) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[dic objectForKey:buttomList[i].groupName]];
        [arr addObject:buttomList[i]];
        [dic setObject:arr forKey:buttomList[i].groupName];
    }
    NSMutableArray* dicArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<_titleArray.count;i++) {
        NSString* keyString = _titleArray[i];
        [dicArray addObject:dic[keyString]];
    }
   // dataListButtom = @[arr,arr1];
    */
    NSString *messageUrl = [NSString stringWithFormat:@"%@/api/v1/role/%@/group/%@/user/%@/message",kBaseUrl,self.user.roleID,self.user.groupID,self.user.userID];
    HttpResponse *responsemessage = [HttpUtils httpGet:messageUrl header:nil timeoutInterval:10];
    if ([responsemessage.statusCode isEqualToNumber:@(200)]) {
        [_noticeArray removeAllObjects];
        NSData *data = responsemessage.received;
         NSArray *arraySource = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"data"];
        for (NSDictionary* dict in arraySource) {
            if(![dict[@"title"] isEqual:nil] && ![dict[@"title"] isEqualToString:@""]){
                [_noticeArray addObject:dict[@"title"]];
            }
        }
    }
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"kpi_data" ofType:@"json"];
    //  NSData *data = [NSData dataWithContentsOfFile:path];
    
}

-(UIView*)footerView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-11, 7, 22, 22)];
    imageView.image = [UIImage imageNamed:@"refresh-footer"];
    [footerView addSubview:imageView];
    return footerView;
}


- (void)getData{
    [dataListButtom removeAllObjects];
    NSString *kpiUrl = [NSString stringWithFormat:@"%@/api/v1/group/%@/role/%@/kpi",kBaseUrl,self.user.groupID,self.user.roleID];
    // NSString *kpiUrl = @"http://yonghui-test.idata.mobi/api/v1/group/165/role/7/kpi";
    NSData *data;
    NSString *javascriptPath = [[FileUtils userspace] stringByAppendingPathComponent:@"HTML"];
    NSString*fileName =  [HttpUtils urlTofilename:kpiUrl suffix:@".kpi"][0];
    javascriptPath = [javascriptPath stringByAppendingPathComponent:fileName];
    
    if ([HttpUtils isNetworkAvailable3]) {
        HttpResponse *reponse = [HttpUtils httpGet:kpiUrl];
        if ([FileUtils checkFileExist:javascriptPath isDir:NO]) {
            [FileUtils removeFile:javascriptPath];
        }
        data = reponse.received;
        [reponse.received writeToFile:javascriptPath atomically:YES];
    }
    else{
        data= [NSData dataWithContentsOfFile:javascriptPath];
    }
    
    if (!data) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"重新加载" actionBlock:^(void) {
            [self getData];
        }];
        [alert showSuccess:self title:@"温馨提示" subTitle:@"请检查您的网络状态" closeButtonTitle:nil duration:0.0f];
        return;
    }
    else {
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"kpi_data" ofType:@"json"];
    //  NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *arraySource = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"data"];
    NSArray<YHKPIModel *> *demolArray = [MTLJSONAdapter modelsOfClass:YHKPIModel.class fromJSONArray:arraySource error:nil];
    for (int i=0; i<demolArray.count; i++) {
        if ([demolArray[i].group_name isEqualToString:@"top_data"]) {
            self.modeltop = demolArray[i];
        }
        else{
            [dataListButtom addObject:demolArray[i]];
        }
    }
    }
    [self.rootTBView reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
      self.tabBarController.tabBar.translucent = NO;
    
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

//标识点
- (void)idColor {
    UIView* idView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50,34, 30, 10)];
    //idView.backgroundColor = [UIColor redColor];
    //[self.navigationController.navigationBar addSubview:idView];
    
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


- (void)backAction{
    if (self.navigationController && self.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


// 添加顶部轮播图

- (UIView*)addHeaderView{
    
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
   // NSArray *imagesURLStrings = @[
     //                             @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t1402/221/421883372/88115/8cc2231a/55815835N35a44559.jpg",
       //                           @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t976/208/1221678737/91179/5d7143d5/5588e849Na2c20c1a.jpg",
         //                         @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t805/241/1199341035/289354/8648fe55/5581211eN7a2ebb8a.jpg",
           //                       @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t1606/199/444346922/48930/355f9ef/55841cd0N92d9fa7c.jpg",
             //                     @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t1609/58/409100493/49144/7055bec5/557e76bfNc065aeaf.jpg",
               //                   @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t895/234/1192509025/111466/512174ab/557fed56N3e023b70.jpg",
                 //                 @"http://img30.360buyimg.com/mobilecms/sc480x180_jfs/t835/313/1196724882/359493/b53c7b70/5581392cNa08ff0a9.jpg",
                   //               @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t898/15//1262262696/95281/57d1f12f/558baeb4Nbfd44d3a.jpg"
                                  //];
    
    NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
    [imagesURLStrings removeAllObjects];
    for (int i =0 ;i<self.modeltop.data.count; i++) {
        [imagesURLStrings addObject:@"banner-bg"];
    }
    
    // 网络加载 --- 创建不带标题的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, 150) imageURLStringsGroup:nil];
    _cycleScrollView.model = self.modeltop;
    _cycleScrollView.infiniteLoop = YES;
    _cycleScrollView.delegate = self;
    _cycleScrollView.placeholderImage=[UIImage imageNamed:@"banner-bg"];
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.autoScrollTimeInterval = 9.0; // 轮播时间间隔，默认1.0秒，可自定义
    
    
    //模拟加载延迟
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cycleScrollView.imageURLStringsGroup = [imagesURLStrings copy];
   // });
    
    [header addSubview:_cycleScrollView];
    
    
    return header;
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    YHKPIDetailModel *item = self.modeltop.data[index];
    NSString *targetString = [NSString stringWithFormat:@"%@",item.targeturl];
    if (![item.targeturl hasPrefix:@"http"]) {
        targetString = [NSString stringWithFormat:@"/%@",item.targeturl];
    }
    [self jumpToDetailView:targetString viewTitle:item.title];
}

- (UIScrollView *)rootSCView {
    
    if (!_rootTBView) {
        //给通知视图预留40height
        _rootTBView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, JYVCWidth, self.view.frame.size.height) style:UITableViewStylePlain];
        _rootTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootTBView.showsVerticalScrollIndicator = NO;
        _rootTBView.dataSource = self;
        _rootTBView.delegate = self;
        _rootTBView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _rootTBView.tableHeaderView = [self addHeaderView];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _rootTBView.tableFooterView = [self footerView];
        _rootTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootTBView.backgroundColor = [UIColor whiteColor];
    }
    return _rootTBView;
}

- (JYNotifyView *)notifyView {
    if (!_notifyView) {
        NSMutableArray* noticearray = [[NSMutableArray alloc]init];
        _notifyView = [[JYNotifyView alloc] initWithFrame:CGRectMake(0, 0, JYVCWidth, kJYNotifyHeight)];
        if (_noticeArray.count >=2) {
            [noticearray addObject:[NSString stringWithFormat:@"%@", _noticeArray[0]]];
             [noticearray addObject:[NSString stringWithFormat:@"%@",_noticeArray[1]]];
        }
        else if (_noticeArray.count ==1){
             [noticearray addObject:[NSString stringWithFormat:@"%@",_noticeArray[0]]];
        }
        else{
            [noticearray addObject:@"暂无消息"];
        }
        _notifyView.notifications = noticearray;
        _notifyView.delegate = self;
        _notifyView.interval = 9.0;
        _notifyView.userInteractionEnabled = NO;
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
    //if (!_fallsView) {
        
        _fallsView = [[JYFallsView alloc] initWithFrame:CGRectMake(5, 5, JYVCWidth-10, JYVCHeight-10)];
        _fallsView.dataSource = dataListButtom;
        _fallsView.delegate = self;
   // }
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
    if ([dataListTop count] >0 && dataListTop != nil) {
       return indexPath.section == 0 ? JYVCHeight : bottomViewHeight;
    }
    else{
        return indexPath.section == 0 ? kJYNotifyHeight: bottomViewHeight;
    }
}

#pragma mark - <UITableViewDelegate>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = JYColor_LightGray_White;
    if (indexPath.section == 0) {
        //if ([dataListTop count] >0 && dataListTop != nil){
          [cell.contentView addSubview:self.notifyView];
      //  }
       /* else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.height = 0;
        }*/
       // [cell.contentView addSubview:_notifyView];
    }
    else{
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#f7fef5"];
        [cell.contentView addSubview:self.fallsView];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.tabBarController.selectedIndex = 3;
    }
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
    self.tabBarController.selectedIndex = 3;
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
    YHKPIDetailModel *model = data;
    NSLog(@"%@",model.targeturl);
     NSString *targetString = [NSString stringWithFormat:@"%@",model.targeturl];
    if (![model.targeturl hasPrefix:@"http"]) {
      targetString = [NSString stringWithFormat:@"/%@",model.targeturl];
    }
    [self jumpToDetailView:targetString viewTitle:model.title];
}

-(void)noteToChangePwd{
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    if ([userDict[@"password_md5"] isEqualToString:@"123456".md5]) {
        [alert addButton:@"稍后修改" actionBlock:^(void) {
        }];
        [alert addButton:@"立即修改" actionBlock:^(void) {
            [self ResetPassword];
        }];
        [alert showSuccess:self title:@"温馨提示" subTitle:@"安全起见，请在【个人信息】-【基本信息】-【修改登录密码】页面修改初始密码" closeButtonTitle:nil duration:0.0f];
    }
}

// 修改密码
- (void)ResetPassword {
    ResetPasswordViewController *resertPwdViewController = [[ResetPasswordViewController alloc]init];
    resertPwdViewController.title = @"修改密码";

    
    UINavigationController *reserPwdCtrl = [[UINavigationController alloc]initWithRootViewController:resertPwdViewController];
    [self.navigationController presentViewController:reserPwdCtrl animated:YES completion:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"点击/设置页面/修改密码";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}

-(void)jumpToDetailView:(NSString*)targeturl viewTitle:(NSString*)title{
    NSArray *urlArray = [targeturl componentsSeparatedByString:@"/"];
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
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
        BOOL isInnerLink = !([targeturl hasPrefix:@"http://"] || [targeturl hasPrefix:@"https://"]);
       if ([targeturl rangeOfString:@"template/3/"].location != NSNotFound) {
          HomeIndexVC *vc = [[HomeIndexVC alloc] init];
          vc.bannerTitle = title;
          vc.dataLink = targeturl;
           vc.objectID =[urlArray lastObject];
          vc.commentObjectType = ObjectTypeAnalyse;
          UINavigationController *rootchatNav = [[UINavigationController alloc]initWithRootViewController:vc];
           logParams[kActionALCName]   = @"点击/生意概况/报表";
           logParams[kObjIDALCName]    = [NSString stringWithFormat:@"%@",[urlArray lastObject]];
           logParams[kObjTypeALCName]  = @(ObjectTypeKpi);
           logParams[kObjTitleALCName] =  title;
           /*
            * 用户行为记录, 单独异常处理，不可影响用户体验
            */
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               @try {
                   [APIHelper actionLog:logParams];
               }
               @catch (NSException *exception) {
                   NSLog(@"%@", exception);
               }
           });

          [self presentViewController:rootchatNav animated:YES completion:nil];
        
     }
     else if ([targeturl rangeOfString:@"template/5/"].location != NSNotFound) {
         SuperChartVc *superChaerCtrl = [[SuperChartVc alloc]init];
         superChaerCtrl.bannerTitle = title;
         superChaerCtrl.dataLink = targeturl;
         superChaerCtrl.objectID =[urlArray lastObject];
         superChaerCtrl.commentObjectType = ObjectTypeKpi;
         UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
         logParams[kActionALCName]   = @"点击/生意概况/报表";
         logParams[kObjIDALCName]    = [NSString stringWithFormat:@"%@",[urlArray lastObject]];
         logParams[kObjTypeALCName]  = @(ObjectTypeKpi);
         logParams[kObjTitleALCName] =  title;
         /*
          * 用户行为记录, 单独异常处理，不可影响用户体验
          */
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             @try {
                 [APIHelper actionLog:logParams];
             }
             @catch (NSException *exception) {
                 NSLog(@"%@", exception);
             }
         });

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
          logParams[kActionALCName]   = @"点击/生意概况/报表";
          logParams[kObjIDALCName]    = [NSString stringWithFormat:@"%@",[urlArray lastObject]];
          logParams[kObjTypeALCName]  = @(ObjectTypeKpi);
          logParams[kObjTitleALCName] =  title;
          /*
           * 用户行为记录, 单独异常处理，不可影响用户体验
           */
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              @try {
                  [APIHelper actionLog:logParams];
              }
              @catch (NSException *exception) {
                  NSLog(@"%@", exception);
              }
          });

          if (isInnerLink) {
              UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
              
              SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
              subjectView.bannerName =title;
              subjectView.link = targeturl;
              subjectView.commentObjectType = ObjectTypeKpi;
              subjectView.objectID = [urlArray lastObject];
              UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
              [self.navigationController presentViewController:subCtrl animated:YES completion:nil];
          }
          else{
              
              SubjectOutterViewController *subjectView = [[SubjectOutterViewController alloc]init];
              subjectView.bannerName = title;
              subjectView.link = targeturl;
              subjectView.commentObjectType = ObjectTypeKpi;
              subjectView.objectID = [urlArray lastObject];
              //UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
              
              [self.navigationController presentViewController:subjectView animated:YES completion:nil];
          }
      }
    }
}
@end




