//
//  YdPharmacistDetailsViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/25.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdPharmacistDetailsViewController.h"
#import "Color+Hex.h"
#import "YdShopViewController.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "WarningBox.h"
#import "UIImageView+WebCache.h"
#import <JMessage/JMessage.h>
#import "mememeViewController.h"

@interface YdPharmacistDetailsViewController ()

{
    CGFloat width;
    CGFloat height;
    
    NSDictionary *ddd;
    
    NSArray *arr;
    NSArray *officearr;
}
@property (nonatomic, strong) NSArray *second;
@end

@implementation YdPharmacistDetailsViewController
-(void)viewWillAppear:(BOOL)animated{
     self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"\n\n\n\n\nhahahaha\n\n\n\n%@\n\n\n\n\n",_logname);
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _second = @[@"性别:",@"资格:",@"专业:",@"解答次数:"];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"药师详情";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    [self jiekou];
    
    [self.tableview reloadData];
}
-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/pharmacistInfoDetail";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:self.yaoshiid,@"id", nil];
    
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
           // [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            //            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                //NSLog(@"datadicdatadicdatadicdatadicdatadicdatadicdatadicdatadicdatadic%@",datadic);
                
                arr = [datadic objectForKey:@"pharmacistInfoDetail"];
                
                officearr = [arr valueForKey:@"office"];
                
                NSLog(@"%@",officearr);
                
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
    return 4;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return _second.count;
    }
    else if (section == 2)
    {
        return 1;
    }
    return 1;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }
    return 40;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
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
    else if (section == 3)
    {
        return 10;
    }

    return 0;
}
//编辑header内容
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//}
//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"xiangqingcell";
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    if (indexPath.section == 0 )
    {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1 ];
        
        UIImageView *touxiang = [[UIImageView alloc]init];
        touxiang.frame = CGRectMake((width - 80) / 2, 35, 80, 80);
        touxiang.image = [UIImage imageNamed:@"IMG_0797.jpg"];
        touxiang.layer.cornerRadius = 40;
        touxiang.layer.masksToBounds = YES;
        NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,[arr[0] objectForKey:@"photo"]]];
        [touxiang sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"IMG_0797.jpg"]];
        
        
        UILabel *name = [[UILabel alloc]init];
        name.frame = CGRectMake(0, 115, width, 35);
        name.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"name"]];;
        name.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        name.textAlignment = NSTextAlignmentCenter;

        [cell.contentView addSubview:touxiang];
        [cell.contentView addSubview:name];
        
    }
    else if (indexPath.section == 1)
    {
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
        cell.textLabel.text = cell.textLabel.text = self.second[indexPath.row];
        
        UILabel *text = [[UILabel alloc]init];
        text.frame = CGRectMake(110, 10, width - 120, 20);
        //text.backgroundColor = [UIColor redColor];
        text.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
        text.textAlignment = NSTextAlignmentRight;
        if (indexPath.row == 0) {

            NSString *str = [[NSString alloc] init];
            str = [arr[0] objectForKey:@"sex"];
            
            
            if ([str integerValue]==1) {
                 text.text =@"男";
            }
            else
            {
                text.text = @"女";
            }
            
        }
        else if (indexPath.row == 1) {
            text.text = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"specialty"]];
        }
        else if (indexPath.row == 2) {
            text.text = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"qualification"]];
        }
        else if (indexPath.row == 3) {
            text.text = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"answerTime"]];
        }
        

        [cell.contentView addSubview:text];
        
    }
    else if (indexPath.section == 2) {
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
        cell.textLabel.text = cell.textLabel.text = @"所属门店";
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }
    else if (indexPath.section == 3) {
        
        UIButton *zixun = [[UIButton alloc]init];
        zixun.frame = CGRectMake(20, 10, width - 40, 30);
        [zixun setTitle:@"咨询" forState:UIControlStateNormal];
        [zixun setTitleColor:[UIColor colorWithHexString:@"f4f4f4" alpha:1] forState:UIControlStateNormal];
        zixun.titleLabel.font = [UIFont systemFontOfSize:15];
        zixun.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
        zixun.layer.cornerRadius =5;
        zixun.layer.masksToBounds = YES;
        [zixun addTarget:self action:@selector(liaotian:) forControlEvents:UIControlEventTouchUpInside];

        
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        
        [cell.contentView addSubview:zixun];

    }
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}
-(void)liaotian:(UIButton*)tt
{
    
    JMSGConversation *conversation = [JMSGConversation singleConversationWithUsername:_logname];
    [conversation allMessages:^(id resultObject, NSError *error) {
        NSLog(@"\n\n\n\n\n\n\nsadasd\n\n\n\n%@",resultObject);
    }];
    if (conversation == nil) {
        
        [WarningBox warningBoxModeText:@"获取会话" andView:self.view];
        
        [JMSGConversation createSingleConversationWithUsername:_logname completionHandler:^(id resultObject, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"创建会话返回\n\n%@",resultObject);
            if (error) {
                NSLog(@"创建会话失败%@",error);
                return ;
            }
            
            mememeViewController *conversationVC = [mememeViewController new];
        conversationVC.conversation = (JMSGConversation *)resultObject;
            conversationVC.opo=_pop;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }];
    } else {
        
        mememeViewController *conversationVC = [mememeViewController new];
        conversationVC.conversation = conversation;
        conversationVC.opo=_pop;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        //跳转传值
         YdShopViewController*Shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shop"];
        Shop.mendian = officearr;
        [self.navigationController pushViewController:Shop animated:YES];
    }
}
//左按钮
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
