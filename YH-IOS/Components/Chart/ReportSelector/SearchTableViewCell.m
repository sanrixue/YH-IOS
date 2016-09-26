//
//  SearchTableViewCell.m
//  YH-IOS
//
//  Created by li hao on 16/9/26.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubview];
    }
    return self;
}

#pragma mark 初始化视图
- (void)initWithSubview {
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 50)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    [self.contentView addSubview:self.searchBar];
}


@end
