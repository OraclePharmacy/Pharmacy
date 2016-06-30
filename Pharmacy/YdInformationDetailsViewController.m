//
//  YdInformationDetailsViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdInformationDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
@interface YdInformationDetailsViewController ()<MPMediaPickerControllerDelegate>
{
    CGFloat width;
    CGFloat height;
    
    UIButton *dianzan;
    UIButton *fenxiang;
    UIButton *shoucang;
    UIImageView *image;
    
    int zan;
    NSString *dian;
    int cang;
    NSString *shou;
}

@end

@implementation YdInformationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    //状态栏名称
    self.navigationItem.title = @"健康电台";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self wangluo];
//    [self shipinbofang:nil];
    
}
//创建cell显示控件
-(void)kongjian
{
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(5, 69, width - 10, 20);
    title.font = [UIFont systemFontOfSize:13];
    title.text = @"标题";
    title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    [self.view addSubview:title];
    
    UILabel *laiyuan = [[UILabel alloc]init];
    laiyuan.frame = CGRectMake(5, CGRectGetMaxY(title.frame), 100, 20);
    laiyuan.font = [UIFont systemFontOfSize:13];
    laiyuan.text = @"来源:网络";
    laiyuan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [self.view addSubview:laiyuan];
    
    UILabel *shijian = [[UILabel alloc]init];
    shijian.frame = CGRectMake(width - 155, CGRectGetMaxY(title.frame), 150, 20);
    shijian.font = [UIFont systemFontOfSize:13];
    shijian.text = @"2016-04-27 14:03:01";
    shijian.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
    shijian.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:shijian];
    
    UILabel *jianjie = [[UILabel alloc]init];
    jianjie.frame = CGRectMake(5, CGRectGetMaxY(laiyuan.frame), width - 10, 20);
    jianjie.font = [UIFont systemFontOfSize:13];
    jianjie.text = @"简介:方式打开垃圾分类萨科技风";
    jianjie.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [self.view addSubview:jianjie];
    
    image = [[UIImageView alloc]init];
    image.frame = CGRectMake(5, CGRectGetMaxY(jianjie.frame) + 5, width - 10, 150);
    //image.image = [UIImage imageNamed:@""];
    image.backgroundColor = [UIColor grayColor];
    [image setUserInteractionEnabled:YES];
    [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    [self.view addSubview:image];
    
    shoucang = [[UIButton alloc]init];
    shoucang.frame = CGRectMake(width - 70, CGRectGetMaxY(image.frame) + 10, 15, 15);
   // [shoucang setBackgroundImage:[UIImage imageNamed:@"collection_dark(1).png"] forState:UIControlStateNormal];
    [shoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoucang];
    
    dianzan = [[UIButton alloc]init];
    dianzan.frame = CGRectMake(width - 45, CGRectGetMaxY(image.frame) + 10, 15, 15);
    //[dianzan setBackgroundImage:[UIImage imageNamed:@"clicklike_dark(1).png"] forState:UIControlStateNormal];
    [dianzan addTarget:self action:@selector(dianzan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dianzan];
    
    fenxiang = [[UIButton alloc]init];
    fenxiang.frame = CGRectMake(width - 20, CGRectGetMaxY(image.frame) + 10, 15, 15);
    [fenxiang setBackgroundImage:[UIImage imageNamed:@"share(1).png"] forState:UIControlStateNormal];
    [fenxiang addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fenxiang];
    
    
    //点赞
    if ([dian isEqualToString:@"0"])
    {
        zan = 2;
        [dianzan setBackgroundImage:[UIImage imageNamed:@"clicklike_light.png"] forState:UIControlStateNormal];
    }
    else if([dian isEqualToString:@"1"])
    {
        zan = 1;
        [dianzan setBackgroundImage:[UIImage imageNamed:@"iconfont-zanzan@3x.png"] forState:UIControlStateNormal];
    }
    //收藏
    if ([shou isEqualToString:@"0"])
    {
        cang = 2;
        [shoucang setBackgroundImage:[UIImage imageNamed:@"collection_light(1).png"] forState:UIControlStateNormal];
    }
    else if([shou isEqualToString:@"1"])
    {
        cang = 1;
        [shoucang setBackgroundImage:[UIImage imageNamed:@"collection_dark(1).png"] forState:UIControlStateNormal];
    }

    
}
//点击手势
-(void)clickCategory:(UITapGestureRecognizer*)image1
{
    
    UIView *viewClicked=[image1 view];
    
    if (viewClicked == image)
    {
        [self.view endEditing:YES];
        //[self wangluo];
        NSLog(@"imageView1");
        
    }
}
//收藏
-(void)shoucang
{
    if (cang == 1) {
        
        [shoucang setBackgroundImage:[UIImage imageNamed:@"star_light.png"] forState:UIControlStateNormal];
        
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
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",@"1",@"type",@"1020",@"vipId",@"0",@"mark", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager GET:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
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
        
        [shoucang setBackgroundImage:[UIImage imageNamed:@"star_dark.png"] forState:UIControlStateNormal];
        
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
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",@"1",@"type",@"1020",@"vipId",@"1",@"mark", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager GET:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
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
-(void)dianzan
{
    if (zan == 1) {
        
        [dianzan setBackgroundImage:[UIImage imageNamed:@"clicklike_light.png"] forState:UIControlStateNormal];
        
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
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",@"1",@"flag",@"1020",@"vipId",@"0",@"clickMark", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager GET:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
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
        
        [dianzan setBackgroundImage:[UIImage imageNamed:@"iconfont-zanzan@3x.png"] forState:UIControlStateNormal];
        
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
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",@"1",@"flag",@"1020",@"vipId",@"1",@"clickMark", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager GET:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
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
-(void)fenxiang
{
    //这里写分享功能
}
-(void)wangluo{
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
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html",@"text/javascript", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",@"1020",@"vipId",nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    NSLog(@"%@",url1);
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    NSLog(@"%@",dic);
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try{
            
            [WarningBox warningBoxHide:YES andView:self.view];
            NSLog(@"－＊－＊－＊－＊－＊详情接口＊－＊－＊＊－\n\n\n%@",responseObject);
            NSString*shareUrl=[[responseObject objectForKey:@"data"] objectForKey:@"shareUrl"];
            dian = [[responseObject objectForKey:@"data"] objectForKey:@"clickMark"];
            shou = [[responseObject objectForKey:@"data"] objectForKey:@"mark"];
            [self kongjian];
            
            
            NSLog(@"%@",[NSString stringWithFormat:@"-------%@%@",service_host,shareUrl]);
//            if ([[responseObject objectForKey:@"code"]isEqual:@"2222"]) {
//                [self yinyuebofang:[NSString stringWithFormat:@"%@%@",service_host,shareUrl]];
//            }else if([[responseObject objectForKey:@"code"]isEqual:@"1111"])
//            {
//                [self shipinbofang:[NSString stringWithFormat:@"%@%@",service_host,shareUrl]];
//            }
//            
            
        }
        @catch (NSException * e) {
            [WarningBox warningBoxModeText:@"" andView:self.view];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        NSLog(@"错误：%@",error);
    }];
    
    
}
-(void)shipinbofang:(NSString *)sFileNamePath{
    NSLog(@"%@",sFileNamePath);
    
    
    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:sFileNamePath]];
//    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:@"http://dlqncdn.miaopai.com/stream/VT40C6y1OVXhEdOt5kpgcg__.mp4"]];
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [movie.moviePlayer prepareToPlay];
    
    [self presentMoviePlayerViewControllerAnimated:movie];
    
    [movie.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    
    
    [movie.view setBackgroundColor:[UIColor clearColor]];
    
    
    
    [movie.view setFrame:self.view.bounds];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                           selector:@selector(movieFinishedCallback:)
     
                                               name:MPMoviePlayerPlaybackDidFinishNotification
     
                                             object:movie.moviePlayer];
}

-(void)movieFinishedCallback:(NSNotification*)notify{
    
    
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    
    
    MPMoviePlayerController* theMovie = [notify object];
    
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
     
     
     
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
     
     
     
                                                object:theMovie];
    
    
    
    [self dismissMoviePlayerViewControllerAnimated];
    
    
    
}
-(void)yinyuebofang:(NSString*)sss{
    MPMoviePlayerViewController *moviePlayer =[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:sss ]];
    [moviePlayer.moviePlayer prepareToPlay];
    [self presentMoviePlayerViewControllerAnimated:moviePlayer]; // 这里是presentMoviePlayerViewControllerAnimated
    [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    [moviePlayer.view setBackgroundColor:[UIColor clearColor]];
    [moviePlayer.view setFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer.moviePlayer];
    
}


-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
