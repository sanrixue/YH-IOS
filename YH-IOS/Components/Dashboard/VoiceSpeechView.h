//
//  VoiceSpeechView.h
//  YH-IOS
//
//  Created by li hao on 16/11/3.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VoiceSpeechView;

@protocol YHVoiceSpeechViewDelegate

- (void)voiceSpeechBtnClick:(VoiceSpeechView *)voiceView;
- (void)cancelSpeechView:(VoiceSpeechView *)voiceView;
@end

@interface VoiceSpeechView : UIView

@property(strong,nonatomic) UIButton *startBtn;
@property(strong,nonatomic) UIProgressView *progressView;
@property(strong,nonatomic) UIButton *cancelBtn;
@property(strong,nonatomic) UITextView *messageView;
@property(weak, nonatomic) id<YHVoiceSpeechViewDelegate> delegate;

@end
