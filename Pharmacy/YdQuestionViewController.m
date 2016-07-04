//
//  YdQuestionViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/11.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdQuestionViewController.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "WarningBox.h"
#import "Color+Hex.h"
#import "UIImageView+WebCache.h"
#import "YdPharmacistDetailsViewController.h"
#import "mememeViewController.h"
#import <JMessage/JMessage.h>

@interface YdQuestionViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *arr;
    NSMutableArray *arrImage;
    
    NSMutableArray *presentarrImage;
}
@end

@implementation YdQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.width;
    
    arrImage = [[NSMutableArray alloc]init];
    presentarrImage = [[NSMutableArray alloc] init];
    
    //状态栏名称
    self.navigationItem.title = @"问药师";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
        
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self jiekou];
}

-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/pharmacistInfoList";
    
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:/*zhid*/@"7",@"officeId",@"1",@"pageSize",@"5",@"pageNo", nil];
    
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
//            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                NSLog(@"dicdatadic%@",datadic);

                
                arr = [datadic objectForKey:@"pharmacistInfoList"];
                
                
                for (int i = 0; i < arr.count; i++) {
                    
                    [arrImage addObject:[NSString stringWithFormat:@"%@%@",service_host,[arr[i] objectForKey:@"photo"]]];
                    
                    
                }
                
                [self.tableview reloadData];
                
            }
            
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        //NSLog(@"错误：%@",error);
    }];
    
}

//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrImage.count;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 80;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    
    baseView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    
    UIView *bai = [[UIView alloc]initWithFrame:CGRectMake(0, 1, width, 18)];
    
    bai.backgroundColor = [UIColor whiteColor];
    
    [baseView addSubview:bai];
    
    return baseView;
}
//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"wencell";
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UIImageView *touxiang = [[UIImageView alloc]init];
    touxiang.frame = CGRectMake(10, 10, 60, 60);
    NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",arrImage[indexPath.section]]];
    [touxiang sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"IMG_0797.jpg"]];
    touxiang.layer.cornerRadius = 30;
    touxiang.layer.masksToBounds = YES;

    
    UILabel * name = [[UILabel alloc]init];
    name.frame = CGRectMake(CGRectGetMaxX(touxiang.frame) + 10, 10, width - 50 -CGRectGetMaxX(touxiang.frame) - 20 , 21);
    name.text =  [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"name"]];
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    
    
    
    UIButton *zixun = [[UIButton alloc]init];
    zixun.frame = CGRectMake(width - 50, 10, 40, 21);
    [zixun setTitle:@"咨询" forState:UIControlStateNormal];
    [zixun setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
    zixun.titleLabel.font = [UIFont systemFontOfSize:15];
    zixun.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
    zixun.layer.cornerRadius =5;
    zixun.layer.masksToBounds = YES;
    [zixun addTarget:self action:@selector(liaotian) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *neirong = [[UILabel alloc]init];
    neirong.frame = CGRectMake(CGRectGetMaxX(touxiang.frame) + 10,38, width - CGRectGetMaxX(touxiang.frame) - 20 ,16);
    neirong.text = [NSString stringWithFormat:@"药师类别:     %@",[arr[indexPath.section] objectForKey:@"specialty"]];
    neirong.font = [UIFont systemFontOfSize:13];
    neirong.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    
    
    UILabel *neirong1 = [[UILabel alloc]init];
    neirong1.frame = CGRectMake(CGRectGetMaxX(touxiang.frame) + 10,55, width - CGRectGetMaxX(touxiang.frame) - 20 ,16);
    neirong1.text = [NSString stringWithFormat:@"药师资质:     %@",[arr[indexPath.section] objectForKey:@"qualification"]];
    neirong1.font = [UIFont systemFontOfSize:13];
    neirong1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    

    
    [cell.contentView addSubview:touxiang];
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:zixun];
    [cell.contentView addSubview:neirong];
    [cell.contentView addSubview:neirong1];

    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
-(void)liaotian
{
    
    JMSGConversation *conversation = [JMSGConversation singleConversationWithUsername:@"memeda"];
    if (conversation == nil) {
        
        
        [JMSGConversation createSingleConversationWithUsername:@"memeda" completionHandler:^(id resultObject, NSError *error) {
            
            if (error) {
                NSLog(@"创建会话失败");
                return ;
            }
            mememeViewController*xixi=[mememeViewController new];
//            xixi.conversation=(JMSGConversation *)resultObject;
            [self.navigationController pushViewController:xixi animated:YES];
            
            
        }];
    } else {
        mememeViewController*xixi=[mememeViewController new];
//        xixi.conversation=conversation;
        [self.navigationController pushViewController:xixi animated:YES];
        
    }

    NSLog(@"聊天界面");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     YdPharmacistDetailsViewController *PharmacistDetails = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"pharmacistdetails"];
     PharmacistDetails.yaoshiid = [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"id"]];
     NSLog(@"%@",PharmacistDetails.yaoshiid);
     [self.navigationController pushViewController:PharmacistDetails animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
        
@end
