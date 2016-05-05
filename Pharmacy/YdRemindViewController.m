//
//  YdRemindViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdRemindViewController.h"
#import "AppDelegate.h"
#import "Color+Hex.h"
@interface YdRemindViewController ()
{
    CGFloat width;
    CGFloat height;
    
    int str ;
    
    NSArray *group;
    
    UIView *view;
    UIPickerView *picker;
    UIButton *queding;
    UIButton *quxiao;
    
    NSMutableArray *aar;
}
@end

@implementation YdRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    str = 0;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"'f4f4f4" alpha:1];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    //tableview
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64);
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    //状态栏名称
    self.navigationItem.title = @"用药提醒";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    //设置右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(tianjia)];
    
}

-(void)picker
{
    
    view = [[UIView alloc]init];
    view.frame = CGRectMake(0, height - 251, width, 246);
    view.backgroundColor = [UIColor whiteColor];
    
    quxiao = [[UIButton alloc]init];
    quxiao.frame = CGRectMake(5,5, 50, 30);
    [quxiao setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    [quxiao setTitle:@"取消" forState:UIControlStateNormal];
    [quxiao addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
    quxiao.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    quxiao.layer.cornerRadius = 5;
    quxiao.layer.masksToBounds = YES;
    
    queding = [[UIButton alloc]init];
    queding.frame = CGRectMake(CGRectGetMaxX(view.frame) - 55, 5, 50, 30);
    [queding setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    [queding setTitle:@"确定" forState:UIControlStateNormal];
    [queding addTarget:self action:@selector(queding ) forControlEvents:UIControlEventTouchUpInside];
    queding.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    queding.layer.cornerRadius = 5;
    queding.layer.masksToBounds = YES;
    
    picker = [[UIPickerView alloc]init];
    picker.delegate=self;
    picker.dataSource=self;
    
    picker.frame=CGRectMake(0, 35, width, 216);
    // 显示选中框
    picker.showsSelectionIndicator=YES;
    
    
    picker.backgroundColor=[UIColor whiteColor];
    group=[NSArray arrayWithObjects:@"0:00",@"0:30",@"1:00",@"1:30",@"2:00",@"2:30",@"3:00",@"3:30",@"4:00",@"4:30",@"5:00",@"5:30",@"6:00",@"6:30",@"7:00",@"7:30",@"8:00",@"8:30",@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",nil];
    [picker selectRow:0 inComponent:0 animated:NO];
    
    [self.view addSubview:view];
    [view addSubview:queding];
    [view addSubview:quxiao];
    [view addSubview:picker];

}
-(void)quxiao
{

    [view removeFromSuperview];
    [picker removeFromSuperview];
    [queding removeFromSuperview];
    [quxiao removeFromSuperview];
    
}
-(void)queding
{
    
    aar = [[NSMutableArray alloc]init];
    if (str == 1) {
        [aar addObject:group[[picker selectedRowInComponent:0]]];
    }
    else if (str == 2)
    {
        [aar addObject:group[[picker selectedRowInComponent:0]]];
        [aar addObject:group[[picker selectedRowInComponent:1]]];
    }
    else if (str == 3)
    {
        [aar addObject:group[[picker selectedRowInComponent:0]]];
        [aar addObject:group[[picker selectedRowInComponent:1]]];
        [aar addObject:group[[picker selectedRowInComponent:2]]];
    }
    else if (str == 4)
    {
        [aar addObject:group[[picker selectedRowInComponent:0]]];
        [aar addObject:group[[picker selectedRowInComponent:1]]];
        [aar addObject:group[[picker selectedRowInComponent:2]]];
        [aar addObject:group[[picker selectedRowInComponent:3]]];
    }
    
     AppDelegate * app = [[AppDelegate alloc]init];
    
     [app addLocalNotification:aar];

    [view removeFromSuperview];
    [picker removeFromSuperview];
    [queding removeFromSuperview];
    [quxiao removeFromSuperview];
   
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return (int)str;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return group.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return group[row % group.count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
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
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 55;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"tixingcell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UILabel *ci = [[UILabel alloc]init];
    ci.frame = CGRectMake(10, 5, 80, 20);
    ci.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    ci.font = [UIFont systemFontOfSize:15];
    ci.text = @"一日四次";
    
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(10, 30, 200, 20);
    time.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
    time.font = [UIFont systemFontOfSize:15];
    time.text = @"12.00,12.00,12.00,12.00";

    UISwitch *kai = [[UISwitch alloc]init];
    kai.frame = CGRectMake(width - 60, 15, 30, 15);
    [kai addTarget: self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];

    [cell.contentView addSubview:ci];
    [cell.contentView addSubview:time];
    [cell.contentView addSubview:kai];
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//添加闹钟功能
-(void)tianjia
{
    
    if (str != 0)
    {
        [view removeFromSuperview];
        [picker removeFromSuperview];
        [queding removeFromSuperview];
        [quxiao removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒的次数" message:@"请选择需要的提醒次数"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"一次",@"两次",@"三次",@"四次", nil];
        
        [alert show];
    }
    else
    {
   
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒的次数" message:@"请选择需要的提醒次数"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"一次",@"两次",@"三次",@"四次", nil];
        
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        str = 1;
        [self picker];
    }
    else if (buttonIndex == 2) {
        str = 2;
        [self picker];
    }
    else if (buttonIndex == 3) {
        str = 3;
        [self picker];
    }
    else if (buttonIndex == 4) {
        str = 4;
        [self picker];
    }
    
}
//开关
-(void)switchIsChanged:(UISwitch *)paramSender{
    NSLog(@"Sender is=%@",paramSender);
    if([paramSender isOn]){//如果开关状态为ON
        NSLog(@"The switch is turned on.");
    }else{
        NSLog(@"The switch is turned off.");
    }
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
