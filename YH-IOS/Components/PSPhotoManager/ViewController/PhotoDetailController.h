//
//  PhotoDetailController.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoBaseViewController.h"

@interface PhotoDetailController : PhotoBaseViewController

@property (nonatomic, strong) NSArray <ALAsset *>*dataArray;

@property (nonatomic, assign) NSInteger index;

@end
