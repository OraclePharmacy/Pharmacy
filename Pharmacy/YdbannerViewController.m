//
//  YdbannerViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdbannerViewController.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
@interface YdbannerViewController ()<UIWebViewDelegate>
{
    int zan;
    NSString *dian;
    int cang;
    NSString *shou;
}
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property (weak, nonatomic) IBOutlet UIButton *shoucang;
- (IBAction)shoucang:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *dianzan;
- (IBAction)dianzan:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fenxiang;
- (IBAction)fenxiang:(id)sender;

@end

@implementation YdbannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;

    _webview.delegate=self;
    //导航栏标题
    self.navigationItem.title = @"活动详情";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];

    [self jiekou];
}
-(void)jiekou
{
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/postDetail/postDetail";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
   NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:self.xixi,@"id", vip,@"vipId",nil];
    
    NSLog(@"入参%@",datadic);
    
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
            //NSLog(@"%@",responseObject);
            
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                dian = [[responseObject objectForKey:@"data"] objectForKey:@"clickMark"];
                shou = [[responseObject objectForKey:@"data"] objectForKey:@"mark"];
                
                NSDictionary *post = [datadic objectForKey:@"post"];
                
                NSString*path=[NSString stringWithFormat:@"%@/hyb%@",service_host,[post objectForKey:@"shareUrl"]];
                
                NSLog(@"path:%@",path);
                
                NSURL *url=[NSURL URLWithString:path];
                
                [_webview loadRequest:[NSURLRequest requestWithURL:url]];
                
                [self kongjian];
                
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

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)kongjian
{
    //点赞
    if ([dian isEqualToString:@"0"])
    {
        zan = 2;
        [self.dianzan setBackgroundImage:[UIImage imageNamed:@"clicklike_light.png"] forState:UIControlStateNormal];
    }
    else if([dian isEqualToString:@"1"])
    {
        zan = 1;
        [self.dianzan setBackgroundImage:[UIImage imageNamed:@"iconfont-zanzan@3x.png"] forState:UIControlStateNormal];
    }
    //收藏
    if ([shou isEqualToString:@"0"])
    {
        cang = 2;
        [self.shoucang setBackgroundImage:[UIImage imageNamed:@"collection_light(1).png"] forState:UIControlStateNormal];
    }
    else if([shou isEqualToString:@"1"])
    {
        cang = 1;
        [self.shoucang setBackgroundImage:[UIImage imageNamed:@"collection_dark(1).png"] forState:UIControlStateNormal];
    }
    
    //分享
    [self.fenxiang setBackgroundImage:[UIImage imageNamed:@"share(1).png"] forState:UIControlStateNormal];
}

//收藏
- (IBAction)shoucang:(id)sender {
  NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
    if (cang == 1) {
        
        [self.shoucang setBackgroundImage:[UIImage imageNamed:@"collection_light(1).png"] forState:UIControlStateNormal];
        
        cang = 2;
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/share/newsCollect";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_xixi,@"id",@"0",@"type",vip,@"vipId",@"0",@"mark", nil];
        
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
                    
                    [WarningBox warningBoxModeText:@"点赞成功" andView:self.view];
                    
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
    else if (cang == 2) {
        
        [self.shoucang setBackgroundImage:[UIImage imageNamed:@"collection_dark(1).png"] forState:UIControlStateNormal];
        
        cang = 1;
        
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/share/newsCollect";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_xixi,@"id",@"0",@"type",vip,@"vipId",@"1",@"mark", nil];
        
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
                    
                    [WarningBox warningBoxModeText:@"点赞取消" andView:self.view];
                    
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
    
}

//点赞
- (IBAction)dianzan:(id)sender {
   NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];    if (zan == 1) {
        
        [self.dianzan setBackgroundImage:[UIImage imageNamed:@"clicklike_light.png"] forState:UIControlStateNormal];
        
        zan = 2;
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/share/clickLike";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_xixi,@"id",@"0",@"flag",vip,@"vipId",@"0",@"clickMark", nil];
        
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
                    
                    [WarningBox warningBoxModeText:@"点赞成功" andView:self.view];
                    
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
    else if (zan == 2) {
        
        [self.dianzan setBackgroundImage:[UIImage imageNamed:@"iconfont-zanzan@3x.png"] forState:UIControlStateNormal];
        
        zan = 1;
        
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/share/clickLike";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_xixi,@"id",@"0",@"flag",vip,@"vipId",@"0",@"clickMark", nil];
        
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
                    
                    [WarningBox warningBoxModeText:@"点赞取消" andView:self.view];
                    
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
    

}

//分享
- (IBAction)fenxiang:(id)sender {
    
    NSLog(@"分享");
    
}
@end
