//
//  YdLeftViewController.m
//  侧滑
//
//  Created by suokun on 16/2/25.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdLeftViewController.h"
#import "YdHomePageViewController.h"
//#import "YdSecondViewController.h"
//#import "YdThirdViewController.h"
//#import "YdFourthViewController.h"
//#import "YdFifthViewController.h"
#import "UIViewController+RESideMenu.h"

static NSString * const kYCLeftViewControllerCellReuseId = @"kYCLeftViewControllerCellReuseId";


@interface YdLeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *lefs;
@property (nonatomic, assign) NSInteger previousRow;


@end

@implementation YdLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    _lefs = @[@"首页", @"客服热线", @"用户反馈", @"软件设置", @"关于我们"];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width - 64);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kYCLeftViewControllerCellReuseId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
   
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYCLeftViewControllerCellReuseId forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kYCLeftViewControllerCellReuseId];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.lefs[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.highlightedTextColor = [UIColor grayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
