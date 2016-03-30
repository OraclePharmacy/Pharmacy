//
//  YdScanJumpViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdScanJumpViewController.h"

@interface YdScanJumpViewController ()

@end

@implementation YdScanJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"评论";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
