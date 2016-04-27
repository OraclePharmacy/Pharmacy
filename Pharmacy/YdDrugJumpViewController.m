//
//  YdDrugJumpViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdDrugJumpViewController.h"
#import "YdDrugViewController.h"
#import "Color+Hex.h"
#import "YdyaopinxiangqingViewController.h"
@interface YdDrugJumpViewController ()
{
    CGFloat width;
    CGFloat height;
}
@end

@implementation YdDrugJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    //状态栏名称
    self.navigationItem.title = @"病症名称";
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
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
    return 130;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"bingzheng";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 80, 80)];
    image.backgroundColor = [UIColor grayColor];
    
    UILabel *name= [[UILabel alloc]initWithFrame:CGRectMake(120 , 10, width -140 , 20)];
    name.font = [UIFont systemFontOfSize:15];
    //name.textAlignment = NSTextAlignmentCenter;
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    name.text =@"葡萄糖";
    

    
    UILabel *changjia = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, width -140, 20)];
    changjia.font = [UIFont systemFontOfSize:13];
    //changjia.textAlignment = NSTextAlignmentCenter;
    changjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    changjia.text =@"哈尔滨医药六场";

    
    UILabel *guige = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, width -140, 20)];
    guige.font = [UIFont systemFontOfSize:11];
    //guige.textAlignment = NSTextAlignmentCenter;
    guige.textColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    guige.text =@"个/盒";

    
    UILabel *jiage = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, width -140, 20)];
    jiage.font = [UIFont systemFontOfSize:10];
    //jiage.textAlignment = NSTextAlignmentCenter;
    jiage.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    jiage.text =@"¥1058";
    
    
    UILabel *jianjie = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, width - 40 , 40)];
    jianjie.font = [UIFont systemFontOfSize:12];
    //jianjie.textAlignment = NSTextAlignmentCenter;
    jianjie.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    jianjie.text =@"哈尔滨医药六场，浑善达克减肥是靠近阿富汗看了就撒地方好，谁都会分开就撒发挥空间上";
    jianjie.numberOfLines = 2;
    
    [cell.contentView addSubview:image];
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:changjia];
    [cell.contentView addSubview:guige];
    [cell.contentView addSubview:jiage];
    [cell.contentView addSubview:jianjie];
    
    
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    //点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YdyaopinxiangqingViewController  *xiangqing =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"yaopinxiangqing"];
    [self.navigationController pushViewController:xiangqing animated:YES];
    
    NSLog(@"11");
    
    return;
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
