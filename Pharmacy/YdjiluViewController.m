//
//  YdjiluViewController.m
//  Pharmacy
//
//  Created by suokun on 16/7/1.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdjiluViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
@interface YdjiluViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *name1;
    NSMutableArray *changshang1;
    NSMutableArray *time1;
    NSMutableArray *cishu1;
    NSMutableArray *tupian1;
    NSDictionary* dic2;
    NSData *imageData;
    int ccc;
}
@end

@implementation YdjiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    name1 = [[NSMutableArray alloc]init];
    changshang1 = [[NSMutableArray alloc]init];
    time1 = [[NSMutableArray alloc]init];
    cishu1 = [[NSMutableArray alloc]init];
    tupian1 = [[NSMutableArray alloc]init];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:@"zhihui.plist"];
    
    //判断是否已经创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
        
        ccc = 1;
        //读文件
        dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
        
    }else {
        
        ccc = 2;
        
    }

    //状态栏名称
    self.navigationItem.title = @"药品详情";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.name.delegate = self;
    self.changshang.delegate = self;
    self.time.delegate = self;
    self.cishu.delegate = self;
    
    self.baocun.layer.cornerRadius = 5;
    self.baocun.layer.masksToBounds = YES;
    
    [self tupian];
}

-(void)tupian
{
    //self.photo.backgroundColor = [UIColor redColor];
    self.photo.layer.cornerRadius = 10;
    self.photo.layer.masksToBounds = YES;
    UITapGestureRecognizer *shoushifangfa=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhaoxiang)];
    [self.photo addGestureRecognizer:shoushifangfa];
    [self.photo setUserInteractionEnabled:YES];
}
-(void)zhaoxiang
{
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
    
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 保存图片至本地，方法见下文
    
    //按时间为图片命名
    NSDateFormatter *forr=[[NSDateFormatter alloc] init];
    
    [forr setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *name=[NSString stringWithFormat:@"%@.jpg",@"tianjia"/*[forr stringFromDate:[NSDate date]]*/];
    
    [self saveImage:image withName:name];
    
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/dianzibinglitupian"];
    
    [fm createDirectoryAtPath:dicpath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *picpath=[NSString stringWithFormat:@"%@/%@",dicpath,imageName];
    
    [fm createFileAtPath:picpath contents:imageData attributes:nil];

        
   _photo.image=[UIImage imageWithData:imageData];
    
}

//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.name resignFirstResponder];
    [self.changshang resignFirstResponder];
    [self.time resignFirstResponder];
    [self.cishu resignFirstResponder];
    
}
//textfield点击return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.name)
    {
        [self.changshang becomeFirstResponder];
    }
    else if (textField == self.changshang)
    {
        [self.time becomeFirstResponder];
    }
    else if (textField == self.time)
    {
        [self.cishu becomeFirstResponder];
    }
    else if (textField == self.cishu)
    {
        [self.view endEditing:YES];
    }

    return YES;
}



-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)baocun:(id)sender {
    
    if (self.name.text.length == 0 || self.changshang.text.length == 0 || self.time.text.length == 0 || self.cishu.text.length == 0)
    {
        
         [WarningBox warningBoxModeText:@"请填写全部内容" andView:self.view];
        
    }
    else
    {
        
        if (ccc == 1)
        {
            if ([[dic2 objectForKey:@"name"] count] == 0 )
            {
                
                name1 = [[NSMutableArray alloc]init];
                changshang1 = [[NSMutableArray alloc]init];
                time1 = [[NSMutableArray alloc]init];
                cishu1 = [[NSMutableArray alloc]init];
                tupian1 = [[NSMutableArray alloc]init];
                
                [name1 addObject:self.name.text];
                [changshang1 addObject:self.changshang.text];
                [time1 addObject:self.time.text];
                [cishu1 addObject:self.cishu.text];
                [tupian1 addObject:imageData];
            }
            else
            {
                name1 = [dic2 objectForKey:@"name"];
                changshang1 = [dic2 objectForKey:@"changshang"];
                time1 = [dic2 objectForKey:@"time"];
                cishu1 = [dic2 objectForKey:@"cishu"];
                tupian1 = [dic2 objectForKey:@"tupian"];
                
                [name1 addObject:self.name.text];
                [changshang1 addObject:self.changshang.text];
                [time1 addObject:self.time.text];
                [cishu1 addObject:self.cishu.text];
                [tupian1 addObject:imageData];
            }
           
        }
        else if ( ccc == 2)
        {
            [name1 addObject:self.name.text];
            [changshang1 addObject:self.changshang.text];
            [time1 addObject:self.time.text];
            [cishu1 addObject:self.cishu.text];
            [tupian1 addObject:imageData];
        }
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths    objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"zhihui.plist"];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:name1,@"name",changshang1,@"changshang",time1,@"time",cishu1,@"cishu",tupian1,@"tupian",nil]; //写入数据
        
        //NSLog(@"%@",dic);
        [dic writeToFile:filename atomically:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加成功" message:@"您已添加成功,是否继续添加?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
    
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.name.text = @"";
        self.changshang.text =@"";
        self.cishu.text = @"";
        self.time.text = @"";
        self.photo.image = [UIImage imageNamed:@"相机@2x.png"];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if (buttonIndex == 1)
    {
        self.name.text = @"";
        self.changshang.text =@"";
        self.cishu.text = @"";
        self.time.text = @"";
        self.photo.image = [UIImage imageNamed:@"相机@2x.png"];
    }
}
@end
