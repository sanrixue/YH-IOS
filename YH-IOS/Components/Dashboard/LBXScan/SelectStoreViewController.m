//
//  SelectStoreViewController.m
//  YH-IOS
//
//  Created by li hao on 16/8/10.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "SelectStoreViewController.h"
#import "User.h"
#import "FileUtils.h"
#import "ScanResultViewController.h"
#import "SearchTableViewCell.h"


@interface SelectStoreViewController ()<UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    
    NSString *searchingText;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSDictionary *currentStore;
@property (assign, nonatomic) BOOL isSearch;
@property (strong, nonatomic) NSArray *searchItems;
@property (strong, nonatomic) NSString *selectedItem;
@property (strong, nonatomic) NSArray *searchArray;

@end

@implementation SelectStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchItems = [NSMutableArray array];
    
    NSString *barCodePath = [FileUtils dirPath:kCachedDirName FileName:kBarCodeResultFileName];
    NSMutableDictionary *cachedDict = [FileUtils readConfigFile:barCodePath];
    self.currentStore = cachedDict[@"store"];
    
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(userDict[kStoreIDsCUName] && [userDict[kStoreIDsCUName] count] > 0) {
        self.searchItems =userDict[kStoreIDsCUName];
    }
    
    /**
     *  筛选项列表按字母排序，以便于用户查找
     */
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.searchItems = [self.searchItems sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    if((self.selectedItem == NULL || [self.selectedItem length] == 0) && [self.searchItems count] > 0) {
        self.selectedItem = [self.searchItems firstObject][@"name"];
    }
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"Banner-Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(actionBannerBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
    // backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    //  [self.navigationItem.leftBarButtonItem setTitlePositionAdjustment:UIOffsetMake(-30, 0) forBarMetrics:UIBarMetricsDefault];
    //[backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}




- (void)actionBannerBack {
    if (_isSearch) {
        _isSearch = NO;
        [self.tableView reloadData];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        self.tableView.dataSource = nil;
        self.tableView.delegate = nil;
        self.tableView = nil;
        self.searchItems = nil;
        }];
    }
}

/**
 *  监听输入框内容变化
 *
 *  @param notifice notifice
 */
- (void)SearchValueChanged:(NSString *)notifice {
    // UITextField *field = [notifice object];
    NSString *searchText = notifice;
    
    if([searchText length] > 0) {
        NSString *predicateStr = [NSString stringWithFormat:@"(SELF['name'] CONTAINS \"%@\")", searchText];
        NSPredicate *sPredicate = [NSPredicate predicateWithFormat:predicateStr];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.searchItems];
        [array filterUsingPredicate:sPredicate];
        self.searchArray = [NSArray arrayWithArray:array];
    }
    else {
        self.searchArray = [self.searchItems copy];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isSearch) {
        return (section == 1)? _searchArray.count : 1;
    }
    else {
        return (section == 2) ? _searchItems.count : 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_isSearch) ? 2 : 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    if (_isSearch) {
        if (indexPath.section == 0) {
            SearchTableViewCell *cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
            cell.searchBar.text = searchingText;
            cell.searchBar.delegate = self;
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentifier];
            }
            cell.textLabel.text = self.searchArray[indexPath.row][@"name"];
            return cell;
        }
    }
    else {
        if (indexPath.section == 0) {
            SearchTableViewCell *cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
            cell.searchBar.delegate = self;
            return cell;
        }
        if (indexPath.section == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selected"];
            cell.textLabel.text = self.currentStore[@"name"];
            return cell;
        }
        else {
            static NSString *CellIndentifier = @"CellIndentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentifier];
            }
            NSString *currentItem = self.searchItems[indexPath.row][@"name"];
            cell.textLabel.text = currentItem;
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 0.001:30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *array = (_isSearch)? @[@"",@"列表"]:@[@"",@"已选项",@"所有选项"];
    return array[section];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? 50 : 30 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *barCodePath = [FileUtils dirPath:kCachedDirName FileName:kBarCodeResultFileName];
    NSMutableDictionary *cachedDict = [FileUtils readConfigFile:barCodePath];
    NSDictionary *currentStore;
    if (indexPath.section == 1) {
        currentStore =( (_isSearch) && [self.searchArray count] > 0 ) ? self.searchArray[indexPath.row] : self.currentStore;
    }
    //fixed-bug: else is vaild at the side-if;
    else if (indexPath.section == 2) {
        currentStore = self.searchItems[indexPath.row];
    }
    else {
        currentStore = self.currentStore;
    }
    cachedDict[@"store"] = @{ @"id": currentStore[@"id"], @"name": currentStore[@"name"] };
    [FileUtils writeJSON:cachedDict Into:barCodePath];
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.tableView.dataSource = nil;
        self.tableView.delegate = nil;
        self.tableView = nil;
        self.searchItems = nil;
    }];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        _isSearch = NO;
        [self.tableView reloadData];
    }
}
- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchingText =searchBar.text;
    self.isSearch = YES;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self SearchValueChanged:searchBar.text];
    searchingText = searchBar.text;
    [searchBar resignFirstResponder];
}

@end
