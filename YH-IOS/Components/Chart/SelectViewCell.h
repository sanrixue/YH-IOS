//
//  SelectViewCell.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/4.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *clickImage;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, assign) NSInteger depth;

-(instancetype )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDeth:(int) depth;
@end
