//
//  YdShakeViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/7.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdShakeViewController.h"

@interface YdShakeViewController ()
{
    
    int i ;
    int j ;
    NSArray *array;
    NSArray *array1;
    NSTimer *time;
    NSTimer *time1;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *beijing;
@property (weak, nonatomic) IBOutlet UIImageView *dong;
@property (weak, nonatomic) IBOutlet UIImageView *bian;
@end

@implementation YdShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];//隐藏UINavigationBar
    //状态栏名称
    self.navigationItem.title = @"摇一摇";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    self.beijing.image = [UIImage imageNamed:@"shake_background.png"];
    
    self.bian.hidden = YES;
    //穿件图片数组   实现手机晃动
    array = [NSArray arrayWithObjects:@"shake_yyy.png",@"shake_yyy_left30.png",@"shake_yyy_left60.png",@"shake_yyy_left30.png",@"shake_yyy.png",@"shake_yyy_right30.png",@"shake_yyy_right60.png",@"shake_yyy_right30.png",@"shake_yyy.png",nil];
    //穿件图片数组  实现花环闪动
    array1 = [NSArray arrayWithObjects:@"",@"shake_fangshe.png",@"",@"shake_fangshe.png",@"",@"shake_fangshe.png",@"",nil];
    i = 0;
    //定时器
    time = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(jinru) userInfo:nil repeats:YES];
    //开始
    [time setFireDate:[NSDate distantPast]];

}
//图片切换  实现手机摇动效果
-(void)jinru
{
    i++;
    
    if ( i < array.count)
    {
        self.dong.image = [UIImage imageNamed:array[i]];
    }
    else{
        //停止
        [time setFireDate:[NSDate distantFuture]];
    }
}
// 实现花环闪动效果
-(void)zhongjiang
{
    j++;
    
    if ( j < array1.count)
    {
        self.bian.image = [UIImage imageNamed:array1[j]];
    }
    else{
        //停止
        [time1 setFireDate:[NSDate distantFuture]];
    }
    
}
//设置摇动为第一响应者
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    i = 0;
    //检测到摇动
    [time setFireDate:[NSDate distantPast]];
    //NSLog(@"jiace");
    
}



- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    //摇动取消
    //NSLog(@"yaodong");
}



- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    //摇动结束
    if (event.subtype == UIEventSubtypeMotionShake) {
        
        
        //延时效果  ＊前为延迟时间  单位  秒
        //摇动结束时  手机停止摇动  执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.bian.hidden = NO;
            
            time1 = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(zhongjiang) userInfo:nil repeats:YES];
            
            j = 0 ;
            //
            //            [time1 setFireDate:[NSDate distantPast]];
            
        });
        //摇奖结束出现
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.bian.hidden = YES;
            self.dong.hidden = YES;
            self.beijing.image = [UIImage imageNamed:@"摇一摇弹窗.png"];
            
        });
        //NSLog(@"结束");
    }
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}


@end
