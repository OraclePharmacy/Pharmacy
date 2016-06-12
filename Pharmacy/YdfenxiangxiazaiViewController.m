//
//  YdfenxiangxiazaiViewController.m
//  Pharmacy
//
//  Created by suokun on 16/6/8.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdfenxiangxiazaiViewController.h"

@interface YdfenxiangxiazaiViewController ()

@end

@implementation YdfenxiangxiazaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //状态栏名称
    self.navigationItem.title = @"分享下载";
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
}

//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
