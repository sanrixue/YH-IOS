//
//  UserHeadView.m
//  YH-IOS
//
//  Created by li hao on 16/9/2.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "UserHeadView.h"

@implementation UserHeadView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubview];
    }
    return self;
}


- (void)initWithSubview {
    
    UIImageView  *backImage = [[UIImageView alloc]initWithFrame:self.frame];
    backImage.backgroundColor = [UIColor redColor];
    [self addSubview:backImage];
    self.userIcon = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 40, 40, 80, 80)];
    self.userIcon.layer.cornerRadius = 40;
    [backImage addSubview:self.userIcon];
    
    self.userName  = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 40,CGRectGetMaxY(self.userIcon.frame)+10,80,40)];
    self.userName.backgroundColor = [UIColor clearColor];
    [backImage addSubview:self.userName];
    
    self.userRole = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userName.frame), self.frame.size.width, 30)];
    self.userRole.textAlignment = NSTextAlignmentCenter;
    [backImage addSubview:self.userName];

}

@end
