//
//  YdInformationViewController.h
//  Pharmacy
//
//  Created by suokun on 16/4/6.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@interface YdInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UISegmentedControl *Segmented;

- (IBAction)Segmented:(id)sender;
@end
