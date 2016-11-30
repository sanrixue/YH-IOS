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
#import "VoiceSpeechView.h"
#import "PcmPlayer.h"
#import "PcmPlayerDelegate.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "HttpResponse.h"
#import "User.h"

@interface VoicePlayViewController () <IFlySpeechSynthesizerDelegate,UITableViewDelegate,UITableViewDataSource>{
    IFlySpeechSynthesizer *_iFlySppechSynthesizer;
}
@property(nonatomic,strong)UITableView *playListTableView;
@property (nonatomic, strong) PcmPlayer *audioPlayer;
@property (nonatomic,strong) NSTimer *voicetimer;
@property (nonatomic,strong) NSMutableDictionary *cacaheDict;
@property (nonatomic,strong) NSMutableArray *reportListArray;
@property (nonatomic,strong) NSMutableArray *reporStringtArray;
@property (strong, nonatomic) User *user;
@property (strong,nonatomic) UIButton *playerBtn;
@property (assign, nonatomic) BOOL isSpeaking;
@end

@implementation VoicePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getReportData];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 60, 30)];
    [backBtn addTarget:self action:@selector(dismissPlay) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setImage:[UIImage imageNamed:@"Banner-Back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    self.isSpeaking = YES;
    self.playListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 600) style:UITableViewStylePlain];
    self.playListTableView.dataSource=self;
    self.playListTableView.delegate = self;
    self.playListTableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.playListTableView];
    self.view.backgroundColor = [UIColor greenColor];
    
    self.playerBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, 40, 40, 40)];
    [self.view addSubview:self.playerBtn];
    self.playerBtn.layer.cornerRadius = 20;
    self.playerBtn.backgroundColor = [UIColor redColor];
    [self.playerBtn addTarget:self action:@selector(voiceSppech) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)dismissPlay {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isReport ? self.reporStringtArray.count : self.reportListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"playcell"];
    }
    if (_isReport) {
        cell.textLabel.text = self.reporStringtArray[indexPath.row];
    }
    else {
        cell.textLabel.text = self.reportListArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return _isReport ? 100 : 40;
}


- (void) voiceSppech{
    
    //_audioPlayer = [[PcmPlayer alloc]initWithFilePath:[[FileUtils sharedPath] stringByAppendingPathComponent:@"oc.pcm"] sampleRate:8000];
    _iFlySppechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySppechSynthesizer.delegate = self;
    [_iFlySppechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    [_iFlySppechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];
    [_iFlySppechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    [_iFlySppechSynthesizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [_iFlySppechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    [_iFlySppechSynthesizer setParameter:@"tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    NSString *contentString =[NSString stringWithFormat:@"%@", [self reayPlayData]];
    if (contentString) {
        
        _isReport ?  [_iFlySppechSynthesizer synthesize:contentString toUri:[[FileUtils userspace] stringByAppendingPathComponent:@"oc.pcm"]]: [_iFlySppechSynthesizer startSpeaking:contentString];
    }
    else {
        [_iFlySppechSynthesizer startSpeaking:@"正在准备播报数据，请稍后"];
    }
    //[_iFlySppechSynthesizer startSpeaking:@"this is a good thing thsat you shuold do 我经常一个人看着那些美丽的封疆，喜欢安安经营的校花"];
}

- (void) getReportData {
     NSString *urlCleanedString = [self urlCleaner:self.reportUrlString];
   // NSString *reportString = [NSString stringWithFormat:@"http://yonghui-test.idata.mobi/api/v1/group/0/role/7/audio"];
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
    _isReport ? [self getReportString:self.reportUrlString] :[self getPlayString:self.reportUrlString];
}

- (NSString *)urlCleaner:(NSString *)urlString {
    return [urlString componentsSeparatedByString:@"?"][0];
}

- (void)getReportString:(NSString *)filePath {
    _user = [[User alloc]init];
    NSString *firstPlayString = [NSString stringWithFormat:@"本报表针对%@商行%@", self.user.roleName, self.user.groupName];
    self.reportListArray = [[NSMutableArray alloc]init];
    self.reporStringtArray = [[NSMutableArray alloc] init];
    [self.reporStringtArray addObject:firstPlayString];
    NSString *urlCleanedString = [self urlCleaner:filePath];
    NSArray *array = _cacaheDict[urlCleanedString][@"audio"];
    self.reportListArray = _cacaheDict[urlCleanedString][@"title"];
    for (NSString *obj in array) {
        [self.reporStringtArray addObject:obj];
    }
}

- (void)getPlayString:(NSString *)filePath {
    _user = [[User alloc]init];
    NSString *firstPlayString = [NSString stringWithFormat:@"本报表针对%@商行%@", self.user.roleName, self.user.groupName];
    self.reportListArray = [[NSMutableArray alloc]init];
    self.reporStringtArray = [[NSMutableArray alloc] init];
    [self.reporStringtArray addObject:firstPlayString];
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
    [self.reporStringtArray addObject:@"以上就是所有播报数据，谢谢收听"];
}

- (NSString *) reayPlayData {
    NSString *contentString = @"";
    for (NSString *obj in self.reporStringtArray) {
        contentString = [NSString stringWithFormat:@"%@%@",contentString,obj];
    }
    
    return contentString;
}

- (void) onSpeakProgress:(int) progress {
    
    NSLog(@"播放的时长为 %d",progress);
}

- (void)onBufferProgress:(int)progress message:(NSString *)msg {
    NSLog(@"正在合成是吗");
}

- (void)onCompleted:(IFlySpeechError *)error {
    if (_isReport) {
        [self playReport];
    }
    NSLog(@"可能会出错的是什么呢");

}

- (void)playReport {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    _audioPlayer = [[PcmPlayer alloc] initWithFilePath:[[FileUtils userspace] stringByAppendingPathComponent:@"oc.pcm"] sampleRate:8000];
    [_audioPlayer play];
}

- (void)playerState {
    if (_isSpeaking) {
        [_iFlySppechSynthesizer pauseSpeaking];
        _isSpeaking = NO;
    }
    else {
        [_iFlySppechSynthesizer resumeSpeaking];
        _isSpeaking = YES;
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [_iFlySppechSynthesizer stopSpeaking];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
