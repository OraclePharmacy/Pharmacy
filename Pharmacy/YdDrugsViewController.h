//
//  YdDrugsViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdDrugsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSString *yaopinID;

@property (strong,nonatomic) UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *lainxidianzhang;
- (IBAction)lianxidianzhang:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *jian;
- (IBAction)jian:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *jia;
- (IBAction)jia:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *jiaru;
- (IBAction)jiaru:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *shuliang;

@end
