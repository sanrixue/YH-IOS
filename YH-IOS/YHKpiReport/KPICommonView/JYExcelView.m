//
//  JYExcelView.m
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYExcelView.h"
#import "JYFreezeWindowView.h"


@interface JYExcelView () <JYFreezeWindowViewDelegate, JYFreezeWindowViewDataSource>

@end

@implementation JYExcelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubView];
    }
    return self;
}

- (void)dealloc {
    
}

- (void)initializeSubView {
    
    JYFreezeWindowView *freezeView = [[JYFreezeWindowView alloc] initWithFrame:self.bounds FreezePoint:CGPointMake(54, 30) cellViewSize:CGSizeMake(100, 44)];
    freezeView.delegate = self;
    freezeView.dataSource = self;
    [freezeView setSignViewWithContent:@"冻结"];
    freezeView.bounceStyle = JYFreezeWindowViewBounceStyleMain;
    [self addSubview:freezeView];
}


#pragma mark - <JYFreezeWindowViewDataSource>
- (NSInteger)numberOfSectionsInFreezeWindowView:(JYFreezeWindowView *)freezeWindowView {
    return 100;
}

- (NSInteger)numberOfRowsInFreezeWindowView:(JYFreezeWindowView *)freezeWindowView {
    return 100;
}
// mianCell
- (JYMainViewCell *)freezeWindowView:(JYFreezeWindowView *)freezeWindowView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"mainCell";
    JYMainViewCell *cell = [freezeWindowView dequeueReusableMainCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[JYMainViewCell alloc] initWithStyle:JYMainViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.title = [NSString stringWithFormat:@"%zi %zi", indexPath.section, indexPath.row];
    return cell;
    
}

- (JYSectionViewCell *)freezeWindowView:(JYFreezeWindowView *)freezeWindowView cellAtSection:(NSInteger)section {
    static NSString *cellID = @"sectionCell";
    
    JYSectionViewCell *cell = [freezeWindowView  dequeueReusableSectionCellWithIdentifier:cellID forSection:section];
    
    if (!cell) {
        cell = [[JYSectionViewCell alloc] initWithStyle:JYSectionViewCellStyleDefault reuseIdentifier:cellID];
        [cell setClickedActive:^(NSString *title) {
            // 做排序处理
            NSLog(@"重新排列 %@", title);
        }];
    }
    cell.title = [NSString stringWithFormat:@"%zi", section];
    return cell;
}

- (JYRowViewCell *)freezeWindowView:(JYFreezeWindowView *)freezeWindowView cellAtRow:(NSInteger)row {
    static NSString *cellID = @"rowCell";
    JYRowViewCell *cell = [freezeWindowView dequeueReusableRowCellWithIdentifier:cellID forRow:row];
    if (!cell) {
        cell = [[JYRowViewCell alloc] initWithStyle:JYFreezeViewCellStyleDefault reuseIdentifier:cellID];
        [cell setClickedActive:^(NSString *title) {
            // 显示完整名称
            NSLog(@"显示 %@", title);
        }];
    }
    
    cell.title = [NSString stringWithFormat:@"%zi", row];
    return cell;
}


#pragma mark - <JYFreezeWindowViewDelegate>
- (void)freezeWindowView:(JYFreezeWindowView *)freezeWindowView didSelectIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", [NSString stringWithFormat:@"did seleced at section %zi row %zi", indexPath.section, indexPath.row]);
}


@end
