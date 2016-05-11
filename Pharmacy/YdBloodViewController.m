//
//  YdBloodViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdBloodViewController.h"
#import "TableViewCell.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
@interface YdBloodViewController ()
{
    CGFloat height;
    CGFloat width;
    
    int index;
    int zhi;
    
    UITextField *gaoyatext;
    UITextField *diyatext;
    UITextField *fanqiangtext;
    UITextField *fanhoutext;
    
    UIView * baseView;
    
    NSMutableArray *xueyaarray;
    NSMutableArray *xuetangarray;
    
    NSDictionary *ddd;
    
}
@property (strong,nonatomic)UISegmentedControl *segmentedControl;
@end

@implementation YdBloodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path1 =[NSHomeDirectory() stringByAppendingString:@"/Documents/GRxinxi.plist"];
    ddd = [NSDictionary dictionaryWithContentsOfFile:path1];
    
    
    //多出空白处
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    NSString *cellName = NSStringFromClass([TableViewCell class]);
    [self.tableview registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];

    //状态栏名称
    self.navigationItem.title = @"血压血糖";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];

    [self huoqu];
}
//获取血压血糖
-(void)huoqu
{
    xueyaarray = [[NSMutableArray alloc]init];
    xuetangarray = [[NSMutableArray alloc]init];
    
    _xueyaarraytime = [[NSMutableArray alloc]init];
    _xuetangarraytime = [[NSMutableArray alloc]init];
    
    _gaoyaarray = [[NSMutableArray alloc]init];
    _diyaarray = [[NSMutableArray alloc]init];
    
    _fanqianarray = [[NSMutableArray alloc]init];
    _fanhouarray = [[NSMutableArray alloc]init];

    [WarningBox warningBoxModeIndeterminate:@"正在加载..." andView:self.view];
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/basic/bodyList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[ddd objectForKey:@"id"],@"vipId", nil];
    
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
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            //NSLog(@"responseObject%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                NSArray *arr = [datadic objectForKey:@"bodyList"];
                
                
                
                for (NSDictionary *dd in arr) {
                    
                    if ([[dd objectForKey:@"checkItem"]isEqual:@"血糖"]) {
                        
                        [xuetangarray addObject:[dd objectForKey:@"result"]];
                        [_xuetangarraytime addObject:[dd objectForKey:@"checkTime"]];

                    }
                    else
                    {
                        
                        [xueyaarray addObject:[dd objectForKey:@"result"]];
                        [_xueyaarraytime addObject:[dd objectForKey:@"checkTime"]];
                    }
                    
                }
                
                NSString *str = [[NSString alloc]init];
                for (int i = 0; i < xueyaarray.count; i++) {
                    
                    str = xueyaarray[i];
                    
                    NSArray *array = [str componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
                    
                    [_gaoyaarray addObject:array[0]];
                    [_diyaarray addObject:array[1]];
                }
                for (int i = 0; i < xuetangarray.count; i++) {
                    
                    str = xuetangarray[i];
                    
                    NSArray *array = [str componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
                    
                    [_fanqianarray addObject:array[0]];
                    [_fanhouarray addObject:array[1]];
                }

                
                NSLog(@"xuetangarray%@\nfanqian%@\nfanhou%@",_xuetangarraytime,_fanqianarray,_fanhouarray);
               
                
                NSLog(@"xueyaarray%@\ngaoya%@\ndiya%@",_xueyaarraytime,_gaoyaarray,_diyaarray);
                
//                NSLog(@"fanqianarray:%@",_fanqianarray);
//                NSLog(@"fanhouarray:%@",_fanhouarray);
//                
//                NSLog(@"gaoyaarray:%@",_gaoyaarray);
//                NSLog(@"diyaarray:%@",_diyaarray);

                NSUserDefaults *ss = [NSUserDefaults standardUserDefaults];
                [ss setValue:_fanqianarray forKey:@"fanqian"];
                [ss setValue:_fanhouarray forKey:@"fanhou"];
                [ss setValue:_gaoyaarray forKey:@"gaoya"];
                [ss setValue:_diyaarray forKey:@"diya"];
                [ss setValue:_xuetangarraytime forKey:@"xuetangarraytime"];
                [ss setValue:_xueyaarraytime forKey:@"xueyaarraytime"];
                
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
//血压
-(void)xueya
{
    UILabel *gaoya = [[UILabel alloc]init];
    gaoya.frame = CGRectMake(5, 5, (width-25)/6, 20);
    gaoya.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    gaoya.font = [UIFont systemFontOfSize:13];
    gaoya.text = @"高   压:";
    //gaoya.textAlignment = NSTextAlignmentCenter;
    
    gaoyatext = [[UITextField alloc]init];
    gaoyatext.frame = CGRectMake(CGRectGetMaxX(gaoya.frame) + 5, 5, (width-25)/3, 20);
    gaoyatext.font = [UIFont systemFontOfSize:13];
    gaoyatext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    gaoyatext.layer.borderWidth =1;
    gaoyatext.layer.cornerRadius = 5.0;
    gaoyatext.placeholder = @"请输入高压";

    UILabel *diya = [[UILabel alloc]init];
    diya.frame = CGRectMake(CGRectGetMaxX(gaoyatext.frame) + 5, 5, (width-25)/6, 20);
    diya.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    diya.font = [UIFont systemFontOfSize:13];
    diya.text = @"低   压:";
    //diya.textAlignment = NSTextAlignmentCenter;
    
    diyatext = [[UITextField alloc]init];
    diyatext.frame = CGRectMake(CGRectGetMaxX(diya.frame) + 5, 5, (width-25)/3, 20);
    diyatext.font = [UIFont systemFontOfSize:13];
    diyatext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    diyatext.layer.borderWidth =1;
    diyatext.layer.cornerRadius = 5.0;
    diyatext.placeholder = @"请输入低压";
    
    UIButton *xueya = [[UIButton alloc]init];
    xueya.frame = CGRectMake(30, 35, width - 60, 20);
    xueya.titleLabel.font = [UIFont systemFontOfSize:13];
    [xueya setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    [xueya setTitle:@"上传血压" forState:UIControlStateNormal];
    [xueya addTarget:self action:@selector(xueyabutton) forControlEvents:UIControlEventTouchUpInside];
    xueya.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    xueya.layer.cornerRadius = 5;
    xueya.layer.masksToBounds = YES;
    
    [baseView addSubview:gaoya];
    [baseView addSubview:gaoyatext];
    [baseView addSubview:diya];
    [baseView addSubview:diyatext];
    [baseView addSubview:xueya];

}
//血糖
-(void)xuetang
{
    UILabel *fanqian = [[UILabel alloc]init];
    fanqian.frame = CGRectMake(5, 70, (width-25)/6, 20);
    fanqian.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    fanqian.font = [UIFont systemFontOfSize:13];
    fanqian.text = @"餐   前:";
    //fanqian.textAlignment = NSTextAlignmentCenter;
    
    fanqiangtext = [[UITextField alloc]init];
    fanqiangtext.frame = CGRectMake(CGRectGetMaxX(fanqian.frame) + 5, 70, (width-25)/3, 20);
    fanqiangtext.font = [UIFont systemFontOfSize:13];
    fanqiangtext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    fanqiangtext.layer.borderWidth =1;
    fanqiangtext.layer.cornerRadius = 5.0;
    fanqiangtext.placeholder = @"请输入餐前血糖";
    
    
    
    UILabel *fanhou = [[UILabel alloc]init];
    fanhou.frame = CGRectMake(CGRectGetMaxX(fanqiangtext.frame) + 5, 70, (width-25)/6, 20);
    fanhou.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    fanhou.font = [UIFont systemFontOfSize:13];
    fanhou.text = @"餐   后:";
    //fanhou.textAlignment = NSTextAlignmentCenter;
    
    fanhoutext = [[UITextField alloc]init];
    fanhoutext.frame = CGRectMake(CGRectGetMaxX(fanhou.frame) + 5, 70, (width-25)/3, 20);
    fanhoutext.font = [UIFont systemFontOfSize:13];
    fanhoutext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    fanhoutext.layer.borderWidth =1;
    fanhoutext.layer.cornerRadius = 5.0;
    fanhoutext.placeholder = @"请输入餐后血糖";
    
    UIButton *xuetang = [[UIButton alloc]init];
    xuetang.frame = CGRectMake(30, 100, width - 60, 20);
    xuetang.titleLabel.font = [UIFont systemFontOfSize:13];
    [xuetang setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    [xuetang setTitle:@"上传血糖" forState:UIControlStateNormal];
    [xuetang addTarget:self action:@selector(xuetangbutton) forControlEvents:UIControlEventTouchUpInside];
    xuetang.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    xuetang.layer.cornerRadius = 5;
    xuetang.layer.masksToBounds = YES;
    
    [baseView addSubview:fanqian];
    [baseView addSubview:fanqiangtext];
    [baseView addSubview:fanhou];
    [baseView addSubview:fanhoutext];
    [baseView addSubview:xuetang];

}
//上传血糖
-(void)xuetangbutton
{
    [WarningBox warningBoxModeIndeterminate:@"正在上传..." andView:self.view];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/saveBodyCheck";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    NSString *xuetangstring = [NSString stringWithFormat:@"%@,%@",fanqiangtext.text,fanhoutext.text];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[ddd objectForKey:@"id"],@"vipId",@"血糖",@"checkItem",xuetangstring,@"result",currentTime,@"checkTime", nil];
    
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
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                
                fanqiangtext.text = @"";
                fanhoutext.text = @"";

                [self huoqu];
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
//上传血压
-(void)xueyabutton
{
    [WarningBox warningBoxModeIndeterminate:@"正在上传..." andView:self.view];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/saveBodyCheck";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    NSString *xueyastring = [NSString stringWithFormat:@"%@,%@",gaoyatext.text,diyatext.text];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[ddd objectForKey:@"id"],@"vipId",@"血压",@"checkItem",xueyastring,@"result",currentTime,@"checkTime", nil];
    
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
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                
                gaoyatext.text = @"";
                diyatext.text = @"";
                
                [self huoqu];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section?1:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class])];
    [cell configUI:indexPath];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(5, 8, 15, 40);
    
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    lab.numberOfLines = 2;
    [cell.contentView addSubview:lab];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            lab.text = @"血压";
        }
        else
        {
            lab.text = @"血糖";
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIView * vi= [[UIView alloc]init];
            vi.frame = CGRectMake(0, 0, width, 170);
            vi.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:vi];
        }
    }
    //点击不变颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //return 30;
    if (section == 0)
    {
        return 130;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    [self xueya];
    [self xuetang];
   
    return baseView;
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
