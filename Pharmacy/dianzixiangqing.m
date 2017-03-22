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
#import "Color+Hex.h"
#import "XLImageShow.h"
@interface dianzixiangqing ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *hehe;
    NSDictionary *xq;
    UILabel *lablehaha;
    NSMutableArray *tupianv;
    CGFloat width;
    CGFloat height;
}
@property (strong, nonatomic) UILabel *biaoti;
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation dianzixiangqing

-(void)viewWillAppear:(BOOL)animated{
    tupianv = [[NSMutableArray alloc] init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    //状态栏名称
    self.navigationItem.title = @"电子病历详情";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableview.delegate=self;
    _tableview.dataSource=self;
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
            xq=[NSDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"data" ]
                                                       objectForKey:@"Emr"]];
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
#pragma mark  -----tableview 整理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }
    else if (section == 1)
    {
        NSArray *aa=[NSArray arrayWithArray:[xq objectForKey:@"urls"]];
        hehe=[NSMutableArray array];
        for (NSString * ss  in aa) {
            if (![ss isEqualToString:@""]) {
                [hehe addObject:ss];
            }
        }
        return hehe.count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            //根据lable返回行高
            NSString* s=[[NSString alloc] init];
            s=[NSString stringWithFormat:@"病例描述: %@",[xq objectForKey:@"emrDesc"] ];
            lablehaha=[[UILabel alloc] init];
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
            NSLog(@"%f       ,     %f",rect.size.width,rect.size.height);
            
            lablehaha.text=s;
            [lablehaha setFrame:CGRectMake(20, 0, rect.size.width, rect.size.height)];
            
            return lablehaha.frame.size.height+1>40? lablehaha.frame.size.height+1:40;
        }
        return 40;
    }
    return _tableview.frame.size.width+20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *id1 =@"cell123";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            self.biaoti = [[UILabel alloc]init];
            self.biaoti.frame = CGRectMake(0, 0, width, 44);
            self.biaoti.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            self.biaoti.font = [UIFont systemFontOfSize:17];
            self.biaoti.textAlignment = NSTextAlignmentCenter;
            if ([xq objectForKey:@"title"] == nil) {
                self.biaoti.text = @"";
            }
            else{
                self.biaoti.text= [NSString stringWithFormat:@"%@",[xq objectForKey:@"title"]];
            }
            [cell.contentView addSubview:self.biaoti];
        }
        else if (indexPath.row == 1){
            
            lablehaha.numberOfLines=0;
            lablehaha.font=[UIFont systemFontOfSize:14];
            lablehaha.textColor=[UIColor colorWithHexString:@"323232"];
            
            [cell.contentView addSubview:lablehaha];
        }
        else if (indexPath.row == 2){

            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            
            if ([xq objectForKey:@"tjsj"] == nil) {
                cell.textLabel.text = @"";
            }
            else{
                cell.textLabel.text = [NSString stringWithFormat:@"%@",[xq objectForKey:@"tjsj"]];
            }
        }
    }
    else if (indexPath.section == 1)
    {
        UIImageView*imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tableview.frame.size.width, _tableview.frame.size.width)];
        imageview.contentMode=UIViewContentModeScaleAspectFit;
        NSURL *uu=[NSURL URLWithString:[NSString stringWithFormat:@"%@/hyb/%@",service_host,hehe[indexPath.row]]];
        [imageview sd_setImageWithURL:uu placeholderImage:[UIImage imageNamed: @"daiti.png" ]];
        [tupianv addObject:imageview];
        [cell addSubview:imageview];
    }
   
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        [XLImageShow showImage:tupianv[indexPath.row]];
    }
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
