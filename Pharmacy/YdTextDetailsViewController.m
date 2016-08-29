//
//  YdTextDetailsViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdTextDetailsViewController.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
@interface YdTextDetailsViewController ()<UIWebViewDelegate,UMSocialUIDelegate>
{
    int zan;
    NSString *dian;
    int cang;
    NSString *shou;
}
@property (weak, nonatomic) IBOutlet UIWebView *halou;

@end

@implementation YdTextDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _halou.hidden=YES;
    //状态栏名称
    self.navigationItem.title = @"文字资讯";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self diaojiekou];
}

-(void)diaojiekou
{
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/integralGift/newsDetailList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_xixi,@"id", vip,@"vipId",nil];
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
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                NSString*path=[NSString stringWithFormat:@"%@/hyb%@",service_host,[[responseObject objectForKey:@"data"] objectForKey:@"shareUrl"]];
                
                dian = [[responseObject objectForKey:@"data"] objectForKey:@"clickMark"];
                shou = [[responseObject objectForKey:@"data"] objectForKey:@"mark"];
                
                [self kongjian];
                
                [self xianshi:path];
                
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
-(void)xianshi:(NSString*)hehe
{
    _halou.hidden=NO;
    NSString * path1=hehe/*@"http:www.baidu.com"*/;
    NSURL *url=[NSURL URLWithString:path1];
    [_halou loadRequest:[NSURLRequest requestWithURL:url]];
    
    _halou.delegate=self;
    _halou.opaque=NO;
    _halou.backgroundColor=[UIColor clearColor];
    //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
    for (UIView *_aView in [_halou subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    
    //    禁用UIWebView左右滚动
    
    [(UIScrollView *)[[_halou subviews] objectAtIndex:0] setBounces:NO];
    
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

- (IBAction)fenxiang:(id)sender {
    
    
    //这里写分享功能
    
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    
    [UMSocialData defaultData].extConfig.title = @"索坤接招！！";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:@"索坤  你是大傻子！！"
                                     shareImage:[UIImage imageNamed:@"IMG_0797.jpg"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
    
}

//实现回调方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
    }
}



- (IBAction)shoucang:(id)sender {
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
        NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_xixi,@"id",@"1",@"type",vip,@"vipId",@"0",@"mark", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
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
        NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_xixi,@"id",@"1",@"type",vip,@"vipId",@"1",@"mark", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        }];
        
        
    }
    
    
    
}

- (IBAction)dianzan:(id)sender {
    if (zan == 1) {
        
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
        NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_xixi,@"id",@"1",@"flag",vip,@"vipId",@"0",@"clickMark", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
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
        NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_xixi,@"id",@"1",@"flag",vip,@"vipId",@"1",@"clickMark", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        }];
        
        
    }
    
    
}
@end
