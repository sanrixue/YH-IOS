//
//  ManualInputViewController.m
//  YH-IOS
//
//  Created by li hao on 17/2/15.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ManualInputViewController.h"
#import "UIColor+Hex.h"
#import "ScanResultViewController.h"


@interface ManualInputViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UITextField *lbxTextField;
@property (nonatomic, strong) UIButton *btnSubmit;

@end

@implementation ManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,60)];
    self.navBar.backgroundColor = [UIColor colorWithHexString:@"#53a93f"];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 60, 30)];
    [backBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setImage:[UIImage imageNamed:@"Banner-Back"] forState:UIControlStateNormal];
    [self.navBar addSubview:backBtn];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 30)];
    titleLabel.text = @"输入条码";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navBar addSubview:titleLabel];
    [self.view addSubview:self.navBar];
    
    self.lbxTextField = [[UITextField alloc]initWithFrame:CGRectMake(20,80 , self.view.frame.size.width - 40, 40)];
    _lbxTextField.placeholder = @"请输入条码";
    _lbxTextField.delegate = self;
    [self.view addSubview:self.lbxTextField];
    
    UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(20, 122, self.view.frame.size.width - 40, 1.5)];
    seperateView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperateView];
    
    self.btnSubmit = [[UIButton alloc]initWithFrame:CGRectMake(20, 130, self.view.frame.size.width - 40, 30)];
    self.btnSubmit.backgroundColor = [UIColor lightGrayColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnSubmit.userInteractionEnabled = NO;
    self.btnSubmit.layer.cornerRadius = 6;
    [self.btnSubmit setTitle:@"输入信息" forState:UIControlStateNormal];
    [self.btnSubmit addTarget:self action:@selector(submitTextToSedrver) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(close) name:@"CLOSE_VIEW" object:nil];
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.btnSubmit.userInteractionEnabled = YES;
    [self.btnSubmit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
}


- (void) submitTextToSedrver {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanResultViewController *scanResultVC = (ScanResultViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ScanResultViewController"];
    if ([_lbxTextField.text length] != 0) {
        scanResultVC.codeInfo = _lbxTextField.text;
        scanResultVC.codeType = @"input";
        [self presentViewController:scanResultVC animated:YES completion:nil];
    }
    else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提交失败"
                                                                       message:@"输入信息为空"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
     _fromViewController = @"jump";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
