//
//  YdyouhuiquanViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/14.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdyouhuiquanViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "huoqumendianyouhuijuan.h"
#import "MJRefresh.h"

@interface YdyouhuiquanViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *arr;
    UITextField *nameField;
    
    NSString *couponId;
    NSString *couId;
    
    int ye;
    int coun;
    
}
@end

@implementation YdyouhuiquanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //状态栏名称
    self.navigationItem.title = @"我的优惠券";
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
  
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"领取" style:UIBarButtonItemStyleDone target:self action:@selector(shiyishi)];
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64);
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
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
    NSString * url =@"/share/MyCoupon";
    
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
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1130",@"vipId",[NSString stringWithFormat:@"%d",ye],@"pageNo",@"5",@"pageSize",nil];
    
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
            NSLog(@"=============我的优惠券============%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                arr = [datadic objectForKey:@"list"];
                
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
//        NSLog(@"错误：%@",error);
    }];
    
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
    
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    

    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(10, 5, 65, 65);
    image.backgroundColor = [UIColor grayColor];
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.section] objectForKey:@"url"]];
    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
    [cell.contentView addSubview:image];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(85, 5, 150, 15);
    name.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.section] objectForKey:@"couponInfo"] objectForKey:@"name"]];
    name.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:name];
    
    UIImageView *youtu = [[UIImageView alloc]init];
    youtu.frame = CGRectMake(width - 70, 0, 70, 75);
    [cell.contentView addSubview:youtu];
    
    UILabel *laiyuan = [[UILabel alloc]init];
    laiyuan.frame = CGRectMake(85, 40, 150, 15);
    laiyuan.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    laiyuan.font = [UIFont systemFontOfSize:11];
    if ([[[arr[indexPath.section] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"1"])
    {
        youtu.image = [UIImage imageNamed:@"hh.png"];
        laiyuan.text = @"摇一摇";
    }
    else if ([[[arr[indexPath.section] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"2"])
    {
        youtu.image = [UIImage imageNamed:@"hh.png"];
        laiyuan.text = @"幸运大转盘";
    }
    else if ([[[arr[indexPath.section] objectForKey:@"couponInfo"] objectForKey:@"couponType"]isEqual:@"3"])
    {
        youtu.image = [UIImage imageNamed:@"hh.png"];
        laiyuan.text = @"有奖问答";
    }
    else if ([[[arr[indexPath.section] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"4"])
    {
        youtu.image = [UIImage imageNamed:@"hh.png"];
        laiyuan.text = @"普通优惠券";
    }
    else if ([[[arr[indexPath.section] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"5"])
    {
        youtu.image = [UIImage imageNamed:@"ll.png"];
        laiyuan.text = @"商家优惠券";
    }

    [cell.contentView addSubview:laiyuan];
    
    NSString *a = [[arr[indexPath.section] objectForKey:@"couponInfo"] objectForKey:@"endTime"];
    NSString *b = [a substringToIndex:10];
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(85, 55, 150, 15);
    time.text =[NSString stringWithFormat:@"有效期至:%@",b ];
    time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    time.font = [UIFont systemFontOfSize:11];
    [cell.contentView addSubview:time];
    
    UILabel *lingqu = [[UILabel alloc]init];
    lingqu.frame = CGRectMake(0, 55, 70, 20);
    lingqu.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    lingqu.font = [UIFont systemFontOfSize:10];
    lingqu.textAlignment = NSTextAlignmentCenter;
    [youtu addSubview:lingqu];

    
    UILabel *shuliang = [[UILabel alloc]init];
    shuliang.frame = CGRectMake(0, 0, 70, 20);
    if ([[[arr[indexPath.section] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"1"])
    {
        shuliang.text = @"未使用";
        lingqu.text = @"立即兑换";
    }
    else if ([[[arr[indexPath.section] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"0"])
    {
        shuliang.text = @"已使用";
        lingqu.text = @"已兑换";
    }
    else if ([[[arr[indexPath.section] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@""])
    {
        shuliang.text = @"暂无";
    }
    shuliang.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    shuliang.font = [UIFont systemFontOfSize:10];
    shuliang.textAlignment = NSTextAlignmentCenter;
    [youtu addSubview:shuliang];
    
    UILabel *moner = [[UILabel alloc]init];
    moner.frame = CGRectMake(0, 20, 70, 35);
    moner.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.section] objectForKey:@"couponInfo"] objectForKey:@"faceValue"]];
    moner.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    moner.font = [UIFont systemFontOfSize:18];
    moner.textAlignment = NSTextAlignmentCenter;
    [youtu addSubview:moner];
    
    UIView *xian = [[UIView alloc]init];
    xian.frame = CGRectMake(5, 55, 60, 0.5);
    xian.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [youtu addSubview:xian];
    
    
    
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
    
    if ([[[arr[indexPath.section] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"0"])
    {
        
        [WarningBox warningBoxModeText:@"您已兑换过，不可再次使用!" andView:self.view];
        
    }
    else
    {
        couponId =  [arr[indexPath.section] objectForKey:@"couponId"];
        couId = [arr[indexPath.section] objectForKey:@"couId"];
        
        if ([[[arr[indexPath.section] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"5"])
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
        NSString*vip;
        NSString *path6 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
        NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path6];
        vip=[NSString stringWithFormat:@"%@",[pp objectForKey:@"id"]];
        
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1130",@"vipId",@"67a3c6f913d24373b4a7917ba8a987ff",@"storeId",couponId,@"id",nameField.text,@"storeCode",couId,@"couId",@"",@"awardId",nil];
        //NSLog(@"datadicdatadicdatadicdatadicdatadicdatadic%@",datadic);
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        //NSLog(@"flsdjkflsajflkjsdlkfjlksjflkjaslkfjlsdakfjlk%@",url1);
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            @try
            {
                [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                NSLog(@"我的优惠卷%@",responseObject);
                if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                    
                    NSDictionary*datadic=[responseObject valueForKey:@"data"];
                    
                    arr = [datadic objectForKey:@"list"];
                    
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
//            NSLog(@"错误：%@",error);
        }];
    }
}
-(void)fanhui
{
    if (([self.panduan isEqualToString:@"1"])) {
        //返回上一页
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    else
    {
        //返回上一页
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

@end
