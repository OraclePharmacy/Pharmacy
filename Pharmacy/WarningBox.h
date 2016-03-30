//
//  WarningBox.h
//  网络篇-用户注册
//
//  Created by imac21 on 15/10/13.
//  Copyright © 2015年 com.appleyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface WarningBox : UIView

//提示框
+ (void)warningBoxModeText:(NSString *)message andView:(UIView *)view;

//获取网络数据时候的加载框
+ (void)warningBoxModeIndeterminate:(NSString *)message andView:(UIView *)view;

//隐藏显示的加载框
+ (void) warningBoxHide:(BOOL)isHide andView:(UIView *)view;

@end
