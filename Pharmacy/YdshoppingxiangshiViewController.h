//
//  YdshoppingxiangshiViewController.h
//  Pharmacy
//
//  Created by suokun on 16/5/10.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdshoppingxiangshiViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *tijiao;

- (IBAction)tijiao:(id)sender;

@end
