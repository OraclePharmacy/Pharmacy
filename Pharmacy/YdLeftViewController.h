//
//  YdLeftViewController.h
//  侧滑
//
//  Created by suokun on 16/2/25.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@interface YdLeftViewController : UIViewController<RESideMenuDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
