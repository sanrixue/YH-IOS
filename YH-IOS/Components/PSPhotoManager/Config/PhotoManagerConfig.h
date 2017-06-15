//
//  PhotoManagerConfig.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/8.
//  Copyright © 2016年 Leiliang. All rights reserved.
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "Masonry.h"
#import "UIView+building.h"
#import "UIView+leoAdd.h"
#import "PhotoSelectManager.h"
#import "ScaleAnimation.h"
#import "UINavigationBar+leoAdd.h"
#import "PSMessageDialog.h"

#define WeakSelf(self) __weak typeof(self) weakSelf = self;

#ifndef kScreenWidth
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef kScreenHeight
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

#define kPlaceholderImageColor [UIColor groupTableViewBackgroundColor]

#define FontBold(x) [UIFont boldSystemFontOfSize:x]
#define Font(x) [UIFont systemFontOfSize:x]

#ifndef HEXCOLOR
#define HEXCOLOR(hexValue)              [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : 1.0]
#endif

#ifndef HEXACOLOR
#define HEXACOLOR(hexValue, alphaValue) [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : (alphaValue)]
#endif

#ifndef Format
#define Format(...) [NSString stringWithFormat:__VA_ARGS__]
#endif

#ifndef Block_exe
#define Block_exe(block, ...) \
if (block) { \
    block(__VA_ARGS__); \
}
#endif

#ifndef YYSYNTH_DYNAMIC_PROPERTY_OBJECT
#define YYSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif

#ifndef YYSYNTH_DYNAMIC_PROPERTY_CTYPE
#define YYSYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    _type_ cValue = { 0 }; \
    NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
    [value getValue:&cValue]; \
    return cValue; \
}
#endif

