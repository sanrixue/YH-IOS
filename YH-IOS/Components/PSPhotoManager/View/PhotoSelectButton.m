//
//  PhotoSelectButton.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoSelectButton.h"
#import "PhotoManagerConfig.h"

@interface PhotoSelectButton ()

@property (nonatomic, copy) PhotoSelectBlock block;

@end

@implementation PhotoSelectButton

+ (instancetype)buidingSelectButton {
    PhotoSelectButton *selectButton = [PhotoSelectButton buttonWithType:UIButtonTypeCustom];
    selectButton.selected = NO;
    selectButton.backgroundColor = [UIColor clearColor];
    return selectButton;
}

- (void)handleSelectButtonClickWithBlock:(PhotoSelectBlock)block {
    self.block = block;
    [self addTarget:self action:@selector(handleSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark - privite methods
- (void)handleSelectButtonAction:(PhotoSelectButton *)sender {
    self.selected = !self.isSelected;
    Block_exe(self.block, self, self.selected);
}

#pragma mark -
#pragma mark - setter methods
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage imageNamed:@"unSelect.png"] forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
