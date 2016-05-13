//
//  YdTieZiXiangQingViewController.h
//  Pharmacy
//
//  Created by suokun on 16/5/12.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdTieZiXiangQingViewController : UIViewController<UITextViewDelegate>

@property (nonatomic,strong) NSString *tieziId;
@property (nonatomic,strong) NSString *bingzheng;
@property (nonatomic,strong) NSString *touxiang1;


@property (weak, nonatomic) IBOutlet UIImageView *touxiang;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *biaoqian;

@property (weak, nonatomic) IBOutlet UILabel *biaoti;


@property (weak, nonatomic) IBOutlet UITextView *neirong;


@property (weak, nonatomic) IBOutlet UIButton *pinglunButton;
- (IBAction)pinglunButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *image1;

@property (weak, nonatomic) IBOutlet UIImageView *image2;

@property (weak, nonatomic) IBOutlet UIImageView *image3;

@end
