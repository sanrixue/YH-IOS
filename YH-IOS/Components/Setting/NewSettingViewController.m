//
//  NewSettingViewController.m
//  YH-IOS
//
//  Created by li hao on 16/8/30.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "NewSettingViewController.h"

@interface NewSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *settingTable;
@property (nonatomic,strong) UIButton *logOutBtn;

@end

@implementation NewSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingTable = [[UITableView alloc]initWithFrame:CGRectMake(0,55, self.view.frame.size.width, self.view.frame.size.height - 104) style:UITableViewStyleGrouped];
    self.settingTable.delegate = self;
    self.settingTable.dataSource = self;
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rowNum;
    switch (section) {
        case 1:
            rowNum = 4;
            break;
        case 2:
            rowNum = 8;
            break;
        case 3:
            rowNum = 1;
            break;
        case 4:
            rowNum = 1;
            break;
        default:
            break;
    }
    return rowNum;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *Cell = [[UITableViewCell alloc]init];
    Cell.textLabel.text = @"kakc";
    return Cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
