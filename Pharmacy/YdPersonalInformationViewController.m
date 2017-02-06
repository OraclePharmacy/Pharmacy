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
#import "SDWebImage/UIImageView+WebCache.h"
#import <JMessage/JMessage.h>

@interface YdPersonalInformationViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    CGFloat width;
    CGFloat height;
    
    NSString*zhid;
    
    UIButton *nan;
    UIButton *nv;
    UIImageView*toux;
    
    NSString *sex;
    
    UITextField* textField1 ;
    UITextField* textField2 ;
    UITextField* textField3 ;
    UITextField* textField4 ;
    UITextField* textField5 ;
    UITextField* textField6 ;
    UITextField* textField7 ;
    UITextField* textField8 ;
    
    UIView * pickerview;
    UIPickerView *picke;
    
    NSArray *stateArray;
    NSArray *cityArray;
    NSArray *areaArray;
    
    NSArray*bingzhengarr;
    
    NSDictionary *stateDic;
    NSDictionary *cityDic;
    
    
    NSData*imageData;
    
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
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    pickerview=[[UIView alloc] init];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    bingzhengarr=[NSArray array];
    //状态栏名称
    self.navigationItem.title = @"个人信息";
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _first = @[@"头像", @"昵称"];
    _second = @[@"姓名",@"性别",@"年龄",@"会员卡号(选填)",@"地区",@"详细地址",@"关注病症"];
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    //创建tableview
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height-64);
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [self.view addSubview:self.tableview];
    
    //代理协议
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
    NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path];
    zhid=[NSString stringWithFormat:@"%@",[pp objectForKey:@"id"]];
    if ([pp objectForKey:@"age"]==nil) {
        [self fuzhi:nil];
        
    }else
        [self fuzhi:pp];
}
-(void)bingzhengjiekou
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
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                NSLog(@"%@",datadic);
                bingzhengarr = [datadic objectForKey:@"attentionDiseaseList"];
                NSLog(@"%@",bingzhengarr);
                
                
                
                
                
                [self tan];
                
            }
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
    }];
    
}
-(void)tan{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"这是可以选择的关注病症哟" preferredStyle:UIAlertControllerStyleActionSheet];
    for (int index = 0; index < bingzhengarr.count; index++) {
        int  key = index;
        NSString*message=[NSString stringWithFormat:@"%@",[bingzhengarr[key] objectForKey:@"diseaseName"]];
        UIAlertAction * action = [UIAlertAction actionWithTitle:message style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"%@",[bingzhengarr[key] objectForKey:@"diseaseName"]);
            //给新家的lable填写信息;
            textField8.text=[bingzhengarr[key] objectForKey:@"diseaseName"];
            
        }];
        [alert addAction:action];
    }
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)fuzhi:(NSDictionary*)dd{
    textField1 = [[UITextField alloc]init];
    textField1.frame = CGRectMake(130, 10, width - 150, 20);
    textField1.textAlignment = NSTextAlignmentRight;
    textField1.font = [UIFont systemFontOfSize:13];
    textField1.delegate=self;
    textField1.placeholder = @"请输入昵称";
    
    textField2 = [[UITextField alloc]init];
    textField2.frame = CGRectMake(130, 10, width - 150, 20);
    textField2.textAlignment = NSTextAlignmentRight;
    textField2.font = [UIFont systemFontOfSize:13];
    textField2.delegate=self;
    textField2.placeholder = @"请输入姓名";
    
    textField3 = [[UITextField alloc]init];
    textField3.frame = CGRectMake(130, 10, width - 150, 20);
    textField3.textAlignment = NSTextAlignmentRight;
    textField3.font = [UIFont systemFontOfSize:13];
    textField3.delegate=self;
    textField3.keyboardType=UIKeyboardTypeNumberPad;
    textField3.placeholder = @"请输入年龄";
    
    textField4 = [[UITextField alloc]init];
    textField4.frame = CGRectMake(130, 10, width - 150, 20);
    textField4.textAlignment = NSTextAlignmentRight;
    textField4.font = [UIFont systemFontOfSize:13];
    textField4.delegate=self;
    textField4.keyboardType=UIKeyboardTypeNumberPad;
    textField4.placeholder = @"请输入会员卡号";
    
    textField5 = [[UITextField alloc]init];
    textField5.frame = CGRectMake(130, 10, width - 150, 20);
    textField5.textAlignment = NSTextAlignmentRight;
    textField5.font = [UIFont systemFontOfSize:13];
    textField5.delegate=self;
    textField5.placeholder = @"请输入地区";
    
    textField6 = [[UITextField alloc]init];
    textField6.frame = CGRectMake(130, 10, width - 150, 20);
    textField6.textAlignment = NSTextAlignmentRight;
    textField6.font = [UIFont systemFontOfSize:13];
    textField6.delegate=self;
    textField6.returnKeyType=UIReturnKeyDone;
    textField6.placeholder = @"请输入详细地址";
    
    textField8 = [[UITextField alloc]init];
    textField8.frame = CGRectMake(130, 10, width - 150, 20);
    textField8.textAlignment = NSTextAlignmentRight;
    textField8.font = [UIFont systemFontOfSize:13];
    textField8.delegate=self;
    textField8.returnKeyType=UIReturnKeyDone;
    textField8.placeholder = @"请选择要关注的病症";
    
    toux=[[UIImageView alloc] init];
    toux.userInteractionEnabled=YES;
    toux.frame=CGRectMake(width-80, 10, 60, 60);
    toux.layer.cornerRadius=30;
    toux.layer.masksToBounds=YES;
    toux.backgroundColor= [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    UITapGestureRecognizer *shoushifangfa=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhaoxiang)];
    [toux addGestureRecognizer:shoushifangfa];
    
    nan = [[UIButton alloc]init];
    nan.frame = CGRectMake(width - 80, 10, 30, 20);
    [nan setImage:[UIImage imageNamed:@"sex2@3x.png"] forState:UIControlStateNormal];
    [nan addTarget:self action:@selector(man) forControlEvents:UIControlEventTouchUpInside];
    
    nv = [[UIButton alloc]init];
    nv.frame = CGRectMake(width - 50, 10, 30, 20);
    [nv setImage:[UIImage imageNamed:@"sex1@3x.png"] forState:UIControlStateNormal];
    [nv addTarget:self action:@selector(woman) forControlEvents:UIControlEventTouchUpInside];
    
    if (dd==nil) {
        sex=nil;
        textField1.text=nil;
        textField2.text=nil;
        textField3.text=nil;
        textField4.text=nil;
        textField5.text=nil;
        textField6.text=nil;
        textField8.text=nil;
    }else{
        sex=[NSString stringWithFormat:@"%@",[dd objectForKey:@"sex"]];
        if ([sex isEqual:@"男"]) {
            [nan setImage:[UIImage imageNamed:@"sexnan@3x.png"] forState:UIControlStateNormal];
            [nv setImage:[UIImage imageNamed:@"sex1@3x.png"] forState:UIControlStateNormal];
        }else{
            [nan setImage:[UIImage imageNamed:@"sex2@3x.png"] forState:UIControlStateNormal];
            [nv setImage:[UIImage imageNamed:@"sexnv@3x.png"] forState:UIControlStateNormal];
        }
        textField1.text=[NSString stringWithFormat:@"%@",[dd objectForKey:@"nickName"]];;
        if (NULL == [dd objectForKey:@"nickName"]) {
            textField1.text=@"";
        }
        textField2.text=[NSString stringWithFormat:@"%@",[dd objectForKey:@"name"]];;
        textField3.text=[NSString stringWithFormat:@"%@",[dd objectForKey:@"age"]];;
        textField4.text=[NSString stringWithFormat:@"%@",[dd objectForKey:@"vipCode"]];;
        textField5.text=[NSString stringWithFormat:@"%@",[dd objectForKey:@"area"]];;
        textField6.text=[NSString stringWithFormat:@"%@",[dd objectForKey:@"detail"]];;
        textField8.text=[NSString stringWithFormat:@"%@",[dd objectForKey:@"bzType"]];;
    }
    NSFileManager*fm=[NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRtouxiang"];
    if ([fm fileExistsAtPath:path]) {
        toux.image =[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/110.jpg",path]];
        _image=toux.image;
    }else if([dd objectForKey:@"photo"]!=nil){
        //接取网络图片;   _image=tou.image;   toux.image=[UIImage ]
        NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/hyb/%@",service_host,[dd objectForKey:@"photo"]]];
        [toux sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"小人@2x.png"]];
        
    }else
        toux.image =[UIImage imageNamed:@"小人@2x.png"];
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
///////////////----------以下是tableview----------/////////////
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
        return 7;
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
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = self.first[indexPath.row];
        
        if (indexPath.row == 0)
        { //lable
            cell.textLabel.text = self.first[indexPath.row];
            //头像
            
            [cell.contentView addSubview:toux];
            
        }
        else
        {
            [cell.contentView addSubview:textField1];
        }
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = self.second[indexPath.row];
        if (indexPath.row == 1)
        {
            
            [cell.contentView addSubview:nan];
            [cell.contentView addSubview:nv];
        }else if (indexPath.row ==0){
            [cell addSubview:textField2];
        }else if (indexPath.row==2){
            [cell addSubview:textField3];
        }else if (indexPath.row==3){
            [cell addSubview:textField4];
        }else if (indexPath.row==4){
            [cell addSubview:textField5];
        }else if (indexPath.row==5){
            [cell addSubview:textField6];
        }else if (indexPath.row==6){
            [cell addSubview:textField8];
        }
        
        
    }
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
///////////////----------以上是tableview----------/////////////

///////////////----------以下是照相----------/////////////
//头像
-(void)zhaoxiang
{
    [self.view endEditing:YES];
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
    imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRtouxiang"];
    
    [fm createDirectoryAtPath:dicpath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *picpath=[NSString stringWithFormat:@"%@/%@",dicpath,imageName];
    
    [fm createFileAtPath:picpath contents:imageData attributes:nil];
    
    toux.image=[UIImage imageWithData:imageData];
    
    
}
///////////////----------以上是照相----------/////////////

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==textField5) {
        [self sanji];
        return NO;
    }else if (textField==textField8){
        [self bingzhengjiekou];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==textField1) {
        [textField2 becomeFirstResponder];
    }else if (textField==textField2) {
        [textField3 becomeFirstResponder];
    }else if (textField==textField3) {
        [textField4 becomeFirstResponder];
    }else if (textField==textField4) {
        [textField5 becomeFirstResponder];
    }else if (textField==textField5) {
        [textField6 becomeFirstResponder];
    }else if (textField==textField6) {
        [self.view endEditing:YES];
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [pickerview removeFromSuperview];
    pickerview=nil;
}

///////////////----------以下是三级联动----------/////////////
-(void)sanji
{
    [self.view endEditing:YES];
    if (pickerview) {
        [pickerview removeFromSuperview];
        pickerview=nil;
    }
    float w=[[UIScreen mainScreen] bounds].size.width;
    float h=[[UIScreen mainScreen] bounds].size.height;
    
    
    pickerview.hidden=NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil];
    
    
    stateArray = [NSArray arrayWithContentsOfFile:path];
    cityArray = [stateArray[0] objectForKey:@"cities"];
    areaArray = [cityArray[0] objectForKey:@"areas"];
    
    
    
    pickerview=[[UIView alloc] initWithFrame:CGRectMake(20, h, w-40, 200)];
    picke=[[UIPickerView alloc] initWithFrame:CGRectMake(20, 20, w-40, 200)];
    
    picke.delegate = self;
    picke.dataSource = self;
    
    [pickerview addSubview:picke];
    
    UIToolbar*tool=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, w, 50)];
    UIBarButtonItem*bb1=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(queding)];
    UIBarButtonItem*flex=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem*bb2=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(quxiao)];
    NSArray*arr9=[NSArray arrayWithObjects:bb1,flex,bb2, nil];
    tool.items=arr9;
    [pickerview addSubview:tool];
    
    [self.view addSubview:pickerview];
    [UIView animateWithDuration:0.3 animations:^{pickerview.frame=CGRectMake(0, h-220, w, 200);}];
}
//返回几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//每列有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component ==0)
    {
        return stateArray.count;
    }
    else if (component == 1)
    {
        return cityArray.count;
    }
    else
    {
        return areaArray.count;
    }
}
//每列显示
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *state= [stateArray[row] objectForKey:@"state"];
        
        return state;
        
    }else if (component == 1){
        
        NSString *city= [cityArray[row] objectForKey:@"city"];
        
        return city;
    }else{
        
        return areaArray[row];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        cityArray = [stateArray[row] objectForKey:@"cities"];
        areaArray = [cityArray[0]    objectForKey:@"areas" ];
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        if ([areaArray count] > 0) {
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
        
    }else if(component == 1){
        
        areaArray = [cityArray[row] objectForKey:@"areas"];
        
        
        [pickerView reloadComponent:2];
        if ([areaArray count] > 0) {
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return width/3;
    }
    else if (component == 1)
    {
        return width/4;
    }
    else if (component == 2)
    {
        return width*5/12;
    }
    
    
    return 0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)queding {
    [pickerview removeFromSuperview];
    
    stateDic = stateArray[[picke selectedRowInComponent:0]];
    
    NSString *state = [stateDic objectForKey:@"state"];
    
    cityDic = cityArray[[picke selectedRowInComponent:1]];
    
    NSString *city= [cityDic objectForKey:@"city"];
    
    NSString *area;
    if (areaArray.count > 0) {
        
        area = areaArray[[picke selectedRowInComponent:2]];
        
    }else{
        
        area = @"";
        
    }
    
    NSString *result = [[NSString alloc]initWithFormat:@"%@ %@ %@",state,city,area];
    
    textField5.text=result;
    
    //    self.bejing.hidden = YES;
    
    
}
- (void)quxiao {
    //    self.bejing.hidden = YES;
    pickerview.hidden = YES;
}
///////////////----------以上是三级联动----------/////////////


//保存方法
-(void)baocun
{
    if ([textField1.text isEqual:@""]||[textField2.text isEqual:@""]||[textField3.text isEqual:@""]||[textField5.text isEqual:@""]||[textField6.text isEqual:@""]||[textField8.text isEqual:@""]) {
        [WarningBox warningBoxModeText:@"请输入完整的信息!" andView:self.view];
    }else{
        if ([sex isEqual:@""]) {
            [WarningBox warningBoxModeText:@"请选择性别!" andView:self.view];
        }else{
            [WarningBox warningBoxModeIndeterminate:@"数据上传中...." andView:self.view];
            
            //请求地址   地址不同 必须要改
            NSString * url =@"/basic/savevipInfo";
            
            //将上传对象转换为json格式字符串
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
            //出入参数：
            NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
            NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:textField5.text,@"area",textField6.text,@"detail",vip,@"vipId",textField1.text,@"nickName",textField2.text,@"name",sex,@"sex",textField3.text,@"age",textField4.text,@"vipCode",textField8.text,@"bzType", nil];
            NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
            
            
            [manager POST:url1 parameters:datadic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                //对图片进行多个上传
                
                
                UIImage *Img=toux.image;
                NSData *data= UIImageJPEGRepresentation(Img, 0.5); //如果用png方法需添加png压缩方法
                NSDateFormatter *fm = [[NSDateFormatter alloc] init];
                // 设置时间格式
                fm.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [fm stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                [formData appendPartWithFileData:data name:@"photo" fileName:fileName mimeType:@"image/jpeg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [WarningBox warningBoxHide:YES andView:self.view];
                NSLog(@"the==========%@",responseObject);
                @try
                {
                    
                    
                    /*
                     userFieldType:
                     kJMSGUserFieldsNickname: 用户名
                     kJMSGUserFieldsBirthday: 生日
                     kJMSGUserFieldsSignature: 签名
                     kJMSGUserFieldsGender: 性别
                     kJMSGUserFieldsRegion: 区域
                     kJMSGUserFieldsAvatar: 头像
                     */
//                    [JMSGUser updateMyInfoWithParameter:imageData userFieldType:kJMSGUserFieldsAvatar  completionHandler:^(id resultObject, NSError *error) {
//                        if (!error) {
//                            NSLog(@"头像成功");
//                            //updateMyInfoWithPareter success
//                        } else {
//                            NSLog(@"头像失败----%@",error);
//                            //updateMyInfoWithPareter fail
//                        }
//                    }];
                    NSLog(@"responseObject:%@",responseObject);
                    [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                    if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                        //把上传的数据存到本地
                        
                        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
                        
                        NSDictionary*nono=[NSDictionary dictionaryWithContentsOfFile:path];
                        
                        NSString*xixi=[NSString stringWithFormat:@"%@",[nono objectForKey:@"photo"]];
                        
                        NSMutableDictionary*zhuan=[NSMutableDictionary dictionaryWithDictionary:datadic];
                        
                        [zhuan setObject:xixi forKey:@"photo"];
                        
                        [zhuan writeToFile:path atomically:YES];
                        
                        [self jiguangtouxianggenggai:imageData];
                        
                    }else{
                        [WarningBox warningBoxModeText:@"上传失败" andView:self.view];
                    }
                    
                    
                }
                @catch (NSException * e) {
                    
                    [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [WarningBox warningBoxHide:YES andView:self.view];
                [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
                
            }];
            
        }
    }
}
-(void)jiguangtouxianggenggai:(NSData*)image{
    
    [JMSGUser updateMyInfoWithParameter:image userFieldType:kJMSGUserFieldsAvatar completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //updateMyInfoWithPareter success
            [self fanhui];
        } else {
            //updateMyInfoWithPareter fail
            [super self];
        }
    }];
}
//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
@end
