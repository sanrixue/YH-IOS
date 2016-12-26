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
    CGFloat _scale;
}
@property (nonatomic, strong)UITableView *playListTableView;
@property (nonatomic, strong) PcmPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *voicetimer;
@property (nonatomic, strong) NSMutableDictionary *cacaheDict;
@property (nonatomic, strong) NSMutableArray *reportListArray;
@property (nonatomic, strong) NSMutableArray *reporStringtArray;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UIButton *playerBtn;
@property (nonatomic, assign) BOOL isSpeaking;
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySppechSynthesizer;
@property (nonatomic, assign) int loopTime;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) NSString *reportDataString;
@property (nonatomic, strong) UIButton *listBtn;
@property (nonatomic, assign) BOOL isShowList;
@end

@implementation VoicePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 60, 30)];
    [backBtn addTarget:self action:@selector(dismissPlay) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setImage:[UIImage imageNamed:@"Banner-Back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    //分割线
    UIView *sepertView = [[UIView alloc]initWithFrame:CGRectMake(0, 98, self.view.frame.size.width, 2)];
    sepertView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sepertView];
    
    //播放列表
    self.playListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.playListTableView.dataSource = self;
    self.playListTableView.delegate = self;
    
    // 播放列表
    self.listBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60, 50, 25, 25)];
    [self.listBtn setImage:[UIImage imageNamed:@"playlist"] forState:UIControlStateNormal];
    self.listBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.listBtn];
    [self.listBtn addTarget:self action:@selector(showListTable) forControlEvents:UIControlEventTouchUpInside];
    
    // 初始化语音播放
    _iFlySppechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySppechSynthesizer.delegate = self;
    [_iFlySppechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    [_iFlySppechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];
    [_iFlySppechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    [_iFlySppechSynthesizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [_iFlySppechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    
    // 播报内容
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100)];
    self.contentTextView.backgroundColor = [UIColor darkGrayColor];
    self.contentTextView.userInteractionEnabled = YES;
    self.contentTextView.editable = NO;
    self.contentTextView.textColor = [UIColor whiteColor];
    [self.view addSubview:self.contentTextView];
    [self pinchGestureRecognizer];
    [self.contentTextView addSubview:self.playListTableView];
    
    self.isSpeaking = [_iFlySppechSynthesizer isSpeaking];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.playerBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 20, 40, 40, 40)];
    [self.view addSubview:self.playerBtn];
    self.playerBtn.layer.cornerRadius = 20;
    
    // 上一曲
    UIButton *lastBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 80, 46, 30, 30)];
    [self.view addSubview:lastBtn];
    [lastBtn setImage:[UIImage imageNamed:@"lastplay"] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(playlastReport) forControlEvents:UIControlEventTouchUpInside];
    
    // 下一曲
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 50, 46, 30, 30)];
    [self.view addSubview:nextBtn];
    [nextBtn setImage:[UIImage imageNamed:@"nextplay"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(playNextReport) forControlEvents:UIControlEventTouchUpInside];
    
    // 播放状态初始化
    _loopTime =[ [[NSUserDefaults standardUserDefaults]objectForKey:@"reportId"] intValue];
    _isSpeaking = [[[NSUserDefaults standardUserDefaults]objectForKey:@"playState"]boolValue];
    if (!self.loopTime) {
        self.loopTime = 0;
    }
    if (_isSpeaking) {
        [self.playerBtn setImage:[UIImage imageNamed:@"playing"] forState:UIControlStateNormal];
        NSString *cachePath = [[FileUtils userspace] stringByAppendingPathComponent:@"Cached"];
        NSString *playDataPath = [cachePath stringByAppendingPathComponent:@"PlayData.plist"];
        [self getPlayString:self.reportUrlString filepath:playDataPath];
    }
    else {
        [self getReportData];
        [self.playerBtn setImage:[UIImage imageNamed:@"stopplay"] forState:UIControlStateNormal];
    }
    
    [self.playerBtn addTarget:self action:@selector(playerState) forControlEvents:UIControlEventTouchUpInside];
    self.isShowList = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopPlay) name:@"stopPlay" object:nil];
}

- (void)dismissPlay {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

// 添加聚合手势
- (void)pinchGestureRecognizer {
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    [self.view addGestureRecognizer:pinch];
}

// 手势判断
- (void)pinchAction:(UIPinchGestureRecognizer *)sender {
    NSLog(@"捏合手势 %f", sender.scale);
    (sender.scale > 1) ? [self hideListTable] : [self showListTable];
}

// 显示播放列表
- (void)showListTable {
    if (self.isShowList) {
        [self hideListTable];
        self.isShowList = NO;
    }
    else {
        [UIView animateWithDuration:2 animations:^{
            self.playListTableView.frame = CGRectMake(0, self.contentTextView.frame.size.height -  200, self.contentTextView.frame.size.width, 200);
        }];
        [self.playListTableView reloadData];
        self.isShowList = YES;
    }
}

// 隐藏播放列表
- (void)hideListTable {
    [UIView animateWithDuration:2 animations:^{
        self.playListTableView.frame = CGRectMake(0, 0,0, 0);
    }];
}

// 停止播放
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

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_iFlySppechSynthesizer stopSpeaking];
    _isSpeaking = NO;
    _loopTime = 0;
    NSNumber *interger =[NSNumber numberWithInt:self.loopTime];
    NSNumber *number = [NSNumber numberWithBool:self.isSpeaking];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"playState"];
    [[NSUserDefaults standardUserDefaults]setObject:interger forKey:@"reportId"];
}

// 开始播报
- (void) voiceSppech{
     [self.playerBtn setImage:[UIImage imageNamed:@"playing"] forState:UIControlStateNormal];
    //_audioPlayer = [[PcmPlayer alloc]initWithFilePath:[[FileUtils sharedPath] stringByAppendingPathComponent:@"oc.pcm"] sampleRate:8000];
    if ([self.reportListArray count] == 0) {
        [_iFlySppechSynthesizer stopSpeaking];
        [self.playerBtn setImage:[UIImage imageNamed:@"stopplay"] forState:UIControlStateNormal];
        NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", [FileUtils dirPath:kHTMLDirName], kCachedHeaderConfigFileName];
        NSMutableDictionary *cachedHeaderDict = [NSMutableDictionary dictionaryWithContentsOfFile:cachedHeaderPath];
        NSString *urlCleanedString = [self urlCleaner:self.reportUrlString];
        cachedHeaderDict[urlCleanedString][@"Etag"] = @"1";
        cachedHeaderDict[urlCleanedString][@"Last-Modified"] = @"1";
        [cachedHeaderDict writeToFile:cachedHeaderPath atomically:YES];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"暂无播报数据"
                                                                       message:@"播报内容为空，可刷新重试"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        UIAlertAction* resetData = [UIAlertAction actionWithTitle:@"刷新" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self getReportData];}];
        
        [alert addAction:defaultAction];
        [alert addAction:resetData];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    _user = [[User alloc]init];
    NSString *contentString = [self reayPlayData];
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

// 获取播报数据
- (void)getReportData{
    NSString *urlCleanedString = [self urlCleaner:self.reportUrlString];
    HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.reportUrlString assetsPath:self.asstePath];
    NSString *cachePath = [[FileUtils userspace] stringByAppendingPathComponent:@"Cached"];
    NSString *playDataPath = [cachePath stringByAppendingPathComponent:@"PlayData.plist"];
    if (![FileUtils checkFileExist:cachePath isDir:NO]) {
        [FileUtils dirPath:@"Cached"];
    }
    self.cacaheDict = [[NSMutableDictionary alloc]init];
    if (httpResponse.response.statusCode == 200) {
        _cacaheDict[urlCleanedString] = httpResponse.data;
        [_cacaheDict writeToFile:playDataPath atomically:YES];
        self.loopTime = 0;
    }

    [self getPlayString:self.reportUrlString filepath:playDataPath];
}

- (NSString *)urlCleaner:(NSString *)urlString {
    return [urlString componentsSeparatedByString:@"?"][0];
}

// 分拆播报数据
- (void)getPlayString:(NSString *)filePath filepath:(NSString *)playDataPath {
    self.cacaheDict = [FileUtils readConfigFile:playDataPath];
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
    
    self.contentTextView.text = [self reayPlayData];
}

// 合成播报数据
- (NSString *)reayPlayData{
    NSString *contentString = @"";
    _user = [[User alloc]init];
     NSString *firstPlayString = [NSString stringWithFormat:@"本报表针对%@商行%@", self.user.roleName, self.user.groupName];
    if  (self.loopTime < self.reporStringtArray.count - 1 && self.reportListArray.count !=0 && self.reporStringtArray.count !=0 ) {
        contentString = [NSString stringWithFormat:@"报表名称%@。%@。%@",self.reportListArray[_loopTime],firstPlayString,self.reporStringtArray[self.loopTime]];
    }
    else if (self.loopTime == self.reporStringtArray.count - 1) {
        contentString = [NSString stringWithFormat:@"报表名称%@。%@。%@。 以上就是全部内容谢谢收听",self.reportListArray[_loopTime],firstPlayString,self.reporStringtArray[self.loopTime]];
    }
    else {
        contentString =  @"播报数据为空";
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
    self.loopTime++;
    if (error.errorCode > 20000) {
        [_iFlySppechSynthesizer stopSpeaking];
        [self.playerBtn setImage:[UIImage imageNamed:@"stopplay"] forState:UIControlStateNormal];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"合成错误" message:@"语音播报合成错误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"停止" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        UIAlertAction* reAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self voiceSppech];
                                                              }];
        [alert addAction:defaultAction];
        [alert addAction:reAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (self.loopTime == self.reporStringtArray.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopPlay" object:nil];
       // [self.playerBtn setImage:[UIImage imageNamed:@"stopplay"] forState:UIControlStateNormal];
    }
    else{
        [self voiceSppech];
    }
}

// 下一曲
- (void)playNextReport {
    [_iFlySppechSynthesizer pauseSpeaking];
    self.loopTime ++;
    if (_loopTime == self.reportListArray.count) {
        _loopTime = 0;
    }
    [self voiceSppech];
}

// 上一曲
- (void)playlastReport {
    [_iFlySppechSynthesizer pauseSpeaking];
    self.loopTime --;
    if (self.loopTime < 0) {
        return;
    }
    [self voiceSppech];
}

- (void)onSpeakBegin {
    NSLog(@"开始合成");
}

// 播放状态
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

// 保存播放状态
- (void) viewWillDisappear:(BOOL)animated {
    if (self.loopTime >= self.reportListArray.count) {
        self.loopTime = 0;
    }
    NSNumber *interger =[NSNumber numberWithInt:self.loopTime];
    NSNumber *number = [NSNumber numberWithBool:self.isSpeaking];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"playState"];
    [[NSUserDefaults standardUserDefaults]setObject:interger forKey:@"reportId"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
