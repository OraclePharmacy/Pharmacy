//
//  YdRegisterViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/18.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdRegisterViewController.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"


@interface YdRegisterViewController ()
{
    NSArray *arr;
    NSString *str;
    
    CGFloat width;
    
    NSArray *stateArray;
    NSArray *cityArray;
    NSArray *areaArray;
    
    NSDictionary *stateDic;
    NSDictionary *cityDic;
    
    
}
@end

@implementation YdRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PhoneText.text = @"18345559961";
    self.PassText.text = @"111111";
    self.AgainPassText.text = @"111111";
    
    self.RecommendedText.text = @"";
    self.StoreText.text = @"黑龙江";
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.bejing.hidden = YES;
    self.tableview.hidden = YES;
    self.pickerview.hidden = YES;
    
    width = [UIScreen mainScreen].bounds.size.width;
    
    //导航栏名称
    self.navigationItem.title = @"注册";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];

    [self TextFieldSetUp];

}

//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.PhoneText resignFirstResponder];
    [self.VerificationText resignFirstResponder];
    [self.RecommendedText resignFirstResponder];
    [self.PassText resignFirstResponder];
    [self.AgainPassText resignFirstResponder];
    [self.StoreText resignFirstResponder];
    
}
//设置textfield
-(void)TextFieldSetUp
{
    self.PhoneText.delegate = self;
    self.VerificationText.delegate = self;
    self.RecommendedText.delegate = self;
    self.PassText.delegate = self;
    self.AgainPassText.delegate = self;
    self.StoreText.delegate = self;
    
    [self.PhoneText addTarget:self action:@selector(PhoneSetLength) forControlEvents:UIControlEventEditingChanged];
    [self.VerificationText addTarget:self action:@selector(VerificationLength) forControlEvents:UIControlEventEditingChanged];
    [self.RecommendedText addTarget:self action:@selector(RecommendedPhoneSetLength) forControlEvents:UIControlEventEditingChanged];
    [self.PassText addTarget:self action:@selector(PassSetLength) forControlEvents:UIControlEventEditingChanged];
    [self.AgainPassText addTarget:self action:@selector(AgainPassSetLength) forControlEvents:UIControlEventEditingChanged];

}
#pragma 限制textfield的长度
//设置手机号长度
-(void)PhoneSetLength
{
    int MaxLen = 11;
    NSString* szText = [_PhoneText text];
    if ([_PhoneText.text length]> MaxLen)
    {
        _PhoneText.text = [szText substringToIndex:MaxLen];
    }
}
//设置手机号长度
-(void)RecommendedPhoneSetLength
{
    int MaxLen = 11;
    NSString* szText = [_RecommendedText text];
    if ([_RecommendedText.text length]> MaxLen)
    {
        _RecommendedText.text = [szText substringToIndex:MaxLen];
    }
}
//设置验证码长度
-(void)VerificationLength
{
    int MaxLen = 4;
    NSString* szText = [_VerificationText text];
    if ([_VerificationText.text length]> MaxLen)
    {
        _VerificationText.text = [szText substringToIndex:MaxLen];
    }
}

//设置密码长度
-(void)PassSetLength
{
    int MaxLen = 16;
    NSString* szText = [_PassText text];
    if ([_PassText.text length]> MaxLen)
    {
        _PassText.text = [szText substringToIndex:MaxLen];
    }
}
//设置密码长度
-(void)AgainPassSetLength
{
    int MaxLen = 16;
    NSString* szText = [_AgainPassText text];
    if ([_AgainPassText.text length]> MaxLen)
    {
        _AgainPassText.text = [szText substringToIndex:MaxLen];
    }
}

#pragma 正则判断手机号密码是否正确
//判断手机号是否正确
-(BOOL)isMobileNumberClassification:(NSString *)mobile{
    if (mobile.length != 11){
        
        return NO;
        
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        //手机号正确表达式
        //        NSString *mm = @"[1][34578]\\d{9}";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}
//验证密码
-(BOOL)mima:(NSString *)pass{
    
    NSString *password = @"^[a-zA-Z0-9]{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",password];
    BOOL isMatch = [pred evaluateWithObject:pass];
    return isMatch;
    
}
//textfield点击return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.PhoneText)
    {
        [self.PassText becomeFirstResponder];
    }
    else if (textField == self.VerificationText)
    {
        [self.RecommendedText becomeFirstResponder];
    }
    else if (textField == self.RecommendedText)
    {
        [self.PassText becomeFirstResponder];
    }
    else if (textField == self.PassText)
    {
        [self.AgainPassText becomeFirstResponder];
    }
    else if (textField == self.AgainPassText)
    {
        [self.StoreText becomeFirstResponder];
    }
    else
    {
         [self.StoreText becomeFirstResponder];
    }
    return YES;
}
#pragma textfield点击事件
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.StoreText) {
        
        [WarningBox warningBoxModeIndeterminate:@"定位门店中..." andView:self.view];
        
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/Store/getLonLat";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"126.663513",@"longitude",@"45.716008",@"latitude",nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        NSLog(@"url1%@",url1);
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        NSLog(@"dic%@",dic);
        [manager GET:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            @try
            {
                [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                NSLog(@"%@",responseObject);
                if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                    
                    NSDictionary*datadic=[responseObject valueForKey:@"data"];
                    arr = [datadic objectForKey:@"mdList"];
                    
                    
                    if (arr.count == 1)
                    {
                        self.StoreText.text = [arr[0] objectForKey:@"office"];
                        str = [arr[0] objectForKey:@"id"];
                    }
                    else if (arr.count > 1)
                    {
                        
                        self.bejing.hidden = NO;
                        self.tableview.hidden = NO;
                        [self.tableview reloadData];
                        
                    }
                    else
                    {
                        self.bejing.hidden = NO;
                        self.pickerview.hidden = NO;
                        [self sanji];
                    }
                    
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
        
        return NO;
    }
    return YES;
}
#pragma 设置tableview
//tableview 分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//tableview 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)arr.count);
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 = @"cell3";
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UILabel *name = [[UILabel alloc]init];
    name.frame  =  CGRectMake(0, 0, 150, 39);
    name.font = [UIFont systemFontOfSize:15.0];
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = [UIColor blackColor];
    name.text = [arr[indexPath.row] objectForKey:@"name"];;
    
    [cell.contentView addSubview:name];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.StoreText.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"name"]];
    str = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"id"]];
    self.tableview.hidden = YES;
    self.bejing.hidden = YES;
}
#pragma 创建三级联动
-(void)sanji
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil];
    
    stateArray = [NSArray arrayWithContentsOfFile:path];
    cityArray = [stateArray[0] objectForKey:@"cities"];
    areaArray = [cityArray[0] objectForKey:@"areas"];
    
    self.picke.delegate = self;
    self.picke.dataSource = self;

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
        
        NSString *state = [stateArray[row] objectForKey:@"state"];
        return state;
        
    }else if (component == 1){
        
        NSString *city = [cityArray[row] objectForKey:@"city"];
        return city;
    }else{
        
        return areaArray[row];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        cityArray = [stateArray[row] objectForKey:@"cities"];
        areaArray = [cityArray[0] objectForKey:@"areas"];
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
        return width/3;
    }
    else if (component == 2)
    {
        return width/3;
    }
    
    
    return 0;
}


#pragma 按钮点击事件

//验证码
- (IBAction)VerificationButton:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.PhoneText.text.length > 0 )
    {
        if (![self isMobileNumberClassification:self.PhoneText.text])
        {
            
            [WarningBox warningBoxModeText:@"请输入正确的手机号" andView:self.view];
         
        }
        else if([self isMobileNumberClassification:self.PhoneText.text])
        {
            [WarningBox warningBoxModeIndeterminate:@"正在获取验证码..." andView:self.view];
            
            //userID    暂时不用改
            NSString * userID=@"0";
            
            //请求地址   地址不同 必须要改
            NSString * url =@"/index/getsjyzm";
            
            //时间戳
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
            
            
            //将上传对象转换为json格式字符串
           AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
          //  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
            SBJsonWriter *writer = [[SBJsonWriter alloc]init];
            //出入参数：
            NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_PhoneText.text,@"phoneNumber",@"0",@"msg_type", nil];
            
            NSString*jsonstring=[writer stringWithObject:datadic];
            
            //获取签名
            NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
            
            NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
            
            
            //电泳借口需要上传的数据
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
            [manager GET:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                @try
                {
                    [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                    NSLog(@"%@",responseObject);
                    if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                        
                        NSDictionary*datadic=[responseObject valueForKey:@"data"];
                        NSLog(@"%@",datadic);
                        
                        
                        
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
    else
    {
        [WarningBox warningBoxModeText:@"手机号不能为空" andView:self.view];
    }

}
//完成
- (IBAction)CompleteButton:(id)sender {
    [self.view endEditing:YES];

    //判断长度是否大于0
    if (self.PhoneText.text.length > 0 && self.VerificationText.text.length > 0 && self.PassText.text.length > 0 && self.AgainPassText.text.length &&self.StoreText.text.length)
    {
        //输入框里面的内容是符合要求
        if (![self isMobileNumberClassification:self.PhoneText.text])
        {
            [WarningBox warningBoxModeText:@"您的手机号不正确" andView:self.view];
        }
//        else if (![self isMobileNumberClassification:self.RecommendedText.text])
//        {
//            [WarningBox warningBoxModeText:@"您的推荐人手机号不正确" andView:self.view];
//        }
        else if (![self mima:self.PassText.text])
        {
            [WarningBox warningBoxModeText:@"您的密码格式不正确" andView:self.view];
        }
        //判断两次输入的密码是否一致
        else if ([self isMobileNumberClassification:self.PhoneText.text]&&[self mima:self.PassText.text])
        {
            //是
            if ([self.PassText.text isEqualToString:self.AgainPassText.text]) {
                
                [WarningBox warningBoxModeIndeterminate:@"正在注册..." andView:self.view];
                
                //userID    暂时不用改
                NSString * userID=@"0";
                
                //请求地址   地址不同 必须要改
                NSString * url =@"/index/register";
                
                //时间戳
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[dat timeIntervalSince1970];
                NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
                
                
                //将上传对象转换为json格式字符串
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
                SBJsonWriter *writer = [[SBJsonWriter alloc]init];
                //出入参数：
                NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_PhoneText.text,@"phoneNumber",_PassText.text,@"password",_VerificationText.text,@"vaildCode", _RecommendedText.text,@"recommendedNumber",@"",@"office_id",nil];
                
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
                        NSLog(@"%@",responseObject);
                        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            
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
            //不是
            else
            {
                
                [WarningBox warningBoxModeText:@"两次输入的密码不一致" andView:self.view];
                
            }

        }
        
    }
    //不大于0
    else
    {
        
       [WarningBox warningBoxModeText:@"输入内容不能为空" andView:self.view];
        
    }

}
//左按钮
-(void)fanhui
{
    //返回上一页面
     [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)queding:(id)sender {
    
    stateDic = stateArray[[self.picke selectedRowInComponent:0]];
    NSString *state = [stateDic objectForKey:@"state"];
    
    
    cityDic = cityArray[[self.picke selectedRowInComponent:1]];
    NSString *city = [cityDic objectForKey:@"city"];
    
    
    NSString *area;
    if (areaArray.count > 0) {
        area = areaArray[[self.picke selectedRowInComponent:2]];
    }else{
        area = @"";
    }
    
    
    NSString *result = [[NSString alloc]initWithFormat:@"%@ %@ %@",state,city,area];
    
    NSLog(@"resultresultresultresultresultresultresult%@",result);
    
    self.bejing.hidden = YES;
    self.pickerview.hidden = YES;
    
    [self.tableview reloadData];
    self.tableview.hidden = NO;
    
}
- (IBAction)quxiao:(id)sender {
    self.bejing.hidden = YES;
    self.pickerview.hidden = YES;
}

- (IBAction)beijing:(id)sender {
    
    self.bejing.hidden = YES;
    self.tableview.hidden = YES;
    self.pickerview.hidden = YES;
}
@end
