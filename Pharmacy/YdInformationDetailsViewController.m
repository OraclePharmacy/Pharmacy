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
{
    NSString*shareUrl;
    
    //音频
    AVAudioPlayer*audioPlayer;
    CGFloat durationTime;
    UIButton*yb1;
    UIButton*yb2;
    UIButton*yb3;
    NSTimer*time;
    UIProgressView*prog;
    
    
    MPMediaPickerController*mpc;
    MPMusicPlayerController*musicplayer;
    MPMediaItemCollection*itemlist;
    
}
@property(nonatomic,strong)MPMoviePlayerController* moviePlay;
@end

@implementation YdInformationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"id==%@-------类型==%@",_hahaha,_liexing);
    //状态栏名称
    self.navigationItem.title = @"健康电台";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    
    
    if ([_liexing integerValue]==1) {
        [self jiazaiyinpin];
    }else if ([_liexing integerValue]==2){
        [self jiazaiyinpin];
    }
}
-(void)jiazaishipin{
    }
-(void)jiazaiyinpin{
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
            
            NSLog(@"%@",responseObject);
            shareUrl=[[responseObject objectForKey:@"data"] objectForKey:@"shareUrl"];

            [self yinyuebofang];
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
-(void)yinyuebofang{
    self.moviePlay=[[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,shareUrl] ]];
    self.moviePlay.controlStyle=MPMovieControlStyleEmbedded;
    self.moviePlay.scalingMode=MPMovieScalingModeAspectFit;
    [self.moviePlay.view setFrame:self.view.bounds];
    UIButton*bu=[[UIButton alloc] initWithFrame:CGRectMake(80, 80, 50, 50)];
    [bu addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    bu.backgroundColor=[UIColor redColor];
    [self.moviePlay.view addSubview:bu];
    [self.view addSubview:self.moviePlay.view];

}
-(void)play:(UIButton *)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (sender.selected) {
        
        [self.moviePlay prepareToPlay];
    }else{
        
        [self.moviePlay stop];
    }
}


-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
