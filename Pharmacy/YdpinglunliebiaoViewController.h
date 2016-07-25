//
//  YdpinglunliebiaoViewController.h
//  Pharmacy
//
//  Created by suokun on 16/5/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdpinglunliebiaoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSString *tieziID;
@property (strong,nonatomic) UITableView *tableview;
@property (nonatomic, strong) UIView *tableFooterView;

@end
