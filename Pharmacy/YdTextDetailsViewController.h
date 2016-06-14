//
//  YdTextDetailsViewController.h
//  Pharmacy
//
//  Created by suokun on 16/4/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdTextDetailsViewController : UIViewController
@property (nonatomic , strong)NSString*xixi;

@property (weak, nonatomic) IBOutlet UIButton *fenxiang;

@property (weak, nonatomic) IBOutlet UIButton *dianzan;

@property (weak, nonatomic) IBOutlet UIButton *shoucang;

- (IBAction)fenxiang:(id)sender;

- (IBAction)shoucang:(id)sender;

- (IBAction)dianzan:(id)sender;

@end
