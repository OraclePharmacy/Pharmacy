//
//  YdDrugJumpViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdDrugJumpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong,nonatomic) NSString *imageName;
@property (nonatomic,assign) NSString * bookNo;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
