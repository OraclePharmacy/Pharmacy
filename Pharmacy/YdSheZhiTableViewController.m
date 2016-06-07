//
//  YdSheZhiTableViewController.m
//  Pharmacy
//
//  Created by suokun on 16/6/6.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdSheZhiTableViewController.h"
#import "Color+Hex.h"
#import "YdModifyViewController.h"
@interface YdSheZhiTableViewController ()
{
    
}
@end

@implementation YdSheZhiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //状态栏名称
    self.navigationItem.title = @"设置";
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return vv;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        
        NSLog(@"1");
        
    }
    else if (indexPath.row == 1)
    {
        
        YdModifyViewController *ModifyViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"modify"];
        
        [self.navigationController pushViewController:ModifyViewController animated:YES];

    }
    else if (indexPath.row == 2)
    {
        
        NSLog(@"3");
        
    }

}
//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
