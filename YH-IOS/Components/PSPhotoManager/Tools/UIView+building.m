//
//  UIView+building.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/8.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "UIView+building.h"

@implementation UIView (building)

UILabel *building_label(NSInteger numberOfLines, UIColor *textColor, NSTextAlignment textAligment, UIFont *font) {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = numberOfLines;
    label.textColor = textColor;
    label.textAlignment = textAligment;
    label.font = font;
    return label;
}

@end
