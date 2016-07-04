//
//  YdYaoXiangViewController.h
//  Pharmacy
//
//  Created by suokun on 16/5/3.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdYaoXiangViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *tianjia;

- (IBAction)tianjia:(id)sender;

@end
