//
//  YdDiseaseViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdDiseaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSString *bingzhengID;
@property (strong,nonatomic) NSString *bingzhengname;


@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end
