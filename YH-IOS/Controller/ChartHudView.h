//
//  ChartHudView.h
//  SwiftCharts
//
//  Created by CJG on 17/4/12.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartHudView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

+ (instancetype)showInView:(UIView*)view delegate:(id)delegate;

@end
