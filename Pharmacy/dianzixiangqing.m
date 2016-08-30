//
//  dianzixiangqing.m
//  Pharmacy
//
//  Created by 小狼 on 16/5/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "dianzixiangqing.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "hongdingyi.h"
#import "WarningBox.h"
#import "SBJsonWriter.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"

@interface dianzixiangqing ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *hehe;
    NSDictionary *xq;
}
@property (weak, nonatomic) IBOutlet UILabel *biaoti;
@property (weak, nonatomic) IBOutlet UILabel *neirong;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *riqi;

@end

@implementation dianzixiangqing

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _neirong.numberOfLines=0;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self jiekou];
}
-(void)jiekou{
  NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
    //userID    暂时不用改
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:vip,@"vipId",@"1",@"pageNo",@"6",@"pageSize",_emrid,@"emrId", nil];
   
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
            xq=[NSDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"data" ] objectForKey:@"Emr"]];
            
            [self fuzhi];
            [_tableview reloadData];
            
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
    }];

    
    
    
}
-(void)fuzhi{
    _biaoti.text= [NSString stringWithFormat:@"%@",[xq objectForKey:@"title"]];
    _neirong.text=[NSString stringWithFormat:@"%@",[xq objectForKey:@"emrDesc"]];
    _riqi.text =  [NSString stringWithFormat:@"%@",[xq objectForKey:@"tjsj"]];
}
#pragma mark  -----tableview 整理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *aa=[NSArray arrayWithArray:[xq objectForKey:@"urls"]];
    hehe=[NSMutableArray array];
    for (NSString * ss  in aa) {
        if (![ss isEqualToString:@""]) {
            [hehe addObject:ss];
        }
    }
    return hehe.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _tableview.frame.size.width+20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *id1 =@"cell123";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    UIImageView*imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tableview.frame.size.width, _tableview.frame.size.width)];
    
     [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",hehe[indexPath.section]]] placeholderImage:[UIImage imageNamed: @"daiti.png" ]];
    
    [cell addSubview:imageview];
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
