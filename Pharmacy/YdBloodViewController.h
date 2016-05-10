//
//  YdBloodViewController.h
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdBloodViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong,nonatomic)NSMutableArray *xueyaarraytime;
@property (strong,nonatomic)NSMutableArray *xuetangarraytime;

@property (strong,nonatomic)NSMutableArray *gaoyaarray;
@property (strong,nonatomic)NSMutableArray *diyaarray;

@property (strong,nonatomic)NSMutableArray *fanqianarray;
@property (strong,nonatomic)NSMutableArray *fanhouarray;



@end
