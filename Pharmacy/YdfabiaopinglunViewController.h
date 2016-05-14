//
//  YdfabiaopinglunViewController.h
//  Pharmacy
//
//  Created by suokun on 16/5/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdfabiaopinglunViewController : UIViewController<UITextViewDelegate>

@property (strong,nonatomic) NSString *pinglunID;
@property (strong,nonatomic) NSString *tieziID;

@property (strong, nonatomic) UITextView *pinglunText;

@property (weak, nonatomic) IBOutlet UIButton *pinglunNutton;

- (IBAction)pinglunButton:(id)sender;

@end
