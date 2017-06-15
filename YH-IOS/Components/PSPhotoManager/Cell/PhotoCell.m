//
//  PhotoCell.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoCell.h"
#import "PhotoManagerConfig.h"
#import "PhotoSelectButton.h"
#import "PhotoCollectionViewController.h"

@interface PhotoCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PhotoSelectButton *selectButton;
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) PhotoSelectedIndexBlock selectedBlock;

@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        [self buildingUI];
        [self layoutUI];
    }
    return self;
}

- (void)buildingUI {
    self.imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.backgroundColor = kPlaceholderImageColor;
    [self addSubview:_imageView];
    
    self.selectButton = [PhotoSelectButton buidingSelectButton];
    [self addSubview:_selectButton];
    
    WeakSelf(self)
    [_selectButton handleSelectButtonClickWithBlock:^(PhotoSelectButton *selectButton, BOOL isSelected) {
        if ([PhotoSelectManager selectedAssets].count >= [PhotoSelectManager maxSelectedCount]) {
            [PSMessageDialog showMessageDialog:@"您选择的图片数量已达到上限"];
            selectButton.selected = NO;
            return;
        }
        if (isSelected) {
            [PhotoSelectManager addAsset:weakSelf.asset];
            [ScaleAnimation addScaleAnimation:weakSelf.selectButton];
            Block_exe(weakSelf.selectedBlock, weakSelf.index);
        } else {
            [PhotoSelectManager removeAsset:weakSelf.asset];
        }
    }];
}

- (void)layoutUI {
    WeakSelf(self)
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(weakSelf);
    }];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.right.equalTo(weakSelf.mas_right).offset(-2);
        make.top.equalTo(weakSelf.mas_top).offset(2);
    }];
}

- (void)reloadDataWithAsset:(ALAsset *)asset index:(NSInteger)index {
    self.index = index;
    self.asset = asset;
    UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
    self.imageView.image = image;
}

- (void)getPhotoSelectedIndexWithBlock:(PhotoSelectedIndexBlock)block {
    self.selectedBlock = block;
}

- (void)resetSelected:(BOOL)selected {
    self.selectButton.selected = selected;
}

@end
