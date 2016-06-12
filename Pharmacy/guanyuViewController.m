//
//  guanyuViewController.m
//  Pharmacy
//
//  Created by suokun on 16/6/8.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "guanyuViewController.h"

@interface guanyuViewController ()

@end

@implementation guanyuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"关于";
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
}

//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];

}


@end