//
//  UpdateVersionAlertView.m
//  Haitao
//
//  Created by Guava on 16/4/5.
//  Copyright © 2016年 YongHui. All rights reserved.
//

#import "Masonry.h"
#import "UpdateVersionAlertView.h"
#import "GUATool.h"


/*--- height without label: 111px ---*/

@interface UpdateVersionAlertView () {
    UIView  *_showFromView;
    UIControl *_overlayView;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *buttonContainedView;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet UILabel *updateTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBGViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@end

@implementation UpdateVersionAlertView
- (void)awakeFromNib {
    [self.updateTitleLabel setTextColor:[UIColor colorWithHexString:@"4c4c4c"]];
    [self.lineView setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
    [self.textView setTextColor:[UIColor colorWithHexString:@"252525"]];
    [self.textView setSelectable:NO];
    [self.textView setEditable:NO];
    [self.textView setTextContainerInset:UIEdgeInsetsMake(0, 8, 8, 0)];
//    [self.textView setBackgroundColor:[UIColor redColor]];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)setForceUpdate:(BOOL)forceUpdate {
    _forceUpdate = forceUpdate;
    if(forceUpdate) {
        self.refuseButton.hidden = YES;
        [self.lineView setHidden:YES];
        [self.updateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.buttonContainedView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}
- (IBAction)refuseAction:(id)sender {
    [self dismiss];
}

- (void)setContent:(NSString *)content {
//    NSMutableString *con = [content mutableCopy];
//    [con replaceOccurrencesOfString:@"/r" withString:@"\r\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [con length])];
//    _content = [con copy];
//    NSString *str =[content substringWithRange:NSMakeRange(3, content.length-8)];
    [self.textView setText:content];
    
    CGFloat h = [content boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.textView.frame), MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:self.textView.font}
                                    context:nil].size.height;
    h += 18.0f;
    if (h < self.textViewHeight.constant) {
        self.textViewHeight.constant = h;
//        [self.textView setScrollEnabled:NO];
    }
}

- (IBAction)updateAction:(id)sender {
//    self.updateUrl = @"itms-apps://itunes.apple.com/app/id1142964515";
    NSURL *url = [NSURL URLWithString:self.updateUrl];
    [[UIApplication sharedApplication] openURL:url];
    if(!self.forceUpdate) [self dismiss];
}

+ (CGFloat)calculateHeightOfViewWithContent:(NSString *)content {
    return [GUATool calculateLabelHeightWithWidth:280.0 contentText:content font:[UIFont systemFontOfSize:14]];
}

- (void)showInView:(UIView *)pView withOverlayView:(BOOL)overLay{
    _showFromView = pView;
    _overlayView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, pView.frame.size.width, pView.frame.size.height)];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    if (overLay) {
        [pView addSubview:_overlayView];
    }
    [pView addSubview:_overlayView];
    [pView addSubview:self];
    [pView bringSubviewToFront:self];
    
    self.center = CGPointMake(pView.bounds.size.width/2.0f,pView.bounds.size.height/2.0f);
    
    [self fadeIn];
}



- (void)dismiss {
    [super dismiss];
    [_overlayView removeFromSuperview];
}
@end
