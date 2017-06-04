//
//  UIScrollView+Size.h
//  utils+category
//
//  Created by mutouren on 7/22/16.
//  Copyright © 2016 mutouren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Size)


@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, assign) CGFloat contentOffsetY;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentWidth;


@property (nonatomic, assign) CGFloat contentInsetTop;
@property (nonatomic, assign) CGFloat contentInsetBottom;
@property (nonatomic, assign) CGFloat contentInsetLeft;
@property (nonatomic, assign) CGFloat contentInsetRight;

@end
