//
//  ViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "ViewController.h"
#import "YdRootViewController.h"
#import "YdForgetViewController.h"
#import "YdRegisterViewController.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏名称
    self.navigationItem.title = @"登录";
    
    self.PhoneText.text = @"15545457012";
    self.PasswordText.text = @"111111";
    
    self.LoginButton.layer.cornerRadius = 5;
    self.LoginButton.layer.masksToBounds = YES;
    
    [self TextFieldSetUp];
}
//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.PhoneText resignFirstResponder];
    [self.PasswordText resignFirstResponder];
    
}
//设置textfield
-(void)TextFieldSetUp
{
    self.PhoneText.delegate = self;
    self.PasswordText.delegate = self;
    
    [self.PhoneText addTarget:self action:@selector(PhoneSetLength) forControlEvents:UIControlEventEditingChanged];
    [self.PasswordText addTarget:self action:@selector(PassSetLength) forControlEvents:UIControlEventEditingChanged];
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
//设置密码长度
-(void)PassSetLength
{
    int MaxLen = 16;
    NSString* szText = [_PasswordText text];
    if ([_PasswordText.text length]> MaxLen)
    {
        _PasswordText.text = [szText substringToIndex:MaxLen];
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
        [self.PasswordText becomeFirstResponder];
    }
    else
    {
        [self.PasswordText becomeFirstResponder];
    }
    return YES;
}

#pragma 按钮点击事件
//登录
- (IBAction)LoginButton:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.PhoneText.text.length > 0 && self.PasswordText.text.length > 0)
    {
        if (![self isMobileNumberClassification:self.PhoneText.text])
        {
            [WarningBox warningBoxModeText:@"请输入正确的手机号" andView:self.view];
        }
        else if(![self mima:self.PasswordText.text])
        {
            [WarningBox warningBoxModeText:@"密码格式不正确" andView:self.view];
        }
        else if ([self isMobileNumberClassification:self.PhoneText.text]&&[self mima:self.PasswordText.text])
        {
            
            
            [WarningBox warningBoxModeIndeterminate:@"登录中..." andView:self.view];
            
            //userID    暂时不用改
            NSString * userID=@"0";
            
            //请求地址   地址不同 必须要改
            NSString * url =@"/viplogin";
            
            //时间戳
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
            
            
            //将上传对象转换为json格式字符串
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
            SBJsonWriter *writer = [[SBJsonWriter alloc]init];
            //出入参数：
            NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_PhoneText.text,@"loginName",_PasswordText.text,@"password", nil];
            
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
                    NSLog(@"登陆返回－－－＊＊＊－－－\n\n\n%@",responseObject);
                    if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                        
                        NSDictionary*datadic=[responseObject valueForKey:@"data"];
                        NSDictionary*vipInfoReturnList=[NSDictionary dictionaryWithDictionary:[datadic objectForKey:@"vipInfoReturnList"]];
NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRtouxiang"];
                        NSFileManager*fm=[NSFileManager defaultManager];
                        if ([fm fileExistsAtPath:path]) {
                           
                            [fm removeItemAtPath:path error:NULL];
                            
                        }
                        
                        NSString *path1 =[NSHomeDirectory() stringByAppendingString:@"/Documents/GRxinxi.plist"];
                        [vipInfoReturnList writeToFile:path1 atomically:YES];
                        NSLog(@"%@",NSHomeDirectory());
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            YdRootViewController *Root=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"root"];
                            [self presentViewController:Root animated:YES completion:^{
                                [self setModalTransitionStyle: UIModalTransitionStyleCrossDissolve];
                            }];
                            
                    });
                       
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
        [WarningBox warningBoxModeText:@"手机号与密码不能为空" andView:self.view];
    }
}
//忘记密码
- (IBAction)ForgetButton:(id)sender {
    [self.view endEditing:YES];
    
    //跳转到忘记密码
    YdForgetViewController *Forget = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"forget"];
    [self.navigationController pushViewController:Forget animated:YES];
}
//注册
- (IBAction)RegisterButton:(id)sender {
    [self.view endEditing:YES];
    
    //跳转到注册
    YdRegisterViewController *Register = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"register"];
    [self.navigationController pushViewController:Register animated:YES];
}

@end
