//
//  ViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

//手机号
@property (weak, nonatomic) IBOutlet UITextField *PhoneText;
//密码
@property (weak, nonatomic) IBOutlet UITextField *PasswordText;
//登录
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
- (IBAction)LoginButton:(id)sender;
//忘记密码
- (IBAction)ForgetButton:(id)sender;
//注册
- (IBAction)RegisterButton:(id)sender;

@end

