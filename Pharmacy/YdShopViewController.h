//
//  YdShopViewController.h
//  Pharmacy
//
//  Created by suokun on 16/4/26.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdShopViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic) NSArray*mendian;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
