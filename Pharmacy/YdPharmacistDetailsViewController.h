//
//  YdPharmacistDetailsViewController.h
//  Pharmacy
//
//  Created by suokun on 16/4/25.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdPharmacistDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property ( strong , nonatomic) NSString * logname;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong , nonatomic) NSString*yaoshiid;

@end
