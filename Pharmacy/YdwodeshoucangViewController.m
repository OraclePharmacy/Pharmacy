//
//  YdwodeshoucangViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/14.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdwodeshoucangViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "YdTextDetailsViewController.h"
#import "YdInformationDetailsViewController.h"
#import "MJRefresh.h"

@interface YdwodeshoucangViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *arr;
    
    int ye;
    int coun;
}
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdwodeshoucangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    //状态栏名称
    self.navigationItem.title = @"我的收藏";
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
    NSString * url =@"/share/newsCollectList";
    
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
            NSLog(@"\n\n\n\n%@\n\n\n\n",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                arr = [datadic objectForKey:@"collectList"];
                
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
    return 160;
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
    static NSString *id1 =@"wodetiezi";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.row] objectForKey:@"picUrl"]] ;
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(10, 10, 100 , 100);
    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
    
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 10, width - CGRectGetMaxY(image.frame) - 20, 30);
    title.font = [UIFont systemFontOfSize:15];
    title.text =[NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"title"] ];
    title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    //title.backgroundColor = [UIColor grayColor];
    
    UILabel *content = [[UILabel alloc]init];
    content.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 60, width - CGRectGetMaxY(image.frame) - 20, 40);
    content.font = [UIFont systemFontOfSize:12];
    content.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"subtitle"] ];
    content.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    content.numberOfLines = 2;
    //content.backgroundColor = [UIColor grayColor];
    
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(width - 120, 100, 110, 20);
    time.font = [UIFont systemFontOfSize:10];
    time.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"createTime"]];
    time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    time.numberOfLines = 2;
    //time.backgroundColor = [UIColor grayColor];
    
    
    UIView *xian = [[UIView alloc] init];
    xian.frame = CGRectMake(0, 120, width, 1);
    xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    
    UILabel *laiyuan = [[UILabel alloc]init];
    laiyuan.frame = CGRectMake(10,130, 100, 20);
    laiyuan.font = [UIFont systemFontOfSize:13];
    laiyuan.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"source"]];
    laiyuan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    
    
    UIButton *fenxiang = [[UIButton alloc] init];
    fenxiang.frame = CGRectMake(width - 70 ,130 ,20 ,20);
    fenxiang.backgroundColor = [UIColor clearColor];
    
    
    UILabel *fenxianglabel = [[UILabel alloc]init];
    fenxianglabel.frame = CGRectMake(0,0,70,20);
    fenxianglabel.text =[NSString stringWithFormat:@"阅读量: %@",[arr[indexPath.row] objectForKey:@"viewCount"]];
    fenxianglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    fenxianglabel.font = [UIFont systemFontOfSize:11];
    [fenxiang addSubview:fenxianglabel];
    
    
    UIButton *shoucang = [[UIButton alloc] init];
    shoucang.frame = CGRectMake(width - 140 ,130 ,20 ,20);
    shoucang.backgroundColor = [UIColor clearColor];
    
    
    UILabel *shoucanglabel = [[UILabel alloc]init];
    shoucanglabel.frame = CGRectMake(0,0,70,20);
    shoucanglabel.text =[NSString stringWithFormat:@"点赞量: %@",[arr[indexPath.row] objectForKey:@"clickLikeCount"]];
    shoucanglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    shoucanglabel.font = [UIFont systemFontOfSize:11];
    [shoucang addSubview:shoucanglabel];
    
    UIView *xian1 = [[UIView alloc] init];
    xian1.frame = CGRectMake(0, 159, width, 1);
    xian1.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    
    [cell.contentView addSubview:image];
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:content];
    [cell.contentView addSubview:xian];
    [cell.contentView addSubview:time];
    [cell.contentView addSubview:shoucang];
    [cell.contentView addSubview:fenxiang];
    [cell.contentView addSubview:laiyuan];
    [cell.contentView addSubview:xian1];
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//tableview点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    YdTieZiXiangQingViewController *TieZiXiangQing=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tiezixiangqing"];
//    TieZiXiangQing.tieziId = [arr[indexPath.row] objectForKey:@"id"];
//    TieZiXiangQing.bingzheng = [arr[indexPath.row] objectForKey:@"diseaseName"];
//    TieZiXiangQing.touxiang1 = [arr[indexPath.row] objectForKey:@"photo"];
//    [self presentViewController:TieZiXiangQing animated:YES completion:^{
//        
//        [self setModalTransitionStyle: UIModalTransitionStyleCrossDissolve];
//        
//    }];
    
    //    YdTieZiXiangQingViewController *TieZiXiangQing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tiezixiangqing"];
    //    TieZiXiangQing.tieziId = [arr[indexPath.row] objectForKey:@"id"];
    //    TieZiXiangQing.bingzheng = [arr[indexPath.row] objectForKey:@"diseaseName"];
    //    TieZiXiangQing.touxiang1 = [arr[indexPath.row] objectForKey:@"photo"];
    //    [self.navigationController pushViewController:TieZiXiangQing animated:YES];
    
    if ([[arr[indexPath.row] objectForKey:@"type"] isEqualToString:@"0"])
    {
        //跳转文字资讯详情
        YdTextDetailsViewController *TextDetails = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"textdetails"];
        //传值   [newsListForInterface[indexPath.row]objectForKey:@"type"];
        TextDetails.xixi=[NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"id"]];
        [self.navigationController pushViewController:TextDetails animated:YES];
    }
    else
    {
        YdInformationDetailsViewController *InformationDetails = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"informationdetails"];
        InformationDetails.hahaha=[NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"id"]];
        InformationDetails.liexing=[NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"type"]];
        [self.navigationController pushViewController:InformationDetails animated:YES];
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
