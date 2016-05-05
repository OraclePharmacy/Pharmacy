//
//  YdRemindViewController.h
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdRemindViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong,nonatomic) UITableView *tableview;

@end
