//
//  YdjiluViewController.m
//  Pharmacy
//
//  Created by suokun on 16/7/1.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdjiluViewController.h"
#import "Color+Hex.h"
@interface YdjiluViewController ()

@end

@implementation YdjiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    NSString *str = [[NSString alloc] init];
    str = self.name.text;
    str = self.changshang.text;
    str = self.time.text;
    str = self.cishu.text;
    

}
@end
