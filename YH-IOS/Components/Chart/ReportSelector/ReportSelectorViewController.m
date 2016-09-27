//
//  ReportSelectorViewController.m
//  YH-IOS
//
//  Created by lijunjie on 16/7/15.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "FileUtils+Report.h"
#import "ReportSelectorViewController.h"
#import "SearchTableViewCell.h"

@interface ReportSelectorViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSArray *searchItems;
@property (strong, nonatomic) NSString *selectedItem;
@property (assign, nonatomic) BOOL isSearch;
@property (strong, nonatomic) UISearchBar *searchBar;
@end

@implementation ReportSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self idColor];
    self.dataList = [NSArray array];
    
    /**
     *  - 如果用户已设置筛选项，则 banner 显示该信息
     *  - 未设置时，默认显示第一个
     */
    self.searchItems = [FileUtils reportSearchItems:self.user.groupID templateID:self.templateID reportID:self.reportID];
    self.selectedItem = [FileUtils reportSelectedItem:self.user.groupID templateID:self.templateID reportID:self.reportID];
    if((self.selectedItem == NULL || [self.selectedItem length] == 0) && [self.searchItems count] > 0) {
        self.selectedItem = [self.searchItems firstObject];
    }
    
    /**
     *  筛选项列表按字母排序，以便于用户查找
     *  self.searchItems 不做任何修改，列表源使用变量 self.dataList
     */
    self.searchItems = [self.searchItems sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    self.dataList = [self.searchItems copy];
    self.labelTheme.text = self.bannerName;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  监听输入框内容变化
 *
 *  @param notifice notifice
 */
- (void)SearchValueChanged:(NSString *)notifice {
    NSString *searchText = notifice;
    
    if([searchText length] > 0) {
        NSString *predicateStr = [NSString stringWithFormat:@"(SELF CONTAINS \"%@\")", searchText];
        NSPredicate *sPredicate = [NSPredicate predicateWithFormat:predicateStr];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.searchItems];
        [array filterUsingPredicate:sPredicate];
        self.dataList = [NSArray arrayWithArray:array];
    }
    else {
        self.dataList = [self.searchItems copy];
    }
    
    [self.tableView reloadData];
}

#pragma mark - ibaction block
- (IBAction)actionBack:(id)sender {
    [super dismissViewControllerAnimated:YES completion:^{
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_isSearch) ? 2 : 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 0.001:30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch) {
        return (section == 1)? _dataList.count : 1;
    }
    else {
        return (section == 2) ? _searchItems.count : 1;
    }

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    if (_isSearch) {
        if (indexPath.section == 0) {
            SearchTableViewCell *cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
            cell.searchBar.delegate = self;
            return cell;
        }
        else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentifier];
        }
        cell.textLabel.text = self.dataList[indexPath.row];
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
        cell.textLabel.text = self.selectedItem;
        return cell;
    }
        else {
            static NSString *CellIndentifier = @"CellIndentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
            if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentifier];
            }
            NSString *currentItem = self.searchItems[indexPath.row];
            cell.textLabel.text = currentItem;
            return cell;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *array = (_isSearch)? @[@"",@"列表"]:@[@"",@"已选",@"未选"];
    return array[section];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? 50 : 30 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItem = self.dataList[indexPath.row];
    NSString *selectedItemPath = [NSString stringWithFormat:@"%@.selected_item", [FileUtils reportJavaScriptDataPath:self.user.groupID templateID:self.templateID reportID:self.reportID]];
    [selectedItem writeToFile:selectedItemPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self actionBack:nil];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.text = searchBar.text;
    self.isSearch = YES;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self SearchValueChanged:searchBar.text];
    [searchBar resignFirstResponder];
}

@end
