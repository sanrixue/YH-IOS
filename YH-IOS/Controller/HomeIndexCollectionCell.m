//
//  HomeIndexCollectionCell.m
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "HomeIndexCollectionCell.h"
#import "HomeIndexCollectionCellContentView.h"

@interface HomeIndexCollectionCell ()
@property (nonatomic, strong) UIView* contentV;
@property (nonatomic, strong) NSMutableArray<HomeIndexCollectionCellContentView*>* contentArr;
@property (nonatomic, assign) NSInteger curIndex;
@end

@implementation HomeIndexCollectionCell

+ (CGSize)sizeForSelf{
    return CGSizeMake(SCREEN_WIDTH, 640.0/750.0*SCREEN_WIDTH);
}

- (NSMutableArray<HomeIndexCollectionCellContentView *> *)contentArr{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}

- (UIView *)contentV{
    if (!_contentV) {
        _contentV = [[UIView alloc] init];
        [_contentV setBorderColor:[AppColor app_9color] width:0.5];
    }
    return _contentV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.contentV];
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);//insets(UIEdgeInsetsMake(1, 1, 1, 1));
    }];
    
    CGSize size = CGSizeMake([HomeIndexCollectionCell sizeForSelf].width*0.5-0.5, [HomeIndexCollectionCell sizeForSelf].height/3.0-0.5);
    for (int i = 0; i<6; i++) {
        HomeIndexCollectionCellContentView *content = [HomeIndexCollectionCellContentView viewWithXibName:nil owner:nil];
        [self.contentV addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
            NSInteger topIndex = i/2;
            make.top.mas_equalTo(size.height*topIndex+0.5);
            make.left.mas_equalTo(i%2==0?0.5:size.width+0.5);
        }];
//        [content setBorderColor:[AppColor app_9color] width:0.25];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer*  _Nonnull sender) {
            if (self.indexBack) {
                NSInteger index = sender.view.tag-1+_curIndex*6;
                self.indexBack(@(index));
            }
        }];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer*  _Nonnull sender) {
            if (self.doubleIndexBack) {
                NSInteger index = sender.view.tag-1+_curIndex*6;
                self.doubleIndexBack(@(index));
            }
        }];
        [tap setNumberOfTapsRequired:1];
        [doubleTap setNumberOfTapsRequired:2];
        [content addGestureRecognizer:tap];
        [content addGestureRecognizer:doubleTap];
        [tap requireGestureRecognizerToFail:doubleTap];

        content.tag = i+1;
        [self.contentArr addObject:content];
    }
}

- (void)setWithIndex:(NSInteger)index items:(NSArray *)items{
    NSInteger a = items.count - index*6;
    _curIndex = index;
    for (HomeIndexCollectionCellContentView* view in self.contentArr) {
        view.hidden = view.tag>a;
        if (!view.hidden) {
            [view setWithHomeIndexItemModel:items[view.tag-1+index*6]];
        }
    }
}

@end
