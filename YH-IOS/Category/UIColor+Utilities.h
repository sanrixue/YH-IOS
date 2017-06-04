//
//  UIColor+Utilities.h
//
//  Created by Micah Hainline
//  http://stackoverflow.com/users/590840/micah-hainline
//

#import <UIKit/UIKit.h>

#pragma mark - RGBA颜色
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface UIColor (HexString)

+ (UIColor *) colorWithHexString: (NSString *) hexString;

@end
