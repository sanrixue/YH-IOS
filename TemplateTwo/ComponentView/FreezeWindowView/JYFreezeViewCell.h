//
//  JYFreezeViewCell.h
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JYFreezeViewCellStyle) {
    JYFreezeViewCellStyleDefault,
    JYFreezeViewCellStyleCustom
};

typedef NS_ENUM(NSInteger, JYRowViewCellSeparatorStyle) {
    JYFreezeViewCellSeparatorStyleSingleLine,
    JYFreezeViewCellSeparatorStyleNone
};


@interface JYFreezeViewCell : UIView


- (instancetype)initWithStyle:(JYFreezeViewCellStyle) style reuseIdentifier:(NSString *)reuseIdentifier;


@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (strong, nonatomic) NSString *title;
@property (readonly, assign, nonatomic) JYFreezeViewCellStyle style;
@property (assign, nonatomic) JYRowViewCellSeparatorStyle separatorStyle;
@property (nonatomic, assign) BOOL showFlagPoint;

- (void)setClickedActive:(void(^)(NSString *title))selectedActive;



@end
