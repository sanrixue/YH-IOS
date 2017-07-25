//
//  NoticeWarningModel.h
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "BaseModel.h"

@interface NoticeWarningModel : BaseModel

@property (nonatomic, strong) NSArray<NoticeWarningModel*>* data;

@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* abstracts;
@property (nonatomic, strong) NSString* time;
@property (nonatomic, assign) BOOL see;


@end

@interface NoticeWarningDetailModel : BaseModel

@property (nonatomic, strong) NoticeWarningModel* data;

@end
