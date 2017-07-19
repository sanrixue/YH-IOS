//
//  JYFreezeWindowView.h
//  JYFreezeWindowView
//
//  Created by niko on 17/5/3.
//  Copyright © 2015年 YMS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYMainViewCell.h"
#import "JYSectionViewCell.h"
#import "JYRowViewCell.h"
#import "JYSignView.h"

@protocol JYFreezeWindowViewDataSource;
@protocol JYFreezeWindowViewDelegate;

typedef NS_ENUM(NSInteger, JYFreezeWindowViewStyle) {
    JYFreezeWindowViewStyleDefault,
    JYFreezeWindowViewStyleRowOnLine      //the row section view on line
};

typedef NS_ENUM(NSInteger, JYFreezeWindowViewBounceStyle) {
    JYFreezeWindowViewBounceStyleNone,
    JYFreezeWindowViewBounceStyleMain,
    JYFreezeWindowViewBounceStyleAll
};

@interface JYFreezeWindowView : UIView

- (instancetype)initWithFrame:(CGRect)frame FreezePoint: (CGPoint) freezePoint cellViewSize: (CGSize) cellViewSize;

- (void)setSignViewWithContent:(NSString *)content;

- (JYMainViewCell *)dequeueReusableMainCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (JYSectionViewCell *)dequeueReusableSectionCellWithIdentifier:(NSString *)identifier forSection:(NSInteger)section;
- (JYRowViewCell *)dequeueReusableRowCellWithIdentifier:(NSString *)identifier forRow:(NSInteger)row;

- (void)setSignViewBackgroundColor:(UIColor *)color;
- (void)setMainViewBackgroundColor:(UIColor *)color;
- (void)setSectionViewBackgroundColor:(UIColor *)color;
- (void)setRowViewBackgroundColor:(UIColor *)color;

- (void)reloadData;

- (UIScrollView *)mainView;
- (UIScrollView *)sectionView;
- (UIScrollView *)rowView;
- (JYSignView *) signView;

@property (weak, nonatomic) id<JYFreezeWindowViewDataSource> dataSource;
@property (weak, nonatomic) id<JYFreezeWindowViewDelegate> delegate;
@property (assign, nonatomic) JYFreezeWindowViewStyle style;
@property (assign, nonatomic) JYFreezeWindowViewBounceStyle bounceStyle;
@property (nonatomic, getter=isTapToTop) BOOL tapToTop;
@property (nonatomic, getter=isTapToLeft) BOOL tapToLeft;
@property (nonatomic) BOOL showsHorizontalScrollIndicator;
@property (nonatomic) BOOL showsVerticalScrollIndicator;
@property (strong, nonatomic) NSIndexPath *keyIndexPath;
@property (nonatomic) BOOL autoHorizontalAligning;
@property (nonatomic) BOOL autoVerticalAligning;
@property (nonatomic, assign) BOOL flexibleHeight;

@end

@protocol JYFreezeWindowViewDataSource <NSObject>

@required

- (JYMainViewCell *)freezeWindowView:(JYFreezeWindowView *)freezeWindowView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (JYSectionViewCell *)freezeWindowView:(JYFreezeWindowView *)freezeWindowView cellAtSection:(NSInteger)section;

- (JYRowViewCell *)freezeWindowView:(JYFreezeWindowView *)freezeWindowView cellAtRow:(NSInteger)row;

- (NSInteger)numberOfSectionsInFreezeWindowView:(JYFreezeWindowView *)freezeWindowView;

- (NSInteger)numberOfRowsInFreezeWindowView:(JYFreezeWindowView *)freezeWindowView;

@optional

// - (JYSignView *)signViewInFreezeWindowView:(JYFreezeWindowView *)freezeWindowView;

@end

@protocol JYFreezeWindowViewDelegate <NSObject>

@optional
// Called after the user changes the selection.
- (void)freezeWindowView:(JYFreezeWindowView *)freezeWindowView didSelectMainZoneIndexPath:(NSIndexPath *)indexPath;
// 首列纵向点击
- (void)freezeWindowView:(JYFreezeWindowView *)freezeWindowView didSelectRowZoneIndexPath:(NSIndexPath *)indexPath;

// Called when you set the key indexPath.
- (JYSectionViewCell *)sectionCellPointInfreezeWindowView:(JYFreezeWindowView *)freezeWindowView;
// Called after the cell in a key indexPath.
- (void)sectionCellReachKey:(JYSectionViewCell *)sectionViewCell withSection:(NSInteger)section;
@end
