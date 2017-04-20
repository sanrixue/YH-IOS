//
//  HomeIndexItemModel.h
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeIndexItemSizeModel;

@interface  HomeIndexItemSizeModel: NSObject
@property (nonatomic, strong) NSString* arrow;
@property (nonatomic, strong) NSString* color;
@property (nonatomic, assign) double data;
@property (nonatomic, strong) NSString* format;

@end

@interface HomeIndexItemModel : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray<HomeIndexItemModel*>* items;
@property (nonatomic, strong) HomeIndexItemSizeModel* state;
@property (nonatomic, strong) HomeIndexItemSizeModel* main_data;
@property (nonatomic, strong) HomeIndexItemSizeModel* sub_data;

@property (nonatomic, strong) HomeIndexItemModel* selctItem;

@property (nonatomic, assign) BOOL select;
@end


