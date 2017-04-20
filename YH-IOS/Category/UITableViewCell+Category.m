//
//  UITableViewCell+Category.m
//  Haitao
//
//  Created by cjg on 16/10/27.
//  Copyright © 2016年 YongHui. All rights reserved.
//

#import "UITableViewCell+Category.h"

@implementation UITableViewCell (Category)

+ (instancetype)cellWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifie{
    if (!identifie) {
        identifie = NSStringFromClass(self);
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifie];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifie owner:nil options:nil] lastObject];
    }
    return cell;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView needXib:(BOOL)need andIdentifier:(NSString *)identifie{
    if (need) {
        return [self cellWithTableView:tableView andIdentifier:identifie];
    }else{
        if (!identifie) {
            identifie = NSStringFromClass(self);
        }
        id cell = [tableView dequeueReusableCellWithIdentifier:identifie];
        if (!cell) {
            cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifie];
        }
        return cell;

    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView needXib:(BOOL)need{
    return [self cellWithTableView:tableView needXib:need andIdentifier:nil];
}

+ (CGFloat)heightForSelf{
    return 0.0;
}

+ (CGFloat)heightForItem:(id)item{
    return 0.0;
}

+ (CGFloat)heightForIndex:(NSIndexPath *)index{
    return 0.0;
}

- (void)setItem:(id)item{
    
}

@end
