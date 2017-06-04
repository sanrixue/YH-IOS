//
//  PointHudTool.m
//  JinXiaoEr
//
//  Created by cjg on 17/3/1.
//
//

#import "PointHudTool.h"

@interface PointHudTool ()
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIButton* confirmBtn;
@property (nonatomic, strong) UIButton* cancleBtn;
@property (nonatomic, strong) UILabel* titleLab;
@property (nonatomic, strong) UILabel* messageLab;
@property (nonatomic, strong) CommonBack confirmBack;
@property (nonatomic, strong) CommonBack cancleBack;
@end


@implementation PointHudTool

+ (instancetype)pointHudShowInView:(UIView *)view title:(NSString *)title message:(NSString *)message confimBack:(CommonBack)confimBack cancleBack:(CommonBack)cancleBack{
    PointHudTool *hud = [[PointHudTool alloc] init];
    hud.alpha = 0;
    hud.messageLab.text = message;
    hud.confirmBack = confimBack;
    hud.cancleBack = cancleBack;
    [view addSubview:hud];
    [hud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        hud.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    return hud;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = RGB(0, 0, 0, 0.4);
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.messageLab];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.cancleBtn];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.width.mas_equalTo(265);
        make.height.mas_equalTo(115);
    }];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(65);
    }];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageLab.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_centerX);
        make.left.mas_equalTo(self.contentView).offset(-0.5);
        make.bottom.mas_equalTo(self.contentView).offset(0.5);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageLab.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_centerX).offset(-0.5);
        make.right.mas_equalTo(self.contentView).offset(0.5);
        make.bottom.mas_equalTo(self.contentView).offset(0.5);
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)onClickAction:(UIButton*)sender{
    [self hide];
    if (sender == self.confirmBtn) {
        if (self.confirmBack) {
            self.confirmBack(self);
        }
    }else{
        if (self.cancleBack) {
            self.cancleBack(self);
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, point)) {
        [self hide];
    }
}

#pragma mark - 懒加载
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView cornerRadius:3];
    }
    return _contentView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
    }
    return _titleLab;
}

- (UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab = [[UILabel alloc] init];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.textColor = UIColorHex(333333);
        _messageLab.font = [UIFont boldSystemFontOfSize:14];
    }
    return _messageLab;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancleBtn setTitleColor:UIColorHex(7a7a7a) forState:UIControlStateNormal];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancleBtn setBorderColor:UIColorHex(f1f1f1) width:0.5];
    }
    return _cancleBtn;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmBtn setTitleColor:UIColorHex(00bc5d) forState:UIControlStateNormal];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setBorderColor:[UIColor colorWithHexString:@"f1f1f1"] width:0.5];
    }
    return _confirmBtn;
}

@end
