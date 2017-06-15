//
//  PhotoSelectButton.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoSelectButton;

typedef void (^PhotoSelectBlock) (PhotoSelectButton *selectButton, BOOL isSelected);

@interface PhotoSelectButton : UIButton

+ (instancetype)buidingSelectButton;

// 点击回调
- (void)handleSelectButtonClickWithBlock:(PhotoSelectBlock)block;

@end
