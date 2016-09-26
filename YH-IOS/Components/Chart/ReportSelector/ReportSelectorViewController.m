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
    
    /**
     *  搜索框内容改变时，实时搜索并展示
     */
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SearchValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    //[self.textFieldSearch addTarget:self action:@selector(SearchValueChanged:) forControlEvents:UIControlEventValueChanged];
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
   // UITextField *field = [notifice object];
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0.001;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 10;
            break;
            
        default:
            return 20;
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            if (_isSearch) {
                return self.dataList.count;
            }
            else {
                return  _searchItems.count;
            }
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        if (_isSearch) {
            cell.textLabel.text = self.dataList[indexPath.row];
        }
        else{
             NSString *currentItem = self.searchItems[indexPath.row];
            cell.textLabel.text = currentItem;
         }
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        NSString *string1 = @"已选";
        return string1;
    }
    if (section == 2) {
        NSString *string2 = @"列表";
        return string2;
    }
    else{
        return NULL;
    }
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }
    else {
        return 30.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItem = self.dataList[indexPath.row];
    NSString *selectedItemPath = [NSString stringWithFormat:@"%@.selected_item", [FileUtils reportJavaScriptDataPath:self.user.groupID templateID:self.templateID reportID:self.reportID]];
    [selectedItem writeToFile:selectedItemPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self actionBack:nil];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
   // [self SearchValueChanged:searchBar.text];
    self.isSearch = YES;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self SearchValueChanged:searchBar.text];
    [searchBar resignFirstResponder];
}

@end
