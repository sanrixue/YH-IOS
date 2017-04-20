//
//  CommonAlertView.h
//  ShenghuoJia
//
//  Created by Guava on 15/12/16.
//  Copyright © 2015年 YongHui. All rights reserved.
//

#import "CommonPopupView.h"

@interface CommonAlertView : CommonPopupView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

-(void)showWithTitle:(NSString *) title
             message:(NSString *) message
                time:(NSTimeInterval) time
              inView:(UIView *) view;


@end
