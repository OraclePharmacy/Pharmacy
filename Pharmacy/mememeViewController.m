//
//  mememeViewController.m
//  Pharmacy
//
//  Created by 小狼 on 16/6/3.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "mememeViewController.h"

@interface mememeViewController ()
{
  
}

@end

@implementation mememeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"\n\n\n\n%@",_opo);
    self.tabBarController.tabBar.hidden=YES;
    //状态栏名称
    self.navigationItem.title = _opo;
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
