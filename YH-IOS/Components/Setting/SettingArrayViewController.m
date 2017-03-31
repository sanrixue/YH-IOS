//
//  SettingArrayViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/29.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SettingArrayViewController.h"
#import "SettingNormalViewController.h"

@interface SettingArrayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;

@end

@implementation SettingArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:false];
}

-(void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellid"];
    }
    if ([_array[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text = _array[indexPath.row][@"name"];
        if ([_array[indexPath.row][@"os"] hasPrefix:@"iPhone"]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"iOS%@",_array[indexPath.row][@"os_version"]];
        }
        else{
             cell.detailTextLabel.text = [NSString stringWithFormat:@"Android%@",_array[indexPath.row][@"os_version"]];
        }
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([_array[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        SettingNormalViewController *thirdView = [[SettingNormalViewController alloc]init];
        thirdView.title = _array[indexPath.row][@"name"];
        thirdView.infodict = _array[indexPath.row];
        [self.navigationController pushViewController:thirdView animated:YES];
    }
    
    if ([_array[indexPath.row] isKindOfClass:[NSArray class]]) {
        SettingArrayViewController *thirdView = [[SettingArrayViewController alloc]init];
        thirdView.title = self.title;
        thirdView.array = _array[indexPath.row];
        [self.navigationController pushViewController:thirdView animated:YES];
    }
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
