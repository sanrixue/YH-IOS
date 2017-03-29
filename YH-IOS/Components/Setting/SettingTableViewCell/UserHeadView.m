//
//  UserHeadView.m
//  YH-IOS
//
//  Created by li hao on 16/9/2.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "UserHeadView.h"
#import "User.h"
#import "HttpUtils.h"
#import "FileUtils.h"

@interface UserHeadView()
@property(nonatomic,strong)UIImage* userIconImage;
@property(nonatomic,strong)User* user;

@end

@implementation UserHeadView


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self initWithview];
    }
    return self;
}

- (void)initWithview {
    
    self.user = [[User alloc]init];
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.frame];
    backImage.backgroundColor = [UIColor grayColor];
    UIImage *backimage= [UIImage imageNamed:@"UserHead-Background"];
    UIImage *userHeadImage = [self handleImage:backimage withSize:CGSizeMake(mWIDTH, 150)];
    backImage.image = userHeadImage;
    backImage.contentMode = UIViewContentModeScaleToFill;
    backImage.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:1];
    backImage.userInteractionEnabled = YES;
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    backView.backgroundColor = [UIColor grayColor];
    backView.alpha = 0.2;
    [backImage addSubview:backView];
    [self addSubview:backImage];
    self.userIcon = [[UIButton alloc] initWithFrame:CGRectMake(mWIDTH / 2 - 30, 20, 60, 60)];
    self.userIcon.layer.cornerRadius = 30;
    self.userIcon.backgroundColor = [UIColor whiteColor];
    [self.userIcon addTarget:self action:@selector(uploadusericon:) forControlEvents:UIControlEventTouchUpInside];
    [self.userIcon.layer setMasksToBounds:YES];
    [self addSubview:self.userIcon];
    self.userName  = [[UILabel alloc] initWithFrame:CGRectMake(mWIDTH / 2 - 40,CGRectGetMaxY(self.userIcon.frame) + 10,80,20)];
    self.userName.textColor = [UIColor whiteColor];
    self.userName.adjustsFontSizeToFitWidth = YES;
    self.userName.text = [NSString stringWithFormat:@"%@(%@)", _user.userName, _user.userID];
    [self addSubview:self.userName];
    
    self.userRole = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.userName.frame) + 5,mWIDTH - 20 , 20)];
    self.userRole.textAlignment = NSTextAlignmentCenter;
    self.userRole.textColor = [UIColor whiteColor];
    self.userRole.font = [UIFont systemFontOfSize:12];
    self.userRole.adjustsFontSizeToFitWidth = YES;
    self.userRole.text = [NSString stringWithFormat:@"%@ | %@", _user.roleName, _user.groupName];
    [self addSubview:self.userRole];
    
}

- (void)uploadusericon:(UIButton *)button {
  [_delegate usericonClick:button];
}

- (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size {
    CGSize originalsize = [originalImage size];
    if (originalsize.width<size.width && originalsize.height<size.height) {
        return originalImage;
    }
    else if(originalsize.width>size.width && originalsize.height>size.height) {
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;
        rate = widthRate>heightRate?heightRate:widthRate;
        CGImageRef imageRef = nil;
        if (heightRate>widthRate) {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));
        }
        else {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));
        }
        UIGraphicsBeginImageContext(size);
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        return standardImage;
    }
    else if(originalsize.height>size.height || originalsize.width>size.width) {
        CGImageRef imageRef = nil;
        if(originalsize.height>size.height) {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));
        }
        else if (originalsize.width>size.width) {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));
        }
        UIGraphicsBeginImageContext(size);
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        return standardImage;
    }
    else {
        return originalImage;
    }
}

@end
