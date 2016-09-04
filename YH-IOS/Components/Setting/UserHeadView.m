//
//  UserHeadView.m
//  YH-IOS
//
//  Created by li hao on 16/9/2.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "UserHeadView.h"

@implementation UserHeadView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubview];
    }
    return self;
}

- (void)initWithSubview {
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, mWIDTH, 150)];
    //backImage.backgroundColor = [UIColor grayColor];
    backImage.image = [UIImage imageNamed:@"Setting-Background"];
   // backImage.contentMode = UIViewContentModeScaleToFill;
    backImage.alpha = 0.5;
    backImage.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:0.5];
    backImage.userInteractionEnabled = YES;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake( self.frame.origin.x,self.frame.origin.y,mWIDTH,150)];
    backView.backgroundColor = [UIColor clearColor];
    [backImage addSubview:backView];
    [self.contentView addSubview:backImage];
    self.userIcon = [[UIButton alloc] initWithFrame:CGRectMake(mWIDTH / 2 - 30, 20, 60, 60)];
    self.userIcon.layer.cornerRadius = 30;
    self.userIcon.backgroundColor = [UIColor whiteColor];
    [self.userIcon.layer setMasksToBounds:YES];
    [backView addSubview:self.userIcon];
    
    self.userName  = [[UILabel alloc] initWithFrame:CGRectMake(mWIDTH / 2 - 40,CGRectGetMaxY(self.userIcon.frame) + 10,80,20)];
    self.userName.textColor = [UIColor whiteColor];
    self.userName.adjustsFontSizeToFitWidth = YES;
    [backView addSubview:self.userName];
    
    self.userRole = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.userName.frame) + 5,mWIDTH - 20 , 20)];
    self.userRole.textAlignment = NSTextAlignmentCenter;
    self.userRole.textColor = [UIColor whiteColor];
    self.userRole.font = [UIFont systemFontOfSize:12];
    self.userRole.adjustsFontSizeToFitWidth = YES;
    [backView addSubview:self.userRole];
}

@end
