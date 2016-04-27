//
//  YdBloodViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdBloodViewController.h"
#import "TableViewCell.h"
@interface YdBloodViewController ()
{
    CGFloat height;
    CGFloat width;
}

@end

@implementation YdBloodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //多出空白处
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    NSString *cellName = NSStringFromClass([TableViewCell class]);
    [self.tableview registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];

    //状态栏名称
    self.navigationItem.title = @"血压血糖";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section?1:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class])];
    [cell configUI:indexPath];
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(0, 0, 30, 20);
    
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor blackColor];
    [cell.contentView addSubview:lab];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            lab.text = @"血糖";
        }
        else
        {
            lab.text = @"血压";
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIView * vi= [[UIView alloc]init];
            vi.frame = CGRectMake(0, 0, width, 170);
            vi.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:vi];
            
            
            
            
            
            
            
        }
    }
    //点击不变颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 30);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:1];
    label.text = section ? @"表格":@"折线图";
    label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
