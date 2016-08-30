//
//  YdpinglunliebiaoViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/13.
//  Copyright © 2016年 sk. All rights reserved.
//
#import "YdpinglunliebiaoViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "YdfabiaopinglunViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
@implementation YdpinglunliebiaoViewController
{
    CGFloat width;
    CGFloat height;
    
    NSMutableArray *arr;
    
    int ye;
    int coun;
    
}

-(void)viewWillAppear:(BOOL)animated{
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ye = 1;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64);
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    //状态栏名称
    self.navigationItem.title = @"评  论";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];

}
-(void)loadNewdata{
    
    ye = 1; MJRefreshAutoNormalFooter*footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableview.mj_footer = footer;
    [self jiekou];
    [self.tableview.mj_header endRefreshing];
    
}
-(void)loadNewData{
    
    if (ye*8 >coun+7||8>coun) {
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
    NSString * url =@"/share/commentList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];

    //出入参数：
  
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_tieziID,@"id",@"8",@"pageSize",[NSString stringWithFormat:@"%d",ye],@"pageNo",nil];

    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp];
    
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
                
                NSArray*mg = [datadic objectForKey:@"commentList"];
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
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
    }];
    
}
//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}
//cell高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 85;
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
    static NSString *id1 =@"pinglunliebiao";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    if ([arr[indexPath.row] objectForKey:@"list"] == nil)
    {
        
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(10, 10, 40, 40);
        NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"photo"]];
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
        image.layer.cornerRadius = 20;
        image.layer.masksToBounds = YES;
        [cell.contentView addSubview:image];
        
        UILabel *name = [[UILabel alloc]init];
        name.frame = CGRectMake(60, 10, 180, 20);
        name.font = [UIFont systemFontOfSize:15];
        name.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"nickName"]];
        name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        [cell.contentView addSubview:name];
        
        UILabel *time = [[UILabel alloc]init];
        time.frame = CGRectMake(60, 30, 180, 20);
        time.font = [UIFont systemFontOfSize:15];
        time.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"replyTime"] ];
        time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        [cell.contentView addSubview:time];
        
        UILabel *pinglun = [[UILabel alloc]init];
        pinglun.frame = CGRectMake(60, 55, width - 70, 20);
        pinglun.font = [UIFont systemFontOfSize:15];
        pinglun.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"reply"] ];
        pinglun.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        [cell.contentView addSubview:pinglun];
        
    }
    else
    {
        
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(10, 10, 40, 40);
        NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"photo"]];
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
        image.layer.cornerRadius = 20;
        image.layer.masksToBounds = YES;
        [cell.contentView addSubview:image];
        
        UILabel *name = [[UILabel alloc]init];
        name.frame = CGRectMake(60, 10, 180, 20);
        name.font = [UIFont systemFontOfSize:15];
        name.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"nickName"]];
        name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        [cell.contentView addSubview:name];
        
        UILabel *time = [[UILabel alloc]init];
        time.frame = CGRectMake(60, 30, 180, 20);
        time.font = [UIFont systemFontOfSize:13];
        time.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"replyTime"] ];
        time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        [cell.contentView addSubview:time];
        
        UILabel *pinglun = [[UILabel alloc]init];
        pinglun.frame = CGRectMake(60, 55, width - 70, 20);
        pinglun.font = [UIFont systemFontOfSize:13];
        pinglun.text = [NSString stringWithFormat:@"回复@%@:%@",[[arr[indexPath.row] objectForKey:@"list"][0] objectForKey:@"nickNameOther"],[arr[indexPath.row] objectForKey:@"reply"]];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:pinglun.text];
        NSString*stt = [NSString stringWithFormat:@"%@",[[arr[indexPath.row] objectForKey:@"list"][0] objectForKey:@"nickNameOther"]];
        pinglun.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"32be60" alpha:1] range:NSMakeRange(2, stt.length + 1)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
        pinglun.attributedText = attributedString;
        [cell.contentView addSubview:pinglun];

    }

    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//tableview点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YdfabiaopinglunViewController *fabiaopinglun = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"fabiaopinglun"];
    fabiaopinglun.pinglunID = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"vipId"]];
    fabiaopinglun.tieziID=_tieziID;
    [self.navigationController pushViewController:fabiaopinglun animated:YES];
    
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
