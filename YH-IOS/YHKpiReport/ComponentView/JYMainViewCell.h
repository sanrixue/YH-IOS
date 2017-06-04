//
//  JYMainViewCell.h
//  JYFreezeWindowView
//
//  Created by niko on 17/5/4.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "JYFreezeViewCell.h"


typedef NS_ENUM(NSInteger, JYMainViewCellStyle) {
    JYMainViewCellStyleDefault,
    JYMainViewCellStyleCustom
};

typedef NS_ENUM(NSInteger, JYMainViewCellSeparatorStyle) {
    JYMainViewCellSeparatorStyleSingleLine,
    JYMainViewCellSeparatorStyleNone
};

@interface JYMainViewCell : UIView


- (instancetype)initWithStyle:(JYMainViewCellStyle) style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (strong, nonatomic) NSString *title;
@property (readonly, assign, nonatomic) JYMainViewCellStyle style;
@property (assign, nonatomic) JYMainViewCellSeparatorStyle separatorStyle;
@property (assign, nonatomic) NSInteger rowNumber;
@property (assign, nonatomic) NSInteger sectionNumber;

@end
