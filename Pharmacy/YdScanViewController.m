//
//  YdScanViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdScanViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import "YdGenerateViewController.h"
#import "YdScanJumpViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "YddianyuanViewController.h"

#define QRCodeWidth  260.0   //正方形二维码的边长
#define SCREENWidth  [UIScreen mainScreen].bounds.size.width   //设备屏幕的宽度
#define SCREENHeight [UIScreen mainScreen].bounds.size.height //设备屏幕的高度
@interface YdScanViewController ()

@end

//需要添加一张图片    掏个洞的
@implementation YdScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"扫描";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self readqrcode];
}


-(void)readqrcode{
    float kuan=[[UIScreen mainScreen ] bounds].size.width;
    float gao=[[UIScreen mainScreen] bounds].size.height;
    //1.摄像头设置
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.设置输入
    NSError*error=nil;
    AVCaptureDeviceInput *input=[AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if(!input){
        
        return;
    }
    //3.设置输出
    AVCaptureMetadataOutput*output=[[AVCaptureMetadataOutput alloc] init];
    //3.1设置输出代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //4.拍摄会话
    AVCaptureSession*session=[[AVCaptureSession alloc] init];
    //添加session的输入与输出
    [session addInput:input];
    [session addOutput:output];
    //4.1设置输出的格式
    //二维码
    [output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode, nil]];
    //5.设置  预览图层
    AVCaptureVideoPreviewLayer*preview=[AVCaptureVideoPreviewLayer layerWithSession:session];
//    UIImageView* image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"123.png"]];
//    float w=[UIScreen mainScreen].bounds.size.width;
//    float h=[UIScreen mainScreen].bounds.size.height;
//    image.frame=CGRectMake(0, 64, w, h-124);
//    image.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    [self.view addSubview:image];
    [self setupMaskView];
    [self setupScanWindowView];
    
    //5.1设置preview的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //5.2设置preview的大小
    [preview setFrame:CGRectMake(0, 64,kuan, gao-64-60)];
    //添加一个按钮
    //5.3将图层添加到试图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    self.previewLayer=preview;
    //6.启动会话
    [session startRunning];
    self.session=session;
    
}

- (void)setupMaskView
{
    //设置统一的视图颜色和视图的透明度
    UIColor *color = [UIColor blackColor];
    float alpha = 0.7;
    
    //设置扫描区域外部上部的视图
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 64, SCREENWidth, (SCREENHeight-64-QRCodeWidth)/2.0-64);
    topView.backgroundColor = color;
    topView.alpha = alpha;
    
    //设置扫描区域外部左边的视图
    UIView *leftView = [[UIView alloc]init];
    leftView.frame = CGRectMake(0, 64+topView.frame.size.height, (SCREENWidth-QRCodeWidth)/2.0,QRCodeWidth);
    leftView.backgroundColor = color;
    leftView.alpha = alpha;
    
    //设置扫描区域外部右边的视图
    UIView *rightView = [[UIView alloc]init];
    rightView.frame = CGRectMake((SCREENWidth-QRCodeWidth)/2.0+QRCodeWidth,64+topView.frame.size.height, (SCREENWidth-QRCodeWidth)/2.0,QRCodeWidth);
    rightView.backgroundColor = color;
    rightView.alpha = alpha;
    
    //设置扫描区域外部底部的视图
    UIView *botView = [[UIView alloc]init];
    botView.frame = CGRectMake(0, 64+QRCodeWidth+topView.frame.size.height,SCREENWidth,SCREENHeight-64-60-QRCodeWidth-topView.frame.size.height);
    botView.backgroundColor = color;
    botView.alpha = alpha;
    
    //将设置好的扫描二维码区域之外的视图添加到视图图层上
    [self.view addSubview:topView];
    [self.view addSubview:leftView];
    [self.view addSubview:rightView];
    [self.view addSubview:botView];
}



- (void)setupScanWindowView
{
    //设置扫描区域的位置(考虑导航栏和电池条的高度为64)
    UIView *scanWindow = [[UIView alloc]initWithFrame:CGRectMake((SCREENWidth-QRCodeWidth)/2.0,(SCREENHeight-QRCodeWidth-64)/2.0,QRCodeWidth,QRCodeWidth)];
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
}
#pragma mark - 输出代理方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //1.如果扫描完成， 停止会话
    [self.session stopRunning];
    //2.删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    //3。设置界面显示扫描结果
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject*obj=metadataObjects[0];
        NSLog(@"objobjobj%@",obj);
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/share/appraiseInterface";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        NSString*zhid;
        NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
        zhid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
        NSString *stt = [NSString stringWithFormat:@"%@",obj.stringValue];
        NSLog(@"sttsttsttstt%@",stt);
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:zhid,@"officeId",stt,@"encode", nil];
        NSLog(@"datadicdatadic%@",datadic);
        NSString*jsonstring=[writer stringWithObject:datadic];
        //一二三四五六七八九十十一
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
                    
                    if ([_str isEqual:@"1"])
                    {
                        YdScanJumpViewController *SearchResult = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scanjump"];
                        
                        [self.navigationController pushViewController:SearchResult animated:YES];
                    }
                    else
                    {
                        YddianyuanViewController *dianyuan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"dianyuan"];
                        dianyuan.objectid=_objecct;
                        [self.navigationController pushViewController:dianyuan animated:YES];
                    }
                    
                }
                else{
                    [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] andView:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self readqrcode];
                    });
                    
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
- (IBAction)Jump:(id)sender {
    
    //跳转到会员码页面
    YdGenerateViewController *Generate = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"generate"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
    NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path];
    
    if ([pp objectForKey:@"age"]!=nil) {
       Generate.haha = [pp objectForKey:@"vipCode"];
        
    }else{
        
        NSString*hh=[[NSUserDefaults standardUserDefaults] objectForKey:@"shoujihao"];
        Generate.haha = hh;
    }
    [self.navigationController pushViewController:Generate animated:NO];
    
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
