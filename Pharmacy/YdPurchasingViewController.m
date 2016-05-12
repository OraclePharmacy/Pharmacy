//
//  YdPurchasingViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdPurchasingViewController.h"
#import "Color+Hex.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "WarningBox.h"
#import "SBJsonWriter.h"
#import "hongdingyi.h"
#import "lianjie.h"
@interface YdPurchasingViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    int po;
    UILabel *tishi;
}
@property (strong,nonatomic)UIImage *image;
@end

@implementation YdPurchasingViewController

- (void)viewDidLoad {
    po=0;
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"代购药";
    
    
    NSFileManager *fm=[NSFileManager defaultManager];
    //完整的图片路径，如果图片是放在文件夹中的话，还要在中间加上文件夹的路径
    NSString *imagepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"];
    
    //可以打印路径看看是什么情况
    if ([fm fileExistsAtPath:[NSString stringWithFormat:@"%@/1.jpg",imagepath]]) {
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/1.jpg",imagepath]];
        [_one setBackgroundImage:image forState:UIControlStateNormal];
    }
    if ([fm fileExistsAtPath:[NSString stringWithFormat:@"%@/2.jpg",imagepath]]) {
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/2.jpg",imagepath]];
        [_one setBackgroundImage:image forState:UIControlStateNormal];
    }
    if ([fm fileExistsAtPath:[NSString stringWithFormat:@"%@/3.jpg",imagepath]]) {
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/3.jpg",imagepath]];
        [_one setBackgroundImage:image forState:UIControlStateNormal];
    }

    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    self.yuding.layer.cornerRadius = 8;
    self.yuding.layer.masksToBounds = YES;
    
    self.beizhu.delegate = self;
    self.beizhu.layer.cornerRadius = 8;
    self.beizhu.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.beizhu.layer.borderWidth =1;
    
    self.nametext.layer.cornerRadius = 8;
    self.nametext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.nametext.layer.borderWidth =1;

    self.guigetext.layer.cornerRadius = 8;
    self.guigetext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.guigetext.layer.borderWidth =1;
    
    self.changjiatext.layer.cornerRadius = 8;
    self.changjiatext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.changjiatext.layer.borderWidth =1;
    
    self.shuliangtext.layer.cornerRadius = 8;
    self.shuliangtext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.shuliangtext.layer.borderWidth =1;
    
    self.pizhuntext.layer.cornerRadius = 8;
    self.pizhuntext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.pizhuntext.layer.borderWidth =1;
    

    tishi = [[UILabel alloc]init];
    tishi.frame = CGRectMake(5, 5, 150, 21);
    tishi.textColor = [UIColor colorWithHexString:@"c8c8c8" alpha:1];
    tishi.font = [UIFont systemFontOfSize:13];
    tishi.text = @"请对药品进行备注...";
    
    [_beizhu addSubview:tishi];

}

//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.beizhu resignFirstResponder];
    [self.nametext resignFirstResponder];
    [self.guigetext resignFirstResponder];
    [self.changjiatext resignFirstResponder];
    [self.shuliangtext resignFirstResponder];
    [self.pizhuntext resignFirstResponder];
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        tishi.text = @"请对药品进行备注...";
    }else{
        tishi.text = @"";
    }
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)choosephoto{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    actionSheet.tag = 255;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
        
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"];
    
    [fm createDirectoryAtPath:dicpath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *picpath=[NSString stringWithFormat:@"%@/%@",dicpath,imageName];
    
    NSLog(@"%@",picpath);
    [fm createFileAtPath:picpath contents:imageData attributes:nil];
    if (po==1) {

        [_one setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    }else if(po==2){
        [_two setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    }else if (po==3){
        [_three setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    }else{
        
    }
   
    
}

//照片1
- (IBAction)one:(id)sender {
    [self.view endEditing:YES];
    po=1;
    [self choosephoto];
}
//照片2
- (IBAction)two:(id)sender {
    [self.view endEditing:YES];
    po=2;
    [self choosephoto];
}
//照片3
- (IBAction)three:(id)sender {
    [self.view endEditing:YES];
    po=3;
    [self choosephoto];
}
//预定按钮
- (IBAction)yuding:(id)sender {
    [self.view endEditing:YES];
    NSMutableArray * heheda=[[NSMutableArray alloc] init];
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"];
    NSString *picpath=[NSString stringWithFormat:@"%@/0.jpg",dicpath];
    NSString *picpath1=[NSString stringWithFormat:@"%@/1.jpg",dicpath];
    NSString *picpath2=[NSString stringWithFormat:@"%@/2.jpg",dicpath];
    NSArray*apq=[NSArray arrayWithObjects:picpath,picpath1,picpath2, nil];
    for (int i=0; i<apq.count; i++) {
        if ([fm isExecutableFileAtPath:apq[i]]) {
            [heheda addObject:dicpath];
        }
    }
    
    //后台写的跟个傻逼似的 擦
    
    [WarningBox warningBoxModeIndeterminate:@"正在帮您代购药...." andView:self.view];
    NSString*zhid;
    NSString *path6 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
    NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path6];
    zhid=[NSString stringWithFormat:@"%@",[pp objectForKey:@"id"]];

    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/saveNewSpecPreOrderByPic";
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    //出入参数：
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_nametext.text,@"drugName",_guigetext.text,@"specification",zhid,@"vipId",_changjiatext.text,@"manufacturer",_shuliangtext.text,@"amount",_pizhuntext.text,@"batchNo",_beizhu.text,@"remark", nil];
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
            
            NSLog(@"代购要返回－－－＊＊＊＊－－－－\n\n\n%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                [WarningBox warningBoxModeText:@"代购药成功!" andView:self.view];
                NSFileManager *defaultManager;
                defaultManager = [NSFileManager defaultManager];
                NSString*path=[NSString stringWithFormat:@"%@/Documents/images",NSHomeDirectory()];
                [defaultManager removeItemAtPath:path error:NULL];
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
