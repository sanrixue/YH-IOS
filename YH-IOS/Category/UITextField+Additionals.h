
#import <UIKit/UIKit.h>

@interface UITextField (Additionals)

- (void)addLeftPadding:(CGFloat)ftValue;
- (void)addRightPaddinImage:(UIImage *)image width:(CGFloat)ftValue height:(CGFloat)height;
- (void)addLeftPaddinImage:(UIImage *)image width:(CGFloat)ftValue height:(CGFloat)height;
- (void)setLeftPaddinText:(NSString *)leftStr fontSize:(float)fSize padding:(float)padding;
- (void)setRightPaddinText:(NSString *)rightStr fontSize:(float)fSize padding:(float)padding;
- (void)setPlaceHolderColor:(UIColor *)color;
- (void)addBottomLine;
/**
 *  添加左边的图片
 *
 *  @param distance 图片和文字的距离
 *  @param image 图片
 *  @param frame 图片在textFiled里的坐标
 */
- (void)addLeftImage:(UIImage*)image imageFrame:(CGRect)frame distance:(CGFloat)distance textFileHeight:(CGFloat)height;
- (void)addLeftPaddinText:(NSString *)text width:(CGFloat)ftValue height:(CGFloat)height
                    color:(UIColor *)color font:(float)font;
@end
