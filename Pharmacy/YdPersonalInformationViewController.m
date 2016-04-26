//
//  YdPersonalInformationViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdPersonalInformationViewController.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "Color+Hex.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "WarningBox.h"
#import "SBJsonWriter.h"
@interface YdPersonalInformationViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    CGFloat width;
    CGFloat height;
    
    UIButton *nan;
    UIButton *nv;
    UIButton *touxiang;
    
    
    NSString *sex;
    
    UITextField* textField1 ;
    UITextField* textField2 ;
    UITextField* textField3 ;
    UITextField* textField4 ;
    UITextField* textField5 ;
    UITextField* textField6 ;
    UITextField* textField7 ;
}
@property (strong , nonatomic) UIImage * image;
@property (strong,nonatomic)UITableView *tableview;
@property (nonatomic, strong) NSArray *first;
@property (nonatomic, strong) NSArray *second;
@property (nonatomic, strong) NSArray *third;

@end

@implementation YdPersonalInformationViewController

//选取照片之后   界面   上边  没有现实；
//昵称需要正则判断不能有特殊符号,长度不能超过6个字；
//

- (void)viewDidLoad {
    [super viewDidLoad];
    sex=@"";
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    _first = @[@"头像", @"昵称"];
    _second = @[@"姓名",@"性别",@"年龄",@"会员卡号(选填)",@"地区",@"详细地址"];
    _third = @[@"请输入姓名",@"",@"请输入年龄",@"请输入会员卡号",@"请选择地区",@"请输入详细地址"];
    
    //创建tableview
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height-64);
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [self.view addSubview:self.tableview];
    //代理协议
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
}
//性别
-(void)man
{
    [nan setImage:[UIImage imageNamed:@"sexnan@3x.png"] forState:UIControlStateNormal];
    [nv setImage:[UIImage imageNamed:@"sex1@3x.png"] forState:UIControlStateNormal];
    sex = @"男";
}
-(void)woman
{
    [nan setImage:[UIImage imageNamed:@"sex2@3x.png"] forState:UIControlStateNormal];
    [nv setImage:[UIImage imageNamed:@"sexnv@3x.png"] forState:UIControlStateNormal];
    
    sex = @"女";
}
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0) {
        return 2;
    }
    else if (section == 1)
    {
        return 6;
    }
    return 0;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ( indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        }
        else
            return 40;
    }
    else
        return 40;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 20;
    }
    else if (section ==2){
        return 80;
    }
    return 0;
}
//header
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    if (section == 2) {
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(50, 20, width-100, 30);
        btn.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setTintColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1]];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(baocun) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
    }
    
    return baseView;
}
//保存方法
-(void)baocun
{
    NSLog(@"%@%@%@%@%@%@%@",textField1.text,textField2.text,textField3.text,textField4.text,textField5.text,textField6.text,sex);
    if ([textField1.text isEqual:@""]||[textField2.text isEqual:@""]||[textField3.text isEqual:@""]||[textField4.text isEqual:@""]||[textField5.text isEqual:@""]||[textField6.text isEqual:@""]) {
         NSLog(@"请输入完整的信息!");
    }else{
       if ([sex isEqual:@""]) {
           NSLog(@"请选择性别!");
       }else{
               [WarningBox warningBoxModeIndeterminate:@"数据上传中...." andView:self.view];
           
               //请求地址   地址不同 必须要改
               NSString * url =@"/basic/savevipInfo";
           
               //将上传对象转换为json格式字符串
               AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
               manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
               //出入参数：
               NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"area",@"",@"detail",@"1000",@"vipId",@"小狼",@"nickName",@"斌小狼",@"name",sex,@"sex",@"18",@"age",@"2012021385",@"vipCode", nil];
               NSLog(@"%@",datadic);
           
               NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
           
               [manager POST:url1 parameters:datadic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                   //对图片进行多个上传
           
                   UIImage *Img=_image;
                   NSData *data= UIImageJPEGRepresentation(Img, 0.5); //如果用png方法需添加png压缩方法
                   NSDateFormatter *fm = [[NSDateFormatter alloc] init];
                   // 设置时间格式
                   fm.dateFormat = @"yyyyMMddHHmmss";
                   NSString *str = [fm stringFromDate:[NSDate date]];
                   NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                   NSLog(@"filename------%@",fileName);
                   [formData appendPartWithFileData:data name:@"photo" fileName:fileName mimeType:@"image/jpeg"];
               } progress:^(NSProgress * _Nonnull uploadProgress) {
           
               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   [WarningBox warningBoxHide:YES andView:self.view];
                   @try
                   {
                       [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                       NSLog(@"%@",responseObject);
                       if ([[responseObject objectForKey:@"code"] intValue]==0000) {
           
                           [self dismissViewControllerAnimated:YES completion: nil ];
           
           
           
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
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    //lable
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    //textField.backgroundColor = [UIColor redColor];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = self.first[indexPath.row];
        
        if (indexPath.row == 0)
        { //lable
            cell.textLabel.text = self.first[indexPath.row];
            
            //头像
            touxiang = [[UIButton alloc]init];
            touxiang.frame = CGRectMake(width - 80, 10, 60, 60);
            [touxiang setImage:[UIImage imageNamed:@"小人@2x.png"] forState:UIControlStateNormal];
            touxiang.layer.cornerRadius = 30;
            touxiang.layer.masksToBounds = YES;
            touxiang.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
            [touxiang addTarget:self action:@selector(zhaoxiang) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:touxiang];
        }
        else
        {   textField1 = [[UITextField alloc]init];
            textField1.frame = CGRectMake(130, 10, width - 150, 20);
            textField1.textAlignment = NSTextAlignmentRight;
            textField1.font = [UIFont systemFontOfSize:13];
            textField1.delegate=self;
            textField1.placeholder = @"请输入昵称";
            [cell.contentView addSubview:textField1];
        }
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = self.second[indexPath.row];
        
        if (indexPath.row == 1)
        {
            nan = [[UIButton alloc]init];
            nan.frame = CGRectMake(width - 80, 10, 30, 20);
            [nan setImage:[UIImage imageNamed:@"sex2@3x.png"] forState:UIControlStateNormal];
            [nan addTarget:self action:@selector(man) forControlEvents:UIControlEventTouchUpInside];
            
            
            nv = [[UIButton alloc]init];
            nv.frame = CGRectMake(width - 50, 10, 30, 20);
            [nv setImage:[UIImage imageNamed:@"sex1@3x.png"] forState:UIControlStateNormal];
            [nv addTarget:self action:@selector(woman) forControlEvents:UIControlEventTouchUpInside];
    
            [cell.contentView addSubview:nan];
            [cell.contentView addSubview:nv];
            
            
        }else if (indexPath.row ==0){
            textField2 = [[UITextField alloc]init];
            textField2.frame = CGRectMake(130, 10, width - 150, 20);
            textField2.textAlignment = NSTextAlignmentRight;
            textField2.font = [UIFont systemFontOfSize:13];
            textField2.delegate=self;
            textField2.placeholder = self.third[indexPath.row];
            [cell addSubview:textField2];
        }else if (indexPath.row==2){
            textField3 = [[UITextField alloc]init];
            textField3.frame = CGRectMake(130, 10, width - 150, 20);
            textField3.textAlignment = NSTextAlignmentRight;
            textField3.font = [UIFont systemFontOfSize:13];
            textField3.delegate=self;
            textField3.keyboardType=UIKeyboardTypeNumberPad;
            textField3.placeholder = self.third[indexPath.row];
            [cell addSubview:textField3];
        }else if (indexPath.row==3){
            textField4 = [[UITextField alloc]init];
            textField4.frame = CGRectMake(130, 10, width - 150, 20);
            textField4.textAlignment = NSTextAlignmentRight;
            textField4.font = [UIFont systemFontOfSize:13];
            textField4.delegate=self;
            textField4.keyboardType=UIKeyboardTypeNumberPad;
            textField4.placeholder = self.third[indexPath.row];
            [cell addSubview:textField4];
        }else if (indexPath.row==4){
            textField5 = [[UITextField alloc]init];
            textField5.frame = CGRectMake(130, 10, width - 150, 20);
            textField5.textAlignment = NSTextAlignmentRight;
            textField5.font = [UIFont systemFontOfSize:13];
            textField5.delegate=self;
            textField5.placeholder = self.third[indexPath.row];
            [cell addSubview:textField5];
        }else if (indexPath.row==5){
            textField6 = [[UITextField alloc]init];
            textField6.frame = CGRectMake(130, 10, width - 150, 20);
            textField6.textAlignment = NSTextAlignmentRight;
            textField6.font = [UIFont systemFontOfSize:13];
            textField6.delegate=self;
            textField6.placeholder = self.third[indexPath.row];
            [cell addSubview:textField6];
        }

        
    }
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 1;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return baseView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏键盘
    [self.view endEditing:YES];
    
}

//头像
-(void)zhaoxiang
{
    [self choosephoto];
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
    
    NSString *name=[NSString stringWithFormat:@"110.jpg"/*[forr stringFromDate:[NSDate date]]*/];
    
    [self saveImage:_image withName:name];
    
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRtouxiang"];
    
    [fm createDirectoryAtPath:dicpath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *picpath=[NSString stringWithFormat:@"%@/%@",dicpath,imageName];
    
    NSLog(@"%@",picpath);
    [fm createFileAtPath:picpath contents:imageData attributes:nil];
   
        
    [touxiang setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
   
    //局部cell刷新  www.2cto.com
    NSIndexPath *te=[NSIndexPath indexPathForRow:0 inSection:0];//刷新第一个section的第二行
    [_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationMiddle];
        
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==textField6) {
        return NO;
    }
    return YES;
}



//返回
- (IBAction)fanhui:(id)sender {
    
    [ self dismissViewControllerAnimated: YES completion: nil ];
    
}
@end
