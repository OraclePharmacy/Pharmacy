//
//  YdDrugJumpViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdDrugJumpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *DrugIMG;

@property (weak, nonatomic) IBOutlet UILabel *DrugLAB;

@property (strong,nonatomic) NSString *imageName;
@property (nonatomic,assign) NSString * bookNo;


@end
