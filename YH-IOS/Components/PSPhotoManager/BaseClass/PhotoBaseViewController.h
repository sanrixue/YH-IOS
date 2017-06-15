//
//  PhotoBaseViewController.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/8.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoManagerConfig.h"

@interface PhotoBaseViewController : UIViewController

- (void)configureUI;

- (void)buildingParams;

- (void)rightBarButton:(NSString *)title selector:(SEL)selector;

- (void)rightBarButtonWithImageName:(NSString *)imageName selector:(SEL)selector;

@end
