//
//  NoticeTableViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NoticeTableViewController.h"
#import "MineNoticeTableViewCell.h"
#import "NoticeDetailViewController.h"
#import "DropViewController.h"
#import "DropTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "MessageNotice.h"
#import "zoomPopup.h"
#import "MLMOptionSelectView.h"
#import "UIView+Category.h"
#import "CustomCell.h"
#import "User.h"

@interface NoticeTableViewController ()<UITableViewDelegate,UITableViewDataSource,CustomCellDelegate>
{
    NSMutableArray *listArray;
    
    
    UILabel *topBottomView;
    
    UILabel *centerShowView;
    UILabel *vhBottomView;
    NSArray* typeArray;
    User *user;

}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dropMenuTitles;
@property (nonatomic, strong) NSArray *dropMenuIcons;
@property (nonatomic, strong) UITableView *dropMenu;
@property (nonatomic, strong) NSMutableArray<MessageNotice *>* dataArray;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) zoomPopup *popup;
@property (nonatomic, assign) BOOL isHadPopView;
@property (nonatomic, strong) MLMOptionSelectView *cellView;
@property (nonatomic, strong)  UIButton *filterButton;
@property (nonatomic, strong) UIView* showpopViewRectView;
@property (nonatomic, strong) NSMutableArray* typeChoiceArray;
@property (nonatomic, assign) int pageNum;
@property (nonatomic, assign) int totoalPage;


@end

@implementation NoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [[User alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataWithType) name:@"needrefreshTableView" object:nil];
    self.typeChoiceArray = [NSMutableArray arrayWithObjects:@1,@1,@1,@1, nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT-35-30- 49) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineNoticeTableViewCell"];
    self.dataArray = [[NSMutableArray alloc]init];
    self.selectView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130, 35, 122, 120)];
    [self.tableView addSubview:_selectView];
    
    _isHidden = YES;
    
    self.filterButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 38, 56, 40, 24)];
  //  [_filterButton setImage:[UIImage imageNamed:@"btn-filter"] forState:UIControlStateNormal];
    [_filterButton setBackgroundImage:[UIImage imageNamed:@"btn-filter"] forState:UIControlStateNormal];
    [self.view addSubview:_filterButton];
    _filterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _filterButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [self.tableView bringSubviewToFront:_filterButton];
    [self getDataWithType];
    _showpopViewRectView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 65,2 , 2)];
    [self.view addSubview:_showpopViewRectView];
                                                                   
    typeArray = @[@"系统公告",@"业务公告",@"预警系统",@"报表评论"];
    listArray = [NSMutableArray arrayWithArray:typeArray];
    
    _cellView = [[MLMOptionSelectView alloc] initOptionView];
    
    
    [self leftRight];
    [self setRefresh];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDataWithRefresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataWithPage)];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}


-(void)getDataWithType{
    //WEAK(weakSelf, self);
    //[weakSelf.cellView dismiss];
    [self.dataArray removeAllObjects];
    [MRProgressOverlayView showOverlayAddedTo:self.tableView title:@"加载中" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    NSMutableString *tyeString = [[NSMutableString alloc]init];
    for (int i =0; i<_typeChoiceArray.count - 1; i++) {
        if ([_typeChoiceArray[i] boolValue]) {
            NSString *addString = [NSString stringWithFormat:@"%d,",i+1];
            [tyeString appendString:addString];
        }
    }
    if ([_typeChoiceArray[_typeChoiceArray.count-1] boolValue]) {
         [tyeString appendString:[NSString stringWithFormat:@"%lu",(unsigned long)_typeChoiceArray.count]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[ NSString stringWithFormat:@"%@/api/v1/user/%@/type/%@/page/1/limit/10/notices", kBaseUrl,user.userNum,tyeString]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          NSArray *dataArray = responseObject[@"data"];
          _pageNum = [responseObject[@"curr_page"] intValue];
          self.totoalPage = [responseObject[@"total_page"] intValue];
          [MRProgressOverlayView dismissOverlayForView:self.tableView animated:YES];
           [self.tableView.mj_header endRefreshing];
          NSArray<MessageNotice *> *modelArray =[MTLJSONAdapter modelsOfClass:MessageNotice.class fromJSONArray:dataArray error:nil];
          [self.dataArray appendObjects:modelArray];
          [self.tableView reloadData];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
}

-(void)getDataWithRefresh{
    [self.dataArray removeAllObjects];
    NSMutableString *tyeString = [[NSMutableString alloc]init];
    for (int i =0; i<_typeChoiceArray.count - 1; i++) {
        if ([_typeChoiceArray[i] boolValue]) {
            NSString *addString = [NSString stringWithFormat:@"%d,",i+1];
            [tyeString appendString:addString];
        }
    }
    if ([_typeChoiceArray[_typeChoiceArray.count-1] boolValue]) {
        [tyeString appendString:[NSString stringWithFormat:@"%lu",(unsigned long)_typeChoiceArray.count]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[ NSString stringWithFormat:@"%@/api/v1/user/%@/type/%@/page/1/limit/10/notices", kBaseUrl,user.userID,tyeString]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          NSArray *dataArray = responseObject[@"data"];
          _pageNum = [responseObject[@"curr_page"] intValue];
          self.totoalPage = [responseObject[@"total_page"] intValue];
          [self.tableView.mj_header endRefreshing];
          NSArray<MessageNotice *> *modelArray =[MTLJSONAdapter modelsOfClass:MessageNotice.class fromJSONArray:dataArray error:nil];
          [self.dataArray appendObjects:modelArray];
          [self.tableView reloadData];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
}


-(void)getDataWithPage{
    if (_pageNum == _totoalPage) {
        [ViewUtils showPopupView:self.view Info:@"已是全部数据"];
    }
    NSString *page = [NSString stringWithFormat:@"%d",_pageNum+1];
    NSMutableString *tyeString = [[NSMutableString alloc]init];
    for (int i =0; i<_typeChoiceArray.count - 1; i++) {
        if ([_typeChoiceArray[i] boolValue]) {
            NSString *addString = [NSString stringWithFormat:@"%d,",i+1];
            [tyeString appendString:addString];
        }
    }
    if ([_typeChoiceArray[_typeChoiceArray.count-1] boolValue]) {
        [tyeString appendString:[NSString stringWithFormat:@"%lu",(unsigned long)_typeChoiceArray.count]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[ NSString stringWithFormat:@"%@/api/v1/user/%@/type/%@/page/%@/limit/10/notices", kBaseUrl,user.userID,tyeString,page]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          NSArray *dataArray = responseObject[@"data"];
          _pageNum = [responseObject[@"curr_page"] intValue];
          self.totoalPage = [responseObject[@"total_page"] intValue];
          [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
          NSArray<MessageNotice *> *modelArray =[MTLJSONAdapter modelsOfClass:MessageNotice.class fromJSONArray:dataArray error:nil];
          [self.dataArray appendObjects:modelArray];
          [self.tableView reloadData];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 左右
- (void)leftRight {
    _cellView.canEdit = NO;
    [_filterButton tapHandle:^{
        [self customCell];
        _cellView.vhShow = NO;
        _cellView.optionType = MLMOptionSelectViewTypeCustom;
        _cellView.selectedOption = nil;
        
#warning ---- 想保持无论何种情况都上、下对齐,可以选择自己想要对齐的边，重新设置edgeInset
        CGRect rect = [MLMOptionSelectView targetView:_showpopViewRectView];
        _cellView.edgeInsets = UIEdgeInsetsMake(rect.origin.y+10, 100, 0, 0);
        
        [_cellView showOffSetScale:.2 viewWidth:150 targetView:_showpopViewRectView direction:MLMOptionSelectViewRight];
    }];
}


#pragma mark - 设置——cell
- (void)customCell {
    WEAK(weaklistArray, listArray);
    WEAK(weakSelf, self);
    _cellView.canEdit = NO;
    _cellView.layer.cornerRadius = 0;
    _cellView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cellView.layer.borderWidth = 1;
    [_cellView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    _cellView.cell = ^(NSIndexPath *indexPath){
        CustomCell *cell = [weakSelf.cellView dequeueReusableCellWithIdentifier:@"CustomCell"];
        cell.label1.text = weaklistArray[indexPath.row];
        cell.cellId = indexPath.row;
        cell.delegate = weakSelf;
        return cell;
    };
    _cellView.optionCellHeight = ^{
        return 40.f;
    };
    _cellView.rowNumber = ^(){
        return (NSInteger)weaklistArray.count;
    };
    _cellView.selectedOption = ^(NSIndexPath *indexPath){
        
        NSLog(@"返回的是什么呢");
    };
    //删除某个选项
    _cellView.removeOption = ^(NSIndexPath *indexPath){
        [weaklistArray removeObjectAtIndex:indexPath.row];
        if (weaklistArray.count == 0) {
            [weakSelf.cellView dismiss];
        }
    };
}

-(void)SwitchTableViewCellButtonClick:(UISwitch *)button with:(NSInteger)cellId{
    NSLog(@"这最好的时代");
    if (!button.isOn) {
        self.typeChoiceArray[cellId] = @0;
    }
    else{
        self.typeChoiceArray[cellId] = @1;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     MineNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineNoticeTableViewCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[MineNoticeTableViewCell alloc]init];
    }
    
    cell.titleLable.text = [NSString stringWithFormat:@"#%@#%@" ,typeArray[self.dataArray[indexPath.row].noticeType-1],self.dataArray[indexPath.row].title];
    cell.timeLable.text = self.dataArray[indexPath.row].time;
    cell.contentLable.text = self.dataArray[indexPath.row].abstracts;
    [cell.noteView setHidden:self.dataArray[indexPath.row].see];
    
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"f7fef5"];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MineNoticeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.noteView setHidden:YES];
    if (_isHadPopView) {
        [_popup closePopup];
        _isHadPopView = NO;
    }
    else {
      NoticeDetailViewController *detailCtrl = [[NoticeDetailViewController alloc]init];
       detailCtrl.title = @"公告详情";
       detailCtrl.noticeID =[NSString stringWithFormat:@"%d" ,self.dataArray[indexPath.row].noticeID];
          [self.navigationController pushViewController:detailCtrl animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end