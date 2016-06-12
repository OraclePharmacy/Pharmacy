//
//  YdzhongjiangxiangqingViewController.h
//  Pharmacy
//
//  Created by suokun on 16/6/12.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdzhongjiangxiangqingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (strong,nonatomic) NSString *jiangpinid;
@property (nonatomic,strong)UITableView *tableview;

@end
