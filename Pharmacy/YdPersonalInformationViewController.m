//
//  YdPersonalInformationViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdPersonalInformationViewController.h"
#import "Color+Hex.h"
@interface YdPersonalInformationViewController ()
{
    CGFloat width;
    CGFloat height;
    
    UIButton *nan;
    UIButton *nv;
    
    NSString *sex;
}
@property (strong,nonatomic)UITableView *tableview;
@property (nonatomic, strong) NSArray *first;
@property (nonatomic, strong) NSArray *second;
@property (nonatomic, strong) NSArray *third;

@end

@implementation YdPersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    _first = @[@"头像", @"昵称"];
    _second = @[@"姓名",@"性别",@"年龄",@"会员卡号(选填)",@"地区",@"详细地址"];
    _third = @[@"请输入姓名",@"",@"请输入年龄",@"请输入会员卡号",@"请选择地区",@"请输入详细地址"];
    
    //创建tableview
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height-64);
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [self.view addSubview:self.tableview];
    //代理协议
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
}
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0) {
        return 2;
    }
    else if (section == 1)
    {
         return 6;
    }
    return 0;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ( indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        }
        else
            return 40;
    }
    else
        return 40;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 20;
    }
    else if (section ==2){
        return 80;
    }
        return 0;
}
//header
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];

    if (section == 2) {

        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(50, 20, width-100, 30);
        btn.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setTintColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1]];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(baocun) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
    }
    
    return baseView;
}
//保存方法
-(void)baocun
{
    [self dismissViewControllerAnimated:YES completion: nil ];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    //lable
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    //头像
    UIButton *touxiang = [[UIButton alloc]init];
    touxiang.frame = CGRectMake(width - 80, 10, 60, 60);
    [touxiang setImage:[UIImage imageNamed:@"小人@2x.png"] forState:UIControlStateNormal];
    touxiang.layer.cornerRadius = 30;
    touxiang.layer.masksToBounds = YES;
    touxiang.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [touxiang addTarget:self action:@selector(zhaoxiang) forControlEvents:UIControlEventTouchUpInside];

    //textfield
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(130, 10, width - 150, 20);
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont systemFontOfSize:13];
    //textField.backgroundColor = [UIColor redColor];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = self.first[indexPath.row];
        
        if (indexPath.row == 0)
        {
            [cell.contentView addSubview:touxiang];
        }
        else
        {
            textField.placeholder = @"请输入昵称";
            [cell.contentView addSubview:textField];
        }
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = self.second[indexPath.row];
        if (indexPath.row == 1)
        {
            nan = [[UIButton alloc]init];
            nan.frame = CGRectMake(width - 80, 10, 30, 20);
            [nan setImage:[UIImage imageNamed:@"sex2@3x.png"] forState:UIControlStateNormal];
            [nan addTarget:self action:@selector(man) forControlEvents:UIControlEventTouchUpInside];

            
            nv = [[UIButton alloc]init];
            nv.frame = CGRectMake(width - 50, 10, 30, 20);
            [nv setImage:[UIImage imageNamed:@"sex1@3x.png"] forState:UIControlStateNormal];
            [nv addTarget:self action:@selector(woman) forControlEvents:UIControlEventTouchUpInside];

    
            
            [cell.contentView addSubview:nan];
            [cell.contentView addSubview:nv];

            
        }
        else
        {
            textField.placeholder = self.third[indexPath.row];
            [cell.contentView addSubview:textField];
        }
        
    }
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;

    return cell;
}
//头像
-(void)zhaoxiang
{
    NSLog(@"zhaoxiang");
}
//性别
-(void)man
{
    [nan setImage:[UIImage imageNamed:@"sexnan@3x.png"] forState:UIControlStateNormal];
    [nv setImage:[UIImage imageNamed:@"sex1@3x.png"] forState:UIControlStateNormal];
    sex = @"男";
}
-(void)woman
{
    [nan setImage:[UIImage imageNamed:@"sex2@3x.png"] forState:UIControlStateNormal];
    [nv setImage:[UIImage imageNamed:@"sexnv@3x.png"] forState:UIControlStateNormal];
    sex = @"女";
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 1;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];

    return baseView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏键盘
    [self.view endEditing:YES];
    
}
//返回
- (IBAction)fanhui:(id)sender {
    
    [ self dismissViewControllerAnimated: YES completion: nil ];
    
}
@end
