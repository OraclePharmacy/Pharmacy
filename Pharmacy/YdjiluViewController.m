//
//  YdjiluViewController.m
//  Pharmacy
//
//  Created by suokun on 16/7/1.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdjiluViewController.h"
#import "Color+Hex.h"
@interface YdjiluViewController ()

@end

@implementation YdjiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"药品详情";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
}



-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
