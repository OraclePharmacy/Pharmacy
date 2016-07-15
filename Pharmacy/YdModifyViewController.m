//
//  YdModifyViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/18.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdModifyViewController.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
@interface YdModifyViewController ()

@end

@implementation YdModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.CompleteButton.layer.cornerRadius = 5;
    self.CompleteButton.layer.masksToBounds = YES;
    
    //导航栏名称
    self.navigationItem.title = @"修改密码";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];

    
    [self TextFieldSetUp];
}
//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.NewPassText resignFirstResponder];
    [self.OldPassText resignFirstResponder];
    [self.AgainPassText resignFirstResponder];
    
    
}
//设置textfield
-(void)TextFieldSetUp
{
    self.NewPassText.delegate = self;
    self.OldPassText.delegate = self;
    self.AgainPassText.delegate = self;
    
    [self.NewPassText addTarget:self action:@selector(NewPassSetLength) forControlEvents:UIControlEventEditingChanged];
    [self.OldPassText addTarget:self action:@selector(OldPassSetLength) forControlEvents:UIControlEventEditingChanged];
    [self.AgainPassText addTarget:self action:@selector(AgainPassSetLength) forControlEvents:UIControlEventEditingChanged];
    
}
#pragma 限制textfield的长度

//设置新密码长度
-(void)NewPassSetLength
{
    int MaxLen = 16;
    NSString* szText = [_NewPassText text];
    if ([_NewPassText.text length]> MaxLen)
    {
        _NewPassText.text = [szText substringToIndex:MaxLen];
    }
}
//设置旧密码长度
-(void)OldPassSetLength
{
    int MaxLen = 16;
    NSString* szText = [_OldPassText text];
    if ([_OldPassText.text length]> MaxLen)
    {
        _OldPassText.text = [szText substringToIndex:MaxLen];
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

//验证密码
-(BOOL)mima:(NSString *)pass{
    
    NSString *password = @"^[a-zA-Z0-9]{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",password];
    BOOL isMatch = [pred evaluateWithObject:pass];
    return isMatch;
    
}
//textfield点击return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.NewPassText)
    {
        [self.AgainPassText becomeFirstResponder];
    }
    else if (textField == self.OldPassText)
    {
        [self.NewPassText becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

//textfield退出编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==_OldPassText) {
        if (![self mima:self.OldPassText.text]) {
            
            [WarningBox warningBoxModeText:@"密码格式不对哟~" andView:self.view];
        }
    }else if (textField==_NewPassText){
        if(![self mima:self.NewPassText.text]){
            [WarningBox warningBoxModeText:@"新密码格式不对哟~" andView:self.view];
        }
    }else if (textField==_AgainPassText){
        if(![self.AgainPassText.text isEqual:_NewPassText.text]){
            [WarningBox warningBoxModeText:@"两次输入的密码不一致" andView:self.view];
        }
    }
    
}

#pragma 按钮点击事件

- (IBAction)CompleteButton:(id)sender {
    //隐藏键盘
    [self.view endEditing:YES];
    //判断输入框输入内容是否为空
    if (self.OldPassText.text.length > 0 && self.NewPassText.text.length > 0 && self.AgainPassText.text.length > 0)
    {
        if (![self mima:self.NewPassText.text]) {
             [WarningBox warningBoxModeText:@"您的新密码格式不正确" andView:self.view];
        }
        else if ([self mima:self.NewPassText.text])
        {
            if ([self.NewPassText.text isEqualToString:self.AgainPassText.text]) {
                
                [WarningBox warningBoxModeIndeterminate:@"密码修改中..." andView:self.view];
                
                //userID    暂时不用改
                NSString * userID=@"0";
                
                //请求地址   地址不同 必须要改
                NSString * url =@"/modifypwd";
                
                //时间戳
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[dat timeIntervalSince1970];
                NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
                
                
                //将上传对象转换为json格式字符串
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
                SBJsonWriter *writer = [[SBJsonWriter alloc]init];
                //出入参数：
                NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"18345559961",@"loginName",_NewPassText.text,@"newpassword", _OldPassText.text,@"oldpassword",nil];
                
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
                            
                            NSDictionary*datadic=[responseObject valueForKey:@"data"];
                            NSLog(@"%@",datadic);
                            
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
            else
            {
                
                [WarningBox warningBoxModeText:@"两次输入的密码不一致" andView:self.view];
                
            }

        }
    }
    //为空
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
