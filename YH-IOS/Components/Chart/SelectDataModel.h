//
//  SelectDataModel.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SelectDataSecondModel;
@class SelectDataThreeModel;

@interface SelectDataModel : NSObject

@property (nonatomic,strong) NSString *firstSection;
@property (nonatomic,strong) NSMutableArray<NSDictionary *> *seconSection;

-(id)initWithFirst:(NSString *)firstsection withSeconArray:(NSDictionary*) secondArray;

@end

@interface SelectDataSecondModel : NSObject

@property (nonatomic, strong) NSString *secondTitle;
@property (nonatomic, strong) NSMutableArray *threeArray;

@end

@interface SelectDataThreeModel : NSObject

@property (nonatomic, strong) NSString *threeTitle;

@end
