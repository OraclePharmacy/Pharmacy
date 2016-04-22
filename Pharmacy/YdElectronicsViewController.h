//
//  YdElectronicsViewController.h
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdElectronicsViewController : UIViewController
<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *first;
- (IBAction)first:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *second;
- (IBAction)second:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *third;
- (IBAction)third:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *titleText;

@property (weak, nonatomic) IBOutlet UITextView *writeText;

@property (weak, nonatomic) IBOutlet UIButton *tijiao;
- (IBAction)tijiao:(id)sender;

@end
