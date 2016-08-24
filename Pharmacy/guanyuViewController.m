//
//  guanyuViewController.m
//  Pharmacy
//
//  Created by suokun on 16/6/8.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "guanyuViewController.h"
#import "Color+Hex.h"

@interface guanyuViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *shang;
}
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation guanyuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"关于";
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [self.view addSubview:self.tableview];
    
    shang = @[@"门店名称",@"门店地址",@"联系电话",@"负责人",@"门店简介",];
    
    [self jiekou];
}

-(void)jiekou
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"wencell";
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    cell.textLabel.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.row == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",shang[indexPath.section]];
    }
    else if (indexPath.row == 1)
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 0) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",shang[indexPath.section]];
        }
        if (indexPath.section == 1) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",shang[indexPath.section]];
        }
        if (indexPath.section == 2) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",shang[indexPath.section]];
        }
        if (indexPath.section == 3) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",shang[indexPath.section]];
        }
        if (indexPath.section == 4) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",shang[indexPath.section]];
        }
    }

    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}

//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];

}


@end