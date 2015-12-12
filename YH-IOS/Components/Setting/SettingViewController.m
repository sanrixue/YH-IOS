//
//  SettingViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/10.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "SettingViewController.h"
#import "ViewUtils.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchGesturePassword;
@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) GesturePasswordController *gesturePasswordController;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bannerView.backgroundColor = [UIColor colorWithHexString:YH_COLOR];

    self.listData = [NSMutableArray array];
    [self.listData addObject:@"手势密码"];
    [self.listData addObject:@"2"];
    [self.listData addObject:@"3"];
    [self.listData addObject:@"4"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
    NSDictionary *settingsInfo = [FileUtils readConfigFile:settingsConfigPath];
    self.switchGesturePassword.on = (settingsInfo && [settingsInfo[@"use_gesture_password"] isEqualToNumber:@1]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action methods
- (IBAction)actionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionWehtherUseGesturePassword:(UISwitch *)sender {
    if([sender isOn]) {
        _gesturePasswordController = [[GesturePasswordController alloc] init];
        _gesturePasswordController.delegate = self;
        [self presentViewController:_gesturePasswordController animated:YES completion:nil];
    }
    else {
        NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
        NSDictionary *settingsInfo = [FileUtils readConfigFile:settingsConfigPath];
        NSMutableDictionary *settingsInfoEditor = [NSMutableDictionary dictionaryWithDictionary:settingsInfo];
        settingsInfoEditor[@"use_gesture_password"] = @0;
        [FileUtils writeJSON:settingsInfoEditor Into:settingsConfigPath];
        
        [ViewUtils showPopupView:self.view Info:@"禁用手势锁设置成功"];
    }
}
#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellID";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text       = self.listData[indexPath.row];
    
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case IndexGesturePassword:
            
            break;
            
        default:
            break;
    }
}


@end
