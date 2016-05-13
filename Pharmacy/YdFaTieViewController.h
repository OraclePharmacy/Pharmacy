//
//  YdFaTieViewController.h
//  Pharmacy
//
//  Created by suokun on 16/5/11.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdFaTieViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *biaotiText;

@property (weak, nonatomic) IBOutlet UITextView *neirongText;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *image1;

@property (weak, nonatomic) IBOutlet UIImageView *image2;

@property (weak, nonatomic) IBOutlet UIImageView *image3;

@end
