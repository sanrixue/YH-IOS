//
//  PSMessageDialog.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/11.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PSMessageDialog.h"
#import "Masonry.h"

#ifndef kAppDelegate
#define kAppDelegate [[UIApplication sharedApplication] delegate]
#endif

#ifndef kScreenWidth 
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef kScreenHeight
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

static CGFloat const kFontSize = 17;
static CGFloat const kShowDuration = 2.f;

@interface PSMessageDialog ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation PSMessageDialog

#pragma mark -
#pragma mark - external methods
+ (void)showMessageDialog:(NSString *)msg {
    [[[PSMessageDialog alloc] init] showMessageDialog:msg];
}

+ (void)showMessageDialogWithBlackText:(NSString *)msg {
    [[[PSMessageDialog alloc] init] showMessageDialogWithBlackText:msg];
}

#pragma mark -
#pragma mark - privite methods
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundView.hidden = YES;
        self.label.hidden = YES;
        
        [[kAppDelegate window] addSubview:self.backgroundView];
        [[kAppDelegate window] addSubview:self.label];
        
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo([kAppDelegate window]);
            make.centerY.equalTo([kAppDelegate window]).offset(+20);
        }];
        
        [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.label);
            make.width.and.height.equalTo(self.label).offset(15);
        }];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"PSMessageDialog : %@", self);
}

- (void)showMessageDialog:(NSString *)msg {
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    self.label.textColor = [UIColor whiteColor];
    self.label.text = msg;
    
    [self bringSubviewToFront];
    [self show];
}

- (void)showMessageDialogWithBlackText:(NSString *)msg {
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    self.label.textColor = [UIColor blackColor];
    self.label.text = msg;
    
    [self bringSubviewToFront];
    [self show];
}

#pragma mark -
#pragma mark - show animation
- (void)show {
    self.backgroundView.hidden = NO;
    self.label.hidden = NO;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.backgroundView.alpha = 1;
        self.label.alpha = 1;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kShowDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5f animations:^{
            self.backgroundView.alpha = 0.f;
            self.label.alpha = 0.f;
        } completion:^(BOOL finished) {
            self.backgroundView.hidden = YES;
            self.label.hidden = YES;
            /// remove to nil
            [self.backgroundView removeFromSuperview];
            [self.label removeFromSuperview];
            self.backgroundView = nil;
            self.label = nil;
        }];
    });
}

- (void)bringSubviewToFront {
    [[kAppDelegate window] bringSubviewToFront:self.backgroundView];
    [[kAppDelegate window] bringSubviewToFront:self.label];
    
    self.backgroundView.alpha = 0;
    self.label.alpha = 0;
}

#pragma mark -
#pragma mark - basic attribute
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.clipsToBounds = YES;
        _backgroundView.layer.cornerRadius = 5.f;
    }
    return _backgroundView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:kFontSize];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = 1;
        _label.numberOfLines = 0;
        _label.preferredMaxLayoutWidth = kScreenWidth - 40;
    }
    return _label;
}

@end
