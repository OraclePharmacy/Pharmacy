//
//  YdRecordListViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/21.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdRecordListViewController.h"
#import "Color+Hex.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "lianjie.h"
#import "hongdingyi.h"
#import "SBJsonWriter.h"
#import "WarningBox.h"
#import "dianzixiangqing.h"
#import "MJRefresh.h"

@interface YdRecordListViewController ()
{
    CGFloat width;
    CGFloat height;
    NSArray * emrList;
    int ye;
    
    
}
@end

@implementation YdRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ye=1;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"我的电子病历";
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
//    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        
//        
//        
//    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
//    NSArray * tupian=[NSArray arrayWithObjects:[UIImage imageNamed:@"IMG_0797.jpg"],[UIImage imageNamed:@"IMG_0799.jpg"], nil];
//    // 设置普通状态的动画图片
//    [header setImages:tupian forState:MJRefreshStateIdle];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [header setImages:tupian forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [header setImages:tupian forState:MJRefreshStateRefreshing];
    // 设置header
    self.tableview.mj_header = header;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;

//    // 隐藏状态
//    header.stateLabel.hidden = YES;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self jiekou];
}
-(void)loadNewData{
    ye++;
    [self jiekou];
    [self.tableview.mj_header endRefreshing];
    
}
-(void)jiekou{
    NSString*vip;
    NSString *path6 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
    NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path6];
    vip=[NSString stringWithFormat:@"%@",[pp objectForKey:@"id"]];    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/basic/emrList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    //emrid  为空时  调回列表；
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:vip,@"vipId",[NSString stringWithFormat:@"%d",ye],@"pageNo",@"2",@"pageSize",@"",@"emrId", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager GET:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            NSLog(@"－＊－＊－＊－＊－＊－＊电子病历列表返回＊－＊－＊－＊－\n\n\n%@",responseObject);
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            emrList=[NSArray arrayWithArray:[[responseObject objectForKey:@"data" ] objectForKey:@"emrList"]];
            
            [_tableview reloadData];
            
            
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
    NSLog(@"%lu",(unsigned long)emrList.count);
    return emrList.count;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 65;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell123";
    
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
    time.text = [NSString stringWithFormat:@"%@",[emrList[indexPath.section] objectForKey:@"tjsj"] ];
    time.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    time.textAlignment = NSTextAlignmentCenter;
    
    
    UIView *bai = [[UIView alloc]init];
    bai.backgroundColor = [UIColor whiteColor];
    bai.frame = CGRectMake(15, 25, width-25, 40);
    
    
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(0, 0, width -20, 20);
    title.font = [UIFont systemFontOfSize:15];
    title.text = [NSString stringWithFormat:@"%@",[emrList[indexPath.section] objectForKey:@"title"] ];
    title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    
    
    UILabel *neirong = [[UILabel alloc]init];
    neirong.frame = CGRectMake(0, 20, width -20, 20);
    neirong.font = [UIFont systemFontOfSize:13];
    neirong.text = [NSString stringWithFormat:@"%@",[emrList[indexPath.section] objectForKey:@"emrDesc"] ];
    neirong.textColor = [UIColor colorWithHexString:@"646464" alpha:1];


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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dianzixiangqing *xq=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"dianzixiangqing"];
    NSString * emrid=[NSString stringWithFormat:@"%@",[emrList[indexPath.section] objectForKey:@"id"] ];
    xq.emrid=emrid;
    [self.navigationController pushViewController:xq animated:YES];
    NSLog(@"%@",emrid);
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
