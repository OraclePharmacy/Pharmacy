//
//  YdRecordListViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/21.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdRecordListViewController.h"
#import "Color+Hex.h"

@interface YdRecordListViewController ()
{
    CGFloat width;
    CGFloat height;
}
@end

@implementation YdRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"我的电子病历";
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 65;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell123";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];

    UIView *shu = [[UIView alloc]init];
    shu.frame = CGRectMake(5, 0, 1, 65);
    shu.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    
    UIImageView *yuan = [[UIImageView alloc]init];
    yuan.frame = CGRectMake(6, 35, 9, 9);
    yuan.image = [UIImage imageNamed:@"time_line_mark.png"];
    
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(0, 5, width, 20);
    time.font = [UIFont systemFontOfSize:13];
    time.text = @"2016年4月22日";
    time.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    time.textAlignment = NSTextAlignmentCenter;
    
    
    UIView *bai = [[UIView alloc]init];
    bai.backgroundColor = [UIColor whiteColor];
    bai.frame = CGRectMake(15, 25, width-25, 40);
    
    
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(0, 0, width -20, 20);
    title.font = [UIFont systemFontOfSize:15];
    title.text = @"飞机失联的快捷付老师家了";
    title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    
    
    UILabel *neirong = [[UILabel alloc]init];
    neirong.frame = CGRectMake(0, 20, width -20, 20);
    neirong.font = [UIFont systemFontOfSize:13];
    neirong.text = @"飞机失联的快捷付老师家了放假了设计费垃圾上来看的吉林省京东方";
    neirong.textColor = [UIColor colorWithHexString:@"646464" alpha:1];


    [bai addSubview:title];
    [bai addSubview:neirong];
    
    
    [cell.contentView addSubview:shu];
    [cell.contentView addSubview:time];
    [cell.contentView addSubview:bai];
    [cell.contentView addSubview:yuan];
    
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    return cell;
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
