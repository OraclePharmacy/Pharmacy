//
//  YdModifyViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/18.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdModifyViewController.h"
#import "WarningBox.h"
@interface YdModifyViewController ()

@end

@implementation YdModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏名称
    self.navigationItem.title = @"修改密码";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    NSString *password = @"^[a-zA-Z0-9]{5,15}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",password];
    BOOL isMatch = [pred evaluateWithObject:pass];
    return isMatch;
    
}
//textfield点击return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.NewPassText)
    {
        [self.OldPassText becomeFirstResponder];
    }
    else if (textField == self.OldPassText)
    {
        [self.AgainPassText becomeFirstResponder];
    }
    else
    {
        [self.AgainPassText becomeFirstResponder];
    }
    return YES;
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
                
                [self.navigationController popViewControllerAnimated:YES];
                
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
