//
//  guanyuViewController.m
//  Pharmacy
//
//  Created by suokun on 16/6/8.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "guanyuViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"

@interface guanyuViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *shang;
    NSDictionary *data;
}
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation guanyuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"关于";
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [self.view addSubview:self.tableview];
    
    shang = @[@"门店名称",@"门店地址",@"联系电话",@"负责人",@"门店简介",];
    
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
    NSString*officeid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    officeid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];

    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"pageNo",@"10",@"pageSize",officeid,@"officeId",nil];
    
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
            NSLog(@"responseObject%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                data=[responseObject valueForKey:@"data"];
                
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"wencell";
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    cell.textLabel.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.row == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",shang[indexPath.section]];
    }
    else if (indexPath.row == 1)
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 0) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[data objectForKey:@"office"] objectForKey:@"name"]];
        }
        if (indexPath.section == 1) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[data objectForKey:@"office"] objectForKey:@"address"]];
        }
        if (indexPath.section == 2) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[data objectForKey:@"office"] objectForKey:@"phone"]];
        }
        if (indexPath.section == 3) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[data objectForKey:@"office"] objectForKey:@"master"]];
        }
        if (indexPath.section == 4) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[data objectForKey:@"office"] objectForKey:@"remarks"]];
        }
    }

    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}

//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];

}


@end