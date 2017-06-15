//
//  MineRequestListViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineRequestListViewController.h"
#import "MineQuestionViewController.h"
#import "MineRequestListCell.h"
#import "MyQuestion.h"
#import "MyRequestDetailViewController.h"
#import "User.h"


@interface MineRequestListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray<MyQuestion *> *dataArray;
@property(nonatomic, strong)User *user;
@property (nonatomic, assign) int pageNum;
@property (nonatomic, assign) int totoalPage;

@end

@implementation MineRequestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.tabBarController.tabBar setHidden:YES];
    self.user = [[User alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
    
    [self setupUI];
    [self getData];
     [self setRefresh];
    // Do any additional setup after loading the view.
}


-(void)setRefresh{
    if (self.dataArray.count>0) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDataWithRefresh)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataWithPage)];
    }
    else{
        [self.tableView setScrollEnabled:NO];
    }
}

-(void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#fbfcf5"];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 64+15, SCREEN_WIDTH-30, SCREEN_HEIGHT-30 - 64)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 30)];
    topLabel.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
    [bgView addSubview:topLabel];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH-30,SCREEN_HEIGHT - 30 - 64 - 30)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [self tableViewFooterView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineRequestListCell" bundle:nil] forCellReuseIdentifier:@"MineRequestListCell"];
    [bgView addSubview:self.tableView];
}

-(void)getData {
    [self.dataArray removeAllObjects];
     [MRProgressOverlayView showOverlayAddedTo:self.tableView title:@"加载中" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat: @"%@/api/v1/user/%@/page/1/limit/10/problems" ,kBaseUrl,_user.userID]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          NSArray *dataArray = responseObject[@"data"];
          NSArray<MyQuestion *> *modelArray =[MTLJSONAdapter modelsOfClass:MyQuestion.class fromJSONArray:dataArray error:nil];
          [self.dataArray appendObjects:modelArray];
          [MRProgressOverlayView dismissOverlayForView:self.tableView animated:YES];
          [self.tableView reloadData];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
}


-(void)getDataWithRefresh{
    [self.dataArray removeAllObjects];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[ NSString stringWithFormat:@"%@/api/v1/user/%@/page/1/limit/10/problems", kBaseUrl,_user.userID]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          NSArray *dataArray = responseObject[@"data"];
          _pageNum = [responseObject[@"curr_page"] intValue];
          self.totoalPage = [responseObject[@"total_page"] intValue];
          [self.tableView.mj_header endRefreshing];
          NSArray<MyQuestion *> *modelArray =[MTLJSONAdapter modelsOfClass:MyQuestion.class fromJSONArray:dataArray error:nil];
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[ NSString stringWithFormat:@"%@/api/v1/user/%@/page/%@/limit/10/problems", kBaseUrl,_user.userID,page]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          NSArray *dataArray = responseObject[@"data"];
          _pageNum = [responseObject[@"curr_page"] intValue];
          self.totoalPage = [responseObject[@"total_page"] intValue];
          [self.tableView.mj_header endRefreshing];
          [self.tableView.mj_footer endRefreshing];
          NSArray<MyQuestion *> *modelArray =[MTLJSONAdapter modelsOfClass:MyQuestion.class fromJSONArray:dataArray error:nil];
          [self.dataArray appendObjects:modelArray];
          [self.tableView reloadData];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
}


-(UIView*)tableViewFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 60)];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-12-15, 10, 24, 24)];
    [footerView addSubview:btn];
    [btn addTarget:self action:@selector(addNewRequest) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"btn_add_green"] forState:UIControlStateNormal];
    
    UILabel *addLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-20-15, 41, 40, 14)];
    addLable.font = [UIFont systemFontOfSize:9];
    addLable.textColor = [UIColor colorWithHexString:@"#000"];
    [footerView addSubview:addLable];
    addLable.text = @"新增反馈";
    return footerView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineRequestListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineRequestListCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MineRequestListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.titleLabel.text = self.dataArray[indexPath.row].content;
    cell.contentLable.text = self.dataArray[indexPath.row].time;
    if (!self.dataArray[indexPath.row].status) {
        [cell.noteView setHidden:YES];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyRequestDetailViewController *myQuestionDetail = [[MyRequestDetailViewController alloc]init];
    myQuestionDetail.title = @"问题反馈详情";
    [self.navigationController pushViewController:myQuestionDetail animated:YES];
    MineRequestListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.noteView setHidden:YES];
}

-(void)addNewRequest {
    MineQuestionViewController * mineRequest = [[MineQuestionViewController alloc]init];
    mineRequest.title = @"生意人反馈收集";
    [self.navigationController pushViewController:mineRequest animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
