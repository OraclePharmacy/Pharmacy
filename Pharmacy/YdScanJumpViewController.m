//
//  YdScanJumpViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdScanJumpViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "YdmendianxinxiViewController.h"
#import "RatingBar.h"

@interface YdScanJumpViewController ()<RatingBarDelegate,UITextViewDelegate>
{
    CGFloat width;
    CGFloat height;
    UILabel *tishi;
    
    NSString *str1;
    NSString *str2;
    NSString *str3;
    NSString *dengji;
}
@property (nonatomic,strong) UILabel *mLabel;

@property (nonatomic,strong) RatingBar *ratingBar1;
@property (nonatomic,strong) RatingBar *ratingBar2;
@property (nonatomic,strong) RatingBar *ratingBar3;

@property (nonatomic,strong) UITextView *textview;
@property (nonatomic,strong) UIButton *haoping;
@property (nonatomic,strong) UIButton *zhongping;
@property (nonatomic,strong) UIButton *chaping;
@property (nonatomic,strong) UILabel *huanjing;
@property (nonatomic,strong) UILabel *taidu;
@property (nonatomic,strong) UILabel *zhuanye;
@property (nonatomic,strong) UIButton *tijiao;

@end

@implementation YdScanJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    //状态栏名称
    self.navigationItem.title = @"评论";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    //RatingBar1
    self.ratingBar1 = [[RatingBar alloc] initWithFrame:CGRectMake(80, 260, 200, 20)];
    //添加到view中
    [self.view addSubview:self.ratingBar1];
    //是否是指示器
    self.ratingBar1.isIndicator = NO;
    [self.ratingBar1 setImageDeselected:@"star_dark.png" halfSelected:@"bx.png" fullSelected:@"star_light.png" andDelegate:self];
    
    //RatingBar2
    self.ratingBar2 = [[RatingBar alloc] initWithFrame:CGRectMake(80, 290, 200, 20)];
    //添加到view中
    [self.view addSubview:self.ratingBar2];
    //是否是指示器
    self.ratingBar2.isIndicator = NO;
    [self.ratingBar2 setImageDeselected:@"star_dark.png" halfSelected:@"bx.png" fullSelected:@"star_light.png" andDelegate:self];
    
    //RatingBar3
    self.ratingBar3 = [[RatingBar alloc] initWithFrame:CGRectMake(80, 320, 200, 20)];
    //添加到view中
    [self.view addSubview:self.ratingBar3];
    //是否是指示器
    self.ratingBar3.isIndicator = NO;
    [self.ratingBar3 setImageDeselected:@"star_dark.png" halfSelected:@"bx.png" fullSelected:@"star_light.png" andDelegate:self];
    
    [self kongjian];
}

-(void)kongjian
{
    self.textview = [[UITextView alloc]init];
    self.textview.frame = CGRectMake(10, 70, width - 20, 150);
    self.textview.delegate = self;
    self.textview.layer.cornerRadius = 8;
    self.textview.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.textview.layer.borderWidth =1;
    [self.view addSubview:self.textview];
    
    tishi = [[UILabel alloc]init];
    tishi.frame = CGRectMake(5, 5, 150, 21);
    tishi.textColor = [UIColor colorWithHexString:@"c8c8c8" alpha:1];
    tishi.font = [UIFont systemFontOfSize:13];
    tishi.text = @"请添加内容...";
    [self.textview addSubview:tishi];
    
    //好评
    self.haoping = [[UIButton alloc]init];
    self.haoping.frame = CGRectMake(width - 180, 230, 50, 16);
    [self.haoping setTitleColor:[UIColor colorWithHexString:@"646464" alpha:1 ] forState:UIControlStateNormal];
    [self.haoping setTitle:@"好评" forState:UIControlStateNormal];
    self.haoping.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.haoping setImage:[UIImage imageNamed:@"clicklike_dark(1).png"] forState:UIControlStateNormal];
    [self.haoping setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.haoping setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,34)];
    [self.haoping addTarget:self action:@selector(pingjia:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.haoping];
    //中评
    self.zhongping = [[UIButton alloc]init];
    self.zhongping.frame = CGRectMake(width - 120, 230, 50, 16);
    [self.zhongping setTitleColor:[UIColor colorWithHexString:@"646464" alpha:1 ] forState:UIControlStateNormal];
    [self.zhongping setTitle:@"中评" forState:UIControlStateNormal];
    self.zhongping.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.zhongping setImage:[UIImage imageNamed:@"clicklike_dark(1).png"] forState:UIControlStateNormal];
    [self.zhongping setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.zhongping setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,34)];
    [self.zhongping addTarget:self action:@selector(pingjia:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zhongping];
    //差评
    self.chaping = [[UIButton alloc]init];
    self.chaping.frame = CGRectMake(width - 60, 230, 50, 16);
    [self.chaping setTitleColor:[UIColor colorWithHexString:@"646464" alpha:1 ] forState:UIControlStateNormal];
    [self.chaping setTitle:@"差评" forState:UIControlStateNormal];
    self.chaping.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.chaping setImage:[UIImage imageNamed:@"clicklike_dark(1).png"] forState:UIControlStateNormal];
    [self.chaping setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.chaping setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,34)];
    [self.chaping addTarget:self action:@selector(pingjia:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chaping];
    
    self.huanjing = [[UILabel alloc]init];
    self.huanjing.frame = CGRectMake(10, 264, 80, 20);
    self.huanjing.text = @"门店环境:";
    self.huanjing.font = [UIFont systemFontOfSize:15];
    self.huanjing.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [self.view addSubview:self.huanjing];
    
    self.taidu = [[UILabel alloc]init];
    self.taidu.frame = CGRectMake(10, 294, 80, 20);
    self.taidu.text = @"服务态度:";
    self.taidu.font = [UIFont systemFontOfSize:15];
    self.taidu.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [self.view addSubview:self.taidu];
    
    self.zhuanye = [[UILabel alloc]init];
    self.zhuanye.frame = CGRectMake(10, 326, 80, 20);
    self.zhuanye.text = @"专业水平:";
    self.zhuanye.font = [UIFont systemFontOfSize:15];
    self.zhuanye.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [self.view addSubview:self.zhuanye];
    
    self.tijiao = [[UIButton alloc]init];
    self.tijiao.frame = CGRectMake(30, 370, width - 60 , 30);
    [self.tijiao setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    [self.tijiao setTitle:@"评论" forState:UIControlStateNormal];
    self.tijiao.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    self.tijiao.layer.cornerRadius = 5;
    [self.tijiao addTarget:self action:@selector(tijiaoanniu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tijiao];
    
}
-(void)pingjia:(UIButton *)btn
{
    if (btn == self.haoping)
    {
        [self.haoping setImage:[UIImage imageNamed:@"clicklike_light(1).png"] forState:UIControlStateNormal];
        [self.zhongping setImage:[UIImage imageNamed:@"clicklike_dark(1).png"] forState:UIControlStateNormal];
        [self.chaping setImage:[UIImage imageNamed:@"clicklike_dark(1).png"] forState:UIControlStateNormal];
        dengji = @"1";
    }
    else if (btn == self.zhongping)
    {
        [self.haoping setImage:[UIImage imageNamed:@"clicklike_dark(1).png"] forState:UIControlStateNormal];
        [self.zhongping setImage:[UIImage imageNamed:@"clicklike_light(1).png"] forState:UIControlStateNormal];
        [self.chaping setImage:[UIImage imageNamed:@"clicklike_dark(1).png"] forState:UIControlStateNormal];
        dengji = @"2";
    }
    else if (btn == self.chaping)
    {
        [self.haoping setImage:[UIImage imageNamed:@"clicklike_dark(1).png"] forState:UIControlStateNormal];
        [self.zhongping setImage:[UIImage imageNamed:@"clicklike_dark(1).png"] forState:UIControlStateNormal];
        [self.chaping setImage:[UIImage imageNamed:@"clicklike_light(1).png"] forState:UIControlStateNormal];
        dengji = @"3";
    }
    
}
-(void)tijiaoanniu
{
    
    if ([self.textview.text  isEqual:@""]||str1.length==0||str2.length==0||str3.length==0||dengji.length==0) {
        [WarningBox warningBoxModeText:@"请输入完整信息！" andView:self.view];
    }else{
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/function/saveAppraise";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        NSString*officeid=[[NSUserDefaults standardUserDefaults] objectForKey:@"officeid"];
        NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:str1,@"appraiseItem1",str2,@"appraiseItem2",str3,@"appraiseItem3",self.textview.text,@"content", dengji,@"level",@"0",@"type",vip,@"vipId",officeid,@"objectId",nil];
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
                // [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                
                if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                    [WarningBox warningBoxModeText:@"评价成功！" andView:self.navigationController.view];
                    
                    YdmendianxinxiViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mendianxinxi"];
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[xln class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                    
                    
                }
                
                
            }
            @catch (NSException * e) {
                
                [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        }];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        tishi.text = @"请添加内容...";
    }else{
        tishi.text = @"";
    }
}

//五角星输出
-(void)ratingBar:(RatingBar *)ratingBar ratingChanged:(float)newRating{
    if (self.ratingBar1 == ratingBar) {
        str1 = [NSString stringWithFormat:@"%.1f",newRating];
        //self.mLabel.text = [NSString stringWithFormat:@"第一个评分条的当前结果为:%.1f",newRating];
    }
    else if (self.ratingBar2 == ratingBar) {
        str2 = [NSString stringWithFormat:@"%.1f",newRating];
        //self.mLabel.text = [NSString stringWithFormat:@"第一个评分条的当前结果为:%.1f",newRating];
    }
    else if (self.ratingBar3 == ratingBar) {
        str3 = [NSString stringWithFormat:@"%.1f",newRating];
        //self.mLabel.text = [NSString stringWithFormat:@"第一个评分条的当前结果为:%.1f",newRating];
    }
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
