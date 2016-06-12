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

@interface huoqumendianyouhuijuan ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray*arr;
    CGFloat width;
    CGFloat height;
    NSString *str2;
}

@end

@implementation huoqumendianyouhuijuan

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    _tableview = [[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 64, width, height - 64);
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //状态栏名称
    self.navigationItem.title = @"门店优惠券";
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];

    
    [self jiekou];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString*zhid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    zhid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"officeId",@"1",@"pageNo",@"5",@"pageSize",nil];
    
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
            NSLog(@"门店优惠卷列表%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];

                arr = [datadic objectForKey:@"couponInfoList"];
              
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
    return 80;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *id1 =@"youhuiquan";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(10, 10, 60, 60);
    image.backgroundColor = [UIColor grayColor];
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.row] objectForKey:@"url"]];
    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
    [cell.contentView addSubview:image];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(80, 10, width - 90, 20);
    name.font = [UIFont systemFontOfSize:13];
    name.text = [NSString stringWithFormat:@"相关门店:%@",[[arr[indexPath.row] objectForKey:@"office"] objectForKey:@"name"] ];
    name.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [cell.contentView addSubview:name];
    
    UILabel *jiage = [[UILabel alloc]init];
    jiage.frame = CGRectMake(80, 30, 100, 20);
    jiage.font = [UIFont systemFontOfSize:13];
    jiage.text = [NSString stringWithFormat:@"优惠金额:%@",[arr[indexPath.row] objectForKey:@"faceValue"] ];
    jiage.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [cell.contentView addSubview:jiage];
    
    UILabel *shuliang = [[UILabel alloc]init];
    shuliang.frame = CGRectMake(80, 50, width - 90, 20);
    shuliang.font = [UIFont systemFontOfSize:13];
    shuliang.text = [NSString stringWithFormat:@"剩余数量:%@",[arr[indexPath.row] objectForKey:@"publishNums"] ];
    shuliang.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [cell.contentView addSubview:shuliang];
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str1  = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"publishNums"] ];
    
    if ([str1 isEqualToString:@"0"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"领取失败" message:@"对不起,优惠券已被领光" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否领取优惠券？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        
        str2 = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"id"]];
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
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
        
        NSLog(@"%@",str2);
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:str2,@"couponTypeId",@"1020",@"vipId",nil];
        
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
            NSLog(@"错误：%@",error);
        }];

    }
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
