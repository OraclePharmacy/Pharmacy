//
//  YdYaoXiangViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/3.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdYaoXiangViewController.h"

@interface YdYaoXiangViewController ()

@end

@implementation YdYaoXiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"智慧药箱";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}


@end