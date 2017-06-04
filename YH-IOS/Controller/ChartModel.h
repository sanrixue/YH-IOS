//
//  ChartModel.h
//  SwiftCharts
//
//  Created by CJG on 17/4/11.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartModel : NSObject
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, strong) NSString* xString ;
@property (nonatomic, strong) UIColor* selectColor;

- (instancetype)initWithX:(double)x y:(double)y xString:(NSString*)xString;

@end
