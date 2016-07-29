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
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
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
    //判断是否登录
    //    if(/*没登录*/){
    //        /*跳转*/
    //    }else{

    //跳转到有奖问答页面
    YdAnswerViewController *Answer = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"answer"];
    [self.navigationController pushViewController:Answer animated:YES];
//}
}
//大转盘
- (IBAction)TurntableButton:(id)sender {
    //判断是否登录
    //    if(/*没登录*/){
    //        /*跳转*/
    //    }else{

    [WarningBox warningBoxModeIndeterminate:@"" andView:self.view];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/dialaward/List";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSString*vip;
    NSString *path6 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
    NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path6];
    vip=[NSString stringWithFormat:@"%@",[pp objectForKey:@"id"]];
    NSString*zhid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    zhid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:vip,@"VipId",zhid,@"storeId", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    

    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            //跳大转盘
            YdTurntableViewController *Turntable = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"turntable"];
            
            Turntable.uu=[NSString stringWithFormat:@"%@/%@",service_host,[[responseObject objectForKey:@"data"] objectForKey:@"url"]];
            NSLog(@"%@",Turntable.uu);
            [self.navigationController pushViewController:Turntable animated:YES];
        }
        NSLog(@"\n\n\n大转盘\n\n\n%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
    }];
    
//    }
   
}

//摇一摇
- (IBAction)ShakeButton:(id)sender {
    //判断是否登录
    //    if(/*没登录*/){
    //        /*跳转*/
    //    }else{

    //跳摇一摇
    YdShakeViewController *Shake = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shake"];
    [self.navigationController pushViewController:Shake animated:YES];
//}
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
