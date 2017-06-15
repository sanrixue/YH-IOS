//
//  MyRequestDetailViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/14.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MyRequestDetailViewController.h"
#import "PhotoRevealCell.h"
#import "MyQuestion.h"
#import "PhotoNavigationController.h"
#import "PhotoManagerConfig.h"
#import "PhotoRevealCell.h"
#import "UIImage+StackBlur.h"
#import "zoomPopup.h"
#import "UIImage+StackBlur.h"
#import "User.h"

static NSString *const reUse = @"reUse";
@interface MyRequestDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UITextView *questionTextField;
@property (nonatomic,strong)UILabel *questionPalceHolderView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *imageNotelabel;
@property (nonatomic, strong) MyQuestion *myquestion;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic, strong)User *user;

@end

@implementation MyRequestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#fbfcf5"];
     self.user = [[User alloc]init];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
      [MRProgressOverlayView showOverlayAddedTo:self.view title:@"加载中" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/v1/user/%@/problem/4",kBaseUrl,_user.userID];
    [manager GET:urlString
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          NSDictionary *dict = responseObject[@"data"];
          self.myquestion = [MTLJSONAdapter modelOfClass:MyQuestion.class fromJSONDictionary:dict error:nil];
          [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
          self.imageArray = self.myquestion.photos;
          [self setUI];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
}

-(void)setUI{
    
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    //顶部绿色
    UILabel *topLabel =[[UILabel alloc]init];
    topLabel.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
    [bgView addSubview:topLabel];
    
    // 描述头
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"生意人 1.4.2 反馈收集";
    titleLable.textColor = [UIColor colorWithHexString:@"#000"];
    titleLable.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:titleLable];
    
    // 描述细节
    
    UILabel *detialLable = [[UILabel alloc]init];
    detialLable.backgroundColor = [UIColor clearColor];
    detialLable.textColor = [UIColor colorWithHexString:@"#000"];
    detialLable.font = [UIFont systemFontOfSize:9];
    detialLable.numberOfLines = 0;
    detialLable.text = @"遇到问题了? 很抱歉生意人给您带来不好的体验，请您把遇到的问题反馈给我们.永辉生意人测试团队会尽快改进哦～";
    [bgView addSubview:detialLable];
    
    //分割线1
    UIView *sepertView1 = [[UIView alloc]init];
    sepertView1.backgroundColor = [UIColor colorWithHexString:@"#7d7d7d"];
    sepertView1.frame = CGRectMake(0, 116+64, SCREEN_WIDTH - 30, 1);
    [bgView addSubview:sepertView1];
    
    // 描述细节头
    UILabel *descripeTitle = [[UILabel alloc]init];
    descripeTitle.text = @"问题描述及改进意见";
    descripeTitle.textColor = [UIColor colorWithHexString:@"#000"];
    descripeTitle.font = [UIFont systemFontOfSize:14];
    descripeTitle.backgroundColor = [UIColor clearColor];
    [bgView addSubview:descripeTitle];
    
    
    UIButton *submitButton = [[UIButton alloc]init];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
    [bgView addSubview:submitButton];
    
    // 描述文字
    
    self.questionTextField = [[UITextView alloc]init];
    // self.questionTextField.placeholder = @"问题描述请直戳要点~ 如能附上具体操作步骤更佳，万分感谢!";
    self.questionTextField.layer.borderColor = [UIColor lightTextColor].CGColor;
    self.questionTextField.font = [UIFont systemFontOfSize:9];
    self.questionTextField.clipsToBounds = YES;
    self.questionTextField.userInteractionEnabled = NO;
    self.questionTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.questionTextField.layer.borderWidth = 1;
    self.questionTextField.text = self.myquestion.content;
   // self.questionTextField.delegate = self;
    // self.questionTextField.borderStyle = UITextBorderStyleLine;
    [bgView addSubview:_questionTextField];
    
    // 问题截图头
    
    UILabel *imageTitle = [[UILabel alloc]init];
    imageTitle.text = @"问题截图";
    imageTitle.font = [UIFont systemFontOfSize:14];
    imageTitle.textColor = [UIColor colorWithHexString:@"#000"];
    [bgView addSubview:imageTitle];
    
    
    
    // 上传问题截图框
    
    
    UIView *imageViews = [[UIView alloc]initWithFrame:CGRectMake(30, 300+64+19, SCREEN_WIDTH - 90, 59.5)];
    
    // imageViews.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //imageViews.layer.borderWidth = 1.5;
    [bgView addSubview:imageViews];
    // [UIView drawDashLine:imageViews lineLength:2 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
    
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 90, 59.5);
    borderLayer.position = CGPointMake(CGRectGetMidX(imageViews.bounds), CGRectGetMidY(imageViews.bounds));
    
    //    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:0].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    //虚线边框
    borderLayer.lineDashPattern = @[@8, @8];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    [imageViews.layer addSublayer:borderLayer];
    
    
    
    // [UIView drawDashLine:dropView lineLength:1 lineSpacing:1 lineColor:[UIColor redColor]];
    
    // 上传完成后展示用
    self.collectionView.frame = CGRectMake(0, 0,SCREEN_WIDTH-90,59.5);
    [imageViews addSubview:self.collectionView];
    //[self.collectionView addSubview:self.imageNotelabel];
    [self.collectionView registerClass:[PhotoRevealCell class] forCellWithReuseIdentifier:reUse];
    
    // 点击上传按钮
    
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(15);
        make.left.mas_equalTo(self.view.left).mas_offset(15);
        make.right.mas_equalTo(self.view.right).mas_offset(-15);
        make.bottom.mas_equalTo(self.view.bottom).mas_offset(-15);
    }];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(15 +64);
        make.left.mas_equalTo(self.view.left).mas_offset(15);
        make.right.mas_equalTo(self.view.right).mas_offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(60+64);
        make.left.mas_equalTo(self.view.left).mas_offset(30);
        make.right.mas_equalTo(self.view.right).mas_offset(-30);
        make.height.mas_equalTo(20);
    }];
    
    [detialLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(83+64);
        make.left.mas_equalTo(self.view.left).mas_offset(30);
        make.right.mas_equalTo(self.view.right).mas_offset(-30);
        make.height.mas_equalTo(30);
    }];
    
    [descripeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(119+64 +15);
        make.left.mas_equalTo(self.view.left).mas_offset(30);
        make.right.mas_equalTo(self.view.right).mas_offset(-30);
        make.height.mas_equalTo(20);
    }];
    
    [self.questionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(142+64+19);
        make.left.mas_equalTo(self.view.left).mas_offset(30);
        make.right.mas_equalTo(self.view.right).mas_offset(-30);
        make.height.mas_equalTo(111.5);
    }];
    
    
    [imageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(270+64+19);
        make.left.mas_equalTo(self.view.left).mas_offset(30);
        make.right.mas_equalTo(self.view.right).mas_offset(-30);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - collectionView protocol methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoRevealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reUse forIndexPath:indexPath];
    NSString *asset = self.imageArray[indexPath.row];

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:asset]];
    return cell;
}

#pragma mark -
#pragma mark - getter methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat kPadding = 3.f;
        CGFloat kWidth = (kScreenWidth - 4 * kPadding - 90) / 3;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kWidth, kWidth);
        layout.sectionInset = UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding);
        layout.minimumInteritemSpacing = kPadding;
        layout.minimumLineSpacing = kPadding;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXCOLOR(0xffffff);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
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
