//
//  YdJiaoLiuViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/3.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdJiaoLiuViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "YdFaTieViewController.h"
#import "YdTieZiXiangQingViewController.h"
#import "MJRefresh.h"
#import "tiaodaodenglu.h"
@interface YdJiaoLiuViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *arr;
    int coun;
    int ye;
}
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdJiaoLiuViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.navigationItem.title = @"病友交流";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    //设置导航栏左按钮
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"发帖" style:UIBarButtonItemStyleDone target:self action:@selector(fatie)];
    
    
    
    //    [self jiekou];
}
-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/share/vipTopicList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"id",[NSString stringWithFormat:@"%d",ye],@"pageNo",@"10",@"pageSize", nil];
    
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
                
                arr = [datadic objectForKey:@"vipTopicList"];
                
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
    return 111;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UISwitch alloc] init];
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UIImageView *touxiang = [[UIImageView alloc]init];
    touxiang.frame = CGRectMake(5, 5, 80, 80);
    touxiang.layer.cornerRadius = 40;
    touxiang.layer.masksToBounds = YES;
    NSString*path=[NSString stringWithFormat:@"%@/hyb/%@",service_host,[[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"photo"]];
    [touxiang sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"小人@2x.png" ]];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(5, 90, 80, 20);
    name.font = [UIFont systemFontOfSize:15];
    if (NULL == [[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"nickName"]) {
        name.text=@"系统管理员";
    }else{
        name.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"nickName"]];
    }
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    
    
    UILabel *biaoti = [[UILabel alloc]init];
    biaoti.frame = CGRectMake(90, 5, width - 95, 20);
    biaoti.font = [UIFont systemFontOfSize:15];
    biaoti.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"title"]];
    biaoti.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    
    
    UILabel *fubiaoti = [[UILabel alloc]init];
    fubiaoti.frame = CGRectMake(90, 25, width - 95, 40);
    fubiaoti.font = [UIFont systemFontOfSize:13];
    fubiaoti.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"context"]];
    fubiaoti.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    fubiaoti.numberOfLines = 2;
    
    UILabel *biaoqian = [[UILabel alloc]init];
    biaoqian.frame = CGRectMake(90, 65, 100, 20);
    biaoqian.font = [UIFont systemFontOfSize:13];
    biaoqian.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"diseaseName"]];
    biaoqian.textAlignment = NSTextAlignmentCenter;
    biaoqian.backgroundColor = [UIColor colorWithHexString:@"FFCC22" alpha:1];
    biaoqian.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    UILabel *shijian = [[UILabel alloc]init];
    shijian.frame = CGRectMake(180, 65, width - 185, 20);
    shijian.font = [UIFont systemFontOfSize:13];
    shijian.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"createTime"]];
    shijian.textAlignment = NSTextAlignmentRight;
    shijian.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
    
    UILabel *yuedu = [[UILabel alloc]init];
    yuedu.frame = CGRectMake(width - 215, 90, 100, 20);
    yuedu.font = [UIFont systemFontOfSize:13];
    yuedu.text = [NSString stringWithFormat:@"阅读量:%@",[arr[indexPath.row] objectForKey:@"viewNums"]];
    yuedu.textAlignment = NSTextAlignmentRight;
    yuedu.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
    
    UILabel *dianzan = [[UILabel alloc]init];
    dianzan.frame = CGRectMake(width - 110, 90, 100, 20);
    dianzan.font = [UIFont systemFontOfSize:13];
    dianzan.text = [NSString stringWithFormat:@"点赞量:%@",[arr[indexPath.row] objectForKey:@"likeNums"]];
    dianzan.textAlignment = NSTextAlignmentRight;
    dianzan.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
    
    UIImageView *remen  = [[UIImageView alloc]init];
    remen.frame = CGRectMake(width - 50 , 0, 50, 50);
    if ([[arr[indexPath.row] objectForKey:@"isTop"] isEqualToString:@"1" ]) {
        
        remen.image = [UIImage imageNamed:@"hot.png"];
        
    }
    else
    {
        
    }
    [cell.contentView addSubview:remen];
    
    [cell.contentView addSubview:touxiang];
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:biaoti];
    [cell.contentView addSubview:fubiaoti];
    [cell.contentView addSubview:biaoqian];
    [cell.contentView addSubview:shijian];
    [cell.contentView addSubview:yuedu];
    [cell.contentView addSubview:dianzan];
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    return cell;
}
//tableview点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是否登录
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
        [tiaodaodenglu jumpToLogin:self.navigationController];
    }else{
        
        YdTieZiXiangQingViewController *TieZiXiangQing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tiezixiangqing"];
        TieZiXiangQing.tieziId = [arr[indexPath.row] objectForKey:@"id"];
        TieZiXiangQing.bingzheng = [arr[indexPath.row] objectForKey:@"diseaseName"];
        TieZiXiangQing.touxiang1 = [[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"photo"];
        TieZiXiangQing.named = [[arr[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"nickName"];
        [self.navigationController pushViewController:TieZiXiangQing animated:YES];
    }
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)fatie
{
    NSString *path1 =[NSHomeDirectory() stringByAppendingString:@"/Documents/GRxinxi.plist"];
    NSFileManager *fm =[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path1]) {
        NSDictionary*gerenxinxi=[NSDictionary dictionaryWithContentsOfFile:path1];
        if (((NSString*)[gerenxinxi objectForKey:@"name"]).length==0||((NSString*)[gerenxinxi objectForKey:@"area"]).length==0) {
            [WarningBox warningBoxModeText:@"请先完善个人信息" andView:self.view];
        }else{
            YdFaTieViewController*FaTie = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"fatie"];
            [self.navigationController pushViewController:FaTie animated:YES];
        }
    }
}

@end
