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
    
    int answer1;
    int answer2;
    int answer3;
    int answer4;
    
    int sb;
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
@property (nonatomic,strong) UILabel *fenshuwei;
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UIImageView *kuxiaoimage;


@end

@implementation YdAnswerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    i = 0 ; j = 0 ;
    answer1 = 0; answer2 = 0;answer3 = 0;answer4 = 0;

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
    NSString*officeid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    officeid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
   NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:vip,@"vipId",officeid,@"officeId",/* ,@"paprId",*/ nil];
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
    NSString*officeid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    officeid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
   NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];    NSLog(@"j=========================%d",j);
    NSString *stt = [NSString stringWithFormat:@"%d",j];
    NSString *sst = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"paperId"]];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:sst,@"paperId",vip,@"vipId",officeid,@"officeId",stt,@"score",@"1",@"pageNo",@"1",@"pageSize", nil];
    NSLog(@"%@",datadic);
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
                
                sb = 1 ;
                [self zuihouxianshi];
            }
            else if([[responseObject objectForKey:@"code"] intValue]==4444)
            {
                sb = 2 ;
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
    self.image = [[UIImageView alloc]init];
    self.image.frame = CGRectMake(20, 64, width - 40, 150);
    self.image.image = [UIImage imageNamed:@"option_tm.png"];
    [self.view addSubview:self.image];
    
    
    self.wenti = [[UILabel alloc]init];
    self.wenti.frame = CGRectMake(10, 190, width - 20, 20);
    self.wenti.font = [UIFont systemFontOfSize:13];
    self.wenti.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.wenti.text = [NSString stringWithFormat:@"问题:%@",[arr[i] objectForKey:@"examName"]];
     self.wenti.textAlignment = NSTextAlignmentCenter;
    self.wenti.hidden = YES;
    [self.view addSubview:self.wenti];
    
    
    self.daan1 = [[UIButton alloc]init];
    self.daan1.frame = CGRectMake(-150, CGRectGetMaxY(self.wenti.frame) + 20, 150, 30);
    [self.daan1 setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"optA"]] forState:UIControlStateNormal];
    [self.daan1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.daan1.titleLabel.font = [UIFont systemFontOfSize:15];
    self.daan1.layer.cornerRadius = 5;
    self.daan1.layer.masksToBounds = YES;
    [self.daan1 setBackgroundImage:[UIImage imageNamed:@"option_a2.png"] forState:UIControlStateNormal];
    [self.daan1 setBackgroundImage:[UIImage imageNamed:@"option_a1.png"] forState:UIControlStateSelected];
    [self.daan1 addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    [self.daan1 setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,-50)];
    [self.view addSubview:self.daan1];
    
    
    self.daan2 = [[UIButton alloc]init];
    self.daan2.frame = CGRectMake(-150, CGRectGetMaxY(self.daan1.frame) + 20, 150, 30);
    [self.daan2 setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"optB"]] forState:UIControlStateNormal];
    [self.daan2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.daan2.titleLabel.font = [UIFont systemFontOfSize:15];
    self.daan2.layer.cornerRadius = 5;
    self.daan2.layer.borderColor  = [[UIColor colorWithHexString:@"32be60" alpha:1]CGColor];
    [self.daan2 setBackgroundImage:[UIImage imageNamed:@"option_b2.png"] forState:UIControlStateNormal];
    [self.daan2 setBackgroundImage:[UIImage imageNamed:@"option_b1.png"] forState:UIControlStateSelected];
    [self.daan2 addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    [self.daan2 setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,-50)];
    [self.view addSubview:self.daan2];
    
    
    self.daan3 = [[UIButton alloc]init];
    self.daan3.frame = CGRectMake(-150, CGRectGetMaxY(self.daan2.frame) + 20, 150, 30);
    [self.daan3 setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"optC"]] forState:UIControlStateNormal];
    [self.daan3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.daan3.titleLabel.font = [UIFont systemFontOfSize:15];
    self.daan3.backgroundColor = [UIColor whiteColor];
    [self.daan3 setBackgroundImage:[UIImage imageNamed:@"option_c2.png"] forState:UIControlStateNormal];
    [self.daan3 setBackgroundImage:[UIImage imageNamed:@"option_c1.png"] forState:UIControlStateSelected];
    [self.daan3 addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    [self.daan3 setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,-50)];
    [self.view addSubview:self.daan3];
    
    
    self.daan4 = [[UIButton alloc]init];
    self.daan4.frame = CGRectMake(-150, CGRectGetMaxY(self.daan3.frame) + 20, 150, 30);
    [self.daan4 setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"optD"]] forState:UIControlStateNormal];
    [self.daan4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.daan4.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.daan4 setBackgroundImage:[UIImage imageNamed:@"option_d2.png"] forState:UIControlStateNormal];
    [self.daan4 setBackgroundImage:[UIImage imageNamed:@"option_d1.png"] forState:UIControlStateSelected];
    [self.daan4 addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    [self.daan4 setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,-50)];
    [self.view addSubview:self.daan4];
    
    
    self.quding = [[UIButton alloc]init];
    self.quding.frame = CGRectMake((width  - 200 )/2, CGRectGetMaxY(self.daan4.frame) + 40, 200, 35);
        [self.quding setBackgroundImage:[UIImage imageNamed:@"option_qr.png"] forState:UIControlStateNormal];
    [self.quding addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    self.quding.hidden = YES;
    [self.view addSubview:self.quding];

    [self donghua];
    
}
-(void)zuihouxianshi
{
    self.jieguo = [[UILabel alloc]init];
    self.jieguo.frame = CGRectMake(20, 100, width - 40 , 30);
    self.jieguo.font = [UIFont systemFontOfSize:22];
    self.jieguo.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    self.jieguo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.jieguo];
    
    self.fenshuwei = [[UILabel alloc]init];
    self.fenshuwei.frame = CGRectMake(20, 135, width - 40, 20);
    self.fenshuwei.font = [UIFont systemFontOfSize:18];
    self.fenshuwei.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    self.fenshuwei.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.fenshuwei];
    
    self.fenshu = [[UILabel alloc]init];
    self.fenshu.frame = CGRectMake(20, 170, width - 40, 30);
    self.fenshu.font = [UIFont systemFontOfSize:26];
    self.fenshu.textColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    self.fenshu.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.fenshu];
    
    self.kuxiaoimage = [[UIImageView alloc]init];
    self.kuxiaoimage.frame = CGRectMake((width - 60) / 2, 220, 60, 60);
    [self.view addSubview:self.kuxiaoimage];
    
    self.jiangpin = [[UILabel alloc]init];
    self.jiangpin.frame = CGRectMake(20, 285, width - 40, 50);
    self.jiangpin.font = [UIFont systemFontOfSize:15];
    self.jiangpin.textColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    self.jiangpin.textAlignment = NSTextAlignmentCenter;
    self.jiangpin.numberOfLines = 2;
    [self.view addSubview:self.jiangpin];
    
    self.shangyiye = [[UIButton alloc]init];
    self.shangyiye.frame = CGRectMake((width - 200) / 2, 360, 200, 30);
    [self.shangyiye setTitle:@"返回上一页" forState:UIControlStateNormal];
    self.shangyiye.titleLabel.font = [UIFont systemFontOfSize:15];
    self.shangyiye.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    self.shangyiye.layer.cornerRadius = 5;
    self.shangyiye.layer.masksToBounds = YES;
    [self.shangyiye setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    [self.shangyiye addTarget:self action:@selector(daan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shangyiye];
    
    if (sb == 1)
    {
        
        if ( j == 100 )
        {
            self.jieguo.text = @"答 题 结 束";
            self.fenshuwei.text = @"您 的 分 数 为";
            self.fenshu.text = [NSString stringWithFormat:@"%d 分",j];
            self.jiangpin.text = [NSString stringWithFormat:@"您 的 奖 品 为\n%@",[arr[0] objectForKey:@"giftName"]];
            self.kuxiaoimage.image = [UIImage imageNamed:@"xl.png"];
        }
        else
        {
            
            self.jieguo.text = @"答 题 结 束";
            self.fenshuwei.text = @"您 的 分 数 为";
            self.fenshu.text = [NSString stringWithFormat:@"%d分",j];
            self.jiangpin.text = @"您 没 有 获 得 奖 品\n下 次 继 续 努 力";
            self.kuxiaoimage.image = [UIImage imageNamed:@"kl.png"];
            
        }

    }
    else
    {
        if ( j == 100 )
        {
            self.jieguo.text = @"答 题 结 束";
            self.fenshuwei.text = @"您 的 分 数 为";
            self.fenshu.text = [NSString stringWithFormat:@"%d 分",j];
            self.jiangpin.text = @"您 已 经 答 过 题 了\n不 要 太 贪 心 哦";
            self.kuxiaoimage.image = [UIImage imageNamed:@"kl.png"];
        }
        else
        {
            
            self.jieguo.text = @"答 题 结 束";
            self.fenshuwei.text = @"您 的 分 数 为";
            self.fenshu.text = [NSString stringWithFormat:@"%d分",j];
            self.jiangpin.text = @"您 没 有 获 得 奖 品\n下 次 继 续 努 力";
            self.kuxiaoimage.image = [UIImage imageNamed:@"kl.png"];
            
        }

    }
    
  
}
-(void)daan:(UIButton *)btn
{
    if (btn == self.daan1)
    {
        self.daan1=btn;
        if (answer1 == 0) {
            self.daan1.selected = YES;//选择状态设置为YES,如果有其他按钮 先把其他按钮的selected设置为NO
            if (xuanxiang.length == 0) {
                xuanxiang = @"A";
                answer1 = 1;
                //[self.daan1 setBackgroundColor:[UIColor colorWithHexString:@"32be60" alpha:1]];
            }
            else{
                xuanxiang = [xuanxiang stringByAppendingString:@"A"];
                answer1 = 1;
                //[self.daan1 setBackgroundColor:[UIColor colorWithHexString:@"32be60" alpha:1]];
            }
        }
        else{
            self.daan1.selected = NO;
            xuanxiang = [xuanxiang stringByReplacingOccurrencesOfString:@"A" withString:@""];
            answer1 = 0;
        }
    }
    else if (btn == self.daan2)
    {
        self.daan2=btn;
        if (answer2 == 0) {

            self.daan2.selected = YES;//选择状态设置为YES,如果有其他按钮 先把其他按钮的selected设置为NO
            if (xuanxiang.length == 0) {
                xuanxiang = @"B";
                answer2 = 1;
                // [self.daan2 setBackgroundColor:[UIColor colorWithHexString:@"32be60" alpha:1]];
            }
            else{
                xuanxiang = [xuanxiang stringByAppendingString:@"B"];
                answer2 = 1;
                // [self.daan2 setBackgroundColor:[UIColor colorWithHexString:@"32be60" alpha:1]];
            }

        }
        else
        {
            self.daan2.selected = NO;
            xuanxiang = [xuanxiang stringByReplacingOccurrencesOfString:@"B" withString:@""];
            answer2 = 0;
        }
    }
    else if (btn == self.daan3)
    {
        self.daan3=btn;
        if (answer3 == 0) {
            
            self.daan3.selected = YES;//选择状态设置为YES,如果有其他按钮 先把其他按钮的selected设置为NO
            if (xuanxiang.length == 0) {
                xuanxiang = @"C";
                answer3 = 1;
                //  [self.daan3 setBackgroundColor:[UIColor colorWithHexString:@"32be60" alpha:1]];
            }
            else{
                xuanxiang = [xuanxiang stringByAppendingString:@"C"];
                answer3 = 1;
                // [self.daan3 setBackgroundColor:[UIColor colorWithHexString:@"32be60" alpha:1]];
            }

        }
        else{
            self.daan3.selected = NO;
            xuanxiang = [xuanxiang stringByReplacingOccurrencesOfString:@"C" withString:@""];
            answer3 = 0;
        }
    }
    else if (btn == self.daan4)
    {
        self.daan4=btn;
        if (answer4 == 0) {
            self.daan4.selected = YES;//选择状态设置为YES,如果有其他按钮 先把其他按钮的selected设置为NO
            if (xuanxiang.length == 0) {
                xuanxiang = @"D";
                answer4 = 1;
                //   [self.daan4 setBackgroundColor:[UIColor colorWithHexString:@"32be60" alpha:1]];
            }
            else{
                xuanxiang = [xuanxiang stringByAppendingString:@"D"];
                answer4 = 1;
                //   [self.daan4 setBackgroundColor:[UIColor colorWithHexString:@"32be60" alpha:1]];
            }

        }else
        {
            self.daan4.selected = NO;
            xuanxiang = [xuanxiang stringByReplacingOccurrencesOfString:@"D" withString:@""];
            answer4 = 0;
        }
    }
    else if (btn == self.quding)
    {
        
        if (xuanxiang.length == 0) {
            [WarningBox warningBoxModeText:@"您没有选择答案,请选择您的答案!" andView:self.view];
        }
        else
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
            [self.image removeFromSuperview];
            
            answer1 = 0; answer2 = 0; answer3 = 0; answer4 = 0;
            
            NSString * str1 = [arr[i] objectForKey:@"answer"];
            
            if ([str1 isEqualToString:xuanxiang] )
            {
                j = j + 10 ;
            }
            else
            {
                j = j + 0 ;
            }

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
            [self.image removeFromSuperview];
            
            answer1 = 0; answer2 = 0; answer3 = 0; answer4 = 0;
            
            NSString * str1 = [arr[i] objectForKey:@"answer"];
            
            NSMutableString *string = [[NSMutableString alloc ]init];
            [string insertString:xuanxiang atIndex:0];
            for (int p=0; p<[string length]-1; p++) {
                for (int q=p+1; q<[string length]; q++) {
                    int asciiCode1 = [string characterAtIndex:p];
                    int asciiCode2 =[string characterAtIndex:q];
                    if (asciiCode1>asciiCode2) {
                        NSString *string2 =[NSString stringWithFormat:@"%c",asciiCode2];
                        NSString *string3 =[NSString stringWithFormat:@"%c",asciiCode1];
                        [string replaceCharactersInRange:NSMakeRange(i, 1) withString:string2];
                        [string replaceCharactersInRange:NSMakeRange(j, 1) withString:string3];
                    }
                }
            }
            xuanxiang = [NSString  stringWithFormat:@"%@",string];
            
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
    }
    else if (btn == self.shangyiye)
    {
        
        [self.jieguo removeFromSuperview];
        [self.fenshu removeFromSuperview];
        [self.jiangpin removeFromSuperview];
        [self.shangyiye removeFromSuperview];
        [self.kuxiaoimage removeFromSuperview];
        [self.fenshuwei removeFromSuperview];
        
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
            
            _daan1.frame=CGRectMake(30, CGRectGetMaxY(self.wenti.frame) + 20, width - 60, 30);
            
        }];
        [UIView animateWithDuration:1.5 animations:^{
            
            _daan2.frame=CGRectMake(30, CGRectGetMaxY(self.daan1.frame) + 20, width - 60, 30);
            
        }];
        [UIView animateWithDuration:2 animations:^{
            
            _daan3.frame=CGRectMake(30, CGRectGetMaxY(self.daan2.frame) + 20, width - 60, 30);
            
        }];
        [UIView animateWithDuration:2.5 animations:^{
            
            _daan4.frame=CGRectMake(30,CGRectGetMaxY(self.daan3.frame) + 20, width - 60, 30);
            
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
