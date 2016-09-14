//
//  ReportSelectorViewController.m
//  YH-IOS
//
//  Created by lijunjie on 16/7/15.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "FileUtils+Report.h"
#import "ReportSelectorViewController.h"

@interface ReportSelectorViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSArray *searchItems;
@property (strong, nonatomic) NSString *selectedItem;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SearchValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [self.textFieldSearch addTarget:self action:@selector(SearchValueChanged:) forControlEvents:UIControlEventValueChanged];
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
- (void)SearchValueChanged:(NSNotification *)notifice {
    UITextField *field = [notifice object];
    NSString *searchText = [field.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentifier];
    }
    
    //[tableView setSeparatorColor:[UIColor blueColor]];
    NSString *currentItem = self.dataList[indexPath.row];
    cell.textLabel.text = currentItem;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = (self.selectedItem && [self.selectedItem isEqualToString:currentItem])  ? [UIColor colorWithHexString:kBannerBgColor] : [UIColor whiteColor];
    cell.backgroundView = bgColorView;

//    
//    cell.separatorInset = UIEdgeInsetsZero;
//    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
//        cell.layoutMargins = UIEdgeInsetsZero;
//        cell.preservesSuperviewLayoutMargins = false;
//    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItem = self.dataList[indexPath.row];
    
    NSString *selectedItemPath = [NSString stringWithFormat:@"%@.selected_item", [FileUtils reportJavaScriptDataPath:self.user.groupID templateID:self.templateID reportID:self.reportID]];
    [selectedItem writeToFile:selectedItemPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self actionBack:nil];
}

@end
