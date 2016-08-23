//
//  YdSearchResultViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdSearchResultViewController.h"
#import "Color+Hex.h"
#import "YdDiseaseViewController.h"
#import "YdDrugsViewController.h"
#import "hongdingyi.h"
#import "UIImageView+WebCache.h"
@interface YdSearchResultViewController ()
{
    CGFloat width;
    CGFloat height;
    
    int index;
    int zhi;
    
    UITableViewCell *cell;
}
@property (strong,nonatomic)UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.tableFooterView = [[UIView alloc] init];
    
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
    if (zhi == 1)
    {
        return _bingzheng.count;
    }
    else if (zhi == 2)
    {
        return _yaopin.count;
    }
    return 0;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (zhi == 1) {
        return 50;
    }
    return 116;
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
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[_bingzheng[indexPath.row] objectForKey:@"name"]];
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
        //image.image = [UIImage imageNamed:@"IMG_0801.jpg"];
        NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[_yaopin[indexPath.row] objectForKey:@"picUrl"]] ;
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
        
        UILabel *name = [[UILabel alloc]init];
        name.frame = CGRectMake(90, 5, width - 95, 20);
        name.font = [UIFont systemFontOfSize:15];
        name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        name.text = [NSString stringWithFormat:@"%@",[_yaopin[indexPath.row] objectForKey:@"commonName"]];
        
        UILabel *chufang = [[UILabel alloc]init];
        chufang.frame = CGRectMake(90, 25, width - 95 , 20);
        chufang.font = [UIFont systemFontOfSize:13];
        chufang.textColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    //?????    chufang.text = [NSString stringWithFormat:@"%@",[_yaopin[indexPath.row] objectForKey:@"prescription"]];
        
        UILabel *guige = [[UILabel alloc]init];
        guige.frame = CGRectMake(90, 45, width - 95, 20);
        guige.font = [UIFont systemFontOfSize:11];
        guige.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        guige.text = [NSString stringWithFormat:@"%@",[_yaopin[indexPath.row] objectForKey:@"specification"]];
        
        UILabel *changjia = [[UILabel alloc]init];
        changjia.frame = CGRectMake(90, 64, width - 95, 20);
        changjia.font = [UIFont systemFontOfSize:11];
        changjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        changjia.text = [NSString stringWithFormat:@"%@",[_yaopin[indexPath.row] objectForKey:@"manufacturer"]];
        
        UILabel *jianjie = [[UILabel alloc]init];
        jianjie.frame = CGRectMake(5, 85, width - 10, 30);
        jianjie.font = [UIFont systemFontOfSize:11];
        jianjie.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        jianjie.numberOfLines = 2;
        jianjie.text = [NSString stringWithFormat:@"药品简介:%@",[_yaopin[indexPath.row] objectForKey:@"summary"]];
        
        
        UIView *xian = [[UIView alloc]init];
        xian.frame = CGRectMake(0, 115, width, 1);
        xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
        
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:chufang];
        [cell.contentView addSubview:guige];
        [cell.contentView addSubview:changjia];
        [cell.contentView addSubview:jianjie];
        [cell.contentView addSubview:xian];
    }
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (zhi == 1) {
        
        YdDiseaseViewController *Disease = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"disease"];
        Disease.bingzhengID = [_bingzheng[indexPath.row] objectForKey:@"id"];
        Disease.bingzhengname = [_bingzheng[indexPath.row] objectForKey:@"name"];
        [self.navigationController pushViewController:Disease animated:YES];
        
    }
    else if (zhi == 2) {
        
        YdDrugsViewController *Drugs = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugs"];
        Drugs.yaopinID = [_yaopin[indexPath.row] objectForKey:@"id"];
        [self.navigationController pushViewController:Drugs animated:YES];
        
    }
    
}

//导航左按钮
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}


@end
