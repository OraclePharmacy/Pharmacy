//
//  YdSearchResultViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdSearchResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong,nonatomic) NSArray *bingzheng;
@property (strong,nonatomic) NSArray *yaopin;

@end
