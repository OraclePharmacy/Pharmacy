//
//  YdyaopinxiangqingViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/27.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdyaopinxiangqingViewController.h"

@interface YdyaopinxiangqingViewController ()

@end

@implementation YdyaopinxiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    //状态栏名称
    self.navigationItem.title = @"药品详情";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
}



-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
