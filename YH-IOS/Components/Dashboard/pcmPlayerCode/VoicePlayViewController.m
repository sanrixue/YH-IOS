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


@interface VoicePlayViewController () <IFlySpeechSynthesizerDelegate,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>{
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
    
    _iFlySppechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySppechSynthesizer.delegate = self;
    [_iFlySppechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    [_iFlySppechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];
    [_iFlySppechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    [_iFlySppechSynthesizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [_iFlySppechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getReportData];
    });
    
    self.isSpeaking = [_iFlySppechSynthesizer isSpeaking];
    self.playListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300) style:UITableViewStylePlain];
    self.playListTableView.dataSource=self;
    self.playListTableView.delegate = self;
    self.playListTableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.playListTableView];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.playerBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, 40, 40, 40)];
    [self.view addSubview:self.playerBtn];
    self.playerBtn.layer.cornerRadius = 20;
    [self.playerBtn setImage:[UIImage imageNamed:@"stopplay"] forState:UIControlStateNormal];
    self.playerBtn.backgroundColor = [UIColor greenColor];
    [self.playerBtn addTarget:self action:@selector(playerState) forControlEvents:UIControlEventTouchUpInside];
    
    _loopTime =[ [[NSUserDefaults standardUserDefaults]objectForKey:@"reportId"] intValue];
    if (!self.loopTime) {
        self.loopTime = 0;
    }
}

- (void)dismissPlay {
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_iFlySppechSynthesizer stopSpeaking];
    _isSpeaking = NO;
    _loopTime = 0;
    [self.playerBtn setImage:[UIImage imageNamed:@"stopplay"] forState:UIControlStateNormal];
}

- (void) voiceSppech{
    [self.playerBtn setImage:[UIImage imageNamed:@"playing"] forState:UIControlStateNormal];
    //_audioPlayer = [[PcmPlayer alloc]initWithFilePath:[[FileUtils sharedPath] stringByAppendingPathComponent:@"oc.pcm"] sampleRate:8000];
    if (self.loopTime == 0) {
        _user = [[User alloc]init];
        NSString *firstPlayString = [NSString stringWithFormat:@"本报表针对%@商行%@", self.user.roleName, self.user.groupName];
        [_iFlySppechSynthesizer startSpeaking:firstPlayString];
    }
    NSString *contentString =[NSString stringWithFormat:@"%@", [self reayPlayData]];
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
    if (self.loopTime == self.reporStringtArray.count) {
        [_iFlySppechSynthesizer stopSpeaking];
    }
    self.loopTime++;
    [self voiceSppech];
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
    NSNumber *interger =[NSNumber numberWithInt:self.loopTime];
    [[NSUserDefaults standardUserDefaults]setObject:interger forKey:@"reportId"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
