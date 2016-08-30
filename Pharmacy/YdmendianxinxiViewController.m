//
//  YdmendianxinxiViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/30.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdmendianxinxiViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "YdScanViewController.h"
#import "tiaodaodenglu.h"

@interface YdmendianxinxiViewController ()
{
    CGFloat width;
    CGFloat height;
    UILabel *lable;
    NSArray *arr;
    NSDictionary *mendiandion;
    NSArray *dianyuanarray;
}
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdmendianxinxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.tableFooterView = [[UIView alloc] init];
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    arr = @[@"门店简介:",@"门店地址:",@"负责人:",@""];
    
    //导航栏标题
    self.navigationItem.title = @"门店名称";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self jiekou];
}

-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/basic/officeUserList";
    
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:zhid,@"officeId",@"2",@"pageNo",@"100",@"pageSize", nil];
    
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
                
                mendiandion = [datadic objectForKey:@"office"];
                
                dianyuanarray = [mendiandion objectForKey:@"userList"];
                
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
    return 3;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 4;
    }
    else if (section == 2)
    {
        return dianyuanarray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else if (section == 1)
    {
        return 10;
    }
    else if (section == 2)
    {
        return 10;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 150;
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row==0){
            //根据lable返回行高
            NSString* s=[[NSString alloc] init];
            s=[NSString stringWithFormat:@"%@",[mendiandion objectForKey:@"remarks"] ];
            
            UIFont *font = [UIFont fontWithName:@"Arial" size:15];
            
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:s
             attributes:@
             {
             NSFontAttributeName: font
             }];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){width-40, CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            
            lable.text=s;
            [lable setFrame:CGRectMake(80, 0, rect.size.width-40, rect.size.height)];
            
            return lable.frame.size.height+1>40? lable.frame.size.height+1:40;
            
        }
        return 40;
    }
    else if (indexPath.section == 2)
    {
        return 80;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"mendianxinxi";
    UITableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    if (indexPath.section == 0) {
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(0, 0, width, 150);
        
        
        NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[mendiandion objectForKey:@"photo"]];
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
        [cell.contentView addSubview:image];
    }
    else if (indexPath.section == 1){
        
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        
        UILabel *jianjie = [[UILabel alloc]init];
        jianjie.frame = CGRectMake( 80, 10, width - 90, 20);
        jianjie.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        jianjie.font = [UIFont systemFontOfSize:13];
        
        if (indexPath.row == 0)
        {
            lable=[[UILabel alloc] initWithFrame:CGRectMake(80, 10,width - 90, 20)];
            lable.numberOfLines=0;
            lable.font=[UIFont systemFontOfSize:14];
            lable.textColor=[UIColor colorWithHexString:@"323232"];
            
            [cell.contentView addSubview:lable];
        }
        else if (indexPath.row == 1)
        {
            
            jianjie.text =  [mendiandion objectForKey:@"address"];
            [cell.contentView addSubview:jianjie];
        }
        else if (indexPath.row == 2)
        {
            UILabel *fuzeren = [[UILabel alloc]init];
            fuzeren.frame = CGRectMake( 65, 10, 80, 20);
            fuzeren.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            fuzeren.font = [UIFont systemFontOfSize:13];
            fuzeren.text = [mendiandion objectForKey:@"master"];
            [cell.contentView addSubview:fuzeren];
            
            UILabel *dianhua = [[UILabel alloc]init];
            dianhua.frame = CGRectMake( width - 155, 10, 150, 20);
            dianhua.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            dianhua.font = [UIFont systemFontOfSize:13];
            dianhua.text = [NSString stringWithFormat:@"电话:%@",[mendiandion objectForKey:@"phone"]];
            dianhua.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:dianhua];
        }
        else if (indexPath.row == 3)
        {
            UILabel *pingjia = [[UILabel alloc]init];
            pingjia.frame = CGRectMake( 5, 10, 100, 20);
            pingjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            pingjia.font = [UIFont systemFontOfSize:13];
            pingjia.text = [NSString stringWithFormat:@"评价:%@次",[mendiandion objectForKey:@"evaluateTimes"]];
            pingjia.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:pingjia];
            
            UILabel *haoping = [[UILabel alloc]init];
            haoping.frame = CGRectMake( 110, 10, 100, 20);
            haoping.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            haoping.font = [UIFont systemFontOfSize:13];
            haoping.text = [NSString stringWithFormat:@"好评率:%@%%",[mendiandion objectForKey:@"evaluateRate"]];
            haoping.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:haoping];
            
            UIButton * mendian = [[UIButton alloc]init];
            mendian.frame = CGRectMake(width - 120, 10, 100, 20);
            [mendian setTitle:@"评价门店" forState:UIControlStateNormal];
            [mendian setTitleColor:[UIColor colorWithHexString:@"32be60" alpha:1] forState:UIControlStateNormal];
            mendian.titleLabel.font = [UIFont systemFontOfSize: 13.0];
            [mendian addTarget:self action:@selector(pingjiamendian) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:mendian];
            
        }
    }
    else if (indexPath.section == 2)
    {
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(10, 10, 60, 60);
        
        image.layer.cornerRadius = 30;
        image.layer.masksToBounds = YES;
        NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[dianyuanarray[indexPath.row] objectForKey:@"photo"]];
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
        [cell.contentView addSubview:image];
        
        UILabel *name = [[UILabel alloc]init];
        name.frame = CGRectMake( 80, 10, width - 90, 20);
        name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        name.font = [UIFont systemFontOfSize:15];
        name.text = [NSString stringWithFormat:@"%@",[dianyuanarray[indexPath.row] objectForKey:@"name"]];
        [cell.contentView addSubview:name];
        
        UILabel *cishu = [[UILabel alloc]init];
        cishu.frame = CGRectMake( 80, 30, 100, 20);
        cishu.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        cishu.font = [UIFont systemFontOfSize:13];
        cishu.text = [NSString stringWithFormat:@"评价:%@次",[dianyuanarray[indexPath.row] objectForKey:@"evaluateTimes"]];
        [cell.contentView addSubview:cishu];
        
        UILabel *haoping = [[UILabel alloc]init];
        haoping.frame = CGRectMake( 80, 50, 100, 20);
        haoping.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        haoping.font = [UIFont systemFontOfSize:13];
        haoping.text = [NSString stringWithFormat:@"好评率:%@%%",[dianyuanarray[indexPath.row] objectForKey:@"evaluateRate"]];
        [cell.contentView addSubview:haoping];
        
        UIButton * mendian = [[UIButton alloc]init];
        mendian.frame = CGRectMake(width - 120, 50, 100, 20);
        [mendian setTitle:@"评价店员" forState:UIControlStateNormal];
        [mendian setTitleColor:[UIColor colorWithHexString:@"32be60" alpha:1] forState:UIControlStateNormal];
        mendian.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        [mendian addTarget:self action:@selector(pingjiadianyuan) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:mendian];
        
    }
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    return cell;
}
-(void)pingjiamendian
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
        [tiaodaodenglu jumpToLogin:self.navigationController];
    }else{
        //跳转到扫描页面
        YdScanViewController *Scan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scan"];
        Scan.str = @"1";
        [self.navigationController pushViewController:Scan animated:YES];
    }
}
-(void)pingjiadianyuan
{ if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
    [tiaodaodenglu jumpToLogin:self.navigationController];
}else{
    //跳转到扫描页面
    YdScanViewController *Scan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scan"];
    Scan.str = @"2";
    [self.navigationController pushViewController:Scan animated:YES];
}
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
