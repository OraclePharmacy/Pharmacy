//
//  YdzhongjiangjiluViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/14.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdzhongjiangjiluViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "YdzhongjiangxiangqingViewController.h"
#import "MJRefresh.h"

@interface YdzhongjiangjiluViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSMutableArray *arr;
    
    int ye;
    int coun;
    
    UILabel *label;
}
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdzhongjiangjiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"我的中奖纪录";
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
    self.tableview.tableFooterView = [[UIView alloc] init];
    
    ye = 1;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewdata)];
    self.tableview.mj_header = header;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    MJRefreshAutoNormalFooter*footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableview.mj_footer = footer;
    
    [self jiekou];

}

-(void)loadNewdata{
    
    ye = 1;
    MJRefreshAutoNormalFooter*footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableview.mj_footer = footer;

    [self jiekou];
    [self.tableview.mj_header endRefreshing];
    
}
-(void)loadNewData{
    
    if (ye*10 >coun+9||10>coun) {
        [WarningBox warningBoxModeText:@"已经是最后一页了!" andView:self.view];
       
        self.tableview.mj_footer = nil;

        [self.tableview.mj_footer endRefreshing];
    }else{
        if (ye==1) {
            ye=2;
        }
        [self jiekou];
        [self.tableview.mj_footer endRefreshing];
    }
    
}

-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/basic/awardetailList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
   NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:vip,@"vipId",[NSString stringWithFormat:@"%d",ye],@"pageNo",@"10",@"pageSize",nil];
    
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
                
               NSArray*mg = [datadic objectForKey:@"awardetailList"];
                
                if (mg.count == 0) {
                    [self kongbai];
                    label.text = @"对不起，你还没有中奖!";
                }
                
                coun=[[datadic objectForKey:@"count"] intValue];
                
                if (ye!=1) {
                    for (NSDictionary*dd in mg) {
                        [arr addObject:dd];
                    }
                }else{
                    arr=[NSMutableArray arrayWithArray:mg];
                }
                ye++;

                
                [self.tableview reloadData];
                
            }
        }
        @catch (NSException * e) {
            [self kongbai];
            label.text = @"";
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self kongbai];
        label.text = @"";
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        NSLog(@"错误：%@",error);
    }];
    
    
}
-(void)kongbai
{
    _tableview.hidden = YES;
    
    label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 114, width, 30);
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}
//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr.count;
}
//cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//cell高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 65;
}
//header高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//自定义header
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.view;
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *id1 =@"zhongjiang";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    UIView *shu = [[UIView alloc]init];
    shu.frame = CGRectMake(5, 0, 1, 65);
    shu.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    
    UIImageView *yuan = [[UIImageView alloc]init];
    yuan.frame = CGRectMake(6, 35, 9, 9);
    yuan.image = [UIImage imageNamed:@"time_line_mark.png"];
    
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(0, 5, width, 20);
    time.font = [UIFont systemFontOfSize:13];
    time.text = [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"actTime"] ];
    time.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    time.textAlignment = NSTextAlignmentCenter;
    
    
    UIView *bai = [[UIView alloc]init];
    bai.backgroundColor = [UIColor whiteColor];
    bai.frame = CGRectMake(15, 25, width-25, 40);
    
    
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(0, 0, width -20, 20);
    title.font = [UIFont systemFontOfSize:15];
    title.text = [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"awardName"] ];
    title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    
    
    UILabel *neirong = [[UILabel alloc]init];
    neirong.frame = CGRectMake(0, 20, width -20, 20);
    neirong.font = [UIFont systemFontOfSize:13];
    neirong.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    
    if ([[arr[indexPath.section] objectForKey:@"exchange"] isEqualToString:@"0"])
    {
        neirong.text = @"已兑换";
    }
    else if ([[arr[indexPath.section] objectForKey:@"exchange"] isEqualToString:@"1"])
    {
        neirong .text = @"未兑换";
    }
    else if ([[arr[indexPath.section] objectForKey:@"exchange"] isEqualToString:@"2"])
    {
        neirong.text = @"已过期";
    }
    
    [bai addSubview:title];
    [bai addSubview:neirong];
    
    
    [cell.contentView addSubview:shu];
    [cell.contentView addSubview:time];
    [cell.contentView addSubview:bai];
    [cell.contentView addSubview:yuan];
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sss = [arr[indexPath.section] objectForKey:@"id"];
    NSLog(@"sssssssssssssss%@",sss);
    YdzhongjiangxiangqingViewController *zhongjiangxiangqing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"zhongjiangxiangqing"];
    zhongjiangxiangqing.jiangpinid = sss;
    if ( NULL == [arr[indexPath.section] objectForKey:@"couId"] )
    {
        zhongjiangxiangqing.couId = @"";
    }
    else
    {
        zhongjiangxiangqing.couId = [arr[indexPath.section] objectForKey:@"couId"];
    }
    if ( NULL == [arr[indexPath.section] objectForKey:@"couInfoId"] )
    {
        zhongjiangxiangqing.couInfoId = @"";
    }
    else
    {
        zhongjiangxiangqing.couInfoId = [arr[indexPath.section] objectForKey:@"couInfoId"];
    }
    if ([[arr[indexPath.section] objectForKey:@"exchange"] isEqualToString:@"0"])
    {
        zhongjiangxiangqing.panduan = @"0";
    }
    else if ([[arr[indexPath.section] objectForKey:@"exchange"] isEqualToString:@"1"])
    {
        zhongjiangxiangqing.panduan = @"1";
    }
    [self.navigationController pushViewController:zhongjiangxiangqing animated:YES];
}
//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
@end
