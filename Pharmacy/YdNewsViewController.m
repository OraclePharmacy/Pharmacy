//
//  YdNewsViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/6.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdNewsViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "MJRefresh.h"
@interface YdNewsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int coun;
    int ye;
    CGFloat width;
    CGFloat height;
    NSMutableArray*pushLogList;
}
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      ye=1;
    self.tableview.tableFooterView = [[UIView alloc] init];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    pushLogList=[[NSMutableArray alloc] init];
    //状态栏名称
    self.navigationItem.title = @"消 息";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [self.view addSubview:self.tableview];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewdata)];
    self.tableview.mj_header = header;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    MJRefreshAutoNormalFooter*footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableview.mj_footer = footer;
    

    [self jiekou];
    
}
-(void)loadNewdata{
//    pushLogList=[[NSMutableArray alloc] init];
    ye=1;
    MJRefreshAutoNormalFooter*footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableview.mj_footer = footer;
    [self jiekou];
    [self.tableview.mj_header endRefreshing];
    
}
-(void)loadNewData{
    NSLog(@"%d,%d",ye,coun);
    if (ye*10 >coun+9) {
        
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

-(void)jiekou{
    [WarningBox warningBoxModeIndeterminate:nil andView:self.view];
    NSLog(@"%d",ye);
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/queryPushLogList";
    
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
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:vip,@"vipId",@"10",@"pageSize",[NSString stringWithFormat:@"%d",ye],@"pageNo", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        NSLog(@"%@",responseObject);
        NSArray*poop=[NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"pushLogList"]];
        coun=[[[responseObject objectForKey:@"data"] objectForKey:@"count"] intValue];
        NSLog(@"%d",ye);
        if (ye!=1) {
            for (NSDictionary*dd in poop) {
                [pushLogList addObject:dd];
            }
        }else{
          
            pushLogList =[NSMutableArray arrayWithArray:poop];
        }
        NSLog(@"%lu",(unsigned long)pushLogList.count);
        ye++;
        
        [_tableview reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        NSLog(@"%@",error);
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
    return pushLogList.count;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 70;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return baseView;
}
//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"wencell";
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    UIView *bai = [[UIView alloc]init];
    bai.backgroundColor = [UIColor whiteColor];
    bai.frame = CGRectMake(5, 0, width - 10 , 61);
    [cell.contentView addSubview:bai];
    
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(5, 0, width - 20, 30);
    NSLog(@"%lu",(unsigned long)pushLogList.count);
    title.text = [NSString stringWithFormat:@"%@",[pushLogList[indexPath.row] objectForKey:@"pushContent"]];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    [bai addSubview:title];
    
    UIView *xian = [[UIView alloc]init];
    xian.frame = CGRectMake(5, 30, width - 20 , 1);
    xian.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    [bai addSubview:xian];
    
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(5, 31, width - 20, 30);
    time.text = [NSString stringWithFormat:@"%@",[pushLogList[indexPath.row] objectForKey:@"pushTime"]];;
    time.font = [UIFont systemFontOfSize:13];
    time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    time.textAlignment = NSTextAlignmentRight;
    [bai addSubview:time];

    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    return cell;
}

//导航左按钮
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
