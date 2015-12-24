//
//  NSData+MD5.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@interface NSData (MD5)
- (NSString*)md5;
@end
