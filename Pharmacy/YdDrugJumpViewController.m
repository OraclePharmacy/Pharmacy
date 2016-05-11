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
@interface YdDrugJumpViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *arr;
}
@end

@implementation YdDrugJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    //状态栏名称
    self.navigationItem.title = _bookNo;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    [self jiekou];
    
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
        //出入参数：
     NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_bookNo,@"level3Name",@"5",@"pageNo",@"1",@"pageSize",nil];
    
        NSString*jsonstring=[writer stringWithObject:datadic];
    
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        NSLog(@"%@",url1);
    
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            @try
            {
                [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                
                if ([[responseObject objectForKey:@"code"] intValue]==0000) {
    
                    NSDictionary*datadic=[responseObject valueForKey:@"data"];
                    
                    arr = [NSArray arrayWithArray:[datadic objectForKey:@"productList"]];
                    
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
    return 130;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"bingzheng";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 80, 80)];
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[indexPath.row]objectForKey:@"picUrl" ]] ;
    NSLog(@"%@",path);
    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
   
    
    UILabel *name= [[UILabel alloc]initWithFrame:CGRectMake(120 , 10, width -140 , 20)];
    name.font = [UIFont systemFontOfSize:15];
    //name.textAlignment = NSTextAlignmentCenter;
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    name.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"name"]];
    

    
    UILabel *changjia = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, width -140, 20)];
    changjia.font = [UIFont systemFontOfSize:13];
    //changjia.textAlignment = NSTextAlignmentCenter;
    changjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    changjia.text =[NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"manufacturer"]];

    
    UILabel *guige = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, width -140, 20)];
    guige.font = [UIFont systemFontOfSize:11];
    //guige.textAlignment = NSTextAlignmentCenter;
    guige.textColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    guige.text =[NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"specification"]];

    
    UILabel *jiage = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, width -140, 20)];
    jiage.font = [UIFont systemFontOfSize:10];
    //jiage.textAlignment = NSTextAlignmentCenter;
    jiage.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    jiage.text =[NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@""]];
    
    
    UILabel *jianjie = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, width - 40 , 40)];
    jianjie.font = [UIFont systemFontOfSize:12];
    //jianjie.textAlignment = NSTextAlignmentCenter;
    jianjie.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    jianjie.text =[NSString stringWithFormat:@"药品简介:%@",[arr[indexPath.row] objectForKey:@""]];
    jianjie.numberOfLines = 2;
    
    [cell.contentView addSubview:image];
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:changjia];
    [cell.contentView addSubview:guige];
    [cell.contentView addSubview:jiage];
    [cell.contentView addSubview:jianjie];
    
    
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    //点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YdDrugsViewController  *Drugs =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugs"];
    Drugs.yaopinID = [arr[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:Drugs animated:YES];
    
    return;
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
