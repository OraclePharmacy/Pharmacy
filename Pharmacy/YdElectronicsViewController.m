//
//  YdElectronicsViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdElectronicsViewController.h"
#import "YdRecordListViewController.h"
#import "Color+Hex.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "lianjie.h"
#import "SBJsonWriter.h"
#import "WarningBox.h"
#import "hongdingyi.h"

@interface YdElectronicsViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UILabel *tishi;
    int po;
}
@property (strong,nonatomic)UIImage *image;
@end

@implementation YdElectronicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"电子病历";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    po=0;
    //设置导航栏右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(liebiao)];
    
    self.tijiao.layer.cornerRadius = 8;
    self.tijiao.layer.masksToBounds = YES;
    
    self.writeText.delegate = self;
    self.writeText.layer.cornerRadius = 8;
    self.writeText.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.writeText.layer.borderWidth =1;

    self.titleText.layer.cornerRadius = 8;
    self.titleText.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.titleText.layer.borderWidth =1;

    tishi = [[UILabel alloc]init];
    tishi.frame = CGRectMake(5, 5, 150, 21);
    tishi.textColor = [UIColor colorWithHexString:@"c8c8c8" alpha:1];
    tishi.font = [UIFont systemFontOfSize:13];
    tishi.text = @"请对病历进行备注...";
    
    self.titleText.delegate = self;
    
    [self.view endEditing:YES];
    
    [_writeText addSubview:tishi];

}

//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.titleText resignFirstResponder];
    [self.writeText resignFirstResponder];
    
}


-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        tishi.text = @"请对病历进行备注...";
    }else{
        tishi.text = @"";
    }
}

//电子病历列表跳转
-(void)liebiao
{
    [self.view endEditing:YES];
    YdRecordListViewController *RecordList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"recordlist"];
    [self.navigationController pushViewController:RecordList animated:YES];
}

-(void)fanhui
{   NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    NSString*path=[NSString stringWithFormat:@"%@/Documents/dianzibinglitupian",NSHomeDirectory()];
    [defaultManager removeItemAtPath:path error:NULL];
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)choosephoto{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    actionSheet.tag = 255;
    [actionSheet  showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    NSUInteger sourceType = 0;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        switch (buttonIndex) {
            case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                return;
            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
                
            case 2:
                
                // 取消
                break;
        }
    }
    else {
        if (buttonIndex == 0) {
            
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:NO completion:^{}];
    
    //        [imagePickerController release];
    
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    [picker dismissViewControllerAnimated:NO completion:^{}];
    
    _image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 保存图片至本地，方法见下文
    
    //按时间为图片命名
    NSDateFormatter *forr=[[NSDateFormatter alloc] init];
    
    [forr setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *name=[NSString stringWithFormat:@"%d.jpg",po/*[forr stringFromDate:[NSDate date]]*/];
    
    [self saveImage:_image withName:name];
    
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/dianzibinglitupian"];
    
    [fm createDirectoryAtPath:dicpath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *picpath=[NSString stringWithFormat:@"%@/%@",dicpath,imageName];
        
    [fm createFileAtPath:picpath contents:imageData attributes:nil];
    if (po==1) {
        
        [_first setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    }else if(po==2){
        [_second setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    }else if (po==3){
        [_third setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    }else{
        
    }
    
}

- (IBAction)first:(id)sender {
    [self.view endEditing:YES];
    po=1;
    [self choosephoto];
}
- (IBAction)second:(id)sender {
    [self.view endEditing:YES];
    po=2;
    [self choosephoto];
}
- (IBAction)third:(id)sender {
    [self.view endEditing:YES];
    po=3;
    [self choosephoto];
}
- (IBAction)tijiao:(id)sender {
    [self.view endEditing:YES];
   
    NSMutableArray * heheda=[[NSMutableArray alloc] init];
    NSFileManager *fm1=[NSFileManager defaultManager];
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/dianzibinglitupian"];
    NSString *picpath=[NSString stringWithFormat:@"%@/1.jpg",dicpath];
    NSString *picpath1=[NSString stringWithFormat:@"%@/2.jpg",dicpath];
    NSString *picpath2=[NSString stringWithFormat:@"%@/3.jpg",dicpath];
    NSArray*apq=[NSArray arrayWithObjects:picpath,picpath1,picpath2, nil];
    for (int i=0; i<apq.count; i++) {
        if ([fm1 fileExistsAtPath: apq[i]]) {
            [heheda addObject:apq[i]];
        }
    }

    NSString*now;
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    now = [formatter stringFromDate:[NSDate date]];
    
    
    //后台写的跟个傻逼似的 擦
    
    [WarningBox warningBoxModeIndeterminate:@"正在上传...." andView:self.view];
    NSString*vip;
    NSString *path6 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
    NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path6];
    vip=[NSString stringWithFormat:@"%@",[pp objectForKey:@"id"]];
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/basic/saveEmr";
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    //出入参数：
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_titleText.text,@"title",_writeText.text,@"emrDesc",vip,@"vipId",now,@"tjsj", nil];
    NSLog(@"%@",datadic);
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    [manager POST:url1 parameters:datadic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<heheda.count; i++) {
            //对图片进行多个上传
            UIImage *Img=[UIImage imageWithContentsOfFile:heheda[i]];
            NSData *data= UIImageJPEGRepresentation(Img, 0.5); //如果用jpg方法需添加jpg压缩方法
            NSDateFormatter *fm = [[NSDateFormatter alloc] init];
            // 设置时间格式
            fm.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [fm stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@___%d.png", str,i];
            NSLog(@"filename------%@",fileName);
            [formData appendPartWithFileData:data name:@"urls" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%.2f%%",uploadProgress.fractionCompleted*100);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            
            NSLog(@"电子病历返回－－－＊＊＊＊－－－－\n\n\n%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                [WarningBox warningBoxModeText:@"上传成功!" andView:self.view];
                NSFileManager *defaultManager;
                defaultManager = [NSFileManager defaultManager];
                NSString*path=[NSString stringWithFormat:@"%@/Documents/dianzibinglitupian",NSHomeDirectory()];
                [defaultManager removeItemAtPath:path error:NULL];
                
            }else{
                [WarningBox warningBoxModeIndeterminate:@"上传失败!" andView:self.view];
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
@end
