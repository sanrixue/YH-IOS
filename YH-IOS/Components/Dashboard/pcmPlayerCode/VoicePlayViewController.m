//
//  VoicePlayViewController.m
//  YH-IOS
//
//  Created by li hao on 16/11/30.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "VoicePlayViewController.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import <AVFoundation/AVFoundation.h>
#import "PcmPlayer.h"
#import "PcmPlayerDelegate.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "HttpResponse.h"
#import "User.h"
#import "DropViewController.h"
#import "UIColor+Hex.h"


@interface VoicePlayViewController () <IFlySpeechSynthesizerDelegate,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,UIPopoverPresentationControllerDelegate>{
}
@property (nonatomic,strong)UITableView *playListTableView;
@property (nonatomic, strong) PcmPlayer *audioPlayer;
@property (nonatomic,strong) NSTimer *voicetimer;
@property (nonatomic,strong) NSMutableDictionary *cacaheDict;
@property (nonatomic,strong) NSMutableArray *reportListArray;
@property (nonatomic,strong) NSMutableArray *reporStringtArray;
@property (strong, nonatomic) User *user;
@property (strong,nonatomic) UIButton *playerBtn;
@property (assign, nonatomic) BOOL isSpeaking;
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySppechSynthesizer;
@property (nonatomic, assign) int loopTime;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) NSString *reportDataString;
@end

@implementation VoicePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 60, 30)];
    [backBtn addTarget:self action:@selector(dismissPlay) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setImage:[UIImage imageNamed:@"Banner-Back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    UIView *sepertView = [[UIView alloc]initWithFrame:CGRectMake(0, 98, self.view.frame.size.width, 2)];
    sepertView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sepertView];
    
    _iFlySppechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySppechSynthesizer.delegate = self;
    [_iFlySppechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    [_iFlySppechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];
    [_iFlySppechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    [_iFlySppechSynthesizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [_iFlySppechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    [self getReportData];
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    self.contentTextView.backgroundColor = [UIColor darkGrayColor];
    self.contentTextView.textColor = [UIColor greenColor];
    self.contentTextView.userInteractionEnabled= NO;
    [self.view addSubview:self.contentTextView];
    
    self.isSpeaking = [_iFlySppechSynthesizer isSpeaking];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.playerBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, 40, 40, 40)];
    [self.view addSubview:self.playerBtn];
    self.playerBtn.layer.cornerRadius = 20;
    if ([_iFlySppechSynthesizer isSpeaking]) {
         [self.playerBtn setImage:[UIImage imageNamed:@"playing"] forState:UIControlStateNormal];
    }
    [self.playerBtn setImage:[UIImage imageNamed:@"stopplay"] forState:UIControlStateNormal];
    self.playerBtn.backgroundColor = [UIColor greenColor];
    [self.playerBtn addTarget:self action:@selector(playerState) forControlEvents:UIControlEventTouchUpInside];
    
    _loopTime =[ [[NSUserDefaults standardUserDefaults]objectForKey:@"reportId"] intValue];
    if (!self.loopTime) {
        self.loopTime = 0;
    }
    if (!self.reportDataString) {
        self.contentTextView.text = self.reportDataString;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopPlay) name:@"stopPlay" object:nil];
}

- (void)dismissPlay {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)stopPlay {
    [_iFlySppechSynthesizer stopSpeaking];
    self.loopTime = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reportcell"];
    cell.textLabel.text = self.reportListArray[indexPath.row];
    if (indexPath.row == self.loopTime) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      //  [_iFlySppechSynthesizer stopSpeaking];
     [self.playerBtn setImage:[UIImage imageNamed:@"playing"] forState:UIControlStateNormal];
    _isSpeaking = YES;
    self.loopTime = (int)indexPath.row;
    [self voiceSppech];
}


-(void)dropTableView:(UIButton *)sender {
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 200 );
    dropTableViewController.modalPresentationStyle = UIModalPresentationPopover;
    [dropTableViewController setPreferredContentSize:CGSizeMake(self.view.frame.size.width,200)];
    dropTableViewController.view.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    dropTableViewController.dropTableView.delegate = self;
    dropTableViewController.dropTableView.dataSource =self;
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.delegate = self;
    [popover setSourceRect:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 12, sender.frame.size.width, sender.frame.size.height)];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    [self presentViewController:dropTableViewController animated:YES completion:nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_iFlySppechSynthesizer stopSpeaking];
    _isSpeaking = NO;
    _loopTime = 0;
    [self.playerBtn setImage:[UIImage imageNamed:@"stopplay"] forState:UIControlStateNormal];
}

- (void) voiceSppech{
     [self.playerBtn setImage:[UIImage imageNamed:@"playing"] forState:UIControlStateNormal];
    //_audioPlayer = [[PcmPlayer alloc]initWithFilePath:[[FileUtils sharedPath] stringByAppendingPathComponent:@"oc.pcm"] sampleRate:8000];
    _user = [[User alloc]init];
    NSString *firstPlayString = [NSString stringWithFormat:@"本报表针对%@商行%@", self.user.roleName, self.user.groupName];
   /* if ([self.reportListArray count] == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"暂无播报数据"
                                                                       message:@"播报内容为空，暂时无法播放"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }*/
    NSString *contentString = [NSString stringWithFormat:@"报表名称%@。%@。%@",self.reportListArray[_loopTime],firstPlayString, [self reayPlayData]];
    self.reportDataString = [contentString stringByReplacingOccurrencesOfString:@"。" withString:@".\n"];
    self.contentTextView.text = self.reportDataString;
    if (contentString) {
        [_iFlySppechSynthesizer startSpeaking:contentString];
    }
    else {
        [self getReportData];
        [_iFlySppechSynthesizer startSpeaking:@"正在准备播报数据，请稍后"];
    }
}

- (void) getReportData {
    NSString *urlCleanedString = [self urlCleaner:self.reportUrlString];
    HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.reportUrlString assetsPath:self.asstePath];
    NSString *cachePath = [[FileUtils userspace] stringByAppendingPathComponent:@"Cached"];
    NSString *playDataPath = [cachePath stringByAppendingPathComponent:@"PlayData.plist"];
    self.cacaheDict = [NSMutableDictionary dictionaryWithContentsOfFile:playDataPath];
    if (![FileUtils checkFileExist:playDataPath isDir:NO]) {
        [[NSFileManager defaultManager] createFileAtPath:playDataPath contents:nil attributes:nil];
    }
    if (!_cacaheDict) {
        _cacaheDict = [[NSMutableDictionary alloc]init];
    }
    if (httpResponse.response.statusCode == 200) {
        _cacaheDict[urlCleanedString] = httpResponse.data;
        [_cacaheDict writeToFile:playDataPath atomically:YES];
        self.loopTime = 0;
    }
    [self getPlayString:self.reportUrlString];
}

- (NSString *)urlCleaner:(NSString *)urlString {
    return [urlString componentsSeparatedByString:@"?"][0];
}

- (void)getPlayString:(NSString *)filePath {
    self.reportListArray = [[NSMutableArray alloc]init];
    self.reporStringtArray = [[NSMutableArray alloc] init];
    NSString *urlCleanedString = [self urlCleaner:filePath];
    NSArray *array = _cacaheDict[urlCleanedString][@"data"];
    for (NSDictionary *boj in array) {
        [self.reportListArray addObject:boj[@"title"]];
        NSArray *arrayinside = boj[@"audio"];
        NSString *playContent = @"";
        for (NSString *str in arrayinside) {
            playContent = [NSString stringWithFormat:@"%@%@",playContent,str];
        }
        [self.reporStringtArray addObject:playContent];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playListTableView reloadData];
        if (![_iFlySppechSynthesizer isSpeaking]) {
            [self voiceSppech];
        }
    });
}

- (NSString *) reayPlayData {
    NSString *contentString = @"";
    if  (self.loopTime < self.reporStringtArray.count) {
        contentString = self.reporStringtArray[self.loopTime];
    }
    [self.playListTableView reloadData];
    return contentString;
}

- (void) onSpeakProgress:(int) progress {
    NSLog(@"播放的时长为 %d",progress);
}

- (void)onBufferProgress:(int)progress message:(NSString *)msg {
    NSLog(@"正在合成是吗");
}

- (void)onCompleted:(IFlySpeechError *)error {
    NSLog(@"可能会出错的是什么呢");
    if (error.errorCode > 20000) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"合成错误" message:@"语音播报合成错误" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (self.loopTime == self.reporStringtArray.count) {
        [_iFlySppechSynthesizer stopSpeaking];
        [self.playerBtn setImage:[UIImage imageNamed:@"playing"] forState:UIControlStateNormal];
    }
    else{
        [self voiceSppech];
        self.loopTime++;
    }
}

- (void)onSpeakBegin {
    NSLog(@"开始合成");
}

- (void)playerState {
    if ( _isSpeaking) {
        [_iFlySppechSynthesizer pauseSpeaking];
        _isSpeaking = NO;
         [self.playerBtn setImage:[UIImage imageNamed:@"stopplay"] forState:UIControlStateNormal];
    }
    else {
        [_iFlySppechSynthesizer resumeSpeaking];
        _isSpeaking = YES;
         [self.playerBtn setImage:[UIImage imageNamed:@"playing"] forState:UIControlStateNormal];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    if (self.loopTime == self.reportListArray.count) {
        return;
    }
    NSNumber *interger =[NSNumber numberWithInt:self.loopTime];
    [[NSUserDefaults standardUserDefaults]setObject:interger forKey:@"reportId"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
