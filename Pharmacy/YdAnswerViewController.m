//
//  YdAnswerViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/7.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdAnswerViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"

@interface YdAnswerViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *arr;
    NSString *xuanxiang;
    
    int i ;
    int j ;
}
@property (nonatomic,strong) UILabel *wenti;
@property (nonatomic,strong) UIButton *daan1;
@property (nonatomic,strong) UIButton *daan2;
@property (nonatomic,strong) UIButton *daan3;
@property (nonatomic,strong) UIButton *daan4;
@property (nonatomic,strong) UIButton *quding;
@property (nonatomic,strong) UIButton *shangyiye;
@property (nonatomic,strong) UILabel *jieguo;
@property (nonatomic,strong) UILabel *fenshu;
@property (nonatomic,strong) UILabel *jiangpin;

@end

@implementation YdAnswerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    i = 0 ; j = 0 ;
    xuanxiang = [[NSString alloc]init];

    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"有奖问答";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    [self jiekou];
   
}
-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/examList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1020",@"vipId",@"2",@"officeId", nil];
    NSLog(@"12345%@",datadic);
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
            
            NSLog(@"%@",responseObject);
            
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
             
                arr = [datadic objectForKey:@"examList"];
                
                 [self kongjian];
                
//                NSLog(@"%@",datadic);
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
-(void)tijiaojiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/paperGiftList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1020",@"vipId",@"2",@"officeId",j,@"score",@"1",@"pageNo",@"1",@"pageSize", nil];
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
            
            NSLog(@"%@",responseObject);
            
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                arr = [datadic objectForKey:@"paperGiftList"];
                
                [self zuihouxianshi];
                
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
-(void)kongjian
{
   
    self.wenti = [[UILabel alloc]init];
    self.wenti.frame = CGRectMake(10, 80, width - 20, 40);
    self.wenti.font = [UIFont systemFontOfSize:15];
    self.wenti.textColor = [UIColor whiteColor];
    self.wenti.text = [NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"examName"]];
    self.wenti.hidden = YES;
    [self.view addSubview:self.wenti];
    
    
    self.daan1 = [[UIButton alloc]init];
    self.daan1.frame = CGRectMake(-150, CGRectGetMaxY(self.wenti.frame) + 50, 150, 30);
    [self.daan1 setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"optA"]] forState:UIControlStateNormal];
    self.daan1.titleLabel.font = [UIFont systemFontOfSize:15];
    //[self.daan1 setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    self.daan1.backgroundColor = [UIColor whiteColor];
    self.daan1.layer.cornerRadius = 5;
    self.daan1.layer.masksToBounds = YES;
    [self.daan1 setBackgroundImage:[UIImage imageNamed:@"IMG_0797.jpg"] forState:UIControlStateNormal];
    [self.daan1 setBackgroundImage:[UIImage imageNamed:@"IMG_0798.jpg"] forState:UIControlStateSelected];
    [self.daan1 addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.daan1];
    
    
    self.daan2 = [[UIButton alloc]init];
    self.daan2.frame = CGRectMake(-150, CGRectGetMaxY(self.daan1.frame) + 20, 150, 30);
    [self.daan2 setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"optB"]] forState:UIControlStateNormal];
    self.daan2.titleLabel.font = [UIFont systemFontOfSize:15];
    //[self.daan1 setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    self.daan2.backgroundColor = [UIColor whiteColor];
    self.daan2.layer.cornerRadius = 5;
    self.daan2.layer.masksToBounds = YES;
    [self.daan2 setBackgroundImage:[UIImage imageNamed:@"IMG_0797.jpg"] forState:UIControlStateNormal];
    [self.daan2 setBackgroundImage:[UIImage imageNamed:@"IMG_0798.jpg"] forState:UIControlStateSelected];
    [self.daan2 addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.daan2];
    
    
    self.daan3 = [[UIButton alloc]init];
    self.daan3.frame = CGRectMake(-150, CGRectGetMaxY(self.daan2.frame) + 20, 150, 30);
    [self.daan3 setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"optC"]] forState:UIControlStateNormal];
    self.daan3.titleLabel.font = [UIFont systemFontOfSize:15];
    //[self.daan1 setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    self.daan3.backgroundColor = [UIColor whiteColor];
    self.daan3.layer.cornerRadius = 5;
    self.daan3.layer.masksToBounds = YES;
    [self.daan3 setBackgroundImage:[UIImage imageNamed:@"IMG_0797.jpg"] forState:UIControlStateNormal];
    [self.daan3 setBackgroundImage:[UIImage imageNamed:@"IMG_0798.jpg"] forState:UIControlStateSelected];
    [self.daan3 addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.daan3];
    
    
    self.daan4 = [[UIButton alloc]init];
    self.daan4.frame = CGRectMake(-150, CGRectGetMaxY(self.daan3.frame) + 20, 150, 30);
    [self.daan4 setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"optD"]] forState:UIControlStateNormal];
    self.daan4.titleLabel.font = [UIFont systemFontOfSize:15];
    //[self.daan1 setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    self.daan4.backgroundColor = [UIColor whiteColor];
    self.daan4.layer.cornerRadius = 5;
    self.daan4.layer.masksToBounds = YES;
    [self.daan4 setBackgroundImage:[UIImage imageNamed:@"IMG_0797.jpg"] forState:UIControlStateNormal];
    [self.daan4 setBackgroundImage:[UIImage imageNamed:@"IMG_0798.jpg"] forState:UIControlStateSelected];
    [self.daan4 addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.daan4];
    
    
    self.quding = [[UIButton alloc]init];
    self.quding.frame = CGRectMake((width - 200)/2, CGRectGetMaxY(self.daan4.frame) + 40, 200, 30);
    [self.quding setTitle:@"确 认" forState:UIControlStateNormal];
    self.quding.titleLabel.font = [UIFont systemFontOfSize:15];
    self.quding.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    self.quding.layer.cornerRadius = 5;
    self.quding.layer.masksToBounds = YES;
    [self.quding setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    [self.quding addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    self.quding.hidden = YES;
    [self.view addSubview:self.quding];

    [self donghua];
    
}
-(void)zuihouxianshi
{
    self.jieguo = [[UILabel alloc]init];
    self.jieguo.frame = CGRectMake(20, 120, width - 40 , 30);
    self.jieguo.font = [UIFont systemFontOfSize:20];
    self.jieguo.textColor = [UIColor whiteColor];
    self.jieguo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.jieguo];
    
    self.fenshu = [[UILabel alloc]init];
    self.fenshu.frame = CGRectMake(20, 150, width - 40, 30);
    self.fenshu.font = [UIFont systemFontOfSize:18];
    self.fenshu.textColor = [UIColor whiteColor];
    self.fenshu.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.fenshu];
    
    self.jiangpin = [[UILabel alloc]init];
    self.jiangpin.frame = CGRectMake(20, 190, width - 40, 50);
    self.jiangpin.font = [UIFont systemFontOfSize:18];
    self.jiangpin.textColor = [UIColor whiteColor];
    self.jiangpin.textAlignment = NSTextAlignmentCenter;
    self.jiangpin.numberOfLines = 2;
    [self.view addSubview:self.jiangpin];
    
    self.shangyiye = [[UIButton alloc]init];
    self.shangyiye.frame = CGRectMake((width - 200) / 2, 320, 200, 30);
    [self.shangyiye setTitle:@"返回上一页" forState:UIControlStateNormal];
    self.shangyiye.titleLabel.font = [UIFont systemFontOfSize:15];
    self.shangyiye.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    self.shangyiye.layer.cornerRadius = 5;
    self.shangyiye.layer.masksToBounds = YES;
    [self.shangyiye setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    [self.shangyiye addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shangyiye];
    
    if ( j == 100 )
    {
         self.jieguo.text = @"答题结束";
         self.fenshu.text = [NSString stringWithFormat:@"您的分数为:%d分",j];
         self.jiangpin.text = [NSString stringWithFormat:@"您的奖品为\n%@",[arr[0] objectForKey:@"giftName"]];
    }
    else
    {
         self.jieguo.text = @"答题结束";
         self.fenshu.text = [NSString stringWithFormat:@"您的分数为:%d分",j];
         self.jiangpin.text = @"您没有获得奖品\n下次努力";
    }

}
-(void)daan:(UIButton *)btn
{
    if (btn == self.daan1)
    {
        self.daan1.selected = YES;//选择状态设置为YES,如果有其他按钮 先把其他按钮的selected设置为NO
        self.daan1=btn;
        if (xuanxiang.length == 0) {
            xuanxiang = @"a";
        }
        else{
            xuanxiang = [xuanxiang stringByAppendingString:@"a"];
        }
        
    }
    else if (btn == self.daan2)
    {
        self.daan2.selected = YES;//选择状态设置为YES,如果有其他按钮 先把其他按钮的selected设置为NO
        self.daan2=btn;
        if (xuanxiang.length == 0) {
            xuanxiang = @"b";
        }
        else{
            xuanxiang = [xuanxiang stringByAppendingString:@"b"];
        }

    }
    else if (btn == self.daan3)
    {
        self.daan3.selected = YES;//选择状态设置为YES,如果有其他按钮 先把其他按钮的selected设置为NO
        self.daan3=btn;
        if (xuanxiang.length == 0) {
            xuanxiang = @"c";
        }
        else{
            xuanxiang = [xuanxiang stringByAppendingString:@"c"];
        }

    }
    else if (btn == self.daan4)
    {
        self.daan4.selected = YES;//选择状态设置为YES,如果有其他按钮 先把其他按钮的selected设置为NO
        self.daan4=btn;
        if (xuanxiang.length == 0) {
            xuanxiang = @"d";
        }
        else{
            xuanxiang = [xuanxiang stringByAppendingString:@"d"];
        }

    }
    else if (btn == self.quding)
    {
        
        if ( i == arr.count - 1) {

            self.daan1.selected = NO;
            self.daan2.selected = NO;
            self.daan3.selected = NO;
            self.daan4.selected = NO;
            
            [self.wenti removeFromSuperview];
            [self.daan1 removeFromSuperview];
            [self.daan2 removeFromSuperview];
            [self.daan3 removeFromSuperview];
            [self.daan4 removeFromSuperview];
            [self.quding removeFromSuperview];
            
            [self tijiaojiekou];
            
        }
        else
        {
            self.daan1.selected = NO;
            self.daan2.selected = NO;
            self.daan3.selected = NO;
            self.daan4.selected = NO;
            
            [self.wenti removeFromSuperview];
            [self.daan1 removeFromSuperview];
            [self.daan2 removeFromSuperview];
            [self.daan3 removeFromSuperview];
            [self.daan4 removeFromSuperview];
            [self.quding removeFromSuperview];
            
            NSString * str1 = [arr[i] objectForKey:@"answer"];
            
            if ([str1 isEqualToString:xuanxiang] )
            {
                j = j + 10 ;
            }
            else
            {
                j = j + 0 ;
            }
            
            xuanxiang = [[NSString alloc]init];
            
            i++;
            
            [self kongjian];
        }
        
    }
    else if (btn == self.shangyiye)
    {
        
        [self.jieguo removeFromSuperview];
        [self.fenshu removeFromSuperview];
        [self.jiangpin removeFromSuperview];
        [self.shangyiye removeFromSuperview];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)donghua
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            self.wenti.hidden = NO;
        
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1 animations:^{
            
            _daan1.frame=CGRectMake((width - 150)/2, CGRectGetMaxY(self.wenti.frame) + 50, 150, 30);
            
        }];
        [UIView animateWithDuration:1.5 animations:^{
            
            _daan2.frame=CGRectMake((width - 150)/2, CGRectGetMaxY(self.daan1.frame) + 20, 150, 30);
            
        }];
        [UIView animateWithDuration:2 animations:^{
            
            _daan3.frame=CGRectMake((width - 150)/2, CGRectGetMaxY(self.daan2.frame) + 20, 150, 30);
            
        }];
        [UIView animateWithDuration:2.5 animations:^{
            
            _daan4.frame=CGRectMake((width - 150)/2,CGRectGetMaxY(self.daan3.frame) + 20, 150, 30);
            
        }];
        
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.quding.hidden = NO;
        
    });

}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}


@end
