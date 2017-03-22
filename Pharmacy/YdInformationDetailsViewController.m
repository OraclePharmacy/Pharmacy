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
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UMSocial.h"
#import "HSDownloadManager.h"
#define HSFileName(url) url.md5String
#define HSFileFullpath(url) [HSCachesDirectory stringByAppendingPathComponent:HSFileName(url)]
@interface YdInformationDetailsViewController ()</*NSURLSessionDownloadDelegate,*/MPMediaPickerControllerDelegate,UMSocialUIDelegate>
{
    CGFloat width;
    CGFloat height;
    
    NSURL *uuuu;
    UIButton *dianzan;
    UIButton *fenxiang;
    UIButton *shoucang;
    UIImageView *image;
    
    int zan;
    NSString *dian;
    int cang;
    NSString *shou;
    
    NSString*shareUrl;
    
    int bo ;
}

/**全局管理的对话*/
@property(nonatomic, strong)NSURLSession *session;
@property (nonatomic , strong)MPMoviePlayerViewController *movie;
@end

@implementation YdInformationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    width = [UIScreen mainScreen].bounds.size.width - 20;
    height = [UIScreen mainScreen].bounds.size.height;
    //状态栏名称
    self.navigationItem.title = @"健康电台";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self wangluo];
    
    
}
//创建cell显示控件
-(void)kongjian
{
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(20, 69, width - 20, 30);
    title.font = [UIFont systemFontOfSize:17];
    title.text = [NSString stringWithFormat:@"%@",[_doc objectForKey:@"title"]];
    title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    [self.view addSubview:title];
    
    UILabel *laiyuan = [[UILabel alloc]init];
    laiyuan.frame = CGRectMake(20, CGRectGetMaxY(title.frame), 100, 30);
    laiyuan.font = [UIFont systemFontOfSize:15];
    laiyuan.text = [NSString stringWithFormat:@"来源:%@",[_doc objectForKey:@"source"]];
    laiyuan.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
    [self.view addSubview:laiyuan];
    
    UILabel *shijian = [[UILabel alloc]init];
    shijian.frame = CGRectMake(width - 155, CGRectGetMaxY(title.frame), 150, 30);
    shijian.font = [UIFont systemFontOfSize:13];
    shijian.text = [NSString stringWithFormat:@"%@",[_doc objectForKey:@"createTime"]];
    shijian.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
    shijian.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:shijian];
    
    UIScrollView *scl=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    UILabel *jianjie = [[UILabel alloc]init];
    jianjie.frame = CGRectMake(20, CGRectGetMaxY(laiyuan.frame), width - 10, 100);
    
    jianjie.text = [NSString stringWithFormat:@"简介:%@",[_doc objectForKey:@"subtitle"]];
    jianjie.numberOfLines=0;
    
    if (width==414)
        jianjie.font=[UIFont systemFontOfSize:15.0f];
    else
        jianjie.font=[UIFont systemFontOfSize:13.0f];
    
    jianjie.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
    
    //
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:jianjie.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, jianjie.text.length)];
    
    jianjie.attributedText = attributedString;
    [jianjie sizeToFit];
    
    [scl addSubview:jianjie];
    
    scl.contentSize=CGSizeMake(width, 70+CGRectGetMaxY(jianjie.frame));
    
    [self.view addSubview:scl];
    
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[_doc objectForKey:@"picUrl"]] ;
    image = [[UIImageView alloc]init];
    image.contentMode=UIViewContentModeScaleAspectFit;
    image.frame = CGRectMake(20, CGRectGetMaxY(jianjie.frame) + 5, width - 20, 200);
    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
    [image setUserInteractionEnabled:YES];
    [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    [self.view addSubview:image];
    
    shoucang = [[UIButton alloc]init];
    shoucang.frame = CGRectMake(width - 65, CGRectGetMaxY(image.frame) + 20, 25, 25);
    //shoucang.backgroundColor = [UIColor redColor];
    [shoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoucang];
    
    dianzan = [[UIButton alloc]init];
    dianzan.frame = CGRectMake(width - 105, CGRectGetMaxY(image.frame) + 20, 25, 25);
    //dianzan.backgroundColor = [UIColor redColor];
    [dianzan addTarget:self action:@selector(dianzan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dianzan];
    
    fenxiang = [[UIButton alloc]init];
    fenxiang.frame = CGRectMake(width - 25, CGRectGetMaxY(image.frame) + 20, 25, 25);
    //fenxiang.backgroundColor = [UIColor redColor];
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
        
        if (bo == 1) {
            [self yinyuebofang:[NSString stringWithFormat:@"%@%@",service_host,shareUrl]];
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",service_host,shareUrl]);
        }
        else if (bo == 2){
            
            NSString*shipinlujing=[NSString stringWithFormat:@"%@%@",service_host,shareUrl];
          
            if ([HSDownloadManager panduan:shipinlujing]) {
                [self downloadFile2:shipinlujing];
            }else{
                [self downloadFile2:shipinlujing];
            }
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",service_host,shareUrl]);
        }
    }
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
    NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",vip,@"vipId",nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try{
            
            [WarningBox warningBoxHide:YES andView:self.view];
            shareUrl=[[responseObject objectForKey:@"data"] objectForKey:@"shareUrl"];
            dian = [[responseObject objectForKey:@"data"] objectForKey:@"clickMark"];
            shou = [[responseObject objectForKey:@"data"] objectForKey:@"mark"];
            
            [self kongjian];
            
            if ([[responseObject objectForKey:@"code"]isEqual:@"2222"]) {
                bo = 1;
            }else if([[responseObject objectForKey:@"code"]isEqual:@"1111"])
            {
                bo = 2;
            }
        }
        @catch (NSException * e) {
            [WarningBox warningBoxModeText:@"" andView:self.view];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
    }];
    
    
}
UILabel* progressLabel;
NSString*oos;
- (void)downloadFile2:(NSString *)ss
{
//    ss=@"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
    progressLabel=[[UILabel alloc] init];
     progressLabel.text=@"0%";
    oos=progressLabel.text;
    __block int i=0;
    [WarningBox warningBoxModeIndeterminate:oos andView:self.view];
    [[HSDownloadManager sharedInstance] download:ss progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
//        [WarningBox warningBoxHide:YES andView:self.view];
            
            
            progressLabel.text = [NSString stringWithFormat:@"%.f%%", [[HSDownloadManager sharedInstance] progress:ss] * 100];
            
            if ([progressLabel.text floatValue]>100) {
                
                if(i == 0){
                [WarningBox warningBoxHide:YES andView:self.view];
                [WarningBox warningBoxModeText:@"视频格式不支持" andView:self.view];
                    i++;
                return ;
                }
            }else{
            if (![oos isEqualToString: progressLabel.text]) {
                oos = progressLabel.text;
                [WarningBox warningBoxModeIndeterminate:oos andView:self.view];
            }
            if([progressLabel.text isEqualToString:@"100%"]){
                [WarningBox warningBoxHide:YES andView:self.view];
            }NSLog(@"%@",progressLabel.text);
            }
        });
    } state:^(DownloadState state) {
        if (state == DownloadStateCompleted) {
            [WarningBox warningBoxHide:YES andView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self shipinbofang:ss];
            });
            
        }else if(state == DownloadStateFailed){
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"视频格式不支持" andView:self.view];
        }
    }];
}
-(void)shipinbofang:(NSString*)ioio{
    
    @try {
        
        [WarningBox warningBoxHide:YES andView:self.view];
        NSString*path=[HSDownloadManager lujing:ioio];
        NSURL *URL = [[NSURL alloc] initFileURLWithPath:path];
        _movie = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [_movie.moviePlayer prepareToPlay];
        
        [self presentMoviePlayerViewControllerAnimated:_movie];
        
        [_movie.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        
        _movie.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
        
        [_movie.view setBackgroundColor:[UIColor clearColor]];
        
        
        [_movie.view setFrame:self.view.bounds];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(movieFinishedCallback:)
         
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
         
                                                   object:_movie.moviePlayer];
        
        
    } @catch (NSException *exception) {
        NSLog(@"哈哈哈");
    }
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
        NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",@"1",@"type",vip,@"vipId",@"0",@"mark", nil];
        
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
        NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",@"1",@"type",vip,@"vipId",@"1",@"mark", nil];
        
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
        NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",@"1",@"flag",vip,@"vipId",@"0",@"clickMark", nil];
        
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
        NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_hahaha,@"id",@"1",@"flag",vip,@"vipId",@"1",@"clickMark", nil];
        
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
//分享
-(void)fenxiang
{
    //这里写分享功能
    
    [UMSocialData defaultData].extConfig.title = @"接招！！";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:@"你是大傻子！！"
                                     shareImage:[UIImage imageNamed:@"IMG_0797.jpg"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
    
    
    
}
@end
