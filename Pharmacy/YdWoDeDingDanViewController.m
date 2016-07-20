//
//  YdWoDeDingDanViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdWoDeDingDanViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "MJRefresh.h"

@interface YdWoDeDingDanViewController ()
{
    CGFloat width;
    CGFloat height;
    
    UIButton *queren;
    
    NSArray *arr;
    int ye;
    int coun;
}
@end

@implementation YdWoDeDingDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //状态栏名称
    self.navigationItem.title = @"我的订单";
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableview];
    
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
    [self jiekou];
    [self.tableview.mj_header endRefreshing];
    
}
-(void)loadNewData{
    
    if (ye*3 >coun+2) {
        [WarningBox warningBoxModeText:@"已经是最后一页了!" andView:self.view];
        
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
    NSString * url =@"/share/myOrder";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSString*vip;
    NSString *path6 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
    NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path6];
    vip=[NSString stringWithFormat:@"%@",[pp objectForKey:@"id"]];
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:vip,@"vipId",[NSString stringWithFormat:@"%d",ye],@"pageNo",@"5",@"pageSize",nil];
    
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
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            NSLog(@"我的订单%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                arr = [datadic objectForKey:@"myOrder"];
                
                coun=[[datadic objectForKey:@"count"] intValue];
                
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

//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 186;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat kuan = width - 20;
    CGFloat gao = 166;
    
    static NSString *id1 =@"wodedingdan";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    UIView *beijing = [[UIView alloc]init];
    beijing.frame = CGRectMake(10, 10, kuan, gao);
    beijing.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    
    UIView *beijinger = [[UIView alloc]init];
    beijinger.frame = CGRectMake(1, 1, kuan - 2, gao - 2);
    beijinger.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:1];
    [beijing addSubview:beijinger];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(5, 5, kuan / 2 , 20);
    name.font = [UIFont systemFontOfSize:13];
    name.text = [NSString stringWithFormat:@"收  药  人:  %@",[[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"name"]];
    name.textColor = [UIColor colorWithHexString:@"646464" alpha:1];

    [beijinger addSubview:name];
    
    UILabel *dianhua = [[UILabel alloc]init];
    dianhua.frame = CGRectMake(kuan / 2, 5, kuan / 2 - 5 , 20);
    dianhua.font = [UIFont systemFontOfSize:13];
    dianhua.text = [NSString stringWithFormat:@"联系电话:%@",[[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"phoneNumber"]];
    dianhua.textColor = [UIColor colorWithHexString:@"646464" alpha:1];

    [beijinger addSubview:dianhua];
    
    UILabel *zhuangtai = [[UILabel alloc]init];
    zhuangtai.frame = CGRectMake(5, 26, kuan - 10, 20);
    zhuangtai.font = [UIFont systemFontOfSize:13];
    zhuangtai.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    
    if ([[arr[indexPath.row] objectForKey:@"states"] isEqual:@"0"]) {
        zhuangtai.text = @"订单状态:  已处理";
    }
    else if ([[arr[indexPath.row] objectForKey:@"states"] isEqual:@"1"]) {
        zhuangtai.text = @"订单状态:  已发货";
    }
    else if ([[arr[indexPath.row] objectForKey:@"states"] isEqual:@"2"]) {
        zhuangtai.text = @"订单状态:  已完成";
    }
    else if ([[arr[indexPath.row] objectForKey:@"states"] isEqual:@"3"]) {
        zhuangtai.text = @"订单状态:  未处理";
    }

    [beijinger addSubview:zhuangtai];
    
    UILabel *jiedan = [[UILabel alloc]init];
    jiedan.frame = CGRectMake(5, 47, kuan - 10, 20);
    jiedan.font = [UIFont systemFontOfSize:13];
    jiedan.text = [NSString stringWithFormat:@"接单门店:  %@",[[[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"office"] objectForKey:@"name"]];
    jiedan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];

    [beijinger addSubview:jiedan];

    UILabel *dizhi = [[UILabel alloc]init];
    dizhi.frame = CGRectMake(5, 68, kuan - 10, 20);
    dizhi.font = [UIFont systemFontOfSize:13];
    dizhi.text = [NSString stringWithFormat:@"送药地址:  %@",[arr[indexPath.row] objectForKey:@"reciAddress"]];
    dizhi.textColor = [UIColor colorWithHexString:@"646464" alpha:1];

    [beijinger addSubview:dizhi];
    
    UILabel *shijian = [[UILabel alloc]init];
    shijian.frame = CGRectMake(5, 89, kuan - 10, 20);
    shijian.font = [UIFont systemFontOfSize:13];
    shijian.text = [NSString stringWithFormat:@"接单时间:  %@",[arr[indexPath.row] objectForKey:@"orderTime"]];
    shijian.textColor = [UIColor colorWithHexString:@"646464" alpha:1];

    [beijinger addSubview:shijian];
    
    UILabel *paisong = [[UILabel alloc]init];
    paisong.frame = CGRectMake(5, 110, kuan - 10, 20);
    paisong.font = [UIFont systemFontOfSize:13];
    if ([[arr[indexPath.row] objectForKey:@"sendTime"] isEqualToString:@""]) {
         paisong.text = @"派送时间:";
    }
    else
    {
        paisong.text = [NSString stringWithFormat:@"派送时间:  %@",[arr[indexPath.row] objectForKey:@"sendTime"]];
    }
    paisong.textColor = [UIColor colorWithHexString:@"646464" alpha:1];

    [beijinger addSubview:paisong];
    
    queren = [[UIButton alloc]init];
    queren.tag = 100 + indexPath.row;
    queren.frame = CGRectMake(30 , 136, kuan - 60, 20);
    [queren setTitle:@"确认收货" forState:UIControlStateNormal];
    [queren setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    queren.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    queren.layer.cornerRadius = 5;
    queren.layer.masksToBounds = YES;
    queren.titleLabel.font    = [UIFont systemFontOfSize: 13];
    [queren addTarget:self action:@selector(queren) forControlEvents:UIControlEventTouchUpInside];
    
    [beijinger addSubview:queren];

    [cell.contentView addSubview:beijing];
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}

-(void)queren
{
    //NSLog(@"%@",[arr[queren.tag - 100] objectForKey:@"states"]);
    if ([[NSString stringWithFormat:@"%@",[arr[queren.tag - 100] objectForKey:@"states"]] isEqualToString:@"1"]) {
        
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/function/changeOrdStateById";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        NSString*vip;
        NSString *path6 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
        NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path6];
        vip=[NSString stringWithFormat:@"%@",[pp objectForKey:@"id"]];
        
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[arr[queren.tag - 100] objectForKey:@"id"]],@"id",@"2",@"states",nil];
        
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
                [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                NSLog(@"我的订单%@",responseObject);
                if ([[responseObject objectForKey:@"code"] intValue]==0000) {

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
    else if ([[NSString stringWithFormat:@"%@",[arr[queren.tag - 100] objectForKey:@"states"]] isEqualToString:@"2"])
    {
        [WarningBox warningBoxModeText:@"订单已完成，无法进行操作！" andView:self.view];
    }
     else if ([[NSString stringWithFormat:@"%@",[arr[queren.tag - 100] objectForKey:@"states"]] isEqualToString:@"3"])
    {
        [WarningBox warningBoxModeText:@"暂未发货,不能收货！" andView:self.view];
    }
    else if ([[NSString stringWithFormat:@"%@",[arr[queren.tag - 100] objectForKey:@"states"]] isEqualToString:@"0"])
    {
        [WarningBox warningBoxModeText:@"正在处理中,请稍后..." andView:self.view];

    }
}

//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
