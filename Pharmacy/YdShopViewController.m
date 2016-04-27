//
//  YdShopViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/26.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdShopViewController.h"
#import "UIImageView+WebCache.h"
#import "Color+Hex.h"
@interface YdShopViewController ()
{
    CGFloat width;
    CGFloat height;
    NSArray *arr;
}
@end

@implementation YdShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arr = _mendian;
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    //状态栏名称
    self.navigationItem.title = @"所属门店";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
}
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mendian.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"mendiancell";
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[_mendian[indexPath.row] objectForKey:@"name"]];

    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//左按钮
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
