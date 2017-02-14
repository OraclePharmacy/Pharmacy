//
//  YdDrugJumpViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdDrugJumpViewController.h"
#import "YdDrugViewController.h"
#import "Color+Hex.h"
#import "YdDrugsViewController.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "lianjie.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
@interface YdDrugJumpViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *arr;
    
    int coun;
    int ye;
    
    UILabel *label;
}
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdDrugJumpViewController
- (void)viewDidLoad {
       [super viewDidLoad];
    self.tableview.tableFooterView = [[UIView alloc] init];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    //状态栏名称
    self.navigationItem.title = _bookNo;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
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
    
    if (ye*3 >coun+2||3>coun) {
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
        [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    
        //userID    暂时不用改
        NSString * userID=@"0";
    
        //请求地址   地址不同 必须要改
        NSString * url =@"/product/productListThree";
    
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval ad =[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",ad];
    
    
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    NSString*officeid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    officeid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
        //出入参数：
     NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_bookNo,@"level3Name",[NSString stringWithFormat:@"%d",ye],@"pageNo",@"5",@"pageSize",officeid,@"store_id",nil];
    
        NSString*jsonstring=[writer stringWithObject:datadic];
    
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            NSLog(@"\n\n药品详情返回\n\n%@",responseObject);
            @try
            {
                if ([[responseObject objectForKey:@"code"] intValue]==0000) {
    
                    NSDictionary*datadic=[responseObject valueForKey:@"data"];
                    
                    arr = [NSArray arrayWithArray:[datadic objectForKey:@"productList"]];
                    
                    coun=[[datadic objectForKey:@"count"] intValue];
                    
                    if (arr.count == 0)
                    {
                        _tableview.hidden = YES;
                        
                        label = [[UILabel alloc]init];
                        label.frame = CGRectMake(0, 114, width, 30);
                        label.font = [UIFont systemFontOfSize:17];
                        label.text = @"对不起,没有找到相关药品!";
                        label.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
                        label.textAlignment = NSTextAlignmentCenter;
                        [self.view addSubview:label];
                    }
                    else
                    {
                        [label removeFromSuperview];
                        _tableview.hidden = NO;
                    }
                    
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
    return 110;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"bingzheng";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 80, 80)];
//    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.row]objectForKey:@"picUrl" ]] ;
//    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
//   
//    
//    UILabel *name= [[UILabel alloc]initWithFrame:CGRectMake(120 , 10, width -140 , 20)];
//    name.font = [UIFont systemFontOfSize:15];
//    //name.textAlignment = NSTextAlignmentCenter;
//    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
//    name.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"name"]];
//    
//    UILabel *changjia = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, width -140, 20)];
//    changjia.font = [UIFont systemFontOfSize:13];
//    //changjia.textAlignment = NSTextAlignmentCenter;
//    changjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
//    if([arr[indexPath.row] objectForKey:@"manufacturer"]==nil){
//        changjia.text=@"";
//    }else
//    changjia.text =[NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"manufacturer"]];
//
//    
//    UILabel *guige = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, width -140, 20)];
//    guige.font = [UIFont systemFontOfSize:11];
//    //guige.textAlignment = NSTextAlignmentCenter;
//    guige.textColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
//    if([arr[indexPath.row] objectForKey:@"specification"]==nil){
//        guige.text=@"";
//    }else
//    guige.text =[NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"specification"]];
//
//    
//    UILabel *jiage = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, width -140, 20)];
//    jiage.font = [UIFont systemFontOfSize:10];
//    jiage.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
//    if ([[arr[indexPath.row] objectForKey:@"prescription"]isEqual:@"0"]) {
//        jiage.text=@"非处方药";
//    }else{
//        jiage.text=@"处方药";
//    }
//   
//    UILabel *jianjie = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, width - 40 , 40)];
//    jianjie.font = [UIFont systemFontOfSize:12];
//    //jianjie.textAlignment = NSTextAlignmentCenter;
//    jianjie.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
//    if([[arr[indexPath.row] objectForKey:@"summary"]isEqual:@""]||[arr[indexPath.row] objectForKey:@"summary"]==nil){
//        jianjie.text =[NSString stringWithFormat:@"药品简介: 暂无"];
//    }else
//    jianjie.text =[NSString stringWithFormat:@"药品简介:%@",[arr[indexPath.row] objectForKey:@"summary"]];
//    jianjie.numberOfLines = 2;
//    
//    [cell.contentView addSubview:image];
//    [cell.contentView addSubview:name];
//    [cell.contentView addSubview:changjia];
//    [cell.contentView addSubview:guige];
//    [cell.contentView addSubview:jiage];
//    [cell.contentView addSubview:jianjie];
    
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(5, 5, 100, 100);
    //image.image = [UIImage imageNamed:@"IMG_0801.jpg"];
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.row] objectForKey:@"picUrl"]] ;
    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(110, 5, width - 115, 20);
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    name.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"name"]];
    
    UILabel *changjia = [[UILabel alloc]init];
    changjia.frame = CGRectMake(110, 25, width - 115, 20);
    changjia.font = [UIFont systemFontOfSize:12];
    changjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    changjia.text = [NSString stringWithFormat:@"生产厂家:%@",[arr[indexPath.row] objectForKey:@"manufacturer"]];
    
    UILabel *guige = [[UILabel alloc]init];
    guige.frame = CGRectMake(110, 45, width - 115, 20);
    guige.font = [UIFont systemFontOfSize:12];
    guige.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    guige.text = [NSString stringWithFormat:@"规格:%@",[arr[indexPath.row] objectForKey:@"specification"]];
    
    UILabel *yuanjian = [[UILabel alloc]init];
    yuanjian.frame = CGRectMake(110, 65, width - 115, 20);
    yuanjian.font = [UIFont systemFontOfSize:12];
    yuanjian.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    if ([[arr[indexPath.row] objectForKey:@"prodPrice"]floatValue] == 0){
        yuanjian.text = @"--";
    }
    else
    {
        yuanjian.text = [NSString stringWithFormat:@"原价:%.2f",[[arr[indexPath.row] objectForKey:@"prodPrice"]floatValue]];
    }
    
    UILabel *tejia = [[UILabel alloc]init];
    tejia.frame = CGRectMake(110, 85, width  - 115, 20);
    tejia.font = [UIFont systemFontOfSize:12];
    if (NULL == [arr[indexPath.row] objectForKey:@"specPrice"] || [[arr[indexPath.row] objectForKey:@"specPrice"]floatValue] == 0) {
        tejia.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        tejia.text = @"非特价药";
    }
    else
    {
        tejia.textColor = [UIColor redColor];
        tejia.text = [NSString stringWithFormat:@"特价:%.2f",[[arr[indexPath.row] objectForKey:@"specPrice"]floatValue]];
    }
    
    UIView *xian = [[UIView alloc]init];
    xian.frame = CGRectMake(0, 109, width, 1);
    xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    
    
    [cell.contentView addSubview:image];
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:guige];
    [cell.contentView addSubview:changjia];
    [cell.contentView addSubview:yuanjian];
    [cell.contentView addSubview:tejia];
    [cell.contentView addSubview:xian];
    
    
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    //点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YdDrugsViewController  *Drugs =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugs"];
    Drugs.yaopinID = [[arr[indexPath.row] objectForKey:@"addedProduct"] objectForKey:@"id"];
    [self.navigationController pushViewController:Drugs animated:YES];
    
    return;
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
