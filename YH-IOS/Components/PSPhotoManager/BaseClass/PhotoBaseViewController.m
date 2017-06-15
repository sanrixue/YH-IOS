//
//  PhotoBaseViewController.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/8.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoBaseViewController.h"

@interface PhotoBaseViewController ()

@end

@implementation PhotoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configureUI {
    
}

- (void)buildingParams {
    
}

#pragma mark -
#pragma mark - config navigation item
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    UILabel *label = building_label(1, HEXCOLOR(0xffffff), 1, FontBold(20));
    label.frame = CGRectMake(0, 0, 100, 20);
    label.text = title;
    self.navigationItem.titleView = label;
}

- (void)rightBarButton:(NSString *)title selector:(SEL)selector {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
    barButton.tintColor = HEXCOLOR(0xffffff);
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)rightBarButtonWithImageName:(NSString *)imageName selector:(SEL)selector {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:selector];
    barButton.tintColor = HEXCOLOR(0xffffff);
    self.navigationItem.rightBarButtonItem = barButton;
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
