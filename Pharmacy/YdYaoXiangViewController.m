//
//  YdYaoXiangViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/3.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdYaoXiangViewController.h"
#import "Color+Hex.h"
#import "YdjiluViewController.h"
@interface YdYaoXiangViewController ()
{
    CGFloat width;
    CGFloat height;
}
@end

@implementation YdYaoXiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"智慧药箱";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
}

//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//cell高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 90;
}
//header高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//自定义header
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(5, 5, 80, 80);
    image.image = [UIImage imageNamed:@""];
    [cell.contentView addSubview:image];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(90, 5, width - 95, 20);
    name.text = @"名    称:   林俊杰";
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    name.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:name ];
    
    UILabel *changshang = [[UILabel alloc]init];
    changshang.frame = CGRectMake(90, 25, width - 95, 20);
    changshang.text = @"厂    商:   林俊杰工厂";
    changshang.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    changshang.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:changshang];
    
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(90, 45, width - 95, 20);
    time.text = @"有限期:   12个月";
    time.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    time.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:time];
    
    UILabel *num = [[UILabel alloc]init];
    num.frame = CGRectMake(90, 65, width - 95, 20);
    num.text = @"次    数:   3次/日";
    num.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    num.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:num];
    
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)tianjia:(id)sender {
    
    YdjiluViewController *jilu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"jilu"];
    
    [self.navigationController pushViewController:jilu animated:YES];

    
}
@end
