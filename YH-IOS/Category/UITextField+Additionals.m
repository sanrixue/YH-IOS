
#import "UITextField+Additionals.h"

@implementation UITextField (Additionals)

- (void)addLeftPadding:(CGFloat)ftValue
{
    UIView* pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ftValue, 1)];
    pView.backgroundColor = [UIColor clearColor];
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:pView];
}

- (void)setPlaceHolderColor:(UIColor *)color {
    if (color) {
        if (self.placeholder) {
            NSAttributedString *atr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:color}];
            self.attributedPlaceholder = atr;
        }
    }
}
//添加textFiled的左边文字
- (void)addLeftPaddinText:(NSString *)text width:(CGFloat)ftValue height:(CGFloat)height
                    color:(UIColor *)color font:(float)font{
    UIButton *pBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ftValue, height)];
    [pBtn addTarget:self action:@selector(editingBegin) forControlEvents:UIControlEventTouchUpInside];
    
    //[pBtn setImage:image forState:UIControlStateNormal];
    [pBtn setTitle:text forState:UIControlStateNormal];
    //pBtn.font = [UIFont fontWithName:@"Helvetica" size:15.f]; [UIFont boldSystemFontOfSize:24.0f]
    //pBtn.font = [UIFont boldSystemFontOfSize:font];
    [pBtn setFont:[UIFont systemFontOfSize:font]];
    //    pBtn.font = [UIFont fontWithName:@"FZLTXHK--GBK1-0" size:font];  //设置字体大小
    [pBtn setTitleColor:color forState:UIControlStateNormal];
    //    pBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:pBtn];
}


- (void)setRightPaddinText:(NSString *)rightStr fontSize:(float)fSize padding:(float)padding {
    
}

- (void)setLeftPaddinText:(NSString *)leftStr fontSize:(float)fSize padding:(float)padding {

}

- (void)editingBegin
{
    [self becomeFirstResponder];
}

- (void)addRightPaddinImage:(UIImage *)image width:(CGFloat)ftValue height:(CGFloat)height
{
    UIButton *pBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ftValue, height)];
    
    [pBtn setImage:image forState:UIControlStateNormal];
    pBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self setRightView:pBtn];
}

- (void)addRightPaddinImage:(UIImage *)image width:(CGFloat)ftValue height:(CGFloat)height rightAction:(SEL)action target:(id)target
{
    UIButton *pBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ftValue, height)];
    [pBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [pBtn setImage:image forState:UIControlStateNormal];
    pBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self setRightView:pBtn];
}

- (void)addLeftPaddinImage:(UIImage *)image width:(CGFloat)ftValue height:(CGFloat)height
{
    UIImageView *pBtn = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, ftValue + 5, height)];
    [pBtn setContentMode:UIViewContentModeScaleAspectFit];
    [pBtn setImage:image];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:pBtn];
}

- (void)addLeftImage:(UIImage *)image imageFrame:(CGRect)frame distance:(CGFloat)distance textFileHeight:(CGFloat)height{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:image];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.mj_w+imageView.mj_x+distance, height)];
    [leftView addSubview:imageView];
    [self setLeftView:leftView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

- (void)addBottomLine{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorHex(cccccc);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}
@end
