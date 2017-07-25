//
//  ArticlesModel.h
//  YH-IOS
//
//  Created by cjg on 2017/7/25.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "BaseModel.h"

@interface ArticlesModel : BaseModel

@property (nonatomic, assign) NSInteger currPage;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong) ArticlesModel* page;

@property (nonatomic, strong) NSArray<ArticlesModel*>* list;

@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, strong) NSString* title;

@property (nonatomic, assign) BOOL favorite;

@property (nonatomic, strong) NSString* tagInfo;


@end
