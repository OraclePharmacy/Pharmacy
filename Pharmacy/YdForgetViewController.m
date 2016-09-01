//
//  YdForgetViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/18.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdForgetViewController.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"

@interface YdForgetViewController ()

@end

@implementation YdForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.VerificationButton.layer.cornerRadius = 5;
    self.VerificationButton.layer.masksToBounds = YES;
    
    self.CompleteButton.layer.cornerRadius = 5;
    self.CompleteButton.layer.masksToBounds = YES;
    
    //导航栏名称
    self.navigationItem.title = @"忘记密码";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];

    [self TextFieldSetUp];

}
//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.PhoneText resignFirstResponder];
    [self.VerificationText resignFirstResponder];
    [self.PassText resignFirstResponder];
    [self.AgainPassText resignFirstResponder];

    
}
//设置textfield
-(void)TextFieldSetUp
{
    self.PhoneText.delegate = self;
    self.VerificationText.delegate = self;
    self.PassText.delegate = self;
    self.AgainPassText.delegate = self;
    
    [self.PhoneText addTarget:self action:@selector(PhoneSetLength) forControlEvents:UIControlEventEditingChanged];
    [self.VerificationText addTarget:self action:@selector(VerificationLength) forControlEvents:UIControlEventEditingChanged];
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
    else if (textField == self.PassText)
    {
        [self.AgainPassText becomeFirstResponder];
    }
    else
    {
        //[self.AgainPassText becomeFirstResponder];
        [textField resignFirstResponder];
    }
    return YES;
}

//textfield退出编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==_PassText) {
        if (![self mima:self.PassText.text]) {
            _PassText.text=@"";
            [WarningBox warningBoxModeText:@"密码格式不对哟~" andView:self.view];
        }
    }else if (textField==_PhoneText){
        if(self.PhoneText.text.length!=11||![self isMobileNumberClassification:self.PhoneText.text]){
            [WarningBox warningBoxModeText:@"您的手机号不正确" andView:self.view];
        }
    }else if (textField==_AgainPassText){
        if(![self.AgainPassText.text isEqual:_PassText.text]){
            [WarningBox warningBoxModeText:@"两次输入的密码不一致" andView:self.view];
        }
        
    }else if (textField==_VerificationText){
        if (_VerificationText.text.length!=4){
            [WarningBox warningBoxModeText:@"验证码格式不对" andView:self.view];
        }
    }
    
    
    
    
}
#pragma 按钮点击事件
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
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
            SBJsonWriter *writer = [[SBJsonWriter alloc]init];
            //出入参数：
            NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_PhoneText.text,@"phoneNumber",@"1",@"msg_type", nil];
            
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
                   // [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
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
- (IBAction)CompleteButton:(id)sender {
    
     [self.view endEditing:YES];
    if (self.PhoneText.text.length > 0 && self.VerificationText.text.length > 0 && self.PassText.text.length > 0 && self.AgainPassText.text.length )
    {
        if (![self isMobileNumberClassification:self.PhoneText.text])
        {
            [WarningBox warningBoxModeText:@"您的手机号不正确" andView:self.view];
        }
        else if (![self mima:self.PassText.text])
        {
            [WarningBox warningBoxModeText:@"您的密码格式不正确" andView:self.view];
        }
        else if ([self isMobileNumberClassification:self.PhoneText.text]&&[self mima:self.PassText.text])
        {
            if ([self.PassText.text isEqualToString:self.AgainPassText.text]) {
                
                [WarningBox warningBoxModeIndeterminate:@"正在更改密码..." andView:self.view];
                
                //userID    暂时不用改
                NSString * userID=@"0";
                
                //请求地址   地址不同 必须要改
                NSString * url =@"/index/forgetPassword";
                
                //时间戳
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[dat timeIntervalSince1970];
                NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
                
                
                //将上传对象转换为json格式字符串
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
                SBJsonWriter *writer = [[SBJsonWriter alloc]init];
                //出入参数：
                NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_PhoneText.text,@"phoneNumber",_VerificationText.text,@"vaildCode", _PassText.text,@"newPassword",nil];
                
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
                       // [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                       
                        
                        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                            [WarningBox warningBoxModeText:@"密码修改成功" andView:self.view];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];

                            });
                            
                            
                        }else if ([[responseObject objectForKey:@"code"] intValue]==1111){
                          
                         [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
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
            else
            {
                
                [WarningBox warningBoxModeText:@"两次输入的密码不一致" andView:self.view];
                
            }
            
        }
        
    }
    else
    {
        
        [WarningBox warningBoxModeText:@"输入内容不能为空" andView:self.view];
        
    }
    

}
//左按钮
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
