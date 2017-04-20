//
//  DataManager.h
//  JinXiaoEr
//
//  Created by CJG on 16/12/23.
//
//

#import <Foundation/Foundation.h>
//#import "Customer.h"

#define CurDataManager [DataManager shareInstance]


typedef enum : NSUInteger {
    UserTypeEnterprise = 0, // 企业用户
    UserTypePerson = 1, // 一般用户
    UserTypeDriver = 2, // 司机
} UserType;

@interface DataManager : NSObject{
    
}
/** app用户,如果不在线或不存在则为nil */
//@property (nonatomic, strong) Customer* customer;
///** 首页数据 */
//@property (nonatomic, strong) HomeViewModel* homeData;

@property (nonatomic, assign) UserType role_type;

+ (instancetype)shareInstance;


@end
