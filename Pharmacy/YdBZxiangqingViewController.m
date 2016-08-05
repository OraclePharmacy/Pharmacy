//
//  YdBZxiangqingViewController.m
//  Pharmacy
//
//  Created by suokun on 16/8/1.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdBZxiangqingViewController.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
@interface YdBZxiangqingViewController ()

@end

@implementation YdBZxiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"病症详情";
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    [self jiekou];
}

-(void)jiekou
{
    
    NSLog(@"%@",self.mingcheng);
    
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
