//
//  YdzhongjiangxiangqingViewController.m
//  Pharmacy
//
//  Created by suokun on 16/6/12.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdzhongjiangxiangqingViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"

@interface YdzhongjiangxiangqingViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSDictionary *arr;
    NSArray *arr1;
    
    UITextField *nameField;
}
@end

@implementation YdzhongjiangxiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr1 = @[@"",@"奖品来源:", @"奖品名称:", @"兑换药店:"];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"中奖纪录详情";
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64);
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];

    [self jiekou];
}

-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/basic/awardetail";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:self.jiangpinid,@"id",nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            //[WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            NSLog(@"我的中奖纪录%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                arr = [datadic valueForKey:@"findAwardetail"];
                
                
                [self.tableview reloadData];
                
            }
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        NSLog(@"错误：%@",error);
    }];
    
    
}

//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return arr1.count;
    }
    else
    {
        return  0;
    }
    
}
//cell高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 150;
        }
        else
        {
            return 50;
        }
    }
    else
    {
        return 0;
    }
}
//header高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 80;
    }
    return 0;
}
//自定义header
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    if (section == 1) {
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(50, 40, width-100, 30);
        btn.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
        [btn setTitle:@"兑换" forState:UIControlStateNormal];
        [btn setTintColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1]];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(duihuan) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
    }
    
    return baseView;

}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *id1 =@"zhongjiang";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    UIView *xian = [[UIView alloc]init];
    xian.frame = CGRectMake(15, 49, width - 11, 1);
    xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    [cell.contentView addSubview:xian];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    if (indexPath.section == 0) {
    if (indexPath.row == 0)
    {
        UIImageView *touxiang = [[UIImageView alloc]init];
        touxiang.frame = CGRectMake(0, 0, width, 150);
        touxiang.layer.masksToBounds = YES;
        NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr objectForKey:@"photo"]];
        [touxiang sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
        [cell.contentView addSubview:touxiang];
    }
    else
    {
        cell.textLabel.text = arr1[indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        
        UILabel *text = [[UILabel alloc]init];
        text.frame = CGRectMake(100, 10, width -110, 30);
        text.font = [UIFont systemFontOfSize:15];
        text.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        [cell.contentView addSubview:text];
        
        if (indexPath.row == 1)
        {
            if ([[arr objectForKey:@"awardSource"] isEqualToString:@"1"])
            {
                 text.text = @"摇一摇";
            }
            else if ([[arr objectForKey:@"awardSource"] isEqualToString:@"2"])
            {
                text.text = @"大转盘";
            }
            else if ([[arr objectForKey:@"awardSource"] isEqualToString:@"3"])
            {
                text.text = @"有奖问答";
            }
            else if ([[arr objectForKey:@"awardSource"] isEqualToString:@"4"])
            {
                text.text = @"领取的优惠券";
            }
            else if ([[arr objectForKey:@"awardSource"] isEqualToString:@"5"])
            {
                text.text = @"合作商家";
            }

        }
        else if (indexPath.row == 2)
        {
            text.text = [NSString stringWithFormat:@"%@",[arr objectForKey:@"awardName"] ];
        }
        else if (indexPath.row == 3)
        {
            if (NULL == [NSString stringWithFormat:@"%@",[[arr objectForKey:@"office"] objectForKey:@"name"]]) {
                text.text=@"";
            }else
             text.text = [NSString stringWithFormat:@"%@",[[arr objectForKey:@"office"] objectForKey:@"name"]];
           
        }
        
    }
    }
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return baseView;
}
-(void)duihuan
{

    if ([self.panduan isEqualToString:@"0"]) {
        
        [WarningBox warningBoxModeText:@"您已兑换过，不可再次使用!" andView:self.view];
        
    }
    else if ([self.panduan isEqualToString:@"1"]){
    if ([[arr objectForKey:@"awardSource"] isEqualToString:@"5"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"兑换" message:@"是否兑换优惠券?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"兑换" message:@"是否兑换优惠券?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        nameField = [alert textFieldAtIndex:0];
        nameField.placeholder = @"请输入一个名称";
        
        [alert show];
        
    }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/basic/couponExchange";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
     NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
        NSString*zhid;
        NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
        zhid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];

        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:self.jiangpinid,@"awardId",zhid,@"storeId",vip,@"vipId",nameField.text,@"storeCode",self.couId,@"couId",self.couInfoId,@"id",nil];
        NSLog(@"%@",datadic);
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            @try
            {
                //[WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
    
                if ([[responseObject objectForKey:@"code"] intValue]==0000)
                {
                    
                   //[self.navigationController popViewControllerAnimated:YES];
                    
                }
            }
            @catch (NSException * e) {
                
                [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
            NSLog(@"错误：%@",error);
        }];
    }
}
//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
