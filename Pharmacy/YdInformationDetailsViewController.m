//
//  YdInformationDetailsViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdInformationDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
@interface YdInformationDetailsViewController ()<MPMediaPickerControllerDelegate>


@end

@implementation YdInformationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"健康电台";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    [self shipinbofang:nil];
//    [self wangluo];
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",nil];
    
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
            
            
            NSLog(@"%@",[NSString stringWithFormat:@"-------%@%@",service_host,shareUrl]);
            if ([[responseObject objectForKey:@"code"]isEqual:@"2222"]) {
                [self yinyuebofang:[NSString stringWithFormat:@"%@%@",service_host,shareUrl]];
            }else if([[responseObject objectForKey:@"code"]isEqual:@"1111"])
            {
                [self shipinbofang:[NSString stringWithFormat:@"%@%@",service_host,shareUrl]];
            }
            
            
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
//    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:sFileNamePath]];
    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:@"http://dlqncdn.miaopai.com/stream/VT40C6y1OVXhEdOt5kpgcg__.mp4"]];
    
    
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
