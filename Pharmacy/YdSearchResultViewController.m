//
//  YdSearchResultViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdSearchResultViewController.h"
#import "Color+Hex.h"
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
    
    zhi = 1;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    _segmentedControl.tintColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
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
    if (zhi == 1) {
        return 50;
    }
    return 115;
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
    if (zhi == 1) {
        
        cell.textLabel.text = @"其他疾病";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1 ];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        
        //    UILabel *renqi = [[UILabel alloc]init];
        //    renqi.frame = CGRectMake(width - 120, 10, 100, 20);
        //    renqi.text = @"人气:12345";
        //    renqi.textColor = [UIColor redColor];
        //    renqi.font = [UIFont systemFontOfSize:13];
        
        
        //    [cell.contentView addSubview:renqi];
        
        //显示最右边的箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    else
    {
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(5, 5, 80, 80);
        image.backgroundColor = [UIColor grayColor];
        
        UILabel *name = [[UILabel alloc]init];
        name.frame = CGRectMake(90, 5, width - 95, 20);
        name.backgroundColor = [UIColor purpleColor];
        
        UILabel *chufang = [[UILabel alloc]init];
        chufang.frame = CGRectMake(90, 25, width - 95 , 20);
        chufang.backgroundColor = [UIColor grayColor];
        
        UILabel *guige = [[UILabel alloc]init];
        guige.frame = CGRectMake(90, 45, width - 95, 20);
        guige.backgroundColor = [UIColor purpleColor];
        
        UILabel *changjia = [[UILabel alloc]init];
        changjia.frame = CGRectMake(90, 64, width - 95, 20);
        changjia.backgroundColor = [UIColor grayColor];
        
        UILabel *jianjie = [[UILabel alloc]init];
        jianjie.frame = CGRectMake(5, 85, width - 10, 30);
        jianjie.backgroundColor = [UIColor greenColor];
        
        
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:chufang];
        [cell.contentView addSubview:guige];
        [cell.contentView addSubview:changjia];
        [cell.contentView addSubview:jianjie];
    }
    
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
