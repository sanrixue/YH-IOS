//
//  UIScrollView+Size.m
//  utils+category
//
//  Created by mutouren on 7/22/16.
//  Copyright © 2016 mutouren. All rights reserved.
//

#import "UIScrollView+Size.h"

@implementation UIScrollView (Size)

- (void)setContentOffsetX:(CGFloat)contentOffsetX{
    CGPoint newContentOffset = self.contentOffset;
    newContentOffset.x = contentOffsetX;
    self.contentOffset = newContentOffset;
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY{
    CGPoint newContentOffset = self.contentOffset;
    newContentOffset.y = contentOffsetY;
    self.contentOffset = newContentOffset;
}

- (CGFloat)contentOffsetX{
    return self.contentOffset.x;
}

- (CGFloat)contentOffsetY{
    return self.contentOffset.y;
}


- (void)setContentHeight:(CGFloat)contentHeight{
    CGSize size = self.contentSize;
    size.height = contentHeight;
    self.contentSize = size;
}

- (void)setContentWidth:(CGFloat)contentWidth{
    CGSize size = self.contentSize;
    size.width = contentWidth;
    self.contentSize = size;
}

- (CGFloat)contentHeight{
    return self.contentSize.height;
}

- (CGFloat)contentWidth{
    return self.contentSize.width;
}

- (CGFloat)contentInsetTop{
    return self.contentInset.top;
}
- (void)setContentInsetTop:(CGFloat)top{
    UIEdgeInsets insets = self.contentInset;
    insets.top = top;
    self.contentInset = insets;
}

- (CGFloat)contentInsetBottom{
    return self.contentInset.bottom;
}
- (void)setContentInsetBottom:(CGFloat)bottom{
    UIEdgeInsets insets = self.contentInset;
    insets.bottom = bottom;
    self.contentInset = insets;
}

- (CGFloat)contentInsetLeft{
    return self.contentInset.left;
}
- (void)setContentInsetLeft:(CGFloat)left{
    UIEdgeInsets insets = self.contentInset;
    insets.left = left;
    self.contentInset = insets;
}

- (CGFloat)contentInsetRight{
    return self.contentInset.right;
}
- (void)setContentInsetRight:(CGFloat)right{
    UIEdgeInsets insets = self.contentInset;
    insets.right = right;
    self.contentInset = insets;
}

@end
