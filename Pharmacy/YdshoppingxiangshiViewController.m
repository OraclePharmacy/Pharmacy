//
//  YdshoppingxiangshiViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/10.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdshoppingxiangshiViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"

@interface YdshoppingxiangshiViewController ()
{
    CGFloat width;
    CGFloat height;
    NSMutableArray*arr;
    float heji;
}
@property (weak, nonatomic) IBOutlet UILabel *dianhuahaoma;
@property (weak, nonatomic) IBOutlet UILabel *xingming;
@property (weak, nonatomic) IBOutlet UILabel *dizhi;
@property (weak, nonatomic) IBOutlet UILabel *hejijiage;

@end

@implementation YdshoppingxiangshiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    heji = 0;
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    NSString *countwenjian=[NSString stringWithFormat:@"%@/Documents/Dingdanxinxi.plist",NSHomeDirectory()];
    arr=[NSMutableArray arrayWithContentsOfFile:countwenjian];
    for (int i=0; i<arr.count; i++) {
        if ([[arr[i] objectForKey:@"specProdFlag"] intValue]==1) {
            float s=[[arr[i] objectForKey:@"specPrice"] floatValue]*[[arr[i] objectForKey:@"shuliang"] floatValue];
            [arr[i] setValue:[NSString stringWithFormat:@"%.2f",s] forKey:@"zongjia"];
        }else{
            float s=[[arr[i] objectForKey:@"prodPrice"] floatValue]*[[arr[i] objectForKey:@"shuliang"] floatValue];
            [arr[i] setValue:[NSString stringWithFormat:@"%.2f",s] forKey:@"zongjia"];
        }
    }
    
    for (int i=0; i<arr.count; i++) {
        heji+=[[arr[i] objectForKey:@"zongjia"] floatValue];
    }
    //状态栏名称
    self.navigationItem.title = @"确认订单";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
     NSString *gerende=[NSString stringWithFormat:@"%@/Documents/GRxinxi.plist",NSHomeDirectory()];
    NSDictionary*geren=[NSDictionary dictionaryWithContentsOfFile:gerende];
    NSUserDefaults*s=[NSUserDefaults standardUserDefaults];
    _dianhuahaoma.text=[NSString stringWithFormat:@"%@",[s objectForKey:@"shoujihao"]];
    _xingming.text=[NSString stringWithFormat:@"%@",[geren objectForKey:@"name"]];
    _dizhi.text=[NSString stringWithFormat:@"%@ %@",[geren objectForKey:@"area"],[geren objectForKey:@"detail"]];
    _hejijiage.text=[NSString stringWithFormat:@"%.2f",heji];
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    UITableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    
    //药品图片
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(10, 10, 80, 80);
    //[image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/hyb/%@",service_host,[yikaishi[indexPath.row]objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg"]];
    //image.layer.cornerRadius=30;
    image.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:image];
    //药品名称
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(100, 10, 200, 20);
    //name.text = [NSString stringWithFormat:@"%@",[[yikaishi[indexPath.row] objectForKey:@"product"] objectForKey:@"commonName"]];
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    name.font =[UIFont systemFontOfSize:15];
    name.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.row] objectForKey:@"product"] objectForKey:@"commonName"]];
    [cell.contentView addSubview:name];
    
    UILabel *yuanjia = [[UILabel alloc]init];
    yuanjia.frame = CGRectMake(100, 30, 70, 20);
    yuanjia.text = [NSString stringWithFormat:@"数量:%@",[arr[indexPath.row] objectForKey:@"shuliang"]];
    yuanjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    yuanjia.font =[UIFont systemFontOfSize:13];
    [cell.contentView addSubview:yuanjia];
    
    UILabel *zongjia = [[UILabel alloc]init];
    zongjia.frame = CGRectMake(100, 50,200, 20);
    zongjia.text = [NSString stringWithFormat:@"总价:¥ %@",[arr[indexPath.row] objectForKey:@"zongjia"]];
    zongjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    zongjia.font =[UIFont systemFontOfSize:13];
    [cell.contentView addSubview:zongjia];
    
    //生产厂家
    UILabel *changjia = [[UILabel alloc]init];
    changjia.frame = CGRectMake(100, 70, 60, 20);
    changjia.text = @"生产厂家:";
    changjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    changjia.font =[UIFont systemFontOfSize:13];
    //changjia.backgroundColor = [UIColor colorWithHexString:@"646464" alpha:1];
    [cell.contentView addSubview:changjia];
    
    UILabel *vender = [[UILabel alloc]init];
    vender.frame = CGRectMake( 160, 70, width - 160 , 20);
    //vender.text = [NSString stringWithFormat:@"%@",[[yikaishi[indexPath.row] objectForKey:@"product"] objectForKey:@"manufacturer"]];
    vender.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.row] objectForKey:@"product"] objectForKey:@"manufacturer"]];
    vender.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    vender.font =[UIFont systemFontOfSize:12];
    [cell.contentView addSubview:vender];
    
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏键盘
    [self.view endEditing:YES];
    
}

- (IBAction)tijiao:(id)sender {
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/saveVipBuyRec";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSMutableArray *yaoId = [[NSMutableArray alloc]init];
    NSMutableArray *shuId = [[NSMutableArray alloc]init];
    NSDictionary *liebiao;
    NSMutableArray *liebiao1 = [[NSMutableArray alloc]init];
    for ( int i = 0; i < arr.count ; i++ ) {
        
        [yaoId addObject:[arr[i] objectForKey:@"id"]];
        [shuId addObject:[arr[i] objectForKey:@"shuliang"]];
//        NSDictionary *yaoid = [NSDictionary dictionaryWithObjectsAndKeys:[arr[i] objectForKey:@"id"], @"id",nil];
//        NSDictionary *shuId = [NSDictionary dictionaryWithObjectsAndKeys:[arr[i] objectForKey:@"shuliang"], @"amount",nil];
        liebiao = [NSDictionary dictionaryWithObjectsAndKeys:yaoId[i],@"id",shuId[i],@"amount", nil];
        
        [liebiao1 addObject:liebiao];
    }
    
    NSString*vip;
    NSString *path6 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRxinxi.plist"];
    NSDictionary*pp=[NSDictionary dictionaryWithContentsOfFile:path6];
    vip=[NSString stringWithFormat:@"%@",[pp objectForKey:@"id"]];
    
    //会员ID  药品ID 数量   药品id与数量放到列表
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1110",@"vipId",liebiao1,@"vipBuyRec", nil];
    NSLog(@"=========%@",datadic);
    NSLog(@"%@",vip);
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
            
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                [WarningBox warningBoxModeText:@"提交成功" andView:self.view];
                
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

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
