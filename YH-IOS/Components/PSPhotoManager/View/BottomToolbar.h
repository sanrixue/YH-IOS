//
//  BottomToolbar.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ToolbarActionBlock) ();

@interface BottomToolbar : UIToolbar

// reset UI style
- (void)resetPreviewButtonEnable:(BOOL)enable;

- (void)resetFinishedButtonEnable:(BOOL)enable;

- (void)resetSelectPhotosNumber:(NSInteger)number;

// handle click callback
- (void)handlePreviewButtonWithBlock:(ToolbarActionBlock)block;

- (void)handleFinishedButtonWithBlock:(ToolbarActionBlock)block;

// hidden preview button
- (void)hiddenPreviewButton;

@end
