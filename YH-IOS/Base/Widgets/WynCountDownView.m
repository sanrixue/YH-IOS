//
//  WynCountDownView.m
//  YonghuiTest
//
//  Created by Waynn on 16/6/20.
//  Copyright © 2016年 cuicuiTech. All rights reserved.
//

#import "WynCountDownView.h"

// 冒号数量
#define kSeparatorCount 2
// day hour minute second
#define labelCount 3


@interface WynCountDownView(){
    // 定时器
    NSTimer *timer;
}
@property (nonatomic,strong)NSMutableArray *timeLabelArrM;
@property (nonatomic,strong)NSMutableArray *separateLabelArrM;
// day
@property (nonatomic,strong)UILabel *dayLabel;
// hour
@property (nonatomic,strong)UILabel *hourLabel;
// minues
@property (nonatomic,strong)UILabel *minuesLabel;
// seconds
@property (nonatomic,strong)UILabel *secondsLabel;

@end

@implementation WynCountDownView

+ (instancetype)wyn_shareCountDown {
    static WynCountDownView *_sharedResult = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedResult = [[self alloc] init];
    });
    
    return _sharedResult;
    
}

+ (instancetype)wyn_countDown {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self addSubview:self.dayLabel];
        [self addSubview:self.hourLabel];
        [self addSubview:self.minuesLabel];
        [self addSubview:self.secondsLabel];
        
        for (NSInteger index = 0; index < kSeparatorCount; index ++) {
            UILabel *separateLabel = [[UILabel alloc] init];
            separateLabel.text = @":";
            separateLabel.textAlignment = NSTextAlignmentCenter;
//            separateLabel.backgroundColor = [UIColor whiteColor];
            [self addSubview:separateLabel];
            [self.separateLabelArrM addObject:separateLabel];
        }
    }
    
    return self;
}

// 拿到外界传来的时间戳
- (void)setTimestamp:(NSInteger)timestamp{
    _timestamp = timestamp;
//    if (_timestamp != 0) {
    if (!timer) {
        timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)timer:(NSTimer*)timerr{
    _timestamp--;
    [self getDetailTimeWithTimestamp:_timestamp];
    if (_curTime) {
        _curTime(_timestamp);
    }
    if (_timestamp <= 0) {
        [timer invalidate];
        timer = nil;
        // 执行block回调
        if (self.timerStopBlock) {
            self.timerStopBlock();
        }
    }
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger hour = timestamp / 3600;
    NSInteger minute = (timestamp - hour*3600) / 60;
    NSInteger second = timestamp - hour*3600 - minute*60;
//    self.dayLabel.text = [NSString stringWithFormat:@"%zd天",day];
    self.hourLabel.text = [NSString stringWithFormat:@"%02zd",hour];
    self.minuesLabel.text = [NSString stringWithFormat:@"%02zd",minute];
    self.secondsLabel.text = [NSString stringWithFormat:@"%02zd",second];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 获得view的宽、高
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height;
    
    // 单个label的宽高
    CGFloat colonW = 10;
    CGFloat labelW = (viewW - colonW * kSeparatorCount) / labelCount;
    CGFloat labelH = viewH;
    
    CGFloat labelPadding = labelW + colonW;
//    self.dayLabel.frame = CGRectMake(0, 0, labelW, labelH);
    self.hourLabel.frame = CGRectMake(0, 0, labelW, labelH);
    self.minuesLabel.frame = CGRectMake(1 * labelPadding, 0, labelW, labelH);
    self.secondsLabel.frame = CGRectMake(2 * labelPadding, 0, labelW, labelH);
    
    [self setCornerRadius:self.hourLabel];
    [self setCornerRadius:self.minuesLabel];
    [self setCornerRadius:self.secondsLabel];

    for (NSInteger index = 0; index < self.separateLabelArrM.count ; index ++) {
        UILabel *separateLabel = self.separateLabelArrM[index];
        separateLabel.frame = CGRectMake(colonW * index + labelW * (index + 1), -2, colonW, labelH);
    }
}

#pragma mark - setter & getter

- (NSMutableArray *)timeLabelArrM{
    if (_timeLabelArrM == nil) {
        _timeLabelArrM = [[NSMutableArray alloc] init];
    }
    return _timeLabelArrM;
}

- (NSMutableArray *)separateLabelArrM{
    if (_separateLabelArrM == nil) {
        _separateLabelArrM = [[NSMutableArray alloc] init];
    }
    return _separateLabelArrM;
}

- (UILabel *)dayLabel{
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        [_dayLabel setTextColor:[UIColor whiteColor]];
        [_dayLabel setBackgroundColor:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1]];
        
        _dayLabel.font = [UIFont systemFontOfSize:11];
        
    }
    return _dayLabel;
}

- (UILabel *)hourLabel{
    if (_hourLabel == nil) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        [_hourLabel setTextColor:[UIColor whiteColor]];
        [_hourLabel setBackgroundColor:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1]];
//        [_hourLabel setTextColor:[UIColor colorWithRed:185/255.0 green:187/255.0 blue:193/255.0 alpha:1]];

        _hourLabel.font = [UIFont systemFontOfSize:11];


    }
    return _hourLabel;
}

- (UILabel *)minuesLabel{
    if (_minuesLabel == nil) {
        _minuesLabel = [[UILabel alloc] init];
        _minuesLabel.textAlignment = NSTextAlignmentCenter;
        [_minuesLabel setTextColor:[UIColor whiteColor]];

        [_minuesLabel setBackgroundColor:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1]];
//        [_minuesLabel setTextColor:[UIColor colorWithRed:185/255.0 green:187/255.0 blue:193/255.0 alpha:1]];

        
        _minuesLabel.font = [UIFont systemFontOfSize:11];

    }
    return _minuesLabel;
}

- (UILabel *)secondsLabel{
    if (_secondsLabel == nil) {
        _secondsLabel = [[UILabel alloc] init];
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
        [_secondsLabel setTextColor:[UIColor whiteColor]];

        [_secondsLabel setBackgroundColor:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1]];
//        [_secondsLabel setTextColor:[UIColor colorWithRed:185/255.0 green:187/255.0 blue:193/255.0 alpha:1]];
        
        _secondsLabel.font = [UIFont systemFontOfSize:11];


    }
    return _secondsLabel;
}

- (void)setCornerRadius:(UIView *)view {
    view.layer.cornerRadius = view.bounds.size.width/10;
    
    view.layer.borderWidth = 0.0;
    view.layer.masksToBounds = YES;
}

@end
