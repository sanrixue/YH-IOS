//
//  BaseNavigationController.h
//  Chart
//
//  Created by ice on 16/5/17.
//  Copyright © 2016年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated hideBottom:(BOOL)hide;

@end
