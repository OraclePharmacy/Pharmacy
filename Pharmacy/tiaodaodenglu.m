//
//  tiaodaodenglu.m
//  Pharmacy
//
//  Created by 小狼 on 16/8/1.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "tiaodaodenglu.h"
#import "ViewController.h"
@implementation tiaodaodenglu
+ (void) jumpToLogin:(UINavigationController*)navigat{
    ViewController*mm=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"view"];
    [navigat pushViewController:mm animated:YES];
}
@end
