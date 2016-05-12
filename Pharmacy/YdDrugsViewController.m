//
//  YdDrugsViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdDrugsViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "YdShoppingCartViewController.h"
#import "YdshoppingxiangshiViewController.h"
@interface YdDrugsViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSArray *arr;
    NSDictionary *xianshiarr;
    
}

@end

@implementation YdDrugsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr = @[@"药 品 名 称 :",@"拼   音   码 :",@"通 用 名 称 :",@"药 品 简 介 :",@"药 品 类 别 :",@"药 品 规 格 :",@"生 产 企 业 :",@"商 品 编 号 :",@"上 架 标 识 :",@"说   明   书 :",@"包          装 :",@"批 准 文 号 :",@"是否为处方:"];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //状态栏名称
    self.navigationItem.title = @"药品详情";
    //self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height  - 104);
    self.tableview.backgroundColor= [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    [self jiekou];
    [self xialan];
}
//调用接口
-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/product/productDetailList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_yaopinID,@"id", nil];
    
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
            NSLog(@"responseObject%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                xianshiarr = [datadic objectForKey:@"product"];
                
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
-(void)xialan
{
    
}

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
    else if (section == 2)
    {
        return arr.count;
    }
    else if (section == 1)
    {
        if ([[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"specProdFlag"] isEqual:@"1"])
        {
            return 2;
        }
        else{
            return 1;
        }
    }
    return 0;
}

//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 150;
    }
    else if (indexPath.section == 1){
        return 25;
    }
    else if (indexPath.section == 2){
        return 25;
    }
    return 0;
}

//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 30;
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    
    UILabel *tishi = [[UILabel alloc]init];
    tishi.frame = CGRectMake(5, 5, 100 , 20);
    tishi.font = [UIFont systemFontOfSize:15];
    tishi.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    
    [view addSubview:tishi];
    
    if (section == 1) {
        if ([[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"specProdFlag"] isEqual:@"1"])
        {
            tishi.text = @"特价药品";
        }
        else
        {
            tishi.text = @"非特价药品";
        }
        
    }
    else if (section == 2){
        
        tishi.text = @"药品信息";
        
    }
    
    return view;
}

//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    if (indexPath.section == 0) {
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(0, 0, width, 150);
        NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[xianshiarr objectForKey:@"picUrl"]];
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
        
        [cell.contentView addSubview:image];
        self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    
    UILabel *shuju = [[UILabel alloc]init];
    shuju.frame = CGRectMake(100, 2, width - 110 , 20);
    shuju.font = [UIFont systemFontOfSize:13];
    shuju.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    if (indexPath.section == 1){
        
        if ([[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"specProdFlag"] isEqual:@"1"]) {
            
             if (indexPath.row == 0) {
                cell.textLabel.text = @"特          价 :";
                shuju.textColor = [UIColor redColor];
                 if ([[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"specPrice"]isEqual:[NSNull null]]) {
                     shuju.text=@"";
                 }else
                shuju.text = [NSString stringWithFormat:@"%@",[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"specPrice"]];
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = @"原          价 :";
                if ([[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"prodPrice"]isEqual:[NSNull null]]) {
                    shuju.text=@"";
                }else
                shuju.text = [NSString stringWithFormat:@"%@",[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"prodPrice"]];
            }
        }
        else
        {
             if (indexPath.row == 0) {
                cell.textLabel.text = @"价          格 :";
                 if ([[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"prodPrice"]isEqual:[NSNull null]]) {
                     shuju.text=@"";
                 }else
                shuju.text = [NSString stringWithFormat:@"%@",[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"prodPrice"]];
            }

        }
    }
    if (indexPath.section == 2){
        
        cell.textLabel.text = arr[indexPath.row];
        
        if (indexPath.row == 0) {
            if ([[xianshiarr objectForKey:@"name"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"name"]];
        }
        else if (indexPath.row == 1) {
            if ([[xianshiarr objectForKey:@"pinyinCode"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"pinyinCode"]];
        }
        else if (indexPath.row == 2) {
            if ([[xianshiarr objectForKey:@"commonName"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"commonName"]];
        }
        else if (indexPath.row == 3) {
            if ([[xianshiarr objectForKey:@"summary"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"summary"]];
        }
        else if (indexPath.row == 4) {
            if ([[xianshiarr objectForKey:@"level3Name"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"level3Name"]];
        }
        else if (indexPath.row == 5) {
            if ([[xianshiarr objectForKey:@"specification"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"specification"]];
        }
        else if (indexPath.row == 6) {
            if ([[xianshiarr objectForKey:@"manufacturer"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"manufacturer"]];
        }
        else if (indexPath.row == 7) {
            if ([[xianshiarr objectForKey:@"prodCode"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"prodCode"]];
        }
        else if (indexPath.row == 8) {
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@""]];
        }
        else if (indexPath.row == 9) {
            if ([xianshiarr objectForKey:@"instructions"]==nil||[[xianshiarr objectForKey:@"instructions"]isKindOfClass:[NSNull class]]) {
                shuju.text=@"hahah";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"instructions"]];
        }
        else if (indexPath.row == 10) {
            if ([[xianshiarr objectForKey:@"package"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"package"]];
        }
        else if (indexPath.row == 11) {
            if ([[xianshiarr objectForKey:@"approvalNumber"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"approvalNumber"]];
        }
        else if (indexPath.row == 12) {
            if ([[xianshiarr objectForKey:@"prescription"]isEqual:[NSNull null]]) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"prescription"]];
        }

    }
    
    [cell.contentView addSubview:shuju];
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}

//联系店长
- (IBAction)lianxidianzhang:(id)sender {
}
//减号
- (IBAction)jian:(id)sender {
}
//加号
- (IBAction)jia:(id)sender {
}
//加入购物车
- (IBAction)jiaru:(id)sender {
}

//导航左按钮
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
