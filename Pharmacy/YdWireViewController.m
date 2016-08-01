//
//  YdWireViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdWireViewController.h"
#import "Color+Hex.h"
#import "YdmingchengViewController.h"
@interface YdWireViewController ()
{
    CGFloat width;
    CGFloat height;
    int index;
    int zhi;
    NSArray *yiji;
    NSArray *erji;
    NSDictionary *dic2;
    int panduan;
}
@property (strong,nonatomic)UISegmentedControl *segmentedControl;
@property (strong,nonatomic)UITableView *tableview1;
@property (strong,nonatomic)UITableView *tableview2;
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdWireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //控制是身体为正面
    panduan = 1;
    //获取屏幕高度
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    //创建数组
    yiji = [[NSArray alloc]init];
    yiji = @[@"头部",@"颈部",@"胸部",@"腹部",@"腰部",@"臀部",@"上肢",@"下肢",@"骨",@"男性生殖",@"女性生殖",@"盆腔",@"全身",@"会阴部",@"心理",@"背部",@"其他",@"全部"];
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self tupian];
    //分段控制器
    [self fenduan];
}

//创建分段控制器
-(void)fenduan
{
    //分段控制器基本属性
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"身体部位",@"列表",nil];
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
        [self.tableview1 removeFromSuperview];
        [self.tableview2 removeFromSuperview];
    }
    else if(index == 1){
        zhi = 2;
        [self tableview];
    }
    
}
#pragma  mark --- 图片
-(void)tupian
{
    //最下面
    UIImageView *beijing = [[UIImageView alloc]init];
    beijing.frame = CGRectMake(0, 64, width, height - 64);
    beijing.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:beijing];
    
    CGFloat viewgao = height - 64;
    CGFloat viewkuan = width;
    
    //第二层
    UIImageView *renti = [[UIImageView alloc]init];
    renti.frame = CGRectMake(65, 0, viewkuan - 130 , viewgao);
    [beijing addSubview:renti];
    if (panduan == 1) {
        
        renti.image = [UIImage imageNamed:@"people2.png"];
        
        //头部
        UIButton *tou = [[UIButton alloc]init];
        tou.frame = CGRectMake((width - width / 8.5)/2 , width / 8.5 / 2, width / 8.5, width / 8.5);
        tou.backgroundColor = [UIColor redColor];
        [beijing bringSubviewToFront:tou];
        [beijing addSubview:tou];
        //肩部
        UIButton *jian = [[UIButton alloc]init];
        jian.frame = CGRectMake(width / 8.5 * 2.5,width / 8.5 / 2 + width / 8.5 ,width / 8.5,width / 8.5);
        jian.backgroundColor = [UIColor redColor];
        [beijing bringSubviewToFront:jian];
        [beijing addSubview:jian];
        
    }
    else if (panduan == 2){
        
    renti.image = [UIImage imageNamed:@"people1.png"];
        
    }
    
    
}
#pragma  mark --- tableview
-(void)tableview
{
    erji = [[NSArray alloc]init];
    
    self.tableview1 = [[UITableView alloc]init];
    self.tableview1.frame = CGRectMake(0, 64, width/3, height - 64);
    self.tableview1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    self.tableview1.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableview1];
    
    self.tableview2 = [[UITableView alloc]init];
    self.tableview2.frame = CGRectMake(width/3, 64, width/3*2, height - 64);
    self.tableview2.backgroundColor = [UIColor whiteColor];
    self.tableview2.delegate = self;
    self.tableview2.dataSource = self;
    self.tableview2.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableview2];
    
}
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableview1) {
        return yiji.count;
    }
    return erji.count;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
        return 50;
}
//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    if (tableView == self.tableview1) {
        
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        
        UILabel *bingzheng = [[UILabel alloc]init];
        bingzheng.frame = CGRectMake(0, 0, width/3, 50);
        bingzheng.backgroundColor = [UIColor clearColor];
        bingzheng.text = yiji[indexPath.row];
        bingzheng.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        bingzheng.textAlignment = NSTextAlignmentCenter;
        bingzheng.font = [UIFont systemFontOfSize:15.0];
        [cell.contentView addSubview:bingzheng];
        
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 49, width/3, 1);
        view.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
        [cell.contentView addSubview:view];
        
        //自定义cell选中颜色
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor whiteColor];
        [cell setSelectedBackgroundView:bgColorView];
    }
    else if (tableView == self.tableview2)
    {
        UILabel *bingzheng = [[UILabel alloc]init];
        bingzheng.frame = CGRectMake(0, 0, width/3*2, 50);
        bingzheng.backgroundColor = [UIColor clearColor];
        bingzheng.text = [erji[indexPath.row] objectForKey:@"name"];
        bingzheng.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        bingzheng.textAlignment = NSTextAlignmentCenter;
        bingzheng.font = [UIFont systemFontOfSize:15.0];
        [cell.contentView addSubview:bingzheng];
        
        //自定义cell选中颜色
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        [cell setSelectedBackgroundView:bgColorView];
    }
    //cell点击不变色
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview1.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableview2.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview1.showsVerticalScrollIndicator =NO;
    self.tableview2.showsVerticalScrollIndicator =NO;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableview1) {
        //获取一级名字
        NSString *str = [NSString stringWithFormat:@"%@",yiji[indexPath.row]];
        //获取plist文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"zizhen.plist" ofType:nil];
        //读文件
        dic2 = [NSDictionary dictionaryWithContentsOfFile:path];
        erji = [dic2 objectForKey:str];
        //刷新 tableview2
        [self.tableview2 reloadData];
    }
    else if (tableView == self.tableview2){
        //  跳页
        YdmingchengViewController *mingcheng = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mingcheng"];
        mingcheng.sanji = [erji[indexPath.row] objectForKey:@"name"];
        [self.navigationController pushViewController:mingcheng animated:YES];
    }

}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
