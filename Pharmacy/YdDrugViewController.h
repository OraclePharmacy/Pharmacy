//
//  YdDrugViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/21.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdDrugViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *Scrollview;

@property (weak, nonatomic) IBOutlet UITableView *Tableview;

@property (weak, nonatomic) IBOutlet UIView *bannerview;

@property (weak, nonatomic) IBOutlet UICollectionView *Collectionview;


@end
