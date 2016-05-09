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
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "YCAdView.h"
#import "UIImageView+WebCache.h"
#import "Color+Hex.h"
#import "YdSurpriseViewController.h"
#import "YdPurchasingViewController.h"
#import "YdQuestionViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface YdHomePageViewController ()<CLLocationManagerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGFloat width;
    CGFloat heigth;
    UITableView*wocalei;
    UITableViewCell *cell;
    UITextField *SearchText;
    NSMutableArray *arrImage;
    NSArray *arr;
    
    NSString*MDID;
    NSInteger rowNo;
    CGFloat gao ;
    CGFloat kuan ;
    
    NSArray *presentarray;
    NSMutableArray *presentarrImage;
    NSMutableArray *proImage;
    
    NSArray *proList;
    NSMutableArray *proListImage;
    
    CLLocationManager*_locationManager;
    
    UIView * pickerview;
    UIPickerView *picke;
    UIButton *SearchButton;
    
    NSString*jing;
    NSString*wei;
    NSString*sheng;
    NSString*shi;
    NSString*qu;
    
    NSArray *stateArray;
    NSArray *cityArray;
    NSArray *areaArray;
    
    NSMutableArray* bianxing;
    NSArray*shengg;
    
    NSDictionary *stateDic;
    NSDictionary *cityDic;
    
    int panduan;
    
    NSArray*wocalede;
    NSArray *arr1;
    NSString *str;
}

@property (strong,nonatomic) UICollectionView *Collectionview;
@property(strong,nonatomic) UIScrollView *scrollView;
@end

@implementation YdHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    panduan=0;
    pickerview=[[UIView alloc] init];
    pickerview.hidden = YES;
    
    arrImage = [[NSMutableArray alloc]init];
    presentarrImage = [[NSMutableArray alloc]init];
    proImage = [[NSMutableArray alloc]init];
    
    width = [UIScreen mainScreen].bounds.size.width;
    heigth = [UIScreen mainScreen].bounds.size.height;
    
    gao = width/4/156*184;
    kuan = width/4;
    
    wocalei=[[UITableView alloc] initWithFrame:CGRectMake((width-200)/2, (heigth-64-50-240)/2, 200, 240)];
    wocalei.delegate=self;
    wocalei.dataSource=self;
    wocalei.hidden=YES;
    [wocalei.layer setBorderWidth:1];
    [wocalei.layer setCornerRadius:30];
    [wocalei.layer setBorderColor:[[UIColor greenColor] CGColor]];
    [self.view addSubview:wocalei];
    //Tab bar 颜色
    self.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
   
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-6@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
     //设置导航栏右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-erweimasaomiaotubiao@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanning)];
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //表头
    [self SearchView];
    
    //调用定位
    [self initializeLocationService];

}
//导航标题  添加View
-(void)SearchView
{
    //创建view
    //设置基本属性
    UIView *searchview = [[UIView alloc]init];
  
    searchview.frame = CGRectMake(0, 0, 150, 40);
    
    searchview.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.titleView = searchview;
    
    //创建button
    //设置基本属性
    SearchButton = [[UIButton alloc]init];
    
    SearchButton.frame = CGRectMake(0, 3, 150, 15);
    
    [SearchButton setTitle:@"选择的门店" forState:UIControlStateNormal];
    
    SearchButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [SearchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [SearchButton addTarget:self action:@selector(searchbutton) forControlEvents:UIControlEventTouchUpInside];
    
    [searchview addSubview:SearchButton];
    
    //创建textfield
    //设置基本属性
    SearchText = [[UITextField alloc]init];
    
    SearchText.frame = CGRectMake(29, 20, 150, 19);
    
    SearchText.text = @"搜索药品、病症";
    
    SearchText.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    SearchText.delegate=self;
    
    SearchText.font = [UIFont systemFontOfSize:13];
    
    UIView *xian = [[UIView alloc]init];
    xian.frame = CGRectMake(0, 39, 150, 1);
    xian.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    
    UIButton *sou = [[UIButton alloc]init];
    sou.frame = CGRectMake(5, 20, 15, 15);
    [sou setImage:[UIImage imageNamed:@"iconfont-search@2x.png"] forState:UIControlStateNormal];
    
    
    [searchview addSubview:xian];
    [searchview addSubview:sou];
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
//选择门店按钮
-(void)searchbutton
{
    //调用定位方法。。。
    [self zidongdingwei];
    //弹出列表
    
    
   
}
#pragma  第一组 轮播

-(void)bannerjiekou
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
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
    
    [manager GET:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                arr = [datadic objectForKey:@"newsList"];
                
                
                for (int i = 0; i < arr.count; i++) {
                    
                    [arrImage addObject:[NSString stringWithFormat:@"%@%@",service_host,[arr[i] objectForKey:@"url"]]];
                    
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
        
    }];
    
    
    
}

#pragma  第二组  四个按钮
-(void)fourButton
{
    //第一个按钮
    UIButton *one = [[UIButton alloc]init];
    one.frame = CGRectMake((width - 55 *4 )/5,10,55,75);
    [one setBackgroundImage:[UIImage imageNamed:@"组-4@3x.png"] forState:UIControlStateNormal];
    [one addTarget:self action:@selector(one) forControlEvents:UIControlEventTouchUpInside];
    //第二个按钮
    UIButton *two = [[UIButton alloc]init];
    two.frame = CGRectMake((width - 55 *4 )/5*2+width/6, 10, 55, 75);
    [two setBackgroundImage:[UIImage imageNamed:@"问药师@3x.png"] forState:UIControlStateNormal];
    [two addTarget:self action:@selector(two) forControlEvents:UIControlEventTouchUpInside];
    //第三个按钮
    UIButton *three = [[UIButton alloc]init];
    three.frame = CGRectMake((width - 55 *4 )/5*3+width/6*2, 10, 55, 75);
    [three setBackgroundImage:[UIImage imageNamed:@"代购药@3x.png"] forState:UIControlStateNormal];
    [three addTarget:self action:@selector(three) forControlEvents:UIControlEventTouchUpInside];
    //第四个按钮
    UIButton *four = [[UIButton alloc]init];
    four.frame = CGRectMake((width - 55 *4 )/5*4+width/6*3, 10, 55, 75);
    [four setBackgroundImage:[UIImage imageNamed:@"送到家@3x.png"] forState:UIControlStateNormal];
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
    YdSurpriseViewController *Surprise = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"superise"];
    [self.navigationController pushViewController:Surprise animated:YES];
    
}
//第二个按钮点击事件
-(void)two
{
    YdQuestionViewController *Question = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"question"];
    [self.navigationController pushViewController:Question animated:YES];
}
//第三个按钮点击事件
-(void)three
{
    YdPurchasingViewController *Purchasing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"purchasing"];
    [self.navigationController pushViewController:Purchasing animated:YES];

}
//第四个按钮点击事件
-(void)four
{
    NSLog(@"four");
}
#pragma  mark ---- 积分礼品接口
//接口
-(void)bargaingoodsjiekou
{
  
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/integralGift/integralGiftList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"6482331337854473800a0239a3bfcb5f",@"officeId",@"1",@"pageNo",@"6",@"pageSize", nil];
    
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
            NSLog(@"－＊－＊－＊－＊－＊－＊积分礼品＊－＊－＊－＊－\n\n\n%@",responseObject);
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                presentarray = [datadic objectForKey:@"integralGiftList"];
                
               
                
                for (int i = 0; i < presentarray.count; i++) {
                    
                    
                    [presentarrImage addObject:[NSString stringWithFormat:@"%@%@",service_host,[presentarray[i] objectForKey:@"url"]]];
                    
                    
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
        NSLog(@"错误：%@",error);
    }];
}
#pragma mark ---- 特价药品接口
-(void)tejieyaopinjiekou{
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"officeId",@"1",@"pageNo",@"6",@"pageSize", nil];
    
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
           
            NSLog(@"－＊－＊－＊－＊－特价药品 -*-*-*--*\n\nn\%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                proList = [datadic objectForKey:@"proList"];
                
                
               
                
                for (int i = 0; i < proList.count; i++) {
                    
                    
                    [proImage addObject:[NSString stringWithFormat:@"%@%@",service_host,[proList[i] objectForKey:@"picUrl"]]];
                    
                    
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
        NSLog(@"错误：%@",error);
    }];

    
}
#pragma mark ---- 病友问答接口
-(void)bingyouwenda{
    
}
#pragma mark ---- 药品分类接口
-(void)yaopinfenlei{
    
}
#pragma  mark ---- tableview
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{if(tableView==wocalei){
    return 1;
}else
    return 6;
}

//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   if(tableView==wocalei){
    return wocalede.count+1;
}else{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return 1;
    }
    else if (section == 3)
    {
        return 1;
    }
    else if (section == 4)
    {
        return 5;
    }
    else if (section == 5)
    {
        return 1;
    }
    return 0;
}
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{if(tableView==wocalei){
    return 40;
}else{
    if (indexPath.section == 0)
    {
        return 150;
    }
    else if (indexPath.section == 1)
    {
        return 95;
    }
    else if (indexPath.section == 2)
    {
        return gao+1+20;
    }
    else if (indexPath.section == 3)
    {
        return gao+1+20;
    }
    else if (indexPath.section == 4)
    {
        return 50;
    }
    else if (indexPath.section == 5)
    {
        return 100;
    }
    return 0;
}
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView==wocalei){
    return 0;
}else{
    if (section == 0)
    {
        return 0;
    }
    else if (section == 1)
    {
        return 0;
    }
    else if (section == 2)
    {
        return 10;
    }
    else if (section == 3)
    {
        return 10;
    }
    else if (section == 4)
    {
        return 30;
    }
    else if (section == 5)
    {
        return 30;
    }
    return 0;
}
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==wocalei) {
        
    }else{
    if (section == 4) {
        
        UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
        baseView.backgroundColor = [UIColor colorWithHexString:@"E2E2E2" alpha:1];
        
        UILabel * tou = [[UILabel alloc]init];
        tou.frame = CGRectMake(8, 5, 100, 20);
        tou.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        tou.font = [UIFont systemFontOfSize:15];
        tou.text = @"病友问答展示";
        
        UIButton *gengduo = [[UIButton alloc]init];
        gengduo.frame = CGRectMake(width-30, 5, 30, 20);
        [gengduo setImage:[UIImage imageNamed:@"Multiple-Email-Thread-拷贝-2@3x.png"] forState:UIControlStateNormal];
        [gengduo addTarget:self action:@selector(interlocutiongengduo) forControlEvents:UIControlEventTouchUpInside];
        
        [baseView addSubview:tou];
        [baseView addSubview:gengduo];
        
        return baseView;
    }
    else if (section == 5)
    {
        UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
        baseView.backgroundColor = [UIColor colorWithHexString:@"E2E2E2" alpha:1];
        
        UILabel * tou = [[UILabel alloc]init];
        tou.frame = CGRectMake(8, 5, 100, 20);
        tou.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        tou.font = [UIFont systemFontOfSize:15];
        tou.text = @"药品分类";
        
        UIButton *gengduo = [[UIButton alloc]init];
        gengduo.frame = CGRectMake(width-30, 5, 30, 20);
        [gengduo setImage:[UIImage imageNamed:@"Multiple-Email-Thread-拷贝-2@3x.png"] forState:UIControlStateNormal];
        [gengduo addTarget:self action:@selector(interlocutiongengduo) forControlEvents:UIControlEventTouchUpInside];
        
        [baseView addSubview:tou];
        [baseView addSubview:gengduo];
        
        return baseView;

    }
    }
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

    
    if (tableView==wocalei) {
        UILabel *name = [[UILabel alloc]init];
        name.frame  =  CGRectMake(0, 0, wocalei.frame.size.width, 39);
        name.font = [UIFont systemFontOfSize:15.0];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = [UIColor blackColor];
        if (indexPath.row==0) {
            name.textColor = [UIColor blueColor];
            name.text=@"请选择门店";
        }else{
            name.text = [[wocalede[indexPath.row-1] objectForKey:@"office"] objectForKey:@"name"];;
        }
        [cell.contentView addSubview:name];
    }else{
    
    //轮播
    if (indexPath.section == 0) {
        
        if (arrImage.count < 1 )
        {
            UIImageView *image = [[UIImageView alloc]init];
            image.frame = CGRectMake(0, 0, width, 150);
            image.image = [UIImage imageNamed:@"IMG_0797.jpg"];
            [cell.contentView addSubview:image];
        }
        else
        {
            YCAdView *ycAdView = [YCAdView initAdViewWithFrame:CGRectMake(0, 0, width, 150)
                                                        images:arrImage
                                                        titles:nil
                                              placeholderImage:[UIImage imageNamed:@"IMG_0797.jpg"]];
            ycAdView.clickAdImage = ^(NSInteger index)
            {
                
                YdbannerViewController *banner = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"banner"];
                //门店id
                //NSString *sst = [NSString stringWithFormat:@"%@",[[arr[index] objectForKey:@"office"] objectForKey:@"id"]];
                [self.navigationController pushViewController:banner animated:YES];
                
                
            };
            
            [cell.contentView addSubview:ycAdView];

        }
        
    }
    //四个按钮
    else if (indexPath.section == 1) {
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        [self fourButton];
        
    }
    //特价药品
    else if (indexPath.section == 2)
    {
        
        UIImageView *biaoti = [[UIImageView alloc] init];
        biaoti.frame = CGRectMake(0, 3, 3, 14);
        biaoti.image = [UIImage imageNamed:@"矩形-20@3x.png"];
        
        UILabel * tou = [[UILabel alloc]init];
        tou.frame = CGRectMake(8, 0, 100, 20);
        tou.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        tou.font = [UIFont systemFontOfSize:15];
        tou.text = @"特价药品展示";
        
        UIButton *gengduo = [[UIButton alloc]init];
        gengduo.frame = CGRectMake(width-30, 0, 30, 20);
        [gengduo setImage:[UIImage imageNamed:@"Multiple-Email-Thread-拷贝-2@3x.png"] forState:UIControlStateNormal];
        [gengduo addTarget:self action:@selector(pharmacygengduo) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *xian = [[UIView alloc]init];
        xian.frame = CGRectMake(0, 20, width, 0.5);
        xian.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        
        
        [cell.contentView addSubview:biaoti];
        [cell.contentView addSubview:tou];
        [cell.contentView addSubview:gengduo];
        [cell.contentView addSubview:xian];
        
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, width, gao)];
        
        for (int i = 0; i < proList.count; i++) {
            
            UIButton *IntegrationSix = [[UIButton alloc]init];
            IntegrationSix.tag = 400+i;
            IntegrationSix.frame = CGRectMake(kuan*i, 0, kuan, gao);
            IntegrationSix.backgroundColor = [UIColor clearColor];
            [IntegrationSix addTarget:self action:@selector(handleClick1:) forControlEvents:UIControlEventTouchUpInside];
            //图片
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.frame = CGRectMake(kuan*0.2, gao*0.1, kuan*0.6, gao*0.45);
            [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,[proList[i] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:@"IMG_0799.jpg"]];
            //名称
            UILabel *name = [[UILabel alloc]init];
            name.frame = CGRectMake(0, gao*0.55, kuan, gao*0.2);
            name.font = [UIFont systemFontOfSize:13];
            name.textAlignment = NSTextAlignmentCenter;
            name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            name.text = [NSString stringWithFormat:@"%@",[proList[i] objectForKey:@"commonName"]];
            //原价
            UILabel *originalcost = [[UILabel alloc]init];
            originalcost.frame = CGRectMake(0, gao*0.75, kuan, gao*0.1);
            originalcost.font = [UIFont systemFontOfSize:11];
            originalcost.textAlignment = NSTextAlignmentCenter;
            originalcost.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            originalcost.text = [NSString stringWithFormat:@"%@",[proList[i] objectForKey:@"prodPrice"]];
            //特价
            UILabel *specialoffer = [[UILabel alloc] init];
            specialoffer.frame = CGRectMake(0, gao*0.85, kuan, gao*0.15);
            specialoffer.font = [UIFont systemFontOfSize:13];
            specialoffer.textAlignment = NSTextAlignmentCenter;
            specialoffer.textColor = [UIColor colorWithHexString:@"FC4753" alpha:1];
            specialoffer.text =  [NSString stringWithFormat:@"¥%@",[proList[i] objectForKey:@"specPrice"]];
            
            self.scrollView.pagingEnabled = YES;
            
            self.scrollView.delegate = self;
            
            
            [self.scrollView addSubview:IntegrationSix];
            [IntegrationSix addSubview:imageview];
            [IntegrationSix addSubview:name];
            [IntegrationSix addSubview:originalcost];
            [IntegrationSix addSubview:specialoffer];

        }
        
        self.scrollView.contentSize = CGSizeMake(kuan*6, gao);
        
        [cell.contentView addSubview:self.scrollView];
        
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    //积分礼品
    else if (indexPath.section == 3)
    {
        
        UIImageView *biaoti = [[UIImageView alloc] init];
        biaoti.frame = CGRectMake(0, 3, 3, 14);
        biaoti.image = [UIImage imageNamed:@"矩形-20-拷贝@3x.png"];
        
        UILabel * tou = [[UILabel alloc]init];
        tou.frame = CGRectMake(8, 0, 100, 20);
        tou.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        tou.font = [UIFont systemFontOfSize:15];
        tou.text = @"积分礼品展示";
        
        UIButton *gengduo = [[UIButton alloc]init];
        gengduo.frame = CGRectMake(width-30, 0, 30, 20);
        [gengduo setImage:[UIImage imageNamed:@"Multiple-Email-Thread-拷贝-2@3x.png"] forState:UIControlStateNormal];
        [gengduo addTarget:self action:@selector(pharmacygengduo) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *xian = [[UIView alloc]init];
        xian.frame = CGRectMake(0, 20, width, 0.5);
        xian.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        
        
        [cell.contentView addSubview:biaoti];
        [cell.contentView addSubview:tou];
        [cell.contentView addSubview:gengduo];
        [cell.contentView addSubview:xian];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, width, gao)];
        
        for (int i = 0; i < presentarray.count; i++) {
            UIButton *IntegrationSix = [[UIButton alloc]init];
            IntegrationSix.tag = 500+i;
            IntegrationSix.frame = CGRectMake(kuan*i, 0, kuan, gao);
            IntegrationSix.backgroundColor = [UIColor clearColor];
            [IntegrationSix addTarget:self action:@selector(handleClick2:) forControlEvents:UIControlEventTouchUpInside];
            //图片
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.frame = CGRectMake(kuan*0.2, gao*0.1, kuan*0.6, gao*0.45);
            NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",presentarrImage[i]]];
            [imageview sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"IMG_0799.jpg"]];
            //名称
            UILabel *name = [[UILabel alloc]init];
            name.frame = CGRectMake(0, gao*0.55, kuan, gao*0.2);
            name.font = [UIFont systemFontOfSize:13];
            name.textAlignment = NSTextAlignmentCenter;
            name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            name.text = [NSString stringWithFormat:@"%@",[presentarray[i] objectForKey:@"name"]];
            //原价
            UILabel *originalcost = [[UILabel alloc]init];
            originalcost.frame = CGRectMake(0, gao*0.75, kuan, gao*0.1);
            originalcost.font = [UIFont systemFontOfSize:11];
            originalcost.textAlignment = NSTextAlignmentCenter;
            originalcost.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            originalcost.text = [NSString stringWithFormat:@"%@",[presentarray[i] objectForKey:@"price"]];;
            //积分
            UILabel *specialoffer = [[UILabel alloc] init];
            specialoffer.frame = CGRectMake(0, gao*0.85, kuan, gao*0.15);
            specialoffer.font = [UIFont systemFontOfSize:13];
            specialoffer.textAlignment = NSTextAlignmentCenter;
            specialoffer.textColor = [UIColor colorWithHexString:@"FC4753" alpha:1];
            specialoffer.text = [NSString stringWithFormat:@"¥%@",[presentarray[i] objectForKey:@"integral"]];

            self.scrollView.pagingEnabled = YES;
            
            self.scrollView.delegate = self;
            
            [self.scrollView addSubview:IntegrationSix];
            [IntegrationSix addSubview:imageview];
            [IntegrationSix addSubview:name];
            [IntegrationSix addSubview:originalcost];
            [IntegrationSix addSubview:specialoffer];
        }
        
        self.scrollView.contentSize = CGSizeMake(kuan*6, gao);

        [cell.contentView addSubview:self.scrollView];
        
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        
    }else if (indexPath.section == 4)
    {
        
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        
        UIImageView *headportrait = [[UIImageView alloc] init];
        headportrait.frame = CGRectMake(10, 5, 40, 40);
        headportrait.image = [UIImage imageNamed:@"IMG_0801.jpg"];
        
        UILabel *name = [[UILabel alloc]init];
        name.frame = CGRectMake(60, 5, 150, 18);
        name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        name.font = [UIFont systemFontOfSize:15];
        name.text = @"小魔仙";
        
        UILabel *neirong = [[UILabel alloc]init];
        neirong.frame = CGRectMake(60, 28, width - 50 , 17);
        neirong.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        neirong.font = [UIFont systemFontOfSize:13];
        neirong.text = @"身上无缘无故会有小伤口 是不是疾病？身上无缘无故会有小伤口 是不是疾病？";

        [cell.contentView addSubview:headportrait];
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:neirong];
        
    }
    else if (indexPath.section == 5)
    {
        
        
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    }
    
    }
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==wocalei) {
        if (indexPath.row!=0) {
            NSString*haha=[NSString stringWithFormat:@"%@",[[wocalede[indexPath.row-1] objectForKey:@"office"] objectForKey:@"name"] ];
            [SearchButton setTitle:haha forState:UIControlStateNormal];
            wocalei.hidden=YES;
            panduan=0;
//            MDID=[wocalei[indexPath.row-1]]
            
            [self tejieyaopinjiekou];
            [self bargaingoodsjiekou];
        }
        
        
    }else
    wocalei.hidden=YES;
}
#pragma  mark ---好多按钮
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    wocalei.hidden=YES;
}
//特价药品展示   药品详情
- (void)handleClick1:(UIButton *)btn{
    
    if (btn.tag == 400)
    {
        
    }
    
    NSLog(@"%ld",btn.tag);
    
}

//更多
-(void)pharmacygengduo
{
    
    NSLog(@"特价药品");
    
}
//积分礼品展示  礼品详情
- (void)handleClick2:(UIButton *)btn{
    
    if (btn.tag == 500)
    {
        
    }
    
    NSLog(@"%ld",btn.tag);
    
}

//更多
-(void)specialoffergengduo
{
    
    
}
//病友问答  更多
-(void)interlocutiongengduo
{
    NSLog(@"病友问答");
    
}
//扫描
-(void)scanning{
    //跳转到扫描页面
    YdScanViewController *Scan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scan"];
    [self.navigationController pushViewController:Scan animated:YES];
    
}

#pragma mark ----- 创建三级联动
-(void)sanji
{
    if (pickerview) {
        [pickerview removeFromSuperview];
        pickerview=nil;
    }
    float w=[[UIScreen mainScreen] bounds].size.width;
    float h=[[UIScreen mainScreen] bounds].size.height;
    
    
    
    pickerview.hidden=NO;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil];
    if (panduan==0) {
        
        stateArray = [NSArray arrayWithContentsOfFile:path];
        cityArray = [stateArray[0] objectForKey:@"cities"];
        areaArray = [cityArray[0] objectForKey:@"areas"];
        
    }
    else {
        stateArray = [NSArray arrayWithArray:bianxing];
        cityArray = [stateArray[0] objectForKey:@"cities"];
        NSArray*qq=[NSArray arrayWithContentsOfFile:path];
        int tiao=0;
        for (int i=0; i<qq.count; i++) {
            if ([[qq[i] objectForKey:@"state"] isEqual:shengg[0]]) {
                for (int y=0; y<[[qq[i] objectForKey:@"cities"] count]; y++) {
                    if ([[[qq[i] objectForKey:@"cities"][y] objectForKey:@"city"]isEqual:cityArray[0]]) {
                        
                        areaArray=  [NSArray arrayWithArray:[[qq[i] objectForKey:@"cities"][y] objectForKey:@"areas"] ];
                        tiao=1;
                        break;
                    }
                }
            }
            if (tiao!=0) {
                break;
            }
        }
    }
    
    pickerview=[[UIView alloc] initWithFrame:CGRectMake(0, h, w, 200)];
    picke=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, w, 230)];
    pickerview.backgroundColor=[UIColor redColor];
    picke.backgroundColor=[UIColor greenColor];
    
    picke.delegate = self;
    picke.dataSource = self;
    
    [pickerview addSubview:picke];
    
    UIToolbar*tool=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, w, 40)];
    UIBarButtonItem*bb1=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(queding)];
    UIBarButtonItem*flex=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem*bb2=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(quxiao)];
    NSArray*arr9=[NSArray arrayWithObjects:bb1,flex,bb2, nil];
    tool.items=arr9;
    [pickerview addSubview:tool];
    
    [self.view addSubview:pickerview];
    [UIView animateWithDuration:0.3 animations:^{pickerview.frame=CGRectMake(0, h-220, w, 200);}];
}
//返回几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//每列有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component ==0)
    {
        return stateArray.count;
    }
    else if (component == 1)
    {
        return cityArray.count;
    }
    else
    {
        return areaArray.count;
    }
}
//每列显示
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *state;
        if(panduan==0){
            state = [stateArray[row] objectForKey:@"state"];
        }else{
            state = [NSString stringWithFormat:@"%@", shengg[row] ];
        }
        return state;
        
    }else if (component == 1){
        
        NSString *city;
        if (panduan==0) {
            city= [cityArray[row] objectForKey:@"city"];
        }else{
            city=[NSString stringWithFormat:@"%@", cityArray[row] ];
        }
        
        return city;
    }else{
        
        return areaArray[row];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if (panduan==0) {
            cityArray = [stateArray[row] objectForKey:@"cities"];
            areaArray = [cityArray[0]    objectForKey:@"areas" ];
        }else{
            cityArray = [bianxing[row] objectForKey:[NSString stringWithFormat:@"%@",[bianxing[row] allKeys][0]]];
            
            
            
            
            NSString *state = shengg[row];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil];
            int xixi=0;
            NSArray*bendi=[NSArray arrayWithContentsOfFile:path];
            for (int i=0; i<bendi.count; i++) {
                if ([[bendi[i] objectForKey:@"state"]isEqual:state]) {
                    for (int y=0; y<[[bendi[i] objectForKey:@"cities"] count]; y++) {
                        if ([[[bendi[i] objectForKey:@"cities"][y] objectForKey:@"city"] isEqual:cityArray[0]]) {
                            areaArray=  [[bendi[i] objectForKey:@"cities"][y] objectForKey:@"areas"];
                            xixi=1;
                            break;
                        }
                    }
                }
                if (xixi==1) {
                    break;
                }
            }
        }
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        if ([areaArray count] > 0) {
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
        
    }else if(component == 1){
        if (panduan==0) {
            areaArray = [cityArray[row] objectForKey:@"areas"];
        }else{
            
            ///////判断是那个 省   那个  市   根据市 取出区
            ///////本地数据与返回数据的接轨
            stateDic = stateArray[[picke selectedRowInComponent:0]];
            
            NSString *state = [stateDic objectForKey:@"state"];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil];
            int xixi=0;
            NSArray*bendi=[NSArray arrayWithContentsOfFile:path];
            for (int i=0; i<bendi.count; i++) {
                if ([[bendi[i] objectForKey:@"state"]isEqual:state]) {
                    for (int y=0; y<[[bendi[i] objectForKey:@"cities"] count]; y++) {
                        if ([[[bendi[i] objectForKey:@"cities"][y] objectForKey:@"city"] isEqual:cityArray[[picke selectedRowInComponent:1]]]) {
                            areaArray=  [[bendi[i] objectForKey:@"cities"][y] objectForKey:@"areas"];
                            xixi=1;
                            break;
                        }
                    }
                }
                if (xixi==1) {
                    break;
                }
            }
        }
        
        [pickerView reloadComponent:2];
        if ([areaArray count] > 0) {
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return width/3;
    }
    else if (component == 1)
    {
        return width/4;
    }
    else if (component == 2)
    {
        return width*5/12;
    }
    
    
    return 0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)queding {
    [pickerview removeFromSuperview];
    
    
    stateDic = stateArray[[picke selectedRowInComponent:0]];
    NSString *state = [stateDic objectForKey:@"state"];
    
    
    cityDic = cityArray[[picke selectedRowInComponent:1]];
    
    NSString *city;
    if (panduan==0) {
        city= [cityDic objectForKey:@"city"];
    }else{
        city= [NSString stringWithFormat:@"%@",cityDic];
    }
    
    
    
    NSString *area;
    if (areaArray.count > 0) {
        
        area = areaArray[[picke selectedRowInComponent:2]];
        
    }else{
        
        area = @"";
        
    }
    
    if (panduan==1) {
        
        [WarningBox warningBoxModeIndeterminate:@"定位门店中..." andView:self.view];
        
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/Store/getLocation";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html",@"text/javascript", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"longitude",@"",@"latitude",state,@"areaProvince", city,@"areaCity",area,@"areaQu",nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @try{
                
                
                
                [WarningBox warningBoxHide:YES andView:self.view];
               
                if([[responseObject objectForKey:@"code"] intValue]==1111){
                    NSDictionary* SSMap=[NSDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"data"] objectForKey:@"SSMap"]];
                    
                    
                    shengg=[SSMap allKeys];
                    bianxing=[[NSMutableArray alloc] init];
                    
                    for (int i=0; i<shengg.count; i++) {
                        
                        NSMutableArray*meme1=[[NSMutableArray alloc] init];
                        NSArray *xixi=[SSMap objectForKey:[NSString stringWithFormat:@"%@",shengg[i]]];
                        NSMutableDictionary*hehe1=[[NSMutableDictionary alloc] init];
                        for (int y=0; y<xixi.count; y++) {
                            [meme1 addObject: [xixi[y] objectForKey:@"name"]];
                        }
                        [hehe1 setObject:meme1 forKey:@"cities"];
                        [hehe1 setObject:shengg[i] forKey:@"state"];
                        [bianxing addObject:hehe1];
                        
                    }
                    [self sanji];
                    
                }
                else if ([[responseObject objectForKey:@"code"] intValue]==0){
                    //5个门店的列表
                    panduan=2;
                    wocalede=[NSArray array];
                    wocalede=[NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"mdList"]];
                    NSLog(@"%@",responseObject);
                    

                    [wocalei reloadData];
                    
                    wocalei.hidden = NO;
                    
                    
                    
                }
            }
            @catch (NSException * e) {
                [WarningBox warningBoxModeText:@"" andView:self.view];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
            NSLog(@"错误：%@",error);
        }];
    }
    
   
    
}
- (void)quxiao {
   
    pickerview.hidden = YES;
}
- (void)initializeLocationService {
    
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    [_locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用。
    [_locationManager startUpdatingLocation];
}
int nicaicai=0;
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //将经度显示到label上
    jing = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    //将纬度现实到label上
    wei = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            sheng=[NSString stringWithFormat:@"%@",[placemark.addressDictionary objectForKey:@"State"]];
            
            
            //获取城市
            NSString *city = placemark.locality;
            
            if (city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
                
                //市
                
                shi=[NSString stringWithFormat:@"%@",placemark.locality];
                //区
                qu=[NSString stringWithFormat:@"%@",placemark.subLocality];
            }
            
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    panduan=0;
    if (nicaicai==0) {
        nicaicai=1;
        [self zidongdingwei];
    }
    
    
}
-(void)zidongdingwei{
    if (panduan==0) {
        [WarningBox warningBoxModeIndeterminate:@"定位门店中..." andView:self.view];
        
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/Store/getLocation";
        
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html",@"text/javascript", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        //出入参数：
        if (jing==nil) {
            jing=@"";
        }
        if (wei==nil) {
            wei=@"";
        }
        if (sheng==nil) {
            sheng=@"";
        }
        if (shi==nil) {
            shi=@"";
        }
        if (qu==nil) {
            qu=@"";
        }
        
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:jing,@"longitude",wei,@"latitude",sheng,@"areaProvince", shi,@"areaCity",qu,@"areaQu",nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        
        //电泳借口需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @try{
                
                
                
                [WarningBox warningBoxHide:YES andView:self.view];
                
                if([[responseObject objectForKey:@"code"] intValue]==1111){
                    panduan=1;
                    NSDictionary* SSMap=[NSDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"data"] objectForKey:@"SSMap"]];
                    
                    
                    shengg=[SSMap allKeys];
                    bianxing=[[NSMutableArray alloc] init];
                    
                    for (int i=0; i<shengg.count; i++) {
                        
                        NSMutableArray*meme1=[[NSMutableArray alloc] init];
                        NSArray *xixi=[SSMap objectForKey:[NSString stringWithFormat:@"%@",shengg[i]]];
                        NSMutableDictionary*hehe1=[[NSMutableDictionary alloc] init];
                        for (int y=0; y<xixi.count; y++) {
                            [meme1 addObject: [xixi[y] objectForKey:@"name"]];
                        }
                        [hehe1 setObject:meme1 forKey:@"cities"];
                        [hehe1 setObject:shengg[i] forKey:@"state"];
                        [bianxing addObject:hehe1];
                        
                    }
                    
                    NSString *path =[NSHomeDirectory() stringByAppendingString:@"/Documents/shengshiqu.plist"];
                    [bianxing writeToFile:path atomically:YES];
                    [self sanji];
                    
                }
                else if ([[responseObject objectForKey:@"code"] intValue]==0){
                    //5个门店的列表
                    panduan=2;
                    wocalede=[NSArray array];
                    wocalede=[NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"mdList"]];
                    
                    [wocalei reloadData];
                    [wocalei reloadData];
                     wocalei.hidden = NO;
                    
                }
            }
            @catch (NSException * e) {
                [WarningBox warningBoxModeText:@"" andView:self.view];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
            NSLog(@"错误：%@",error);
        }];
        
        
        
    }
    else if (panduan==2){
        wocalei.hidden=NO;
        
    }else{
        [self sanji];
    }

}

@end
