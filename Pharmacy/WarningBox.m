//
//  WarningBox.m
//  网络篇-用户注册
//
//  Created by imac21 on 15/10/13.
//  Copyright © 2015年 com.appleyf. All rights reserved.
//

#import "WarningBox.h"



@implementation WarningBox

/**
 *  2秒后消失的提示框
 *
 */
+ (void)warningBoxModeText:(NSString *)message andView:(UIView *)view{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.yOffset = 160;
    //hud.xOffset = 30;
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud hide:YES afterDelay:2];
    
}
/**
 *  获取网络数据时候的加载框
 *
 */
+ (void)warningBoxModeIndeterminate:(NSString *)message andView:(UIView *)view{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:12];
    [hud setRemoveFromSuperViewOnHide:YES];
    
}

/**
 *  隐藏显示的加载框
 *
 */
+ (void) warningBoxHide:(BOOL)isHide andView:(UIView *)view{
    
    [MBProgressHUD hideHUDForView:view animated:YES];
    
}



@end
