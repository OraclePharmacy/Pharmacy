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
#import <JMessage/JMessage.h>
@interface ViewController ()
{
    NSMutableDictionary *Passdic;
    NSString *Rempath;
    int m;
    BOOL isRemember;
    
    NSString *yongjingxi,*wenyaoshi,*daigouyao,*youhuiquan,*bingyoujiaoliu,*zizhen,*yongyaotixing,*xueyaxuetang,*dianzibingli,*zhihuiyaoxiang;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏名称
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"登录";
//    self.tabBarController.tabBar.hidden=YES;
//    self.navigationController.navigationBarHidden=NO;
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    self.LoginButton.layer.cornerRadius = 5;
    self.LoginButton.layer.masksToBounds = YES;
    
    //    [self.RememberButton setTitle:@"记住密码" forState:UIControlStateNormal];
    //    [self.RememberButton setImage:[UIImage imageNamed:@"time_line_mark.png"] forState:UIControlStateNormal];
    //    [self.RememberButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
    //    [self.RememberButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    isRemember=NO;
    
    [self TextFieldSetUp];
}


-(void)viewWillAppear:(BOOL)animated{
    Rempath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/RememberPass.plist"];
    NSLog(@"%@",NSHomeDirectory());
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithContentsOfFile:Rempath];
    NSString *isZiDongdenglu =  [[NSUserDefaults standardUserDefaults]objectForKey:@"zddl"];
   
    if ([isZiDongdenglu  isEqual: @"1"]) {
        isRemember = YES;
        [self.RememberButton setTitle:@"记住密码" forState:UIControlStateNormal];
        [self.RememberButton setImage:[UIImage imageNamed:@"time_line_mark.png"] forState:UIControlStateNormal];
        _PhoneText.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"phonetext"]];
        _PasswordText.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"password"]];
    }

    
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
            
            [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [WarningBox warningBoxHide:YES andView:self.view];
                @try
                {
                    //[WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                    NSLog(@"登陆返回－－－＊＊＊－－－\n\n\n%@",responseObject);
                    if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                        
                        NSDictionary*datadic=[responseObject valueForKey:@"data"];
                        NSDictionary*vipInfoReturnList=[NSDictionary dictionaryWithDictionary:[datadic objectForKey:@"vipInfoReturnList"]];
                        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRtouxiang"];
                        NSFileManager*fm=[NSFileManager defaultManager];
                        if ([fm fileExistsAtPath:path]) {
                            
                            [fm removeItemAtPath:path error:NULL];
                            
                        }
                        Passdic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_PhoneText.text,@"phonetext",_PasswordText.text,@"password", nil];
                        [Passdic writeToFile:Rempath atomically:NO];
                        NSLog(@"\n\n\n\nhaha\n\n\n\n%@",Passdic);
                        NSString *path1 =[NSHomeDirectory() stringByAppendingString:@"/Documents/GRxinxi.plist"];
                        [vipInfoReturnList writeToFile:path1 atomically:YES];
                        NSLog(@"%@",NSHomeDirectory());
                        NSUserDefaults*s= [NSUserDefaults standardUserDefaults];
                        [s setObject:[vipInfoReturnList objectForKey:@"loginName"] forKey:@"shoujihao"];
                        [s setObject:[vipInfoReturnList objectForKey:@"id"] forKey:@"vipId"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLogin"];
                        
                        
                        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                        NSString *path2=[paths objectAtIndex:0];
                        //NSLog(@"path = %@",path);
                        NSString *filename=[path2 stringByAppendingPathComponent:@"baocun.plist"];
                        //NSLog(@"path = %@",filename);
                        //判断是否已经创建文件
                        if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                            
                            NSDictionary* dictionaryic = [NSDictionary dictionaryWithContentsOfFile:filename];
                            yongjingxi = [dictionaryic objectForKey:@"yongjingxi"];
                            wenyaoshi = [dictionaryic objectForKey:@"wenyaoshi"];
                            daigouyao = [dictionaryic objectForKey:@"daigouyao"];
                            youhuiquan = [dictionaryic objectForKey:@"youhuiquan"];
                            bingyoujiaoliu = [dictionaryic objectForKey:@"bingyoujiaoliu"];
                            zizhen = [dictionaryic objectForKey:@"zizhen"];
                            yongyaotixing = [dictionaryic objectForKey:@"yongyaotixing"];
                            xueyaxuetang = [dictionaryic objectForKey:@"xueyaxuetang"];
                            dianzibingli = [dictionaryic objectForKey:@"dianzibingli"];
                            zhihuiyaoxiang = [dictionaryic objectForKey:@"zhihuiyaoxiang"];
                            
                            [self diaojiekou];
                            
                        }else {
                            
                            NSDictionary* dictionaryic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
                            //NSLog(@"%@",dic);
                            [dictionaryic writeToFile:filename atomically:YES];
                            
                        }

                        
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                YdRootViewController *Root = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"root"];
                                [self.navigationController pushViewController:Root animated:YES];
                                
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

-(void)diaojiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/basic/saveStatistics";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:yongjingxi,@"a",wenyaoshi,@"b",daigouyao,@"c",youhuiquan,@"d",bingyoujiaoliu,@"e",zizhen,@"f",yongyaotixing,@"g",xueyaxuetang,@"h",dianzibingli,@"i",zhihuiyaoxiang,@"j", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    NSLog(@"url1%@",url1);
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
           // [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            NSLog(@"responseObject%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                //NSDictionary*datadic=[responseObject valueForKey:@"data"];
            
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path2=[paths objectAtIndex:0];
                //NSLog(@"path = %@",path);
                NSString *filename=[path2 stringByAppendingPathComponent:@"baocun.plist"];
                NSDictionary* dictionaryic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil];
                
                [dictionaryic writeToFile:filename atomically:YES];
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

- (IBAction)RememberButton:(id)sender {
    NSUserDefaults*user =  [NSUserDefaults standardUserDefaults];
    if(isRemember==NO){
        isRemember=YES;
        [user setObject:@"1" forKey:@"zddl"];
        
        [self.RememberButton setTitle:@"记住密码" forState:UIControlStateNormal];
        [self.RememberButton setImage:[UIImage imageNamed:@"time_line_mark.png"] forState:UIControlStateNormal];
        
    }
    else{
        [user setObject:@"0" forKey:@"zddl"];
        isRemember=NO;
       [self.RememberButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
    }
    
}
//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
@end
