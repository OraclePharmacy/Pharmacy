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
    
    NSMutableArray *arr;
    int ye;
    int coun;
    
    UILabel *label;
}
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdWoDeDingDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.tableFooterView = [[UIView alloc] init];
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
    
    if (ye*5 >coun+4) {
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
  NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
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
                 coun=[[datadic objectForKey:@"count"] intValue];
                 NSArray*mg= [datadic objectForKey:@"myOrder"];
                
                if (mg == nil) {
                    [self kongbai];
                    label.text = @"对不起,您暂时没有订单!";
                }
                
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
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr.count;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGRectGetMaxY(queren.frame) + 3;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"wodedingdan";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    //门店名
    UILabel *Ydname = [[UILabel alloc]init];
    Ydname.frame = CGRectMake(5, 0, (width - 10)/2, 30);
    Ydname.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    Ydname.text = [[arr[indexPath.section] objectForKey:@"office"]  objectForKey:@"name"];
    Ydname.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:Ydname];
    //订单状态
    UILabel *Ddzhuangtai = [[UILabel alloc]init];
    Ddzhuangtai.frame = CGRectMake(width - (width - 10)/2 - 5 , 0, (width - 10)/2, 30);
    Ddzhuangtai.textColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    if ([[arr[indexPath.section] objectForKey:@"states"] isEqual:@"0"]) {
        Ddzhuangtai.text = @"订单状态:  已处理";
    }
    else if ([[arr[indexPath.section] objectForKey:@"states"] isEqual:@"1"]) {
        Ddzhuangtai.text = @"订单状态:  已发货";
    }
    else if ([[arr[indexPath.section] objectForKey:@"states"] isEqual:@"2"]) {
        Ddzhuangtai.text = @"订单状态:  已完成";
    }
    else if ([[arr[indexPath.section] objectForKey:@"states"] isEqual:@"3"]) {
        Ddzhuangtai.text = @"订单状态:  未处理";
    }
    Ddzhuangtai.font = [UIFont systemFontOfSize:14];
    Ddzhuangtai.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:Ddzhuangtai];
    //收药人
    UILabel *Syren = [[UILabel alloc]init];
    Syren.frame = CGRectMake(5, CGRectGetMaxY(Ydname.frame), 60, 20);
    Syren.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    Syren.text = @"收药人:";
    Syren.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:Syren];
    //收药人返回数据
    UILabel *SyrenFH = [[UILabel alloc]init];
    SyrenFH.frame = CGRectMake(65,CGRectGetMaxY(Ydname.frame),width - 70,20);
    SyrenFH.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    SyrenFH.text = [[arr[indexPath.section] objectForKey:@"vipinfo"] objectForKey:@"name"];
    SyrenFH.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:SyrenFH];
    //联系电话
    UILabel *Phone = [[UILabel alloc]init];
    Phone.frame = CGRectMake(5,CGRectGetMaxY(Syren.frame),60,20);
    Phone.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    Phone.text = @"联系电话:";
    Phone.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:Phone];
    //联系电话返回数据
    UILabel *PhoneFH = [[UILabel alloc]init];
    PhoneFH.frame = CGRectMake(65,CGRectGetMaxY(Syren.frame),width - 70,20);
    PhoneFH.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    PhoneFH.text = [[arr[indexPath.section] objectForKey:@"vipinfo"] objectForKey:@"phoneNumber"];
    PhoneFH.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:PhoneFH];
    //送药地址
    UILabel *Sydizhi = [[UILabel alloc]init];
    Sydizhi.frame = CGRectMake(5,CGRectGetMaxY(Phone.frame),60,20);
    Sydizhi.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    Sydizhi.text = @"送药地址:";
    Sydizhi.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:Sydizhi];
    //送药地址返回数据
    UILabel *SydizhiFH = [[UILabel alloc]init];
    SydizhiFH.frame = CGRectMake(65,CGRectGetMaxY(Phone.frame),width - 70,20);
    SydizhiFH.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    SydizhiFH.text = [arr[indexPath.section] objectForKey:@"reciAddress"];
    SydizhiFH.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:SydizhiFH];
    //接单时间
    UILabel *Jdtime = [[UILabel alloc]init];
    Jdtime.frame = CGRectMake(5,CGRectGetMaxY(SydizhiFH.frame),60,20);
    Jdtime.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    Jdtime.text = @"接单时间:";
    Jdtime.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:Jdtime];
    //接单时间返回
    UILabel *JdtimeFH = [[UILabel alloc]init];
    JdtimeFH.frame = CGRectMake(65,CGRectGetMaxY(SydizhiFH.frame),width - 70,20);
    JdtimeFH.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    JdtimeFH.text = [arr[indexPath.section] objectForKey:@"orderTime"];
    JdtimeFH.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:JdtimeFH];
    //派送时间
    UILabel *Pstime = [[UILabel alloc]init];
    Pstime.frame = CGRectMake(5,CGRectGetMaxY(JdtimeFH.frame),60,20);
    Pstime.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    Pstime.text = @"派送时间:";
    Pstime.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:Pstime];
    //派送时间返回
    UILabel *PstimeFH = [[UILabel alloc]init];
    PstimeFH.frame = CGRectMake(65,CGRectGetMaxY(JdtimeFH.frame),width - 70,20);
    PstimeFH.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    if (NULL == [arr[indexPath.section] objectForKey:@"sendTime"] ) {
        
        PstimeFH.text = @"暂时没有派送信息,请耐心等待";
    }
    else{
        
        PstimeFH.text = [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"sendTime"]];
    }
    PstimeFH.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:PstimeFH];
    //背景
    UIView *Beijing = [[UIView alloc]init];
    Beijing.frame = CGRectMake(0, 30, width, CGRectGetMaxY(PstimeFH.frame) - 30);
    Beijing.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:0.5];
    [cell.contentView addSubview:Beijing];
    //确认按钮
    queren = [[UIButton alloc]init];
    queren.tag = 100 + indexPath.row;
    queren.frame = CGRectMake(width - 80 , CGRectGetMaxY(Beijing.frame) + 3, 60, 24);
    [queren setTitle:@"确认收货" forState:UIControlStateNormal];
    [queren setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    queren.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    queren.layer.cornerRadius = 5;
    queren.layer.masksToBounds = YES;
    queren.titleLabel.font    = [UIFont systemFontOfSize: 13];
    [queren addTarget:self action:@selector(queren) forControlEvents:UIControlEventTouchUpInside];
    if ([[arr[indexPath.section] objectForKey:@"states"] isEqual:@"2"]) {
        
    }else
    [cell.contentView addSubview:queren];
    
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
    
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[arr[queren.tag - 100] objectForKey:@"id"]],@"id",@"2",@"states",nil];
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
//                [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
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
