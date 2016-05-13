//
//  YdFaTieViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/11.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdFaTieViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"

@interface YdFaTieViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UILabel *tishi;
    
    CGFloat width;
    CGFloat height;
    
    NSArray *arr;
    NSString *bingzheng;
    
    int po;
}
@property (strong,nonatomic)UIImage *image;
@end

@implementation YdFaTieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    po = 0;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"发帖";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    //设置导航栏左按钮
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(fabu)];
    
    [self jiekou];
    [self textfieldshezhi];
    [self textviewshezhi];
    [self imageshezhi];
}
-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/product/attentionDisease";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil];
    
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
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            NSLog(@"responseObject%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                arr = [datadic objectForKey:@"attentionDiseaseList"];
                
                [self scrollviewshezhi];
                
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

//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.biaotiText resignFirstResponder];
    [self.neirongText resignFirstResponder];
    
}

//textfield 设置
-(void)textfieldshezhi
{
    self.biaotiText.delegate = self;
    self.biaotiText.layer.cornerRadius = 8;
    self.biaotiText.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.biaotiText.layer.borderWidth =1;

}
//textview 设置
-(void)textviewshezhi
{
    tishi = [[UILabel alloc]init];
    tishi.frame = CGRectMake(5, 5, 150, 21);
    tishi.textColor = [UIColor colorWithHexString:@"c8c8c8" alpha:1];
    tishi.font = [UIFont systemFontOfSize:13];
    tishi.text = @"请添加内容...";
    [self.neirongText addSubview:tishi];
    
    self.neirongText.delegate = self;
    self.neirongText.layer.cornerRadius = 8;
    self.neirongText.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.neirongText.layer.borderWidth =1;
}
-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        tishi.text = @"请添加内容...";
    }else{
        tishi.text = @"";
    }
}

//scrollview 设置
-(void)scrollviewshezhi
{
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 5;//用来控制button距离父视图的高
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 100 + i;
        button.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        //根据计算文字的大小
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGFloat length = [[arr[i] objectForKey:@"name"] boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:[arr[i] objectForKey:@"name"] forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 15 , 30);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length + 15 > width -10){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 15, 30);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [self.scrollView addSubview:button];
        
        self.scrollView.pagingEnabled = YES;
        
        self.scrollView.delegate = self;

    }

    //设置可滑动大小
    self.scrollView.contentSize = CGSizeMake(width - 20 , height / 3);
    //隐藏滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
}
- (void)handleClick:(UIButton *)btn
{
    
    bingzheng = [[NSString alloc]init];
    
    bingzheng = [arr[btn.tag - 100] objectForKey:@"id"];
    
    NSLog(@"%@",bingzheng);
    
}
//image 设置
-(void)imageshezhi
{
    
    self.image1.layer.cornerRadius = 8;
    self.image1.layer.masksToBounds = YES;
    [self.image1 setUserInteractionEnabled:YES];
    [self.image1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];

    self.image2.layer.cornerRadius = 8;
    self.image2.layer.masksToBounds = YES;
    [self.image2 setUserInteractionEnabled:YES];
    [self.image2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    //self.image2.hidden = YES;
    
    self.image3.layer.cornerRadius = 8;
    self.image3.layer.masksToBounds = YES;
    [self.image3 setUserInteractionEnabled:YES];
    [self.image3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    //self.image3.hidden = YES;

}
//image点击事件
-(void)clickCategory:(UITapGestureRecognizer*)image
{
    
    UIView *viewClicked=[image view];
    
    if (viewClicked == self.image1)
    {
        [self.view endEditing:YES];
        
        po=1;
        
        [self choosephoto];
        
        NSLog(@"imageView1");
        
    }
    else if(viewClicked == self.image2)
    {
        [self.view endEditing:YES];
        
        po=2;
        
        [self choosephoto];
        
        NSLog(@"imageView2");
        
    }
    else if(viewClicked == self.image3)
    {
        [self.view endEditing:YES];
        
        po=3;
        
        [self choosephoto];
        
        NSLog(@"imageView3");
        
    }
    
}
-(void)choosephoto{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    actionSheet.tag = 255;
    [actionSheet showInView:self.view];
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
    
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/fatie"];
    
    [fm createDirectoryAtPath:dicpath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *picpath=[NSString stringWithFormat:@"%@/%@",dicpath,imageName];
    
    
    [fm createFileAtPath:picpath contents:imageData attributes:nil];
    if (po==1) {
        
        _image1.image = [UIImage imageWithData:imageData];
       
    }else if(po==2){
        
        _image2.image = [UIImage imageWithData:imageData];
        
    }else if (po==3){
        
        _image3.image = [UIImage imageWithData:imageData];
        
    }else{
        
    }

}

-(void)fanhui
{
    [self.view endEditing:YES];
    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    NSString*path=[NSString stringWithFormat:@"%@/Documents/fatie",NSHomeDirectory()];
    [defaultManager removeItemAtPath:path error:NULL];
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)fabu
{
    [self.view endEditing:YES];
    NSMutableArray * heheda=[[NSMutableArray alloc] init];
    NSFileManager *fm1=[NSFileManager defaultManager];
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/fatie"];
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
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [formatter stringFromDate:[NSDate date]];
    
    
    
    [WarningBox warningBoxModeIndeterminate:@"正在上传...." andView:self.view];
    NSString*zhid;
    NSString *path6 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
    NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path6];
    zhid=[NSString stringWithFormat:@"%@",[pp objectForKey:@"id"]];
    
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/share/saveMyTopic";
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    //出入参数：
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:zhid,@"vipId",self.biaotiText.text,@"title",self.neirongText.text,@"context",now,@"createTime",bingzheng,@"id",nil];
    NSLog(@"传值%@",datadic);
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
                self.neirongText.text = @"";
                self.biaotiText.text = @"";
                //返回上一页
                [self.navigationController popViewControllerAnimated:YES];
                [WarningBox warningBoxModeText:@"上传成功!" andView:self.view];
                NSFileManager *defaultManager;
                defaultManager = [NSFileManager defaultManager];
                NSString*path=[NSString stringWithFormat:@"%@/Documents/fatie",NSHomeDirectory()];
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
