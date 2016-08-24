//
//  YDTejialiebiaoViewController.m
//  Pharmacy
//
//  Created by 小狼 on 16/5/27.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YDTejialiebiaoViewController.h"
#import "AFHTTPSessionManager.h"
#import "SBJsonWriter.h"
#import "lianjie.h"
#import "hongdingyi.h"
#import "WarningBox.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "Color+Hex.h"
#import "YdDrugsViewController.h"
#import "MJRefresh.h"
@interface YDTejialiebiaoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray*proList;
    float width;
   
    int ye;
    int coun;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YDTejialiebiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableview.tableFooterView = [[UIView alloc] init];
    //Tab bar 颜色
    self.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    //状态栏名称
    self.navigationItem.title = @"特价药品";
    
 self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
 
  
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    width = [UIScreen mainScreen].bounds.size.width;
    
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

-(void)jiekou{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/product/proList";
    
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:zhid,@"officeId",[NSString stringWithFormat:@"%d",ye],@"pageNo",@"10",@"pageSize", nil];
    
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
            
            NSLog(@"－＊－＊－＊－＊－特价药品列表 -*-*-*--*\n\nn\%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                proList = [NSMutableArray arrayWithArray:[datadic objectForKey:@"proList"] ];
      
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"cell1";
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(5, 5, 100, 100);
    //image.image = [UIImage imageNamed:@"IMG_0801.jpg"];
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[proList[indexPath.row] objectForKey:@"picUrl"]] ;
    [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(110, 5, width - 115, 20);
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    name.text = [NSString stringWithFormat:@"%@",[proList[indexPath.row] objectForKey:@"commonName"]];
    
    UILabel *changjia = [[UILabel alloc]init];
    changjia.frame = CGRectMake(110, 25, width - 115, 20);
    changjia.font = [UIFont systemFontOfSize:12];
    changjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    changjia.text = [NSString stringWithFormat:@"生产厂家:%@",[proList[indexPath.row] objectForKey:@"manufacturer"]];
    
    UILabel *guige = [[UILabel alloc]init];
    guige.frame = CGRectMake(110, 45, width - 115, 20);
    guige.font = [UIFont systemFontOfSize:12];
    guige.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    guige.text = [NSString stringWithFormat:@"规格:%@",[proList[indexPath.row] objectForKey:@"specification"]];
    
    UILabel *yuanjian = [[UILabel alloc]init];
    yuanjian.frame = CGRectMake(110, 65, width - 115, 20);
    yuanjian.font = [UIFont systemFontOfSize:12];
    yuanjian.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    yuanjian.text = [NSString stringWithFormat:@"原价:%.2f",[[proList[indexPath.row] objectForKey:@"prodPrice"]floatValue]];
    
    UILabel *tejia = [[UILabel alloc]init];
    tejia.frame = CGRectMake(110, 85, width  - 115, 20);
    tejia.font = [UIFont systemFontOfSize:12];
    tejia.textColor = [UIColor redColor];
    tejia.text = [NSString stringWithFormat:@"特价:%.2f",[[proList[indexPath.row] objectForKey:@"specPrice"]floatValue]];
    
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
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return proList.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YdDrugsViewController*sousou=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugs"];
    sousou.yaopinID=[NSString stringWithFormat:@"%@",[proList[indexPath.row] objectForKey:@"id"] ];
    [self.navigationController pushViewController:sousou animated:YES];
    
}
-(void)fanhui{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
