

#import <UIKit/UIKit.h>

@interface UILabel (ContentSize)


- (CGSize)contentSize;
- (CGSize)contentSizeInSie:(CGSize)size;
- (CGFloat)contentHeight;
- (CGFloat)contentWidth;
/**
 *  设置label的颜色
 *
 *  @param color              要设置的颜色
 *  @param stringFromLocation 起始点
 *  @param stringNeedLength   要设置颜色的长度
 */
-(void)setLabelColor:(UIColor *)color StringFromLocation:(NSInteger)stringFromLocation  StringNeedLength:(NSInteger)stringNeedLength;
/**
 *  设置字号大小，从开始设置的位置到最后
 *
 *  @param fontSize           字号大小
 *  @param stringFromLocation 开始设置的位置
 */
-(void)setLabelFontSize:(CGFloat)fontSize StringFromLocation:(NSInteger)stringFromLocation;
@end

@interface UILabel (textSize)

+ (CGFloat)textHeightWithFrameWidth:(CGFloat)w text:(NSString*)text textFontSize:(CGFloat)fontSize;
/**
 *  样式1 字体颜色383838 左对齐 大小12
 */
- (void)style1;
/**
 *  样式2 字体颜色383838 居中对齐 大小12
 */
- (void)style2;
/**
 *  样式3 字体颜色383838 左对齐 大小14
 */
- (void)style3;
/**
 *  样式4 字体颜色灰色#bdc0c5 左对齐 大小12
 */
- (void)style4;
/**
 *  样式5 字体颜色383838 右对齐 大小12
 */
- (void)style5;

#pragma mark label内容的高度
/**  label内容的高度 */
- (CGFloat)textHeight;

#pragma mark label attributedText的高度
- (CGFloat)attributedTextHeight;

/** 1行的text宽度 */
- (CGFloat)textALineWidth;

/** label 1行的text高度 */
- (CGFloat)textALineHeight;

#pragma mark label 内容的行数
- (int)textLineCount;

@end
