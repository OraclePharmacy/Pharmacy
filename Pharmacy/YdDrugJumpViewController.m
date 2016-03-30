//
//  YdDrugJumpViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdDrugJumpViewController.h"
#import "YdDrugViewController.h"
@interface YdDrugJumpViewController ()

@end

@implementation YdDrugJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //设置显示的图片
    self.DrugIMG.image = [UIImage imageNamed:self.imageName];
    self.DrugLAB.text = [NSString stringWithFormat:@"%@",self.bookNo];
}
@end
