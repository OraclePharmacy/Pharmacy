//
//  YdPurchasingViewController.h
//  Pharmacy
//
//  Created by suokun on 16/4/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdPurchasingViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *one;
- (IBAction)one:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *two;
- (IBAction)two:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *three;
- (IBAction)three:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nametext;
@property (weak, nonatomic) IBOutlet UITextField *guigetext;
@property (weak, nonatomic) IBOutlet UITextField *changjiatext;
@property (weak, nonatomic) IBOutlet UITextField *shuliangtext;
@property (weak, nonatomic) IBOutlet UITextField *pizhuntext;

@property (weak, nonatomic) IBOutlet UITextView *beizhu;


@property (weak, nonatomic) IBOutlet UIButton *yuding;
- (IBAction)yuding:(id)sender;


@end
