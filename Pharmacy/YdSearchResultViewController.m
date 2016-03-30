//
//  YdSearchResultViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdSearchResultViewController.h"

@interface YdSearchResultViewController ()
{
    CGFloat width;
    CGFloat height;
    
    int index;
    int zhi;
    
    UITableViewCell *cell;
}
@property (strong,nonatomic)UISegmentedControl *segmentedControl;

@end

@implementation YdSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    [self fenduan];
    
}
//创建分段控制器
-(void)fenduan
{
    //分段控制器基本属性
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"病症信息",@"药品信息",nil];
    //初始化UISegmentedControl
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(0,0,width/2,30);
    _segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    _segmentedControl.tintColor = [UIColor grayColor];
    [_segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    //显示在导航栏
    self.navigationItem.titleView = self.segmentedControl;
}
//分段控制器点击方法
-(void)change:(UISegmentedControl *)segmentControl
{
    index = (int)_segmentedControl.selectedSegmentIndex;
    if (index == 0 ) {
        zhi = 1;
        [self.tableview reloadData];
    }
    else if(index == 1){
        zhi = 2;
        [self.tableview reloadData];
    }
    
}

//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 0;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    
    return cell;
}

//导航左按钮
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}


@end
