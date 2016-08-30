//
//  huoqumendianyouhuijuan.m
//  Pharmacy
//
//  Created by 小狼 on 16/5/26.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "huoqumendianyouhuijuan.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "MJRefresh.h"
#import "SBJsonWriter.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "WarningBox.h"
#import "Color+Hex.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface huoqumendianyouhuijuan ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray*arr;
    CGFloat width;
    CGFloat height;
    NSString *str2;
    
    int ye;
    int coun;
    
    UILabel *label;
}
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation huoqumendianyouhuijuan

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ye = 1;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    _tableview = [[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 64, width, height - 64);
    _tableview.delegate=self;
    _tableview.dataSource=self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableview];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //状态栏名称
    self.navigationItem.title = @"门店优惠券";
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
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
        self.tableview.mj_footer=nil;
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
    NSString * url =@"/integralGift/couponInfoList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSString*officeid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    officeid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
    NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:vip,@"vipId",officeid,@"officeId",[NSString stringWithFormat:@"%d",ye],@"pageNo",@"10",@"pageSize",nil];
    
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
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                coun=[[datadic objectForKey:@"count"] intValue];
                
                NSArray*mg = [datadic objectForKey:@"couponInfoList"];
                
                if (mg.count == 0) {
                    [self kongbai];
                    label.text = @"对不起,还没有可领取的优惠券!";
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
    return  1;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 75;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *id1 =@"youhuiquan";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(10, 5, 65, 65);
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.section] objectForKey:@"url"]];
    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
    [cell.contentView addSubview:image];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(85, 5, 150, 15);
    name.text = [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"name"] ];
    name.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:name];
    
    UILabel *laiyuan = [[UILabel alloc]init];
    laiyuan.frame = CGRectMake(85, 40, 150, 15);
    laiyuan.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    laiyuan.font = [UIFont systemFontOfSize:11];
    [cell.contentView addSubview:laiyuan];
    
    NSString *a = [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"endTime"] ];
    NSString *b = [a substringToIndex:10];
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(85, 55, 150, 15);
    time.text =[NSString stringWithFormat:@"有效期至:%@",b ];
    time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    time.font = [UIFont systemFontOfSize:11];
    [cell.contentView addSubview:time];
    
    UIImageView *youtu = [[UIImageView alloc]init];
    youtu.frame = CGRectMake(width - 70, 0, 70, 75);
    [cell.contentView addSubview:youtu];
    
    UILabel *shuliang = [[UILabel alloc]init];
    shuliang.frame = CGRectMake(0, 0, 70, 20);
    shuliang.text = [NSString stringWithFormat:@"剩余:%@个",[arr[indexPath.section] objectForKey:@"publishNums"] ];
    shuliang.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    shuliang.font = [UIFont systemFontOfSize:10];
    shuliang.textAlignment = NSTextAlignmentCenter;
    [youtu addSubview:shuliang];
    
    UILabel *moner = [[UILabel alloc]init];
    moner.frame = CGRectMake(0, 20, 70, 35);
    moner.text = [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"faceValue"] ];
    moner.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    moner.font = [UIFont systemFontOfSize:18];
    moner.textAlignment = NSTextAlignmentCenter;
    [youtu addSubview:moner];
    
    UIView *xian = [[UIView alloc]init];
    xian.frame = CGRectMake(5, 55, 60, 0.5);
    xian.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [youtu addSubview:xian];
    
    UILabel *lingqu = [[UILabel alloc]init];
    lingqu.frame = CGRectMake(0, 55, 70, 20);
    
    lingqu.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    lingqu.font = [UIFont systemFontOfSize:10];
    lingqu.textAlignment = NSTextAlignmentCenter;
    [youtu addSubview:lingqu];
    
    if ( [[arr[indexPath.section] objectForKey:@"isSend"] isEqualToString:@"1"]) {
        
        if ([[arr[indexPath.section] objectForKey:@"couponType"] isEqualToString:@"4"])
        {
            lingqu.text = @"立即领取";
            
            name.textColor = [UIColor colorWithHexString:@"f24f52" alpha:1];
            
            youtu.image = [UIImage imageNamed:@"hh.png"];
            
            laiyuan.text =[NSString stringWithFormat:@"%@",[[arr[indexPath.section] objectForKey:@"office"] objectForKey:@"name"] ];
            
        }
        else
        {
            lingqu.text = @"立即领取";
            
            name.textColor = [UIColor colorWithHexString:@"41aaec" alpha:1];
            
            youtu.image = [UIImage imageNamed:@"ll.png"];
            
            laiyuan.text =@"合作商家";
        }
    }
    else
    {
        if ([[arr[indexPath.section] objectForKey:@"couponType"] isEqualToString:@"4"])
        {
            lingqu.text = @"已领取";
            
            name.textColor = [UIColor colorWithHexString:@"f24f52" alpha:1];
            
            youtu.image = [UIImage imageNamed:@"hh.png"];
            
            laiyuan.text =[NSString stringWithFormat:@"%@",[[arr[indexPath.section] objectForKey:@"office"] objectForKey:@"name"] ];
            
        }
        else
        {
            lingqu.text = @"已领取";
            
            name.textColor = [UIColor colorWithHexString:@"41aaec" alpha:1];
            
            youtu.image = [UIImage imageNamed:@"ll.png"];
            
            laiyuan.text =@"合作商家";
            
        }
        
    }
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str1  = [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"publishNums"] ];
    
    if ( [[arr[indexPath.section] objectForKey:@"isSend"] isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"领取失败" message:@"对不起,您已经领取过了" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if ([str1 isEqualToString:@"0"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"领取失败" message:@"对不起,优惠券已被领光" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否领取优惠券？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alert show];
            
            str2 = [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"id"]];
            
        }
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        ye=1;
        [self jiekou];
    }
    else if (buttonIndex == 1)
    {
        
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/basic/couponList";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        NSString*zhid;
        NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
        zhid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
        NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:str2,@"couponTypeId",vip,@"vipId",nil];
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
                
                if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                    
                    [self jiekou];
                    
                    [self.tableview reloadData];
                    
                }
            }
            @catch (NSException * e) {
                
                [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        }];
        
    }
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
