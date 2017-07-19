//
//  JYSectionViewCell.h
//  JYFreezeWindowView
//
//  Created by niko on 17/5/4.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "JYFreezeViewCell.h"

typedef NS_ENUM(NSInteger, JYSectionViewCellStyle) {
    JYSectionViewCellStyleDefault,
    JYSectionViewCellStyleCustom
};

typedef NS_ENUM(NSInteger, JYSectionViewCellSeparatorStyle) {
    JYSectionViewCellSeparatorStyleSingleLine,
    JYSectionViewCellSeparatorStyleNone
};

@interface JYSectionViewCell : UIView

- (instancetype)initWithStyle:(JYSectionViewCellStyle) style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (readonly, assign, nonatomic) JYSectionViewCellStyle style;
@property (assign, nonatomic) JYSectionViewCellSeparatorStyle separatorStyle;
@property (strong, nonatomic) NSString *title;


- (void)rotationCellSortIcon:(CGFloat)angle;
- (void)setClickedActive:(void(^)(NSString *title, BOOL isSelect))selectedActive;

@end
