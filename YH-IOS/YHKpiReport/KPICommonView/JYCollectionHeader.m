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
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, JYScreenWidth - JYDefaultMargin, CGRectGetHeight(self.frame))];
        _titleLab.text = _sectionTitle;
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = [UIFont systemFontOfSize:20];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}


@end
