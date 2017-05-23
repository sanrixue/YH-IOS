//
//  DropViewController.h
//  YH-IOS
//
//  Created by li hao on 16/9/14.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropViewController;

@protocol DropViewDataSource<NSObject>

- (NSInteger)numberOfPagesIndropView:(DropViewController *)flowView;
- (UITableViewCell *)dropView:(DropViewController *)flowView cellForPageAtIndex:(NSIndexPath*)index;

@end

@protocol DropViewDelegate <NSObject>

- (void)dropView:(DropViewController *)flowView didTapPageAtIndex:(NSIndexPath*)index;

@end

@interface DropViewController : UIViewController

@property (nonatomic,strong) UITableView *dropTableView;
@property(nonatomic,weak) id <DropViewDataSource> dataSource;
@property(nonatomic,weak) id <DropViewDelegate> delegate;

@end
