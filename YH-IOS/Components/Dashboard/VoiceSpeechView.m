//
//  VoiceSpeechView.m
//  YH-IOS
//
//  Created by li hao on 16/11/3.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "VoiceSpeechView.h"

@implementation VoiceSpeechView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self laySubView];
    }
    return self;
}

- (void)laySubView {
    self.backgroundColor = [UIColor lightGrayColor];
    self.startBtn = [[UIButton alloc]init];
    self.startBtn.frame = CGRectMake(10, 10, 20, 20);
    self.startBtn.layer.cornerRadius = 10;
    self.startBtn.backgroundColor = [UIColor redColor];
    [self.startBtn addTarget:self action:@selector(voiceStart) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.startBtn];
    
    self.progressView = [[UIProgressView alloc]init];
    self.progressView.frame = CGRectMake(40, 27, self.frame.size.width - 80, 10);
    self.progressView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.progressView];
    self.progressView.trackTintColor = [UIColor blueColor];
    self.progressView.progressTintColor = [UIColor yellowColor];
    [self.progressView setProgressViewStyle:UIProgressViewStyleDefault];
    
    self.cancelBtn = [[UIButton alloc]init];
    self.cancelBtn.frame = CGRectMake(self.frame.size.width - 30, 10, 20, 20);
    self.cancelBtn.backgroundColor = [UIColor greenColor];
    [self.cancelBtn addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    self.messageView = [[UITextView alloc]init];
    self.messageView.text = @"正在播报";
    self.messageView.frame = CGRectMake(40, 0, self.frame.size.width - 80, 25);
    self.messageView.textAlignment = NSTextAlignmentCenter;
    self.messageView.backgroundColor = [UIColor clearColor];
    self.messageView.textColor = [UIColor blueColor];
    self.messageView.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.messageView];
}


- (void)voiceStart {
    [self.delegate voiceSpeechBtnClick:self];
}

- (void)cancelView {
    [self.delegate cancelSpeechView:self];
}


@end
