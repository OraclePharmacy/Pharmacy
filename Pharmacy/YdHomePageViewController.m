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
#import "YdTieZiXiangQingViewController.h"
#import "YdTextDetailsViewController.h"
#import "YdDrugsViewController.h"
#import "YdJiaoLiuViewController.h"
#import "YDTejialiebiaoViewController.h"
#import "YDJifenViewController.h"
#import "YDJifenxiangViewController.h"
#import "YdyouhuiquanViewController.h"
#import "YdmendianxinxiViewController.h"
#import "huoqumendianyouhuijuan.h"
#import "YdNewsViewController.h"
#import "MJRefresh.h"
#import "denglu.h"
#import "tiaodaodenglu.h"
#import <JMessage/JMessage.h>
#import "GuideViewController.h"
#import "YdDrugJumpViewController.h"

@interface YdHomePageViewController ()<CLLocationManagerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGFloat width;
    CGFloat heigth;
    UITableView*wocalei;
    UITableViewCell *cell;
    UITextField *SearchText;
    NSMutableArray *arrImage;
    NSMutableArray *titarr;
    NSArray *arr;
    
    NSString*MDID;
    NSInteger rowNo;
    CGFloat gao ;
    CGFloat kuan ;
    
    NSArray *presentarray;
    NSMutableArray *presentarrImage;
    
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
    
    NSArray *rementieziarray;
    NSMutableArray *remenzixunarray;
    
    int q ;
    int p ;
    UIButton *bingzheng;
    
    NSArray *bingzhengarr;
    
    UILabel *label;
    int coun;
    int ye;
}

@property (strong,nonatomic) UICollectionView *Collectionview;
@property(strong,nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdHomePageViewController

-(void)viewWillAppear:(BOOL)animated{
    NSString *cunzai=[NSString stringWithFormat:@"%@/Documents/cun.plist",NSHomeDirectory()];
    NSFileManager *fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:cunzai])
    {
        if ([SearchButton.titleLabel.text isEqual:@"请选择门店"]) {
            if(nicaicai==1)
                [self zidongdingwei];
        }
        self.navigationController.navigationBarHidden=NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *cunzai=[NSString stringWithFormat:@"%@/Documents/cun.plist",NSHomeDirectory()];
    
    NSFileManager *fm=[NSFileManager defaultManager];
    
    bingzhengarr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    
    //    启动
    if (![fm fileExistsAtPath:cunzai])
    {
        [@"sada" writeToFile:cunzai atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [GuideViewController sharedGuide];
        [GuideViewController show];
    }
    self.tableview.tableFooterView = [[UIView alloc] init];
    remenzixunarray = [[NSMutableArray alloc]init];
    
    panduan=0;
    pickerview=[[UIView alloc] init];
    pickerview.hidden = YES;
    
    arrImage = [[NSMutableArray alloc]init];
    presentarrImage = [[NSMutableArray alloc]init];
    
    
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"read(1).png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanning)];
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewdata)];
    self.tableview.mj_header = header;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    //表头
    [self SearchView];
    //调用定位
    [self initializeLocationService];
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLogin"];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
        
    }else{
        NSString*Rempath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/RememberPass.plist"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        if ([fm fileExistsAtPath:Rempath]){
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"zddl"] isEqualToString:@"0"] ) {
                
            }else{
                [denglu zidongdenglu:self.view];
            }
        }
        
    }
}
-(void)loadNewdata{
    
    [self bargaingoodsjiekou];
    [self tejieyaopinjiekou];
    [self rementiezi];
    [self remenzixun];
    [self bannerjiekou];
    
    [self.tableview.mj_header endRefreshing];
    
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
    
    [SearchButton setTitle:@"请选择门店" forState:UIControlStateNormal];
    
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
    NSString*zhid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    zhid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:zhid,@"officeId", nil];
    
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
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                titarr=[[NSMutableArray alloc] init];
                arrImage=[[NSMutableArray alloc] init];
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                arr = [datadic objectForKey:@"newsList"];
                
                
                
                for (int i = 0; i < arr.count; i++) {
                    
                    [arrImage addObject:[NSString stringWithFormat:@"%@%@",service_host,[arr[i] objectForKey:@"url"]]];
                    [titarr addObject:[arr[i] objectForKey:@"title"]];
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
    UIButton *one = [[UIButton alloc]init];
    one.frame = CGRectMake(0, 0, width / 4, 95 );
    [one setTitleColor:[UIColor colorWithHexString:@"646464" alpha:1 ] forState:UIControlStateNormal];
    [one setTitle:@"有惊喜" forState:UIControlStateNormal];
    one.titleLabel.font = [UIFont systemFontOfSize:13];
    [one setImage:[UIImage imageNamed:@"youjingxi.png"] forState:UIControlStateNormal];
    [one addTarget:self action:@selector(one) forControlEvents:UIControlEventTouchUpInside];
    
    //第二个按钮
    UIButton *two = [[UIButton alloc]init];
    two.frame = CGRectMake(width/4, 0, width / 4, 95 );
    [two setTitleColor:[UIColor colorWithHexString:@"646464" alpha:1 ] forState:UIControlStateNormal];
    [two setTitle:@"问药师" forState:UIControlStateNormal];
    two.titleLabel.font = [UIFont systemFontOfSize:13];
    [two setImage:[UIImage imageNamed:@"wenyaoshi.png"] forState:UIControlStateNormal];
    [two addTarget:self action:@selector(two) forControlEvents:UIControlEventTouchUpInside];
    //第三个按钮
    UIButton *three = [[UIButton alloc]init];
    three.frame = CGRectMake(width/4*2, 0, width / 4, 95 );
    [three setTitleColor:[UIColor colorWithHexString:@"646464" alpha:1 ] forState:UIControlStateNormal];
    [three setTitle:@"代购药" forState:UIControlStateNormal];
    three.titleLabel.font = [UIFont systemFontOfSize:13];
    [three setImage:[UIImage imageNamed:@"daigouyao.png"] forState:UIControlStateNormal];
    [three addTarget:self action:@selector(three) forControlEvents:UIControlEventTouchUpInside];
    //第四个按钮
    UIButton *four = [[UIButton alloc]init];
    four.frame = CGRectMake(width/4*3, 0, width / 4, 95 );
    [four setTitleColor:[UIColor colorWithHexString:@"646464" alpha:1 ] forState:UIControlStateNormal];
    [four setTitle:@"优惠券" forState:UIControlStateNormal];
    four.titleLabel.font = [UIFont systemFontOfSize:13];
    [four setImage:[UIImage imageNamed:@"youhuijuan.png"] forState:UIControlStateNormal];
    [four addTarget:self action:@selector(four) forControlEvents:UIControlEventTouchUpInside];
    if (width == 414)
    {
        [one setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-60,0)];
        [one setImageEdgeInsets:UIEdgeInsetsMake(10, 25, 30, 25)];
        [two setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-60,0)];
        [two setImageEdgeInsets:UIEdgeInsetsMake(10, 25, 30, 25)];
        [three setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-60,0)];
        [three setImageEdgeInsets:UIEdgeInsetsMake(10, 25, 30, 25)];
        [four setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-60,0)];
        [four setImageEdgeInsets:UIEdgeInsetsMake(10, 25, 30, 25)];
    }
    else if (width == 375)
    {
        [one setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-70,0)];
        [one setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 25, 15)];
        [two setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-70,0)];
        [two setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 25, 15)];
        [three setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-70,0)];
        [three setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 25, 15)];
        [four setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-70,0)];
        [four setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 25, 15)];
    }
    else if (self.view.bounds.size.width == 320)
    {
        [one setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-75,0)];
        [one setImageEdgeInsets:UIEdgeInsetsMake(15, 10, 20, 10)];
        [two setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-75,0)];
        [two setImageEdgeInsets:UIEdgeInsetsMake(15, 10, 20, 10)];
        [three setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-75,0)];
        [three setImageEdgeInsets:UIEdgeInsetsMake(15, 10, 20, 10)];
        [four setTitleEdgeInsets:UIEdgeInsetsMake(0,-70,-75,0)];
        [four setImageEdgeInsets:UIEdgeInsetsMake(15, 10, 20, 10)];
    }
    
    [cell.contentView addSubview:one];
    [cell.contentView addSubview:two];
    [cell.contentView addSubview:three];
    [cell.contentView addSubview:four];
    
}
//第一个按钮点击事件
-(void)one
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"baocun.plist"];
    //判断是否已经创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
        int yongjingxi;
        //读文件
        NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
        
        yongjingxi = [[dic objectForKey:@"yongjingxi"] intValue];
        
        yongjingxi++;
        NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/[NSString stringWithFormat:@"%d",yongjingxi],@"yongjingxi",/*2*/[dic objectForKey:@"wenyaoshi"],@"wenyaoshi",/*3*/[dic objectForKey:@"daigouyao"],@"daigouyao",/*4*/[dic objectForKey:@"youhuiquan"],@"youhuiquan",/*5*/[dic objectForKey:@"bingyoujiaoliu"],@"bingyoujiaoliu",/*6*/[dic objectForKey:@"zizhen"],@"zizhen",/*7*/[dic objectForKey:@"yongyaotixing"],@"yongyaotixing",/*8*/[dic objectForKey:@"xueyaxuetang"],@"xueyaxuetang",/*9*/[dic objectForKey:@"dianzibingli"],@"dianzibingli",/*10*/[dic objectForKey:@"zhihuiyaoxiang"],@"zhihuiyaoxiang",nil];
        
        [dic1 writeToFile:filename atomically:YES];
        
    }else {
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"1",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
        
        [dic writeToFile:filename atomically:YES];
        
    }
    
    YdSurpriseViewController *Surprise = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"superise"];
    [self.navigationController pushViewController:Surprise animated:YES];
    
}
//第二个按钮点击事件
-(void)two
{
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
        [tiaodaodenglu jumpToLogin:self.navigationController];
    }else{
        [WarningBox warningBoxModeIndeterminate:@"登录聊天" andView:self.view];
        YdQuestionViewController *Question = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"question"];
        
        [JMSGUser loginWithUsername:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shoujihao"]] password:@"111111" completionHandler:^(id resultObject, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
            if (error) {
                [WarningBox warningBoxHide:YES andView:self.view];
               
                [WarningBox warningBoxModeText:@"网络出错，请重试" andView:self.view];
                return ;
            }
            
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path=[paths objectAtIndex:0];
            NSString *filename=[path stringByAppendingPathComponent:@"baocun.plist"];
            //判断是否已经创建文件
            if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                
                int wentaoshi;
                //读文件
                NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
                
                wentaoshi = [[dic objectForKey:@"wenyaoshi"] intValue];
                
                wentaoshi++;
                
                NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/[dic objectForKey:@"yongjingxi"],@"yongjingxi",/*2*/[NSString stringWithFormat:@"%d",wentaoshi],@"wenyaoshi",/*3*/[dic objectForKey:@"daigouyao"],@"daigouyao",/*4*/[dic objectForKey:@"youhuiquan"],@"youhuiquan",/*5*/[dic objectForKey:@"bingyoujiaoliu"],@"bingyoujiaoliu",/*6*/[dic objectForKey:@"zizhen"],@"zizhen",/*7*/[dic objectForKey:@"yongyaotixing"],@"yongyaotixing",/*8*/[dic objectForKey:@"xueyaxuetang"],@"xueyaxuetang",/*9*/[dic objectForKey:@"dianzibingli"],@"dianzibingli",/*10*/[dic objectForKey:@"zhihuiyaoxiang"],@"zhihuiyaoxiang",nil];
                
                [dic1 writeToFile:filename atomically:YES];
                
            }else {
                
                NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"1",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
                
                [dic writeToFile:filename atomically:YES];
                
            }
            
            [WarningBox warningBoxHide:YES andView:self.view];
            [self.navigationController pushViewController:Question animated:YES];
        }];
        
    }
}
//第三个按钮点击事件
-(void)three
{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
        [tiaodaodenglu jumpToLogin:self.navigationController];
    }else{
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"baocun.plist"];
        //判断是否已经创建文件
        if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
            
            int daigouyao;
            //读文件
            NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
            
            daigouyao = [[dic objectForKey:@"daigouyao"] intValue];
            
            daigouyao++;
            
            NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/[dic objectForKey:@"yongjingxi"],@"yongjingxi",/*2*/[dic objectForKey:@"wenyaoshi"],@"wenyaoshi",/*3*/[NSString stringWithFormat:@"%d",daigouyao],@"daigouyao",/*4*/[dic objectForKey:@"youhuiquan"],@"youhuiquan",/*5*/[dic objectForKey:@"bingyoujiaoliu"],@"bingyoujiaoliu",/*6*/[dic objectForKey:@"zizhen"],@"zizhen",/*7*/[dic objectForKey:@"yongyaotixing"],@"yongyaotixing",/*8*/[dic objectForKey:@"xueyaxuetang"],@"xueyaxuetang",/*9*/[dic objectForKey:@"dianzibingli"],@"dianzibingli",/*10*/[dic objectForKey:@"zhihuiyaoxiang"],@"zhihuiyaoxiang",nil];
            
            [dic1 writeToFile:filename atomically:YES];
            
        }else {
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"1",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
            
            [dic writeToFile:filename atomically:YES];
            
        }
        
        YdPurchasingViewController *Purchasing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"purchasing"];
        [self.navigationController pushViewController:Purchasing animated:YES];
    }
}
//第四个按钮点击事件
-(void)four
{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
        [tiaodaodenglu jumpToLogin:self.navigationController];
    }else{
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"baocun.plist"];
        //判断是否已经创建文件
        if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
            
            int youhuiquan;
            //读文件
            NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
            
            youhuiquan = [[dic objectForKey:@"youhuiquan"] intValue];
            
            youhuiquan++;
            
            NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/[dic objectForKey:@"yongjingxi"],@"yongjingxi",/*2*/[dic objectForKey:@"wenyaoshi"],@"wenyaoshi",/*3*/[dic objectForKey:@"daigouyao"],@"daigouyao",/*4*/[NSString stringWithFormat:@"%d",youhuiquan],@"youhuiquan",/*5*/[dic objectForKey:@"bingyoujiaoliu"],@"bingyoujiaoliu",/*6*/[dic objectForKey:@"zizhen"],@"zizhen",/*7*/[dic objectForKey:@"yongyaotixing"],@"yongyaotixing",/*8*/[dic objectForKey:@"xueyaxuetang"],@"xueyaxuetang",/*9*/[dic objectForKey:@"dianzibingli"],@"dianzibingli",/*10*/[dic objectForKey:@"zhihuiyaoxiang"],@"zhihuiyaoxiang",nil];
            
            [dic1 writeToFile:filename atomically:YES];
            
        }else {
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"1",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
            
            [dic writeToFile:filename atomically:YES];
            
        }
        
        huoqumendianyouhuijuan *huoqumendianyouhuijuan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mendianyouhuijuan"];
        
        [self.navigationController pushViewController:huoqumendianyouhuijuan animated:YES];
    }
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
    NSString*zhid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    zhid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:zhid,@"officeId",@"1",@"pageNo",@"6",@"pageSize", nil];
    
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
    NSString*zhid;
    NSUserDefaults*uiwe=  [NSUserDefaults standardUserDefaults];
    zhid=[NSString stringWithFormat:@"%@",[uiwe objectForKey:@"officeid"]];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:zhid,@"officeId",@"1",@"pageNo",@"6",@"pageSize", nil];
    
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
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                proList = [datadic objectForKey:@"proList"];
                
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
#pragma mark ---- 热门帖子接口
-(void)rementiezi{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/share/vipTopicListHot";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"id", nil];
    
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
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                rementieziarray = [datadic objectForKey:@"vipTopicListHot"];
                
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
#pragma mark ---- 热门资讯接口
-(void)remenzixun{
    
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/integralGift/newsListForInterface";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"pageNo",@"10",@"pageSize",@"1002",@"id", nil];
    
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
            
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                remenzixunarray=[datadic objectForKey:@"newsListForInterface"];
                
                [_tableview reloadData];
                
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
#pragma mark ---- 药品分类接口
-(void)yaopinfenlei
{
    
}
#pragma  mark ---- tableview
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{if(tableView==wocalei){
    return 1;
}else
    return 7;
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
    {if (proList.count==0) {
        return 0;
    }else
        return 1;
    }
    else if (section == 3)
    {if (presentarray.count==0) {
        return 0;
    }else
        return 1;
    }
    else if (section == 4)
    {
        if (rementieziarray.count==0) {
            return 0;
        }else if(rementieziarray.count>4){
            return 4;
        }else
            return rementieziarray.count;
    }
    else if (section == 5)
    {
        if(remenzixunarray.count<5){
            return remenzixunarray.count;
        }else
            return 4;
    }
    else if (section == 6)
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
        return 111;
    }
    else if (indexPath.section == 5)
    {
        return 160;
    }
    else if (indexPath.section == 6)
    {
        return 80;
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
            return 0;
        }
        else if (section == 3)
        {
            return 0;
        }
        else if (section == 4)
        {
            if (rementieziarray.count==0) {
                return 0;
            }else
                return 30;
        }
        else if (section == 5)
        {if (remenzixunarray.count==0) {
            return 0;
        }else
            return 30;
        }
        else if (section == 6)
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
            if(rementieziarray.count==0){
                
            }else{
                
                UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
                baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
                
                UILabel * tou = [[UILabel alloc]init];
                tou.frame = CGRectMake(8, 5, 100, 20);
                tou.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
                tou.font = [UIFont systemFontOfSize:15];
                tou.text = @"热门帖子";
                
                [baseView addSubview:tou];
                
                
                return baseView;
            }
        }
        else if (section == 5)
        {
            if (remenzixunarray.count==0) {
                
            }else{
                UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
                baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
                
                UILabel * tou = [[UILabel alloc]init];
                tou.frame = CGRectMake(8, 5, 100, 20);
                tou.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
                tou.font = [UIFont systemFontOfSize:15];
                tou.text = @"热门资讯";
                
                [baseView addSubview:tou];
                
                return baseView;
            }
        }
        else if (section == 6)
        {
            UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
            baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
            
            UILabel * tou = [[UILabel alloc]init];
            tou.frame = CGRectMake(8, 5, 100, 20);
            tou.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            tou.font = [UIFont systemFontOfSize:15];
            tou.text = @"药品分类";
            
            [baseView addSubview:tou];
            
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
                image.image = [UIImage imageNamed:@"daiti.png"];
                [cell.contentView addSubview:image];
            }
            else
            {
                YCAdView *ycAdView = [YCAdView initAdViewWithFrame:CGRectMake(0, 0, width, 150)
                                                            images:arrImage
                                                            titles:titarr
                                                  placeholderImage:[UIImage imageNamed:@"daiti.png"]];
                ycAdView.clickAdImage = ^(NSInteger index)
                {
                    if (index == 0) {
                        YdmendianxinxiViewController *mendianxinxi = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mendianxinxi"];
                        [self.navigationController pushViewController:mendianxinxi animated:YES];
                    }
                    else
                    {
                        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]);
                        if (![[[NSUserDefaults standardUserDefaults]
                               objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
                            [tiaodaodenglu jumpToLogin:self.navigationController];
                        }else{
                            YdbannerViewController *banner = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"banner"];
                            //门店id
                            NSString *sst = [NSString stringWithFormat:@"%@",[arr[index] objectForKey:@"id"]];
                            banner.xixi = sst;
                            [self.navigationController pushViewController:banner animated:YES];
                        }
                    }
                    
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
                [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,[proList[i] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:@"daiti.png"]];
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
                originalcost.text = [NSString stringWithFormat:@"¥%.2f",[[proList[i] objectForKey:@"prodPrice"]floatValue]];
                //特价
                UILabel *specialoffer = [[UILabel alloc] init];
                specialoffer.frame = CGRectMake(0, gao*0.85, kuan, gao*0.15);
                specialoffer.font = [UIFont systemFontOfSize:13];
                specialoffer.textAlignment = NSTextAlignmentCenter;
                specialoffer.textColor = [UIColor colorWithHexString:@"FC4753" alpha:1];
                specialoffer.text =  [NSString stringWithFormat:@"¥%.2f",[[proList[i] objectForKey:@"specPrice"] floatValue]];
                
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
            [gengduo addTarget:self action:@selector(specialoffergengduo) forControlEvents:UIControlEventTouchUpInside];
            
            
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
                [imageview sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"daiti.png"]];
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
                originalcost.text = [NSString stringWithFormat:@"¥%@",[presentarray[i] objectForKey:@"price"]];;
                //积分
                UILabel *specialoffer = [[UILabel alloc] init];
                specialoffer.frame = CGRectMake(0, gao*0.85, kuan, gao*0.15);
                specialoffer.font = [UIFont systemFontOfSize:13];
                specialoffer.textAlignment = NSTextAlignmentCenter;
                specialoffer.textColor = [UIColor colorWithHexString:@"FC4753" alpha:1];
                specialoffer.text = [NSString stringWithFormat:@"%@积分",[presentarray[i] objectForKey:@"integral"]];
                
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
            
            UIImageView *touxiang = [[UIImageView alloc]init];
            touxiang.frame = CGRectMake(5, 5, 80, 80);
            touxiang.layer.cornerRadius = 40;
            touxiang.layer.masksToBounds = YES;
            NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[rementieziarray[indexPath.row] objectForKey:@"photo"]];
            [touxiang sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"小人@2x.png" ]];
            
            UILabel *name = [[UILabel alloc]init];
            name.frame = CGRectMake(5, 90, 80, 20);
            name.font = [UIFont systemFontOfSize:15];
            name.text = [NSString stringWithFormat:@"%@",[[rementieziarray[indexPath.row] objectForKey:@"vipinfo"] objectForKey:@"nickName"]];
            name.textAlignment = NSTextAlignmentCenter;
            name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            
            
            UILabel *biaoti = [[UILabel alloc]init];
            biaoti.frame = CGRectMake(90, 5, width - 95, 20);
            biaoti.font = [UIFont systemFontOfSize:15];
            biaoti.text = [NSString stringWithFormat:@"%@",[rementieziarray[indexPath.row] objectForKey:@"title"]];
            biaoti.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            
            
            UILabel *fubiaoti = [[UILabel alloc]init];
            fubiaoti.frame = CGRectMake(90, 25, width - 95, 40);
            fubiaoti.font = [UIFont systemFontOfSize:13];
            fubiaoti.text = [NSString stringWithFormat:@"%@",[rementieziarray[indexPath.row] objectForKey:@"context"]];
            fubiaoti.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            fubiaoti.numberOfLines = 2;
            
            UILabel *biaoqian = [[UILabel alloc]init];
            biaoqian.frame = CGRectMake(90, 65, 80, 20);
            biaoqian.font = [UIFont systemFontOfSize:13];
            biaoqian.text = [NSString stringWithFormat:@"%@",[rementieziarray[indexPath.row] objectForKey:@"diseaseName"]];
            biaoqian.textAlignment = NSTextAlignmentCenter;
            biaoqian.backgroundColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
            biaoqian.textColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
            
            UILabel *shijian = [[UILabel alloc]init];
            shijian.frame = CGRectMake(180, 65, width - 185, 20);
            shijian.font = [UIFont systemFontOfSize:13];
            shijian.text = [NSString stringWithFormat:@"%@",[rementieziarray[indexPath.row] objectForKey:@"createTime"]];
            shijian.textAlignment = NSTextAlignmentRight;
            shijian.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            
            UILabel *yuedu = [[UILabel alloc]init];
            yuedu.frame = CGRectMake(width - 215, 90, 100, 20);
            yuedu.font = [UIFont systemFontOfSize:13];
            yuedu.text = [NSString stringWithFormat:@"阅读量:%@",[rementieziarray[indexPath.row] objectForKey:@"viewNums"]];
            yuedu.textAlignment = NSTextAlignmentRight;
            yuedu.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            
            UILabel *dianzan = [[UILabel alloc]init];
            dianzan.frame = CGRectMake(width - 110, 90, 100, 20);
            dianzan.font = [UIFont systemFontOfSize:13];
            dianzan.text = [NSString stringWithFormat:@"点赞量:%@",[rementieziarray[indexPath.row] objectForKey:@"likeNums"]];
            dianzan.textAlignment = NSTextAlignmentRight;
            dianzan.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            
            UIImageView *remen  = [[UIImageView alloc]init];
            remen.frame = CGRectMake(width - 50 ,0, 50, 50);
            if ([[rementieziarray[indexPath.row] objectForKey:@"isTop"] isEqualToString:@"1" ]) {
                
                remen.image = [UIImage imageNamed:@"hot.png"];
                
            }
            else
            {
                
            }
            
            [cell.contentView addSubview:remen];
            [cell.contentView addSubview:touxiang];
            [cell.contentView addSubview:name];
            [cell.contentView addSubview:biaoti];
            [cell.contentView addSubview:fubiaoti];
            [cell.contentView addSubview:biaoqian];
            [cell.contentView addSubview:shijian];
            [cell.contentView addSubview:yuedu];
            [cell.contentView addSubview:dianzan];
            
        }
        else if (indexPath.section == 5)
        {
            NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[remenzixunarray[indexPath.row] objectForKey:@"picUrl"]] ;
            UIImageView *image = [[UIImageView alloc]init];
            image.frame = CGRectMake(10, 10, 100 , 100);
            [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
            
            UILabel *title = [[UILabel alloc]init];
            title.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 10, width - CGRectGetMaxY(image.frame) - 20, 30);
            title.font = [UIFont systemFontOfSize:15];
            title.text =[NSString stringWithFormat:@"%@",[remenzixunarray[indexPath.row] objectForKey:@"title"] ];
            title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            
            UILabel *content = [[UILabel alloc]init];
            content.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 60, width - CGRectGetMaxY(image.frame) - 20, 40);
            content.font = [UIFont systemFontOfSize:12];
            content.text = [NSString stringWithFormat:@"%@",[remenzixunarray[indexPath.row] objectForKey:@"subtitle"] ];
            content.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            content.numberOfLines = 2;
            
            UILabel *time = [[UILabel alloc]init];
            time.frame = CGRectMake(width - 150, 100, 145, 20);
            time.font = [UIFont systemFontOfSize:13];
            time.text = [NSString stringWithFormat:@"%@",[remenzixunarray[indexPath.row] objectForKey:@"createTime"]];
            time.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            time.textAlignment = NSTextAlignmentRight;
            time.numberOfLines = 2;
            
            UIView *xian = [[UIView alloc] init];
            xian.frame = CGRectMake(0, 120, width, 1);
            xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
            
            UILabel *laiyuan = [[UILabel alloc]init];
            laiyuan.frame = CGRectMake(10,130, 100, 20);
            laiyuan.font = [UIFont systemFontOfSize:15];
            laiyuan.text = [NSString stringWithFormat:@"%@",[remenzixunarray[indexPath.row] objectForKey:@"source"]];
            laiyuan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            
            UILabel *fenxianglabel = [[UILabel alloc]init];
            fenxianglabel.frame = CGRectMake(width - 110, 125, 100, 30);
            fenxianglabel.text =[NSString stringWithFormat:@"点赞量: %@",[remenzixunarray[indexPath.row] objectForKey:@"clickLikeCount"]];
            fenxianglabel.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            fenxianglabel.font = [UIFont systemFontOfSize:13];
            fenxianglabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:fenxianglabel];
            
            UILabel *shoucanglabel = [[UILabel alloc]init];
            shoucanglabel.frame = CGRectMake(width - 215, 125, 100, 30);
            shoucanglabel.text =[NSString stringWithFormat:@"阅读量: %@",[remenzixunarray[indexPath.row] objectForKey:@"viewCount"]];
            shoucanglabel.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            shoucanglabel.font = [UIFont systemFontOfSize:13];
            shoucanglabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:shoucanglabel];
            
            UIView *xian1 = [[UIView alloc] init];
            xian1.frame = CGRectMake(0, 159, width, 1);
            xian1.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
            
            [cell.contentView addSubview:image];
            [cell.contentView addSubview:title];
            [cell.contentView addSubview:content];
            [cell.contentView addSubview:xian];
            [cell.contentView addSubview:time];
            [cell.contentView addSubview:laiyuan];
            [cell.contentView addSubview:xian1];
            
            
            
        }
        else if (indexPath.section == 6)
        {
            
            CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
            CGFloat h =0;//用来控制button距离父视图的高
            for (int i = 0; i < 8; i++)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                button.tag = 100 + i;
                [button addTarget:self action:@selector(bingzheng:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:[UIColor colorWithHexString:@"32be60" alpha:1] forState:UIControlStateNormal];
                
                [button setTitle:bingzhengarr[i] forState:UIControlStateNormal];
                //设置button的frame
                button.frame = CGRectMake(w, h, width / 4 , 40);
                //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
                if( w + width / 4 > width )
                {
                    w = 0; //换行时将w置为0
                    h = h + button.frame.size.height;//距离父视图也变化
                    button.frame = CGRectMake(w, h, width / 4 , 40);//重设button的frame
                }
                w = button.frame.size.width + button.frame.origin.x;
                [cell.contentView addSubview:button];
                
            }
        }
        
    }
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==wocalei) {
        if (indexPath.row!=0) {
            
            NSString*haha=[NSString stringWithFormat:@"%@",[[wocalede[indexPath.row-1] objectForKey:@"office"] objectForKey:@"name"] ];
            [SearchButton setTitle:haha forState:UIControlStateNormal];
            wocalei.hidden=YES;
            panduan=0;
            
            NSUserDefaults*pp=  [NSUserDefaults standardUserDefaults];
            [pp setObject:[NSString stringWithFormat:@"%@",[wocalede[indexPath.row-1] objectForKey:@"id"]] forKey:@"officeid"];
            [self bannerjiekou];
            [self tejieyaopinjiekou];
            [self bargaingoodsjiekou];
            [self rementiezi];
            [self remenzixun];
        }
        
        
    }else
    {
        wocalei.hidden=YES;
        if (indexPath.section == 5) {
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                //跳转文字资讯详情
                YdTextDetailsViewController *TextDetails = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"textdetails"];
                //传值   [newsListForInterface[indexPath.row]objectForKey:@"type"];
                TextDetails.xixi=[NSString stringWithFormat:@"%@",[remenzixunarray[indexPath.row] objectForKey:@"id"]];
                [self.navigationController pushViewController:TextDetails animated:YES];
            }
        }
        else if (indexPath.section == 4) {
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                YdTieZiXiangQingViewController *TieZiXiangQing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tiezixiangqing"];
                TieZiXiangQing.tieziId = [rementieziarray[indexPath.row] objectForKey:@"id"];
                TieZiXiangQing.bingzheng = [rementieziarray[indexPath.row] objectForKey:@"diseaseName"];
                TieZiXiangQing.touxiang1 = [rementieziarray[indexPath.row] objectForKey:@"photo"];
                [self.navigationController pushViewController:TieZiXiangQing animated:YES];
            }
        }
        
    }
    
}
#pragma  mark ---好多按钮
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    wocalei.hidden=YES;
}
//特价药品展示   药品详情
- (void)handleClick1:(UIButton *)btn{
    //药品详情  传过去药品ID
    YdDrugsViewController *dr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugs"];
    dr.yaopinID=[proList[btn.tag-400] objectForKey:@"id"];
    [self.navigationController pushViewController:dr animated:YES];
    
}

//更多
-(void)pharmacygengduo
{    //特价药品列表
    YDTejialiebiaoViewController*tejia=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tejialiebiao"];
    [self.navigationController pushViewController:tejia animated:YES];
    
    
}
//积分礼品展示  礼品详情
- (void)handleClick2:(UIButton *)btn{
    //礼品详情  传过去礼品ID
    
    if (btn.tag == 500)
    {
        
    }
    
}

//跳转积分礼品列表
-(void)specialoffergengduo
{
    YDJifenViewController*jifen=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"jifen"];
    [self.navigationController pushViewController:jifen animated:YES];
    
}

//扫描
-(void)scanning{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
        [tiaodaodenglu jumpToLogin:self.navigationController];
    }else{
        //跳转到扫描页面
        YdNewsViewController *News = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"news"];
        [self.navigationController pushViewController:News animated:YES];
    }
}
//病症
-(void)bingzheng:(UIButton *)btn
{
    //跳转到详细病症
    YdDrugJumpViewController *DrugJump =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugjump"];
    DrugJump.bookNo = bingzhengarr[btn.tag-100] ;
    [self.navigationController pushViewController:DrugJump animated:YES];
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
    pickerview.backgroundColor=[UIColor blackColor];
    picke.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    
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
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
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
        
                    [wocalei reloadData];
                    
                    wocalei.hidden = NO;
                    
                    
                    
                }
            }
            @catch (NSException * e) {
                [WarningBox warningBoxModeText:@"请仔细检查网络！" andView:self.view];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
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
        }
        else if (error != nil)
        {
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    panduan=0;
    if (nicaicai==0) {
        nicaicai=1;
        //为了让定位只调用一遍
        
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
                    [WarningBox warningBoxHide:YES andView:self.view];
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
                    [WarningBox warningBoxHide:YES andView:self.view];
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
                [WarningBox warningBoxHide:YES andView:self.view];
                [WarningBox warningBoxModeText:@"请仔细检查网络！" andView:self.view];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        }];
        
        
        
    }
    else if (panduan==2){
        [WarningBox warningBoxHide:YES andView:self.view];
        wocalei.hidden=NO;
        
    }else{
        [WarningBox warningBoxHide:YES andView:self.view];
        [self sanji];
    }
    
}

@end
