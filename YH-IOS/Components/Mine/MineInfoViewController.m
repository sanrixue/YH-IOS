//
//  MineInfoViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineInfoViewController.h"
#import "MineHeadView.h"

@interface MineInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

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
   _mineHeaderView.userNameLabel.text = @"美丽美丽";
    
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
  //  [self.mineHeaderView.avaterImageView sd_setImageWithURL:self.person.icon];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"我是帅哥";
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
