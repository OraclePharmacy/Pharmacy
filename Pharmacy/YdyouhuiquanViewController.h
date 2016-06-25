//
//  YdyouhuiquanViewController.h
//  Pharmacy
//
//  Created by suokun on 16/5/14.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdyouhuiquanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (strong,nonatomic) UITableView *tableview;
@property (strong,nonatomic) NSString *panduan;
@end
