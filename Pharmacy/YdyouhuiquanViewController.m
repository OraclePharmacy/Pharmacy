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
@interface YdyouhuiquanViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *arr;
    
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
    
    [self jiekou];
    
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
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1030",@"vipId",@"1",@"pageNo",@"5",@"pageSize",nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    NSLog(@"flsdjkflsajflkjsdlkfjlksjflkjaslkfjlsdakfjlk%@",url1);
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
    
//    UIImageView *image = [[UIImageView alloc]init];
//    image.frame = CGRectMake(5, 10, 60, 60);
//    image.backgroundColor = [UIColor grayColor];
//    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.row] objectForKey:@"url"]];
//    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
//    [white1 addSubview:image];
//    
//    UILabel *name = [[UILabel alloc]init];
//    name.frame = CGRectMake(70, 5, width / 2, 15);
//    name.font = [UIFont systemFontOfSize:13];
//    name.text = [NSString stringWithFormat:@"优惠券    %@",[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"name"]];
//    name.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
//    [white1 addSubview:name];
//    
//    UILabel *money = [[UILabel alloc]init];
//    money.frame = CGRectMake(70, 20, width / 2, 40);
//    money.font = [UIFont systemFontOfSize:30];
//    money.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"faceValue"]];
//    money.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
//    [white1 addSubview:money];
//    
//    NSString *a = [[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"startTime"];
//    NSString *b = [a substringToIndex:10];
//
//    NSString *c = [[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"endTime"];
//    NSString *d = [c substringToIndex:10];
//
//    NSString *e = [NSString stringWithFormat:@"有效期 : %@ -- %@",b,d];
//    UILabel *time = [[UILabel alloc]init];
//    time.frame = CGRectMake(70, 60, white1.frame.size.width - 80, 15);
//    time.font = [UIFont systemFontOfSize:10];
//    time.text = e;
//    time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
//    [white1 addSubview:time];
//    
//    UIButton *xiangqing = [[UIButton alloc]init];
//    xiangqing.frame = CGRectMake(0, 84, green.frame.size.width, 25);
//    xiangqing.backgroundColor = [UIColor whiteColor];
//    [xiangqing setTitle:@"详  情" forState:UIControlStateNormal];
//    xiangqing.titleLabel.font = [UIFont systemFontOfSize:15];
//    [xiangqing setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
//    [green addSubview:xiangqing];
//    
//    UIView *white2 = [[UIView alloc]init];
//    white2.frame = CGRectMake(2, 111, green.frame.size.width - 4, 31);
//    white2.backgroundColor = [UIColor whiteColor];
//    [green addSubview:white2];
//    
//    UILabel *laiyuan = [[UILabel alloc]init];
//    laiyuan.frame = CGRectMake(5, 0, 250, 15);
//    laiyuan.font = [UIFont systemFontOfSize:10];
//    if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"1"])
//    {
//        laiyuan.text = @"来源 : 摇一摇";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"2"])
//    {
//         laiyuan.text = @"来源 : 幸运大转盘";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"3"])
//    {
//        laiyuan.text = @"来源 : 有奖问答";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"4"])
//    {
//        laiyuan.text = @"来源 : 普通优惠券";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"5"])
//    {
//        laiyuan.text = @"来源 : 商家优惠券";
//    }
//    laiyuan.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
//    [white2 addSubview:laiyuan];
//    
//    UIView *xian = [[UIView alloc]init];
//    xian.frame = CGRectMake(5, 15, white2.frame.size.width - 10, 1);
//    xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
//    [white2 addSubview:xian];
//    
//    UILabel *store = [[UILabel alloc]init];
//    store.frame = CGRectMake(5, 16, 250, 15);
//    store.text = [NSString stringWithFormat:@"所属门店:%@",[[arr[indexPath.row] objectForKey:@"office"] objectForKey:@"name"]];
//    store.font = [UIFont systemFontOfSize:10];
//    store.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
//    [white2 addSubview:store];
//    
//    UILabel *zhuangtai = [[UILabel alloc]init];
//    zhuangtai.frame = CGRectMake(white1.frame.size.width - 60,5,50,20);
//    zhuangtai.font = [UIFont systemFontOfSize:13];
//    zhuangtai.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
//    if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"1"])
//    {
//        zhuangtai.text = @"已使用";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"0"])
//    {
//        zhuangtai.text = @"未使用";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@""])
//    {
//        zhuangtai.text = @"暂无";
//    }
//    zhuangtai.textAlignment = NSTextAlignmentCenter;
//    zhuangtai.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
//    zhuangtai.layer.cornerRadius = 5 ;
//    zhuangtai.layer.masksToBounds = YES;
//
//    [white1 addSubview:zhuangtai];
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(10, 5, 65, 65);
    image.backgroundColor = [UIColor grayColor];
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.row] objectForKey:@"url"]];
    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
    [cell.contentView addSubview:image];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(85, 5, 150, 15);
    name.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"name"]];
    name.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:name];
    
    UIImageView *youtu = [[UIImageView alloc]init];
    youtu.frame = CGRectMake(width - 70, 0, 70, 75);
    [cell.contentView addSubview:youtu];
    
    UILabel *laiyuan = [[UILabel alloc]init];
    laiyuan.frame = CGRectMake(85, 40, 150, 15);
    laiyuan.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    laiyuan.font = [UIFont systemFontOfSize:11];
    if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"1"])
    {
        youtu.image = [UIImage imageNamed:@"hh.png"];
        laiyuan.text = @"摇一摇";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"2"])
    {
        youtu.image = [UIImage imageNamed:@"hh.png"];
        laiyuan.text = @"幸运大转盘";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"]isEqual:@"3"])
    {
        youtu.image = [UIImage imageNamed:@"hh.png"];
        laiyuan.text = @"有奖问答";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"4"])
    {
        youtu.image = [UIImage imageNamed:@"hh.png"];
        laiyuan.text = @"普通优惠券";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"5"])
    {
        youtu.image = [UIImage imageNamed:@"ll.png"];
        laiyuan.text = @"商家优惠券";
    }

    [cell.contentView addSubview:laiyuan];
    
    NSString *a = [[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"endTime"];
    NSString *b = [a substringToIndex:10];
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(85, 55, 150, 15);
    time.text =[NSString stringWithFormat:@"有效期至:%@",b ];
    time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    time.font = [UIFont systemFontOfSize:11];
    [cell.contentView addSubview:time];
    
    
    UILabel *shuliang = [[UILabel alloc]init];
    shuliang.frame = CGRectMake(0, 0, 70, 20);
    if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"1"])
    {
        shuliang.text = @"已使用";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"0"])
    {
        shuliang.text = @"未使用";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@""])
    {
        shuliang.text = @"暂无";
    }
    shuliang.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    shuliang.font = [UIFont systemFontOfSize:10];
    shuliang.textAlignment = NSTextAlignmentCenter;
    [youtu addSubview:shuliang];
    
    UILabel *moner = [[UILabel alloc]init];
    moner.frame = CGRectMake(0, 20, 70, 35);
    moner.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"faceValue"]];
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
    lingqu.text = @"立即兑换";
    lingqu.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    lingqu.font = [UIFont systemFontOfSize:10];
    lingqu.textAlignment = NSTextAlignmentCenter;
    [youtu addSubview:lingqu];

    
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
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1030",@"vipId",@"67a3c6f913d24373b4a7917ba8a987ff",@"storeId",@"1270",@"id",@"123456",@"storeCode",@"7-200000-4-0000000010",@"couponCode",nil];
    NSLog(@"%@",datadic);
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    NSLog(@"flsdjkflsajflkjsdlkfjlksjflkjaslkfjlsdakfjlk%@",url1);
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
//-(void)shiyishi
//{
//    
//    huoqumendianyouhuijuan *huoqumendianyouhuijuan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mendianyouhuijuan"];
//    
//    [self.navigationController pushViewController:huoqumendianyouhuijuan animated:YES];
//     
//}

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
