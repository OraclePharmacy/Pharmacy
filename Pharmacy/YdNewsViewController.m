//
//  YdNewsViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/6.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdNewsViewController.h"
#import "Color+Hex.h"

@interface YdNewsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat width;
    CGFloat height;
}
@property (nonatomic,strong) UITableView *tableview;
@end

@implementation YdNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"消 息";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
}


//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 70;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return baseView;
}
//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"wencell";
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    UIView *bai = [[UIView alloc]init];
    bai.backgroundColor = [UIColor whiteColor];
    bai.frame = CGRectMake(5, 0, width - 10 , 61);
    [cell.contentView addSubview:bai];
    
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(5, 0, width - 20, 30);
    title.text = @"sfjskdfh";
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    [bai addSubview:title];
    
    UIView *xian = [[UIView alloc]init];
    xian.frame = CGRectMake(5, 30, width - 20 , 1);
    xian.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    [bai addSubview:xian];
    
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(5, 31, width - 20, 30);
    time.text = @"fsdflk";
    time.font = [UIFont systemFontOfSize:13];
    time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    time.textAlignment = NSTextAlignmentRight;
    [bai addSubview:time];

    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//导航左按钮
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
