//
//  YdHomePageViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdHomePageViewController.h"
#import "YdLeftViewController.h"
#import "YdScanViewController.h"
#import "YdSearchViewController.h"
#import "YdbannerViewController.h"
#import "WarningBox.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "YCAdView.h"
@interface YdHomePageViewController ()
{
    CGFloat width;
    CGFloat heigth;
    UITableViewCell *cell ;
    UITextField *SearchText;
    NSMutableArray *arrImage;
    
}
@end

@implementation YdHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrImage = [[NSMutableArray alloc]init];
    
    width = [UIScreen mainScreen].bounds.size.width;
    heigth = [UIScreen mainScreen].bounds.size.height;
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
     //设置导航栏又按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanning)];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self SearchView];

}
//导航标题  添加View
-(void)SearchView
{
    //创建view
    //设置基本属性
    UIView *searchview = [[UIView alloc]init];
  
    searchview.frame = CGRectMake(0, 0, width/2, 40);
    
    searchview.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.titleView = searchview;
    
    //创建button
    //设置基本属性
    UIButton *SearchButton = [[UIButton alloc]init];
    
    SearchButton.frame = CGRectMake(0, 3, width/2-10, 15);
    
    [SearchButton setTitle:@"选择的门店" forState:UIControlStateNormal];
    
    SearchButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [SearchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [SearchButton addTarget:self action:@selector(searchbutton) forControlEvents:UIControlEventTouchUpInside];
    
    [searchview addSubview:SearchButton];
    
    //创建textfield
    //设置基本属性
    SearchText = [[UITextField alloc]init];
    
    SearchText.frame = CGRectMake(5, 20, width/2-10, 20);
    
    SearchText.placeholder = @" 输入药品、病症";
    
    SearchText.delegate=self;
    
    SearchText.font = [UIFont systemFontOfSize:13];
    
    SearchText.layer.borderColor = [[UIColor grayColor] CGColor];
    
    SearchText.layer.borderWidth =1;
    
    SearchText.layer.cornerRadius = 5.0;
    
    [searchview addSubview:SearchText];
    
}
//textfield点击事件
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == SearchText) {
        
        //跳转到搜索界面
        YdSearchViewController *Search = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
        [self.navigationController pushViewController:Search animated:YES];
        
        return NO;
    }
    return NO;
}
//选择地址按钮
-(void)searchbutton
{
    NSLog(@"暂时不需要跳页,但是有此方法");
}
//第一组 轮播
-(void)banner
{
    
    [WarningBox warningBoxModeIndeterminate:@"数据加载中..." andView:self.view];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/newsList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"officeId", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                NSArray *arr = [datadic objectForKey:@"newsList"];
                
                
                for (int i = 0; i < arr.count; i++) {
                    
                    [arrImage addObject:[NSString stringWithFormat:@"%@%@",service_host,[arr[i] objectForKey:@"url"]]];
                    
                }
                
                NSLog(@"%@",arrImage);
                
                YCAdView *ycAdView = [YCAdView initAdViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heigth/4)
                                                            images:arrImage
                                                            titles:nil
                                                  placeholderImage:[UIImage imageNamed:@"IMG_0797.jpg"]];
                ycAdView.clickAdImage = ^(NSInteger index)
                {
                    
                    NSLog(@"点击了第%ld图片",index);
                    
                };
                
                [cell.contentView addSubview:ycAdView];

            }
            
            
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        NSLog(@"错误：%@",error);
        
    }];
}
//第二组  四个按钮
-(void)fourButton
{
    //第一个按钮
    UIButton *one = [[UIButton alloc]init];
    one.frame = CGRectMake(0, 0, width/4, width/4);
    [one setImage:[UIImage imageNamed:@"IMG_0797.jpg"] forState:UIControlStateNormal];
    [one addTarget:self action:@selector(one) forControlEvents:UIControlEventTouchUpInside];
    //第二个按钮
    UIButton *two = [[UIButton alloc]init];
    two.frame = CGRectMake(width/4, 0, width/4, width/4);
    [two setImage:[UIImage imageNamed:@"IMG_0798.jpg"] forState:UIControlStateNormal];
    [two addTarget:self action:@selector(two) forControlEvents:UIControlEventTouchUpInside];
    //第三个按钮
    UIButton *three = [[UIButton alloc]init];
    three.frame = CGRectMake(width/4*2, 0, width/4, width/4);
    [three setImage:[UIImage imageNamed:@"IMG_0799.jpg"] forState:UIControlStateNormal];
    [three addTarget:self action:@selector(three) forControlEvents:UIControlEventTouchUpInside];
    //第四个按钮
    UIButton *four = [[UIButton alloc]init];
    four.frame = CGRectMake(width/4*3, 0, width/4, width/4);
    [four setImage:[UIImage imageNamed:@"IMG_0800.jpg"] forState:UIControlStateNormal];
    [four addTarget:self action:@selector(four) forControlEvents:UIControlEventTouchUpInside];

    //在cell上显示
    [cell.contentView addSubview:one];
    [cell.contentView addSubview:two];
    [cell.contentView addSubview:three];
    [cell.contentView addSubview:four];
    
}
//第一个按钮点击事件
-(void)one
{
    NSLog(@"one");
}
//第二个按钮点击事件
-(void)two
{
    NSLog(@"two");
}
//第三个按钮点击事件
-(void)three
{
    NSLog(@"three");
}
//第四个按钮点击事件
-(void)four
{
    NSLog(@"four");
}

//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
        return 1;
    }
    return 0;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return heigth/4;
    }
    else if (indexPath.section == 1)
    {
        return width/4;
    }
    return 0;
}
//header 高度
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
    return 0;
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    if (indexPath.section == 0) {
        
        [self banner];
        
    }
    
    if (indexPath.section == 1) {
        
        [self fourButton];
        
    }
    
    return cell;
}

//扫描
-(void)scanning{
    //跳转到扫描页面
    YdScanViewController *Scan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scan"];
    [self.navigationController pushViewController:Scan animated:YES];
    
}

@end
