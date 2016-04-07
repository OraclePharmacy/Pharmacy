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
@interface YdScanViewController ()

@end

@implementation YdScanViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.previewLayer removeFromSuperlayer];
     [self readqrcode];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"扫描";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - 输出代理方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //1.如果扫描完成， 停止会话
    [self.session stopRunning];
    //2.删除预览图层
    [self.previewLayer removeFromSuperlayer];
    NSLog(@"%@",metadataObjects);
    
    //3。设置界面显示扫描结果
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject*obj=metadataObjects[0];
        NSLog(@"%@",obj.stringValue);
         YdScanJumpViewController *tiaotiao=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scanjump"];
        tiaotiao.jieshou=obj.stringValue;
        [self.navigationController pushViewController:tiaotiao animated:YES];
        
    }
}
- (IBAction)Jump:(id)sender {
    
    //跳转到会员码页面
    YdGenerateViewController *Generate = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"generate"];
    Generate.haha = @"2012021385";
    [self.navigationController pushViewController:Generate animated:NO];

    
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
