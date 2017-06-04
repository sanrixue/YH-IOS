

#import "UILabel+ContentSize.h"

@implementation UILabel (ContentSize)

- (CGSize)contentSize
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    if ([self.text isEqualToString:@""]) {
        contentSize.height = 0;
    }
    DLog(@"contentSize================%@",NSStringFromCGSize(contentSize));
    return contentSize;
}

- (CGFloat)contentHeight
{
    CGSize size = [self contentSizeInSie:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    return size.height;
}

- (CGFloat)contentWidth {
    CGSize size = [self contentSizeInSie:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    return size.width;
}

-(CGSize) contentSizeInSie:(CGSize)size{
    CGSize contentSize = [self sizeThatFits:size];
    if ([self.text isEqualToString:@""]) {
        contentSize.height = 0;
    }
    DLog(@"contentSize================%@",NSStringFromCGSize(contentSize));
    return contentSize;
}

-(void)setLabelColor:(UIColor *)color StringFromLocation:(NSInteger)stringFromLocation  StringNeedLength:(NSInteger)stringNeedLength{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSForegroundColorAttributeName
                value:color
                range:NSMakeRange(stringFromLocation,stringNeedLength)];
    self.attributedText = str;
}

-(void)setLabelFontSize:(CGFloat)fontSize StringFromLocation:(NSInteger)stringFromLocation  {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [str addAttribute:NSFontAttributeName
                value:[UIFont systemFontOfSize:fontSize]
                range:NSMakeRange(stringFromLocation,str.length - stringFromLocation)];
    self.attributedText = str;
}

@end

@implementation UILabel (textSize)

+ (CGFloat)textHeightWithFrameWidth:(CGFloat)w text:(NSString*)text textFontSize:(CGFloat)fontSize
{
    return [text boundingRectWithSize:CGSizeMake(w, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                              context:nil].size.height;
}

- (void)style1{
    self.textColor =UIColorHex(333333);
    self.textAlignment = NSTextAlignmentLeft;
    self.font = [UIFont systemFontOfSize:12];
}

- (void)style2{
    self.textColor = UIColorHex(333333);
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:12];
}

- (void)style3{
    self.textColor = UIColorHex(333333);
    self.textAlignment = NSTextAlignmentLeft;
    self.font = [UIFont systemFontOfSize:14];
}

- (void)style4{
    self.textColor = [UIColor colorWithHexString:@"#bdc0c5"];
    self.textAlignment = NSTextAlignmentLeft;
    self.font = [UIFont systemFontOfSize:12];
}

- (void)style5{
    self.textColor = [UIColor colorWithHexString:@"#252525"];
    self.textAlignment = NSTextAlignmentRight;
    self.font = [UIFont systemFontOfSize:12];
}

- (CGFloat)textHeight
{
    return [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                attributes:@{NSFontAttributeName:self.font}
                                   context:nil].size.height;
}

- (CGFloat)attributedTextHeight
{
    return [self.attributedText boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                             context:nil].size.height;
}

- (int)textLineCount
{
    CGFloat oneH = [self textALineHeight];
    CGFloat moreH = [self textHeight];
    
    return moreH/oneH;
}

- (CGFloat)textALineWidth
{
    return [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
}

- (CGFloat)textALineHeight
{
    return [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
}

@end
