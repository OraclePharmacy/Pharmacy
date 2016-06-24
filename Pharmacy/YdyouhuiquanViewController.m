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
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1020",@"vipId",@"1",@"pageNo",@"5",@"pageSize",nil];
    
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
    return 149;
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
    
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
//    UIView *beijing = [[UIView alloc]init];
//    beijing.frame = CGRectMake(10, 10, kuan, gao);
//    beijing.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
//    
//    UIView *beijinger = [[UIView alloc]init];
//    beijinger.frame = CGRectMake(1, 1, kuan - 2, gao - 2);
//    beijinger.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:1];
//    [beijing addSubview:beijinger];
//    
//    UIImageView *image = [[UIImageView alloc]init];
//    image.frame = CGRectMake(10, 20, 80, 80);
//    image.backgroundColor = [UIColor grayColor];
//    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.row] objectForKey:@"url"]];
//    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
//    [beijinger addSubview:image];
//    
//    UILabel *jine = [[UILabel alloc]init];
//    jine.frame = CGRectMake(100, 0, (kuan - 100) / 2-2, 20);
//    jine.font = [UIFont systemFontOfSize:13];
//    jine.text = [NSString stringWithFormat:@"金额:%@",[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"faceValue"]];
//    jine.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
//    [beijinger addSubview:jine];
//    
//    UILabel *laiyuan = [[UILabel alloc]init];
//    laiyuan.frame = CGRectMake(CGRectGetMaxX(jine.frame), 0, (kuan - 100) / 2, 20);
//    laiyuan.font = [UIFont systemFontOfSize:13];
//    if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"1"])
//    {
//        laiyuan.text = @"摇一摇";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"2"])
//    {
//        laiyuan.text = @"幸运大转盘";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"3"])
//    {
//        laiyuan.text = @"有奖问答";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"4"])
//    {
//        laiyuan.text = @"普通优惠券";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"5"])
//    {
//        laiyuan.text = @"商家优惠券";
//    }
//    laiyuan.textAlignment = NSTextAlignmentCenter;
//    laiyuan.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
//    laiyuan.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
//    [beijinger addSubview:laiyuan];
//    
//    UILabel *youhuiquan = [[UILabel alloc]init];
//    youhuiquan.frame = CGRectMake(100, 20, (kuan - 100) / 2-2, 20);
//    youhuiquan.font = [UIFont systemFontOfSize:13];
//    youhuiquan.text = [NSString stringWithFormat:@"优惠券:%@",[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"name"]];
//    youhuiquan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
//    [beijinger addSubview:youhuiquan];
//    
//    UILabel *zhuangtai = [[UILabel alloc]init];
//    zhuangtai.frame = CGRectMake(CGRectGetMaxX(youhuiquan.frame), 20, (kuan - 100) / 2, 20);
//    zhuangtai.font = [UIFont systemFontOfSize:13];
//    if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"1"])
//    {
//        zhuangtai.textColor = [UIColor redColor];
//        zhuangtai.text = @"已使用";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"0"])
//    {
//        zhuangtai.textColor = [UIColor colorWithHexString:@"32be60" alpha:1];
//        zhuangtai.text = @"未使用";
//    }
//    else if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@""])
//    {
//        zhuangtai.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
//        zhuangtai.text = @"暂无";
//    }
//    zhuangtai.textAlignment = NSTextAlignmentCenter;
//    [beijinger addSubview:zhuangtai];
//    
//    UILabel *duihuan = [[UILabel alloc]init];
//    duihuan.frame = CGRectMake(100, 40, kuan - 120-2, 20);
//    duihuan.font = [UIFont systemFontOfSize:13];
//    duihuan.text = [NSString stringWithFormat:@"兑换码:%@",[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"code"]];
//    duihuan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
//    [beijinger addSubview:duihuan];
//    
//    UILabel *mendian = [[UILabel alloc]init];
//    mendian.frame = CGRectMake(100, 60, kuan - 120-2, 20);
//    mendian.font = [UIFont systemFontOfSize:13];
//    mendian.text = [NSString stringWithFormat:@"所属门店:%@",[[arr[indexPath.row] objectForKey:@"office"] objectForKey:@"name"]];
//    mendian.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
//    [beijinger addSubview:mendian];
//
//    UILabel *kaishi = [[UILabel alloc]init];
//    kaishi.frame = CGRectMake(100, 80, kuan - 100-2, 20);
//    kaishi.font = [UIFont systemFontOfSize:13];
//    kaishi.text = [NSString stringWithFormat:@"开始时间:%@",[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"startTime"]];
//    kaishi.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
//    [beijinger addSubview:kaishi];
//    
//    UILabel *jieshu = [[UILabel alloc]init];
//    jieshu.frame = CGRectMake(100, 100, kuan - 100-2, 20);
//    jieshu.font = [UIFont systemFontOfSize:13];
//    jieshu.text = [NSString stringWithFormat:@"结束时间:%@",[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"endTime"]];
//    jieshu.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
//    [beijinger addSubview:jieshu];

//    [cell.contentView addSubview:beijing];
    
    
    UIView *green = [[UIView alloc]init];
    green.frame = CGRectMake(10, 5, width - 20, 144);
    green.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    [cell.contentView addSubview:green];
    
    UIView *white1 = [[UIView alloc]init];
    white1.frame = CGRectMake(2, 2, green.frame.size.width - 4, 80);
    white1.backgroundColor = [UIColor whiteColor];
    [green addSubview:white1];
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(5, 10, 60, 60);
    image.backgroundColor = [UIColor grayColor];
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.row] objectForKey:@"url"]];
    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
    [white1 addSubview:image];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(70, 5, width / 2, 15);
    name.font = [UIFont systemFontOfSize:13];
    name.text = [NSString stringWithFormat:@"优惠券    %@",[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"name"]];
    name.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [white1 addSubview:name];
    
    UILabel *money = [[UILabel alloc]init];
    money.frame = CGRectMake(70, 20, width / 2, 40);
    money.font = [UIFont systemFontOfSize:30];
    money.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"faceValue"]];
    money.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    [white1 addSubview:money];
    
    NSString *a = [[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"startTime"];
    NSString *b = [a substringToIndex:10];

    NSString *c = [[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"endTime"];
    NSString *d = [c substringToIndex:10];

    NSString *e = [NSString stringWithFormat:@"有效期 : %@ -- %@",b,d];
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(70, 60, white1.frame.size.width - 80, 15);
    time.font = [UIFont systemFontOfSize:10];
    time.text = e;
    time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [white1 addSubview:time];
    
    UIButton *xiangqing = [[UIButton alloc]init];
    xiangqing.frame = CGRectMake(0, 84, green.frame.size.width, 25);
    xiangqing.backgroundColor = [UIColor whiteColor];
    [xiangqing setTitle:@"详  情" forState:UIControlStateNormal];
    xiangqing.titleLabel.font = [UIFont systemFontOfSize:15];
    [xiangqing setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    [green addSubview:xiangqing];
    
    UIView *white2 = [[UIView alloc]init];
    white2.frame = CGRectMake(2, 111, green.frame.size.width - 4, 31);
    white2.backgroundColor = [UIColor whiteColor];
    [green addSubview:white2];
    
    UILabel *laiyuan = [[UILabel alloc]init];
    laiyuan.frame = CGRectMake(5, 0, 250, 15);
    laiyuan.font = [UIFont systemFontOfSize:10];
    if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"1"])
    {
        laiyuan.text = @"来源 : 摇一摇";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"2"])
    {
         laiyuan.text = @"来源 : 幸运大转盘";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"3"])
    {
        laiyuan.text = @"来源 : 有奖问答";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"4"])
    {
        laiyuan.text = @"来源 : 普通优惠券";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"couponInfo"] objectForKey:@"couponType"] isEqual:@"5"])
    {
        laiyuan.text = @"来源 : 商家优惠券";
    }
    laiyuan.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    [white2 addSubview:laiyuan];
    
    UIView *xian = [[UIView alloc]init];
    xian.frame = CGRectMake(5, 15, white2.frame.size.width - 10, 1);
    xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    [white2 addSubview:xian];
    
    UILabel *store = [[UILabel alloc]init];
    store.frame = CGRectMake(5, 16, 250, 15);
    store.text = [NSString stringWithFormat:@"所属门店:%@",[[arr[indexPath.row] objectForKey:@"office"] objectForKey:@"name"]];
    store.font = [UIFont systemFontOfSize:10];
    store.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    [white2 addSubview:store];
    
    UILabel *zhuangtai = [[UILabel alloc]init];
    zhuangtai.frame = CGRectMake(white1.frame.size.width - 60,5,50,20);
    zhuangtai.font = [UIFont systemFontOfSize:13];
    zhuangtai.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"1"])
    {
        zhuangtai.text = @"已使用";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@"0"])
    {
        zhuangtai.text = @"未使用";
    }
    else if ([[[arr[indexPath.row] objectForKey:@"coupon"] objectForKey:@"isUser"] isEqual:@""])
    {
        zhuangtai.text = @"暂无";
    }
    zhuangtai.textAlignment = NSTextAlignmentCenter;
    zhuangtai.backgroundColor = [UIColor colorWithHexString:@"32be60" alpha:1];
    zhuangtai.layer.cornerRadius = 5 ;
    zhuangtai.layer.masksToBounds = YES;

    [white1 addSubview:zhuangtai];

    
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
