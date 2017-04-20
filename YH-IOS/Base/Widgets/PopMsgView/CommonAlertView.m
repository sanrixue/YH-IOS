//
//  CommonAlertView.m
//  ShenghuoJia
//
//  Created by Guava on 15/12/16.
//  Copyright © 2015年 YongHui. All rights reserved.
//

#import "CommonAlertView.h"
#import "UILabel+ContentSize.h"

@interface CommonAlertView ()

@property (assign, nonatomic) CGFloat topOfTitle;
@property (assign, nonatomic) CGFloat heightOfTitle;
@property (assign, nonatomic) CGFloat topOfMessage;
@property (assign, nonatomic) CGFloat heightOfMessage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintOfTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintOfTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintOfMessage;

@end

@implementation CommonAlertView

-(instancetype)init {
    return [CommonAlertView loadCommonAlertView];
}

-(void)showWithTitle:(NSString *) title
             message:(NSString *) message
                time:(NSTimeInterval) time
              inView:(UIView *) view
{
    self.titleLabel.text = title;
    self.messageLabel.text = message;
    CGFloat heightOfView = self.heightOfTitle + self.topOfMessage + self.heightOfMessage + 30;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH - 140, heightOfView);
    self.touchToDismiss = NO;
    self.heightConstraintOfTitle.constant = self.heightOfTitle;
    self.topConstraintOfTitle.constant = self.topOfTitle;
    self.topConstraintOfMessage.constant = self.topOfMessage;
//    [self.layer setCornerRadius:8];
    [self showInView:view];
    if([message length] >= 20 && time < 1) {
        time = 3;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(dismiss)
                                   userInfo:nil
                                    repeats:NO];
    
}

+(CommonAlertView*)loadCommonAlertView{
    CommonAlertView *hud = [[[NSBundle mainBundle] loadNibNamed:@"CommonAlertView" owner:self options:nil] firstObject];
    return hud;
}

-(CGFloat)topOfTitle {
    return [NSString isEmptyOrWhitespace:self.titleLabel.text] ? 0 : 10;
}
-(CGFloat)heightOfTitle {
    return [NSString isEmptyOrWhitespace:self.titleLabel.text] ? 0 : 21;
}
-(CGFloat)topOfMessage {
    return [NSString isEmptyOrWhitespace:self.messageLabel.text] ? 0 : 10;
}
-(CGFloat)heightOfMessage {
        return [NSString isEmptyOrWhitespace:self.messageLabel.text] ? 0 : [self heightOfMessageLabelWithContent:self.messageLabel.text];
}

-(CGFloat)heightOfMessageLabelWithContent:(NSString *)messageString {
    UILabel *label = self.messageLabel;
    self.messageLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 146, 0);
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = messageString;
    return label.contentHeight;
    
}
@end
