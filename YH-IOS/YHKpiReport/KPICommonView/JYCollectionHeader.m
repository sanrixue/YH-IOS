//
//  JYCollectionHeader.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYCollectionHeader.h"

@interface JYCollectionHeader ()

@property (nonatomic, strong) UILabel *titleLab;


@end

@implementation JYCollectionHeader


- (void)prepareForReuse {
    
    self.titleLab.text = self.sectionTitle;

}

- (void)setSectionTitle:(NSString *)sectionTitle {
    if (![_sectionTitle isEqualToString:sectionTitle]) {
        _sectionTitle = sectionTitle;
        self.titleLab.text = sectionTitle;
    }
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        UIImageView *greenImageLine = [[UIImageView alloc]initWithFrame:CGRectMake(6, 12, 4, self.frame.size.height-24)];
        greenImageLine.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
        greenImageLine.image = [[UIImage imageNamed:@"ic_green_line"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addSubview:greenImageLine];
        
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.frame)-2, JYScreenWidth, 1)];
        sepView.backgroundColor = [UIColor colorWithHexString:@"#d1d1d1"];
       // [self addSubview:sepView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(22, 6, JYScreenWidth - 22, CGRectGetHeight(self.frame)-12)];
        _titleLab.text = _sectionTitle;
        _titleLab.textColor = [UIColor colorWithHexString:@"#000"];
        _titleLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}


@end
