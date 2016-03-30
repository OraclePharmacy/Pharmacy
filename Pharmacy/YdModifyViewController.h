//
//  YdModifyViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/18.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdModifyViewController : UIViewController<UITextFieldDelegate>
//旧密码
@property (weak, nonatomic) IBOutlet UITextField *OldPassText;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *NewPassText;
//再次输入
@property (weak, nonatomic) IBOutlet UITextField *AgainPassText;
//完成按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CompleteButton;
- (IBAction)CompleteButton:(id)sender;

@end
