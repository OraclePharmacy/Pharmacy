//
//  YdForgetViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/18.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdForgetViewController : UIViewController<UITextFieldDelegate>
//手机号
@property (weak, nonatomic) IBOutlet UITextField *PhoneText;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *VerificationText;
@property (weak, nonatomic) IBOutlet UIButton *VerificationButton;
- (IBAction)VerificationButton:(id)sender;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *PassText;
//重复密码
@property (weak, nonatomic) IBOutlet UITextField *AgainPassText;
//完成
@property (weak, nonatomic) IBOutlet UIButton *CompleteButton;
- (IBAction)CompleteButton:(id)sender;
@end
