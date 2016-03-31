//
//  YdRegisterViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/18.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdRegisterViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
//手机号
@property (weak, nonatomic) IBOutlet UITextField *PhoneText;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *VerificationText;
@property (weak, nonatomic) IBOutlet UIButton *VerificationButton;
- (IBAction)VerificationButton:(id)sender;
//推荐人
@property (weak, nonatomic) IBOutlet UITextField *RecommendedText;
//密码
@property (weak, nonatomic) IBOutlet UITextField *PassText;
//重复密码
@property (weak, nonatomic) IBOutlet UITextField *AgainPassText;
//门店地址
@property (weak, nonatomic) IBOutlet UITextField *StoreText;
//完成
@property (weak, nonatomic) IBOutlet UIButton *Complete;
- (IBAction)CompleteButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *bejing;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIPickerView *picke;

- (IBAction)queding:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *quxiao;
@property (weak, nonatomic) IBOutlet UIView *pickerview;

- (IBAction)quxiao:(id)sender;

- (IBAction)beijing:(id)sender;
@end
