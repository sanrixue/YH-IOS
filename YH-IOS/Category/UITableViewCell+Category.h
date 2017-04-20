//
//  UITableViewCell+Category.h
//  Haitao
//
//  Created by cjg on 16/10/27.
//  Copyright © 2016年 YongHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Category)

/**提供初始化方法，只需传tableView和xib标识id，无需注册*/
+ (instancetype)cellWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifie;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                          needXib:(BOOL)need
                    andIdentifier:(NSString *)identifie;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                          needXib:(BOOL)need;

+ (CGFloat)heightForSelf;

+ (CGFloat)heightForItem:(id)item;

+ (CGFloat)heightForIndex:(NSIndexPath *)index;

- (void)setItem:(id)item;

@end
