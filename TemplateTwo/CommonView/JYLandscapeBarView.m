//
//  JYLandscapeBarView.m
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYLandscapeBarView.h"
#import "JYLandscapeBar.h"
#import "JYInvertButton.h"
#import "JYBlockButton.h"
#import "JYBargraphModel.h"
#import "JYHudView.h"

@interface JYLandscapeBarView () <JYLandscapeBarDelegate> {
    UIView *titleView;
    NSArray <UIButton *> *proNameList;
    NSArray <UILabel *> *ratioList;
    
    JYInvertButton *inverBtnFirst;
    JYInvertButton *inverBtnSecond;
}


@property (nonatomic, strong) JYLandscapeBar *landscapeBar;
@property (nonatomic, strong) JYBargraphModel *bargraphModel;

@end

@implementation JYLandscapeBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubVeiw];
    }
    return self;
}

- (JYLandscapeBar *)landscapeBar {
    if (!_landscapeBar) {
        _landscapeBar = [[JYLandscapeBar alloc] initWithFrame:CGRectMake(JYViewWidth / 2.0 + 20, CGRectGetMaxY(titleView.frame), JYViewWidth / 2.0-20, JYViewHeight)];
        _landscapeBar.delegate = self;
        [self addSubview:_landscapeBar];
    }
    return _landscapeBar;
}

- (JYBargraphModel *)bargraphModel {
    if (!_bargraphModel) {
        _bargraphModel = (JYBargraphModel *)self.moduleModel;
    }
    return _bargraphModel;
}

- (void)initializeSubVeiw {
    
    [self initializeTitle];
    //[self initializeAxis];
}

- (void)initializeTitle {
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JYViewWidth, 40)];
    [self addSubview:titleView];
    
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < 2; i++) {
        JYInvertButton *inverBtn = [[JYInvertButton alloc] initWithFrame:CGRectMake(JYViewWidth / 3.0 * i, 0, JYViewWidth / 3.0 / (i + 1), 40)];
        //inverBtn.typeName = @[self.bargraphModel.xAxisName, self.bargraphModel.seriesName][i];
        inverBtn.tag = -2000 + i;
        [inverBtn setInverHandler:^(NSString *type, BOOL isSelected) {
            [weakSelf invertActionWithType:type selected:isSelected];
        }];
        [titleView addSubview:inverBtn];
        
        if (i == 0) {
            inverBtnFirst = inverBtn;
        }
        else if (i == 1) {
            inverBtnSecond = inverBtn;
        }
    }
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), JYViewWidth, 0.5)];
    sepLine.backgroundColor = JYColor_TextColor_Chief;
    [titleView addSubview:sepLine];
    
}

- (void)initializeAxis {
    
    [[self viewWithTag:-3000] removeFromSuperview];
    UIView *proInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.landscapeBar.frame), JYViewWidth / 2.0+20, CGRectGetHeight(self.landscapeBar.frame))];
    proInfoView.tag = -3000;
    [self addSubview:proInfoView];
    
    NSMutableArray *nameList = [NSMutableArray arrayWithCapacity:self.bargraphModel.xAxisData.count];
    NSMutableArray *rList = [NSMutableArray arrayWithCapacity:self.bargraphModel.seriesData.count];
    for (NSInteger i = 0; i < self.bargraphModel.seriesData.count; i++) {
        
        UIImageView *IV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_greenarrow"]];
        IV.frame = CGRectMake(-JYDefaultMargin, 0, 10, 10);
        [proInfoView addSubview:IV];
        CGPoint center = IV.center;
        center.y = CGPointFromString(self.landscapeBar.pionts[i]).y;
        IV.center = center;
        IV.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
        
        UIButton *proName = [UIButton buttonWithType:UIButtonTypeCustom];
        proName.frame = CGRectMake(CGRectGetMaxX(IV.frame) + JYDefaultMargin / 2.0, 0, CGRectGetWidth(proInfoView.frame) - 35 - 10, kBarHeight);
        [proName addTarget:self action:@selector(clickNameActive:) forControlEvents:UIControlEventTouchUpInside];
        proName.tag = -10000 + i;
        [proName setTitle:self.bargraphModel.xAxisData[i] forState:UIControlStateNormal];
        [proName setTitleColor:JYColor_TextColor_Chief forState:UIControlStateNormal];
        proName.titleLabel.font = [UIFont systemFontOfSize:13];
        proName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        proName.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [proInfoView addSubview:proName];
        
        center = proName.center;
        center.y = CGPointFromString(self.landscapeBar.pionts[i]).y;
        proName.center = center;
        proName.userInteractionEnabled = NO;
        CGSize size = [proName.currentTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(proName.frame)) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : proName.titleLabel.font} context:nil].size;
        if (size.width > CGRectGetWidth(proName.frame)) {
            proName.userInteractionEnabled = YES;
            [proName setTitleColor:JYColor_LineColor_LightBlue forState:UIControlStateNormal];
        }
        
        UILabel *ratio = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(proName.frame), CGRectGetMinY(proName.frame), 35, kBarHeight)];
        ratio.text = self.bargraphModel.seriesData[i];
        ratio.textAlignment = NSTextAlignmentRight;
        ratio.textColor = JYColor_TextColor_Chief;
        ratio.font = [UIFont systemFontOfSize:12];
        [proInfoView addSubview:ratio];
        
        [nameList addObject:proName];
        [rList addObject:ratio];
    }
    
    proNameList = [nameList copy];
    ratioList = [rList copy];
}

- (void)clickNameActive:(UIButton *)sender {
    NSInteger i = sender.tag + 10000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoBaseView:didSelectedAtIndex:data:)]) {
        [self.delegate moduleTwoBaseView:self didSelectedAtIndex:i data:self.bargraphModel.xAxisData[i]];
    }
    
    [JYHudView showHUDWithTitle:self.bargraphModel.xAxisData[i]];
    
}

- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    return  20;//[self.landscapeBar estimateViewHeight:model] + CGRectGetHeight(titleView.frame);
}

- (void)refreshSubViewData {
    self.landscapeBar.model = self.bargraphModel;
    
    for (int i = 0; proNameList.count; i++) {
        [proNameList[i] setTitle:self.bargraphModel.xAxisData[i] forState:UIControlStateNormal];
        ratioList[i].text = self.bargraphModel.seriesData[i];
    }
    
    inverBtnFirst.typeName = self.bargraphModel.xAxisName;
    inverBtnSecond.typeName = self.bargraphModel.seriesName;
}

#pragma mark - <JYLandscapeBarDelegate>
- (void)landscapeBar:(JYLandscapeBar *)bar refreshHeight:(CGFloat)height {
    // bar 布局完成后悔自动更新frame
    CGRect frame = self.frame;
    frame.size.height = CGRectGetHeight(self.landscapeBar.frame) + CGRectGetHeight(titleView.frame);
    self.frame = frame;
    [self initializeAxis];
}

- (void)invertActionWithType:(NSString *)type selected:(BOOL)isSelected{
    // 有一个在进行排序，另外一个就不排序
    for (UIView *view in titleView.subviews) {
        if ([view isKindOfClass:[JYInvertButton class]]) {
            JYInvertButton *inverBtn = (JYInvertButton *)view;
            if ([inverBtn.typeName isEqualToString:type]) continue;
            [inverBtn recoverIconTransform];
        }
    }
    //NSLog(@"TODO：排序 %@", type);
    if ([type isEqualToString:self.bargraphModel.seriesName]) {
        if (isSelected) {
            [self.bargraphModel sortedSeriesList:JYBargraphModelSortRatioUp];
        }
        else {
            [self.bargraphModel sortedSeriesList:JYBargraphModelSortRatioDown];
        }
    }
    else if ([type isEqualToString:self.bargraphModel.xAxisName]) {
        if (isSelected) {
            [self.bargraphModel sortedSeriesList:JYBargraphModelSortProNameUp];
        }
        else {
            [self.bargraphModel sortedSeriesList:JYBargraphModelSortProNameDown];
        }
    }
    
    //[proNameList makeObjectsPerformSelector:@selector(setTitle:forState:) withObject:self.bargraphModel.xAxisData];
    for (int i = 0; i < proNameList.count; i++) {
        [proNameList[i] setTitle:self.bargraphModel.xAxisData[i] forState:UIControlStateNormal];
        ratioList[i].text = self.bargraphModel.seriesData[i];
    }
    self.landscapeBar.model = self.bargraphModel;
    
}

@end
