//
//  YdjiluViewController.h
//  Pharmacy
//
//  Created by suokun on 16/7/1.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdjiluViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UITextField *changshang;

@property (weak, nonatomic) IBOutlet UITextField *time;

@property (weak, nonatomic) IBOutlet UITextField *cishu;

@property (weak, nonatomic) IBOutlet UIButton *baocun;
- (IBAction)baocun:(id)sender;

@end
