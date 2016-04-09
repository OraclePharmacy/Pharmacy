//
//  YdSurpriseViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/7.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdSurpriseViewController.h"
#import "YdAnswerViewController.h"
#import "YdTurntableViewController.h"
#import "YdShakeViewController.h"
@interface YdSurpriseViewController ()

@end

@implementation YdSurpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"天天有惊喜";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
}


//有奖问答
- (IBAction)AnswerButton:(id)sender {
    //跳转到有奖问答页面
    YdAnswerViewController *Answer = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"answer"];
    [self.navigationController pushViewController:Answer animated:YES];

}
//大转盘
- (IBAction)TurntableButton:(id)sender {
    //跳大转盘
    YdTurntableViewController *Turntable = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"turntable"];
    [self.navigationController pushViewController:Turntable animated:YES];
}

//摇一摇
- (IBAction)ShakeButton:(id)sender {
    //跳摇一摇
    YdShakeViewController *Shake = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shake"];
    [self.navigationController pushViewController:Shake animated:YES];

}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
