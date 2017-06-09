//
//  MineInfoViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineInfoViewController.h"
#import "MineHeadView.h"
#import "MineInfoTableViewCell.h"

@interface MineInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArray;
    NSArray *secondArray;
    NSArray *titleIameArray;
    NSArray *seconImageArray;
}

@property (nonatomic, strong) MineHeadView *mineHeaderView;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSDictionary *userMessageDict;
@property (nonatomic, strong) UITableView *minetableView;

@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self loadData];
    titleArray = @[@"用户角色",@"归属部门",@"密码修改",@"问题反馈"];
    titleIameArray = @[@"list_ic_person",@"list_ic_department",@"list_ic_lock",@"list_ic_feedback"];
    
    secondArray = @[@"文章收藏",@"我的设置"];
    seconImageArray = @[@"list_ic_save",@"list_ic_set"];
     [self setupTableView];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _mineHeaderView = [[MineHeadView alloc]init];
    _mineHeaderView.frame  = CGRectMake(0, 0, SCREEN_WIDTH, 300);
    self.minetableView.tableHeaderView = _mineHeaderView;
    [self BindDate];
    RACSignal *requestSingal = [self.requestCommane execute:nil];
    [requestSingal subscribeNext:^(Person *x) {
        self.person = x;
        [self refreshHeadView];
    }];
}

- (void)BindDate {
    _requestCommane = [[RACCommand  alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:@"http://192.168.0.137:3000/api/v1/user/1/mine/user_info" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"用户信息 %@",responseObject);
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERROR- %@",error);
            }];
             return nil;
        }];
        return [requestSignal map:^id(NSDictionary *value){
            NSDictionary *dict = value[@"data"];
            self.userMessageDict = dict;
            Person *person = [MTLJSONAdapter modelOfClass:Person.class fromJSONDictionary:dict error:nil];
            return person;
        }];
    }];
}


-(void)refreshHeadView {
    _mineHeaderView = [[MineHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) withPerson:self.person];
}


-(void)setupTableView {
    
    self.minetableView= [[UITableView alloc]init];
    self.minetableView.frame = self.view.frame;
    [self.view addSubview:self.minetableView];
    
    
    self.minetableView.delegate = self;
    self.minetableView.dataSource = self;
     self.minetableView.tableHeaderView = _mineHeaderView;
    [self.minetableView sendSubviewToBack:_mineHeaderView];
    self.minetableView.separatorStyle = UITableViewCellSelectionStyleNone;
    UINib *mineInfoCell = [UINib nibWithNibName:@"MineInfoTableViewCell" bundle:nil];
    [self.minetableView registerNib:mineInfoCell forCellReuseIdentifier:@"MineInfoTableViewCell"];
    
  //  [self.mineHeaderView.avaterImageView sd_setImageWithURL:self.person.icon];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    else{
        return 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
          return 35;
    }
    else if (section == 2) {
        return 15;
    }
    else {
        return 0.01f;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineInfoTableViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.userTitle.text = titleArray[indexPath.row];
        cell.noticeIcon.image = [UIImage  imageNamed:titleIameArray[indexPath.row]];
        cell.userDetailLable.text = @"小店长";
    }
    else if (indexPath.section == 1) {
        cell.userTitle.text = secondArray[indexPath.row];
        cell.noticeIcon.image = [UIImage imageNamed:seconImageArray[indexPath.row]];
        cell.userDetailLable.text = @"";
                                 
    }
    if (!(indexPath.row % 2)) {
        cell.backgroundColor = [UIColor colorWithHexString:@"fbfcf5"];
    }
    return cell;
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
