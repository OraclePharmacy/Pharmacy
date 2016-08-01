//
//  YdmingchengViewController.m
//  Pharmacy
//
//  Created by suokun on 16/8/1.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdmingchengViewController.h"
#import "Color+Hex.h"
#import "YdBZxiangqingViewController.h"
@interface YdmingchengViewController ()
{
    CGFloat width;
    CGFloat height;
}
@property (strong,nonatomic)UITableView *tableview;
@end

@implementation YdmingchengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取屏幕高度
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    //状态栏名称
    self.navigationItem.title = @"病症名称";
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64);
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableview];
    
    NSLog(@"%@",self.sanji);
}

//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    UILabel *bingzheng = [[UILabel alloc]init];
    bingzheng.frame = CGRectMake(0, 0, width, 50);
    bingzheng.backgroundColor = [UIColor clearColor];
    bingzheng.text = @"sdjfsjkdfl";
    bingzheng.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    bingzheng.textAlignment = NSTextAlignmentCenter;
    bingzheng.font = [UIFont systemFontOfSize:15.0];
    [cell.contentView addSubview:bingzheng];
        
    //自定义cell选中颜色
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    
    //cell点击不变色
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  跳页
    YdBZxiangqingViewController *BZxiangqing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"bzxiangqing"];
    BZxiangqing.mingcheng = @"小儿头疼";
    [self.navigationController pushViewController:BZxiangqing animated:YES];
    
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
