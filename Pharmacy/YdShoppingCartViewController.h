//
//  YdShoppingCartViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@interface YdShoppingCartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *tijiao;
@property (weak, nonatomic) IBOutlet UIButton *lianxidianzhnag;
- (IBAction)tijiaoanniu:(id)sender;
- (IBAction)dianzhanganniu:(id)sender;

@end
