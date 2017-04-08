//
//  SettingArrayViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/29.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SettingArrayViewController.h"
#import "SettingNormalViewController.h"
#import "FileUtils.h"
#import "User.h"

@interface SettingArrayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,assign) BOOL isUserable;

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    else if ([_array[indexPath.row] isKindOfClass:[NSString class]]){
        cell.textLabel.text = _array[indexPath.row];
        cell.detailTextLabel.text = @"手动删除";
        self.isUserable = YES;
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
    
    if ([_array[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        SettingArrayViewController *thirdView = [[SettingArrayViewController alloc]init];
        thirdView.title = self.title;
        thirdView.array = _array[indexPath.row];
        [self.navigationController pushViewController:thirdView animated:YES];
    }
    if (self.isUserable && [_array[indexPath.row] isKindOfClass:[NSString class]]) {
        NSString* filePath = [[FileUtils basePath] stringByAppendingPathComponent:_array[indexPath.row]];
        [FileUtils removeFile:filePath];
        [self getDocumentName];
    }
}

- (void)getDocumentName{
    NSArray *firstSavePathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    for (NSString *path in firstSavePathArray) {
        NSLog(@"%@",path);
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:firstSavePathArray[0] error:&error];
    NSMutableArray* cleanArray = [[NSMutableArray alloc]init];
    NSLog(@"%@",fileList);
    User* user = [[User alloc]init];
    NSString *userFileName = [NSString stringWithFormat:@"user-%@",user.userID];
    for (NSString* value in fileList) {
        if ([value hasPrefix:@"user-"] && ![value isEqualToString:userFileName]) {
            [cleanArray addObject:value];
        }
    }
    self.array = cleanArray;
    [self.tableView reloadData];
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
