//
//  PhotoGroupCell.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/8.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoGroupCell : UITableViewCell

/** 设置cell的显示数据
 * @param image: 缩略图
 * @param groupName: group名称
 * @param photoNumber: 本组图片数量
 */
- (void)reloadDataWithImage:(UIImage *)image groupName:(NSString *)groupName photoNumber:(NSInteger)photoNumber;

// cell 高度
+ (CGFloat)height;

@end
