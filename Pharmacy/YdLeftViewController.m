//
//  YdLeftViewController.m
//  侧滑
//
//  Created by suokun on 16/2/25.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdLeftViewController.h"
#import "YdHomePageViewController.h"
#import "YdPersonalInformationViewController.h"
#import "UIViewController+RESideMenu.h"
#import "Color+Hex.h"
#import "YdWoDeDingDanViewController.h"
#import "YdyouhuiquanViewController.h"
#import "YdwodetieziViewController.h"
#import "YdwodeshoucangViewController.h"
#import "YdzhongjiangjiluViewController.h"

static NSString * const kYCLeftViewControllerCellReuseId = @"kYCLeftViewControllerCellReuseId";


@interface YdLeftViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat width;
    CGFloat height;
}
@property (nonatomic, strong) NSArray *lefs;
@property (nonatomic, assign) NSInteger previousRow;


@end

@implementation YdLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    
    _lefs = @[@"我的订单", @"我的优惠券", @"我的中奖纪录", @"我的收藏", @"我的帖子",@"意见反馈",@"分享下载",@"设置"];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 64, width, height);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kYCLeftViewControllerCellReuseId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
   
    [self.view addSubview:self.tableView];

}
//设置状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lefs.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 90;
    }
    return 0;
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //32BE60
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 80)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(10, 15, 60, 60);
    image.image = [UIImage imageNamed:@"小人@2x.png"];
    image.layer.cornerRadius = 30;
    image.layer.masksToBounds = YES;
    
    UIButton *denglu = [[UIButton alloc]init];
    denglu.frame = CGRectMake(70, 30, 100, 30);
    denglu.backgroundColor = [UIColor clearColor];
    [denglu setTitle:@"登录/注册" forState:UIControlStateNormal];
    [denglu setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    [denglu addTarget:self action:@selector(denglu) forControlEvents:UIControlEventTouchUpInside];

    [baseView addSubview:image];
    [baseView addSubview:denglu];
    return baseView;
}
-(void)denglu
{
    
    YdPersonalInformationViewController *PersonalInformation = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"personalinformation"];
    [self.navigationController pushViewController:PersonalInformation animated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYCLeftViewControllerCellReuseId forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kYCLeftViewControllerCellReuseId];
    }
    
    cell.textLabel.text = self.lefs[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        
        YdWoDeDingDanViewController *WoDeDingDan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"wodedingdan"];
        [self.navigationController pushViewController:WoDeDingDan animated:YES];
        
    }
    else if (indexPath.row == 1)
    {
        
        YdyouhuiquanViewController *youhuiquan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"youhuiquan"];
        [self.navigationController pushViewController:youhuiquan animated:YES];

    }
    else if (indexPath.row == 2)
    {
        
        YdzhongjiangjiluViewController *zhongjiangjilu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"zhongjiangjilu"];
        [self.navigationController pushViewController:zhongjiangjilu animated:YES];
        
    }
    else if (indexPath.row == 3)
    {
        
        YdwodeshoucangViewController *wodeshoucang = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"wodeshoucang"];
        [self.navigationController pushViewController:wodeshoucang animated:YES];
        
    }
    else if (indexPath.row == 4)
    {
        
        YdwodetieziViewController *wodetiezi = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"wodetiezi"];
        [self.navigationController pushViewController:wodetiezi animated:YES];
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
