//
//  YdShakeViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/7.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdShakeViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"

@interface YdShakeViewController ()
{
    
    int i ;
    int j ;
    NSArray *array;
    NSArray *array1;
    NSTimer *time;
    NSTimer *time1;
    
    NSDictionary*chuan;
    
    CGFloat width;
    CGFloat height;
    
    NSArray *zhongjiang;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *beijing;
@property (weak, nonatomic) IBOutlet UIImageView *dong;
@property (weak, nonatomic) IBOutlet UIImageView *bian;
@end

@implementation YdShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
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
        UILabel *dengji = [[UILabel alloc]init];
        dengji.frame = CGRectMake(0, height / 6, width, 30);
        dengji.textColor = [UIColor whiteColor];
        dengji.font = [UIFont systemFontOfSize:16];
        dengji.textAlignment = NSTextAlignmentCenter;
        
        
        
//        dengji.text = @"几等奖";
        
        
        [self.beijing addSubview:dengji];
        
        UILabel *jieguo = [[UILabel alloc]init];
        jieguo.frame = CGRectMake(0, CGRectGetMaxY(dengji.frame) +10, width, 30);
        jieguo.textColor = [UIColor whiteColor];
        jieguo.font = [UIFont systemFontOfSize:15];
        jieguo.textAlignment = NSTextAlignmentCenter;
        jieguo.text = [chuan objectForKey:@"results"];
        [self.beijing addSubview:jieguo];
        
        
        UIButton *fanhui = [[UIButton alloc]init];
        fanhui.frame = CGRectMake( 50, height - 100, width - 100, 30);
        [fanhui setTitle:@"返回" forState:UIControlStateNormal];
        [fanhui setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        fanhui.layer.cornerRadius = 5;
        fanhui.layer.masksToBounds = YES;
        fanhui.layer.borderColor = [UIColor whiteColor].CGColor;
        fanhui.layer.borderWidth =1;
        [fanhui addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:fanhui];

        self.bian.hidden = YES;
        self.dong.hidden = YES;
        self.beijing.image = [UIImage imageNamed:@"yyy_zhongjiang.png"];
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
    NSLog(@"dianole");
}

-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/basic/awardShakeList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSString*zhid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    zhid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
   NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:zhid,@"officeId",vip,@"vipId", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
           [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            NSLog(@"responseObject%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==4444) {
                UIButton *fanhui = [[UIButton alloc]init];
                fanhui.frame = CGRectMake( 50, height - 100, width - 100, 30);
                [fanhui setTitle:@"返回" forState:UIControlStateNormal];
                [fanhui setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                fanhui.layer.cornerRadius = 5;
                fanhui.layer.masksToBounds = YES;
                fanhui.layer.borderColor = [UIColor whiteColor].CGColor;
                fanhui.layer.borderWidth =1;
                [fanhui addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:fanhui];
            }
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                chuan=[[NSDictionary alloc] init];
                chuan=[responseObject valueForKey:@"data"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.bian.hidden = NO;
                    time1 = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(zhongjiang) userInfo:nil repeats:YES];
                    
                    j = 0 ;
                    //
                    //            [time1 setFireDate:[NSDate distantPast]];
                    
                });

            }
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        NSLog(@"错误：%@",error);
    }];
    
    
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
        
        [self jiekou];
        //延时效果  ＊前为延迟时间  单位  秒
        //摇动结束时  手机停止摇动  执行
               //摇奖结束出现
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
        });
        //NSLog(@"结束");
    }
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


@end
