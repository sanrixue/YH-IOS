//
//  HomeIndexModel.h
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeIndexItemModel.h"

@interface HomeIndexModel : NSObject

@property (nonatomic, strong) NSString* period;
@property (nonatomic, strong) NSString* xaxis_order;
@property (nonatomic, strong) NSString* head;
@property (nonatomic, strong) NSArray<HomeIndexItemModel*>* products;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, strong) NSString *jsonUrlStr;

+ (NSArray*)homeIndexModelWithJson:(id)json withUrl:(NSString *)urlString;

@end


