//
//  NoticeDetailViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/10.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "MessageNotice.h"
#import "User.h"

@interface NoticeDetailViewController ()

@property (nonatomic, strong)MessageNotice *messageNotice;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)User *user;

@end

@implementation NoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7fef5"];
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.user = [[User alloc]init];
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(64);
        make.left.mas_equalTo(self.view.left).mas_offset(10);
        make.right.mas_equalTo(self.view.right).mas_offset(-10);
        make.bottom.mas_equalTo(self.view.bottom).mas_offset(-10);
    }];
   // [self setupToolUI];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];
}

- (void)setupToolUI {
    // 收藏和分享行
    
    UILabel *collectLable = [[UILabel alloc]init];
    collectLable.text = @"这么好的文章，点击右侧即可收藏或分享";
    collectLable.backgroundColor = [UIColor lightGrayColor];
    collectLable.textColor = [UIColor colorWithHexString:@"#959595"];
    collectLable.font = [UIFont systemFontOfSize:12];
  //  [_bgView addSubview:collectLable];
    
    //收藏按钮
    UIButton *collectButton = [[UIButton alloc]init];
    [collectButton setImage:[UIImage imageNamed:@"btn_save"] forState:UIControlStateNormal];
   // [_bgView addSubview:collectButton];
    
    //分享按钮
    
    UIButton *shareButton  = [[UIButton alloc]init];
    [shareButton setImage:[UIImage imageNamed:@"btn_share_pre"] forState:UIControlStateNormal];
    [_bgView addSubview:shareButton];
    
    // 评论行
    UITextField *commitTextFiled = [[UITextField alloc]init];
    commitTextFiled.borderStyle = UITextBorderStyleLine;
    commitTextFiled.placeholder = @"说点什么";
    commitTextFiled.font = [UIFont systemFontOfSize:12];
    commitTextFiled.clipsToBounds = YES;
    commitTextFiled.layer.cornerRadius = 2;
   // [_bgView addSubview:commitTextFiled];
    
    // 发送评论按钮
    
    UIButton *submitCommitButton = [[UIButton alloc]init];
    [submitCommitButton setTitle:@"发送" forState:UIControlStateNormal];
    submitCommitButton.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
    [submitCommitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[_bgView addSubview:submitCommitButton];
    
    
   /* [collectLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.superview.bottom).mas_offset(-70);
        make.right.mas_equalTo(self.view.superview.right).mas_offset(-100);
        make.left.mas_equalTo(self.view.superview.left).mas_offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.superview.bottom).mas_offset(-70);
        make.right.mas_equalTo(self.view.superview.right).mas_offset(-70);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(30);
    }];
    */
   /* [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.superview.bottom).mas_offset(-70);
        make.right.mas_equalTo(self.view.superview.right).mas_offset(-30);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(30);
    }];
    */
    
  /*  [commitTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.superview.bottom).mas_offset(-30);
        make.right.mas_equalTo(self.view.superview.right).mas_offset(-100);
        make.left.mas_equalTo(self.view.superview.left).mas_offset(10);
        make.height.mas_equalTo(30);
    }];
    
    
    [submitCommitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.superview.bottom).mas_offset(-30);
        make.right.mas_equalTo(self.view.superview.right).mas_offset(-30);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    
*/

}

-(void)setupUI{
    
    
    UILabel *titieLable = [[UILabel alloc]init];
    titieLable.text = self.messageNotice.title;
    titieLable.font = [UIFont boldSystemFontOfSize:16];
    titieLable.textColor = [UIColor colorWithHexString:@"#000"];
    titieLable.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:titieLable];
    
    UILabel *timeLable = [[UILabel alloc]init];
    timeLable.textColor = [UIColor colorWithHexString:@"#6e6e6e"];
    timeLable.font = [UIFont systemFontOfSize:11];
    timeLable.textAlignment = NSTextAlignmentRight;
    timeLable.text =self.messageNotice.time;
    [_bgView addSubview:timeLable];
    
    UIWebView *contentLable = [[UIWebView alloc]init];
   // contentLable.textColor = [UIColor colorWithHexString:@"#6e6e6e"];
  //  contentLable.font = [UIFont systemFontOfSize:12];
    //contentLable.userInteractionEnabled = NO;
   // contentLable.text  = self.messageNotice.content;
    [contentLable loadHTMLString:self.messageNotice.content baseURL:nil];
    [_bgView addSubview:contentLable];
    

    
    
    [titieLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.superview.top).mas_offset(20);
        make.left.mas_equalTo(self.view.superview.left).mas_offset(0);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(180);
    }];
    
    
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.superview.top).mas_offset(20);
        make.right.mas_equalTo(self.view.superview.right).mas_offset(0);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(140);
    }];
    
    
    [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.superview.top).mas_offset(50);
        make.right.mas_equalTo(self.view.superview.right).mas_offset(-10);
        make.bottom.mas_offset(self.view.superview.bottom).mas_offset(0);
        make.left.mas_equalTo(self.view.superview.left).mas_offset(10);
    }];
}


- (void)getData {
      [MRProgressOverlayView showOverlayAddedTo:self.view title:@"加载中" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/v1/user/%@/notice/%@",kBaseUrl,_user.userNum,self.noticeID];
    [manager GET:urlString
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          NSDictionary *dict = responseObject[@"data"];
          self.messageNotice = [MTLJSONAdapter modelOfClass:MessageNotice.class fromJSONDictionary:dict error:nil];
          [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
          [self setupUI];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
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
