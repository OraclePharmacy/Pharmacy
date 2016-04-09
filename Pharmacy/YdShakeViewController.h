//
//  YdShakeViewController.h
//  Pharmacy
//
//  Created by suokun on 16/4/7.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdShakeViewController : UIViewController
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
@end
