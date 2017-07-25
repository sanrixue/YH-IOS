//
//  MineQuestionViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/10.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineQuestionViewController.h"
#import "PhotoNavigationController.h"
#import "PhotoManagerConfig.h"
#import "PhotoRevealCell.h"
#import "UIImage+StackBlur.h"
#import "zoomPopup.h"
#import "UIImage+StackBlur.h"
#import "User.h"
#import "SCLAlertView.h"
#import "Version.h"
#import "APIHelper.h"

static NSString *const reUse = @"reUse";

@interface MineQuestionViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView *background;
    NSInteger  clickImageNumber;
    User *user;
    
}

@property (nonatomic,strong)UITextView *questionTextField;
@property (nonatomic,strong)UILabel *questionPalceHolderView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <ALAsset *>*dataArray;
@property (nonatomic, strong) UILabel *imageNotelabel;
@property (nonatomic, strong) NSMutableArray<UIImage *> * imageArray;
@property (nonatomic, strong) NSMutableArray<UIImage *> * imageArrayorigin;
@property (nonatomic, strong) Version *version;

@end

@implementation MineQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [NSMutableArray new];
    self.imageArrayorigin = [NSMutableArray new];
    user = [[User alloc]init];
    self.version = [[Version alloc] init];
     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
     [self.navigationController.navigationBar setHidden:NO];
   // [self.tabBarController.tabBar setHidden:YES];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#fbfcf5"];
    [self setUI];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    // Do any additional setup after loading the view.
}


-(void)setUI{
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [UIColor colorWithHexString:@"#d2d2d2"].CGColor;
    [self.view addSubview:bgView];
    //顶部绿色
    UILabel *topLabel =[[UILabel alloc]init];
    topLabel.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
    [bgView addSubview:topLabel];
    
    // 描述头
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"生意人反馈收集";
    titleLable.textColor = [UIColor colorWithHexString:@"#000"];
    titleLable.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:titleLable];
    
    // 描述细节
    
    UILabel *detialLable = [[UILabel alloc]init];
    detialLable.backgroundColor = [UIColor clearColor];
    detialLable.textColor = [UIColor colorWithHexString:@"#000"];
    detialLable.font = [UIFont systemFontOfSize:12];
    detialLable.numberOfLines = 3;
    detialLable.text = @"遇到问题了? 很抱歉生意人给您带来不好的体验，请您把遇到的问题反馈给我们.永辉生意人测试团队会尽快改进哦～";
    [bgView addSubview:detialLable];
    
    //分割线1
    UIView *sepertView1 = [[UIView alloc]init];
    sepertView1.backgroundColor = [UIColor colorWithHexString:@"#d2d2d2"];
    sepertView1.frame = CGRectMake(0, 184+13, SCREEN_WIDTH - 30, 1);
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
    [submitButton addTarget:self action:@selector(submitMyProblem) forControlEvents:UIControlEventTouchUpInside];
    submitButton.layer.masksToBounds = YES;
    submitButton.layer.cornerRadius = 8;
    [bgView addSubview:submitButton];
    
    // 描述文字
    
    self.questionTextField = [[UITextView alloc]init];
   // self.questionTextField.placeholder = @"问题描述请直戳要点~ 如能附上具体操作步骤更佳，万分感谢!";
  //  self.questionTextField.layer.borderColor = [UIColor colorWithHexString:@"#959595"].CGColor;
    self.questionTextField.font = [UIFont systemFontOfSize:9];
    self.questionTextField.clipsToBounds = YES;
    self.questionTextField.layer.borderColor = [UIColor colorWithHexString:@"#959595"].CGColor;
    self.questionTextField.layer.borderWidth = 1;
    self.questionTextField.delegate = self;
   // self.questionTextField.borderStyle = UITextBorderStyleLine;
    [bgView addSubview:_questionTextField];
    
    self.questionPalceHolderView = [[UILabel alloc]init];
    self.questionPalceHolderView.frame = CGRectMake(4, 4, SCREEN_WIDTH-60, 15);
    [self.questionTextField addSubview:_questionPalceHolderView];
    self.questionPalceHolderView.layer.borderColor = [UIColor colorWithHexString:@"#959595"].CGColor;
    self.questionPalceHolderView.text = @"问题描述请直戳要点~ 如能附上具体操作步骤更佳，万分感谢!";
    self.questionPalceHolderView.font = [UIFont systemFontOfSize:9];
    self.questionPalceHolderView.textColor = [UIColor colorWithHexString:@"#959595"];
    // 问题截图头
    
    UILabel *imageTitle = [[UILabel alloc]init];
    imageTitle.text = @"问题截图";
    imageTitle.font = [UIFont systemFontOfSize:14];
    imageTitle.textColor = [UIColor colorWithHexString:@"#000"];
    [bgView addSubview:imageTitle];
    
    
    // 上传问题截图框
    
    
    UIView *imageViews = [[UIView alloc]initWithFrame:CGRectMake(30, 300+64+19+17, SCREEN_WIDTH - 90, 59.5)];
    
   // imageViews.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //imageViews.layer.borderWidth = 1.5;
    [bgView addSubview:imageViews];
   // [UIView drawDashLine:imageViews lineLength:2 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
    
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 90, 59.5);
    borderLayer.position = CGPointMake(CGRectGetMidX(imageViews.bounds), CGRectGetMidY(imageViews.bounds));
    
    //    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:0].CGPath;
    borderLayer.lineWidth = 4. / [[UIScreen mainScreen] scale];
    //虚线边框
    borderLayer.lineDashPattern = @[@3, @2];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor colorWithHexString:@"#959595"].CGColor;
    [imageViews.layer addSublayer:borderLayer];
    
    //添加图片提示
    
    self.imageNotelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, SCREEN_WIDTH - 90, 20)];
    _imageNotelabel.font = [UIFont systemFontOfSize:9];
    _imageNotelabel.textColor = [UIColor colorWithHexString:@"#7e7e7e"];
    _imageNotelabel.text = @"请将你遇到问题的页面截图上传，最多三张哦!";
    
    
   // [UIView drawDashLine:dropView lineLength:1 lineSpacing:1 lineColor:[UIColor redColor]];
    
    // 上传完成后展示用
    self.collectionView.frame = CGRectMake(0, 0,SCREEN_WIDTH-90,59.5);
    [imageViews addSubview:self.collectionView];
    self.dataArray = [NSArray array];
    [self.collectionView addSubview:self.imageNotelabel];
    [self.collectionView registerClass:[PhotoRevealCell class] forCellWithReuseIdentifier:reUse];
    
    // 点击上传按钮
    
    UIButton *imagePicButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-90)/2  - 15,20 , 30, 30)];
    [imageViews addSubview:imagePicButton];
    [imagePicButton setImage:[UIImage imageNamed:@"btn_add_biack"] forState:UIControlStateNormal];
    [imagePicButton addTarget:self action:@selector(handleSelectPhotosAction:) forControlEvents:UIControlEventTouchUpInside];

    
    
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
        make.height.mas_equalTo(45);
    }];
    
    [descripeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(119+64+15 +15);
        make.left.mas_equalTo(self.view.left).mas_offset(30);
        make.right.mas_equalTo(self.view.right).mas_offset(-30);
        make.height.mas_equalTo(20);
    }];
    
    [self.questionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(142+64+19+15);
        make.left.mas_equalTo(self.view.left).mas_offset(30);
        make.right.mas_equalTo(self.view.right).mas_offset(-30);
        make.height.mas_equalTo(111.5);
    }];
    
    
    [imageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(270+64+19+15);
        make.left.mas_equalTo(self.view.left).mas_offset(30);
        make.right.mas_equalTo(self.view.right).mas_offset(-30);
        make.height.mas_equalTo(20);
    }];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.bottom).mas_offset(-30);
        make.left.mas_equalTo(self.view.left).mas_offset(30);
        make.right.mas_equalTo(self.view.right).mas_offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        [self.questionPalceHolderView setHidden:YES];
    }
    else {
        [self.questionPalceHolderView setHidden:NO];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleSelectPhotosAction:(UIButton*)sender {
    [self.imageNotelabel setHidden:YES];
    PhotoNavigationController *navigationController = [[PhotoNavigationController alloc] init];
    navigationController.maxSelectedCount = 3;
    [self presentViewController:navigationController animated:YES completion:nil];
    // 选择图片回调
    WeakSelf(self)
    [navigationController getSelectedPhotosWithBlock:^(NSArray<ALAsset *> *selectedArray) {
        weakSelf.dataArray = [NSArray arrayWithArray:selectedArray];
        [self.imageArray removeAllObjects];
        [weakSelf.collectionView reloadData];
        
    }];
}

#pragma mark -
#pragma mark - update Prompt
- (void)updatePrompt {
    NSTimeInterval delayInSeconds = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataArray.count > 0) {
            [self.navigationItem setPrompt:nil];
        } else {
            [self.navigationItem setPrompt:@"点击右侧按钮选择图片"];
        }
    });
}

#pragma mark -
#pragma mark - collectionView protocol methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoRevealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reUse forIndexPath:indexPath];
    ALAsset *asset = self.dataArray[indexPath.row];
    // 显示缩略图
    UIImage *image;
   /* ALAssetRepresentation *image_representation = [asset defaultRepresentation];
    uint8_t buffer = (Byte)malloc(image_representation.size);
    NSUInteger length = [image_representation getBytes:&buffer fromOffset: 0.0 length:image_representation.size error:nil];
    
    if (length != 0)  {
        NSData *adata = [[NSData alloc] initWithBytesNoCopy:buffer length:image_representation.size freeWhenDone:YES];
        image = [UIImage imageWithData:adata];
    }*/
     ALAssetRepresentation * representation = [asset defaultRepresentation];
     image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:1.0 orientation:UIImageOrientationDownMirrored];
    [self.imageArrayorigin addObject:image];
    [self.imageArray addObject:[UIImage imageWithCGImage:[asset thumbnail]]];

    [cell reloadDataWithImage:[UIImage imageWithCGImage:[asset thumbnail]]];
    return cell;
}


-(void)popImageView:(NSInteger)index{
    ALAsset *asset = self.dataArray[index];
    // 显示缩略图
    UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    zoomPopup *popup = [[zoomPopup alloc] initWithMainview:self.view andStartRect:CGRectMake(SCREEN_WIDTH-10, 65, 300, 300)];
    [popup setBlurRadius:10];
    [popup showPopup:imageView];
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


-(void)submitMyProblem{
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在上传" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    NSDictionary *parames = @{@"content":self.questionTextField.text,@"title":@"生意人问题反馈",@"user_num":user.userNum,@"app_version":self.version.current,@"platform":@"ios",@"platform_version":self.version.platform};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *postString = [NSString stringWithFormat:@"%@/api/v1/feedback",kBaseUrl];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:postString parameters:parames constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < self.imageArrayorigin.count; i++) {
            UIImage *image = self.imageArrayorigin[i];
            NSData *data = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"image%d",i] fileName:[NSString stringWithFormat:@"image%d.png",i] mimeType:@"multipart/form-data"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        if ([dic[@"code"] isEqualToNumber:@(201)]) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert addButton:@"确定" actionBlock:^(void) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addButton:@"取消" actionBlock:^(void) {
                }];
                [alert showSuccess:self title:@"温馨提示" subTitle:@"提交成功" closeButtonTitle:nil duration:0.0f];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /*
                 * 用户行为记录, 单独异常处理，不可影响用户体验
                 */
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName] = @"点击/问题反馈成功";
                [APIHelper actionLog:logParams];
            });
        }
        else{
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:@"重试" actionBlock:^(void) {
                [self submitMyProblem];
            }];
            [alert addButton:@"取消" actionBlock:^(void) {
            }];
            [alert showSuccess:self title:@"温馨提示" subTitle:@"上传失败" closeButtonTitle:nil duration:0.0f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",@"上传失败了");
        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        [ViewUtils showPopupView:self.view Info:@"上传失败，请重试"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"点击/问题反馈失败";
            [APIHelper actionLog:logParams];
        });
    }];
    
}


// 点击放大图片

//点击图片后的方法(即图片的放大全屏效果)
- (void) tapAction{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 600)];
    background = bgView;
    [bgView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bgView];
    
    //创建显示图像的视图
    //初始化要显示的图片内容的imageView（这里位置继续偷懒...没有计算）
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 300, 300)];
    //要显示的图片，即要放大的图片
    ALAsset *asset = self.dataArray[clickImageNumber];
    // 显示缩略图
    UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
    [imgView setImage:image];
    [bgView addSubview:imgView];
    
    imgView.userInteractionEnabled = YES;
    //添加点击手势（即点击图片后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [imgView addGestureRecognizer:tapGesture];
    
    [self shakeToShow:bgView];//放大过程中的动画
}
-(void)closeView{
    [background removeFromSuperview];
}
//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
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
