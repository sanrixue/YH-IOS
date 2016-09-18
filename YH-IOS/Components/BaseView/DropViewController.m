//
//  DropViewController.m
//  YH-IOS
//
//  Created by li hao on 16/9/14.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "DropViewController.h"
#import "DropTableViewCell.h"

@interface DropViewController ()<UITableViewDataSource>

@end

@implementation DropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dropTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.dropTableView.scrollEnabled  = NO;
    self.dropTableView.backgroundColor = [UIColor clearColor];
    self.dropTableView.separatorColor = [UIColor whiteColor];
    self.dropTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.dropTableView.layoutMargins  = UIEdgeInsetsZero;
    self.dropTableView.separatorInset = UIEdgeInsetsZero;
    self.dropTableView.dataSource =self;
    [self.view addSubview:self.dropTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - UITableView Delgate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dropMenuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dorpcell"];
    if (!cell) {
        cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dorpcell"];
    }
    cell.tittleLabel.text = self.dropMenuTitles[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:self.dropMenuIcons[indexPath.row]];
    
    UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
    cellBackView.backgroundColor = [UIColor darkGrayColor];
    cell.selectedBackgroundView = cellBackView;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150 / 4;
}


@end
