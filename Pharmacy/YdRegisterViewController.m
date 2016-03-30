//
//  YdRegisterViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/18.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdRegisterViewController.h"
#import "WarningBox.h"
@interface YdRegisterViewController ()

@end

@implementation YdRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma 按钮点击事件

//验证码
- (IBAction)VerificationButton:(id)sender {
    
    [self.view endEditing:YES];

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
                
               [self.navigationController popViewControllerAnimated:YES];
                
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
@end
