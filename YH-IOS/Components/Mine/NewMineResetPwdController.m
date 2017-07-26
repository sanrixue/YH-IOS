//
//  NewMineResetPwdController.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/26.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewMineResetPwdController.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "User.h"
#import "APIHelper.h"
#import "HttpResponse.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "FileUtils.h"
#import "LoginViewController.h"

@interface NewMineResetPwdController ()<UITableViewDataSource,UITableViewDelegate,RMessageProtocol>

{
    UITableView *ResetPwdTableView;
    UIButton *saveBtn;
    UITextField *NewPwdNumber;
    UITextField *RequestPwdNumber;
    UIButton *NewPwdON;
    UIButton *RequestON;
    User *user;
}

@property (nonatomic,copy) NSString *oldPwdString;
@property (nonatomic,copy) NSString *NewPwdString;
@property (nonatomic,copy) NSString *RequstPwdString;

@end

@implementation NewMineResetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
     user = [[User alloc]init];
    
    [RMessage setDefaultViewController:self.navigationController];
    [RMessage setDelegate:self];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController setNavigationBarHidden:false];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#32414b"]}] ;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    
    UIImage *imageback = [[UIImage imageNamed:@"newnav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    bakImage.image = imageback;
    
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(NewPwdViewBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];


    [self setTableView];
}



-(void)setTableView
{
    
    ResetPwdTableView=[[UITableView alloc] init];
    
    [self.view addSubview:ResetPwdTableView];
    
    
    ResetPwdTableView.scrollEnabled =NO; //设置tableview 不能滚动
    
    [ResetPwdTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height));
    }];
    [ResetPwdTableView setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]];
    ResetPwdTableView.dataSource = self;
    ResetPwdTableView.delegate = self;
    
}

#pragma  get GroupArray count  to set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else{
        return 4;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1 && indexPath.row==2) {
        return 45;
    }
    else
        return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    else
        return self.view.frame.size.height-265;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString *Identifier = @"oldPwdCell";
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
            UITextField *OldPwdNumber =[[UITextField alloc] init];
            [cell addSubview:OldPwdNumber];
            OldPwdNumber.placeholder=@"旧密码";
            OldPwdNumber.font=[UIFont systemFontOfSize:16];
            OldPwdNumber.textAlignment=NSTextAlignmentLeft;
            OldPwdNumber.textColor=[UIColor colorWithHexString:@"#bcbcbc"];
            [OldPwdNumber addTarget:self action:@selector(OldPwdDidChange:) forControlEvents:UIControlEventEditingChanged];
            [OldPwdNumber mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 50));
            }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   else if (indexPath.section==1 && indexPath.row==0)
   {
       static NSString *Identifier = @"newPwdCell";
       UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
       if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
           //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
           NewPwdNumber =[[UITextField alloc] init];
           [cell addSubview:NewPwdNumber];
           NewPwdNumber.placeholder=@"请输入新密码";
           NewPwdNumber.font=[UIFont systemFontOfSize:16];
           NewPwdNumber.textAlignment=NSTextAlignmentLeft;
            [NewPwdNumber setSecureTextEntry:YES];
           NewPwdNumber.textColor=[UIColor colorWithHexString:@"#666666"];
           [NewPwdNumber addTarget:self action:@selector(NewPwdDidChange:) forControlEvents:UIControlEventEditingChanged];
           [NewPwdNumber mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
               make.centerY.mas_equalTo(cell.mas_centerY);
               make.right.mas_equalTo(cell.mas_right).offset(-44);
               make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width-44, 50));
           }];
       }
       
       
       NewPwdON=[UIButton buttonWithType:UIButtonTypeCustom];
       
       NewPwdON.tag=100;
       
       [cell.contentView addSubview:NewPwdON];
       
       [NewPwdON setBackgroundImage:[UIImage imageNamed:@"look-on"] forState:UIControlStateNormal];

       [NewPwdON addTarget:self action:@selector(newPwdOnOrOffBtn:) forControlEvents:UIControlEventTouchDown];
       
       [NewPwdON mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.mas_equalTo(cell.contentView.mas_centerY);
           make.right.mas_equalTo(cell.contentView.mas_right).offset(-28);
           make.size.mas_equalTo(CGSizeMake(16, 16));
       }];
       
       [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
   }
   else if (indexPath.section==1 && indexPath.row==1)
   {
       static NSString *Identifier = @"RequestPwdCell";
       UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
       if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
           //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
           RequestPwdNumber =[[UITextField alloc] init];
           [cell addSubview:RequestPwdNumber];
             RequestPwdNumber.placeholder=@"请再次输入新密码";
           RequestPwdNumber.font=[UIFont systemFontOfSize:16];
           [RequestPwdNumber setSecureTextEntry:YES];
           RequestPwdNumber.textAlignment=NSTextAlignmentLeft;
           RequestPwdNumber.textColor=[UIColor colorWithHexString:@"#666666"];
           [RequestPwdNumber addTarget:self action:@selector(RequestPwdDidChange:) forControlEvents:UIControlEventEditingChanged];
           [RequestPwdNumber mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
               make.right.mas_equalTo(cell.contentView.mas_right).offset(-44);
               make.centerY.mas_equalTo(cell.mas_centerY);
               make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width-44, 50));
           }];
       }
       
       RequestON=[UIButton buttonWithType:UIButtonTypeCustom];
       
       [cell.contentView addSubview:RequestON];
       
       RequestON.tag=100;
       
       [RequestON setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
       
       [RequestON setBackgroundImage:[UIImage imageNamed:@"look-on"] forState:UIControlStateNormal];
       
       [RequestON addTarget:self action:@selector(RequestOnOrOffBtn:) forControlEvents:UIControlEventTouchDown];
       
       [RequestON mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.mas_equalTo(cell.contentView.mas_centerY);
           make.right.mas_equalTo(cell.contentView.mas_right).offset(-28);
           make.size.mas_equalTo(CGSizeMake(16, 16));
       }];
      
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
       
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
   }
   else if (indexPath.section==1 && indexPath.row==2)
   {
       static NSString *Identifier = @"LabelCell";
       UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
       if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
           //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
           UILabel *textLabel=[[UILabel alloc] init];
           [cell addSubview:textLabel];
           textLabel.text=@"密码需为6位以上，数字和字母的组合";
           textLabel.textColor=[UIColor colorWithHexString:@"bcbcbc"];
           textLabel.textAlignment=NSTextAlignmentLeft;
           textLabel.font=[UIFont systemFontOfSize:13];
           [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
               
               make.centerY.mas_equalTo(cell.mas_centerY);
           }];
           [cell setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]];
       }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
   }
    else
    {
    
        static NSString *Identifier = @"saveCell";
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
            saveBtn=[[UIButton alloc]init];
            [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
            saveBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
            [saveBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
            [saveBtn setTitleColor:[UIColor colorWithHexString:@"#00a4e9"] forState:UIControlStateNormal];
            [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]  forState:UIControlStateSelected];
            [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"] forState:UIControlStateHighlighted];
            [cell addSubview:saveBtn];
            [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cell.mas_centerX);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 50));
            }];
        }
        return cell;
    }
}


-(void)newPwdOnOrOffBtn:(UIButton *)newBtn
{
    if (newBtn.tag==100) {
        [NewPwdON setBackgroundImage:[UIImage imageNamed:@"look-off"] forState:UIControlStateNormal];
        NewPwdON.tag=101;
        [NewPwdNumber setSecureTextEntry:NO];
    }
    else
    {
        [NewPwdON setBackgroundImage:[UIImage imageNamed:@"look-on"] forState:UIControlStateNormal];
        NewPwdON.tag=100;
        [NewPwdNumber setSecureTextEntry:YES];
    }
    
}

-(void)RequestOnOrOffBtn:(UIButton *)RequestPwdBtn
{
    if (RequestPwdBtn.tag==100) {
        [RequestON setBackgroundImage:[UIImage imageNamed:@"look-off"] forState:UIControlStateNormal];
        RequestON.tag=101;
         [RequestPwdNumber setSecureTextEntry:NO];
    }
    else
    {
        [RequestON setBackgroundImage:[UIImage imageNamed:@"look-on"] forState:UIControlStateNormal];
        RequestON.tag=100;
        [RequestPwdNumber setSecureTextEntry:YES];
    }
}

-(void)OldPwdDidChange:(UITextField*)OldPwdNumber
{
    _oldPwdString=OldPwdNumber.text;
}

-(void)NewPwdDidChange:(UITextField*)NewPwdTextField
{
    _NewPwdString=NewPwdTextField.text;
}

-(void)RequestPwdDidChange:(UITextField*)RequestTextField
{
    _RequstPwdString=RequestTextField.text;
}

-(void)saveBtn
{
    if (![_oldPwdString.md5 isEqualToString:user.password]) {
        [ViewUtils showPopupView:self.view Info:@"密码输入错误"];
        return;
    }
    if (![_NewPwdString isEqualToString:_RequstPwdString]) {
        [ViewUtils showPopupView:self.view Info:@"新密码输入不一致"];
        return;
    }
    if ([self checkIsHaveNumAndLetter:_NewPwdString]!=3 || [_NewPwdString length] <6 ) {
        [ViewUtils showPopupView:self.view Info:@"密码需为6位以上，数字和字母的组合"];
        return;
    }
    if([_oldPwdString.md5 isEqualToString:user.password]) {
        
        HttpResponse *response = [APIHelper resetPassword:user.userID newPassword:_NewPwdString.md5];
        NSString *message = [NSString stringWithFormat:@"%@", response.data[@"info"]];
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        if(response.statusCode && [response.statusCode isEqualToNumber:@(201)]) {
            [self changLocalPwd:_NewPwdString];
            [alert addButton:@"重新登录" actionBlock:^(void) {
                [self jumpToLogin];
            }];
            
            [alert showSuccess:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /*
                 * 用户行为记录, 单独异常处理，不可影响用户体验
                 */
                @try {
                    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                    logParams[@"action"] = @"点击/密码修改";
                    [APIHelper actionLog:logParams];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            });
        }
        else {
            // [self changLocalPwd:newPassword];
            [alert addButton:@"好的" actionBlock:^(void) {
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }];
            [alert showWarning:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
        }
    }
    else {
        [ViewUtils showPopupView:self.view Info:@"原始密码输入有误"];
    }
    
}

- (void)jumpToLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[kIsLoginCUName] = @(NO);
    [userDict writeToFile:userConfigPath atomically:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kMainSBName bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:kLoginVCName];
    self.view.window.rootViewController = loginViewController;
}


- (void)changLocalPwd:(NSString *)newPassword {
    NSString  *noticeFilePath = [FileUtils dirPath:@"Cached" FileName:@"local_notifition.json"];
    NSMutableDictionary *noticeDict = [FileUtils readConfigFile:noticeFilePath];
    noticeDict[@"setting_password"] = @(-1);
    noticeDict[@"setting"] = @(0);
    [FileUtils writeJSON:noticeDict Into:noticeFilePath];
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[@"user_md5"] = newPassword.md5;
    [FileUtils writeJSON:userDict Into:userConfigPath];
}


//直接调用这个方法就行
-(int)checkIsHaveNumAndLetter:(NSString*)password{
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, password.length)];
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    if (tNumMatchCount == password.length) {
        //全部符合数字，表示沒有英文
        return 1;
    } else if (tLetterMatchCount == password.length) {
        //全部符合英文，表示沒有数字
        return 2;
    } else if (tNumMatchCount + tLetterMatchCount == password.length) {
        //符合英文和符合数字条件的相加等于密码长度
        return 3;
    } else {
        return 4;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
}


-(void)NewPwdViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
