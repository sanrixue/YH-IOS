//
//  GifRefreshHeader.h
//  JinXiaoEr
//
//  Created by CJG on 16/12/29.
//
//

#import <MJRefresh/MJRefresh.h>

@interface GifRefreshHeader : MJRefreshGifHeader

@property (nonatomic, strong) UIImageView* animationView;

+ (instancetype)instanceWithTarget:(id)target selector:(SEL)selector;

@end
