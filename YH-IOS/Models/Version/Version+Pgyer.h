//
//  Version+Self.h
//  iSearch
//
//  Created by lijunjie on 15/7/9.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//

#ifndef iSearch_Version_Self_h
#define iSearch_Version_Self_h
#import "Version.h"

/**
 *  版本更新，使用自己的服务器托管
 */
@interface Version (Pyger)

- (void)checkUpdate:(void(^)())successBlock FailBloc:(void(^)())failBlock;
@end

#endif
