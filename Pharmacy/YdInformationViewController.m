//
//  YdInformationViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/6.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdInformationViewController.h"
#import "Color+Hex.h"
#import "YdInformationDetailsViewController.h"
#import "YdTextDetailsViewController.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "tiaodaodenglu.h"
#import "YdNewsViewController.h"
@interface YdInformationViewController ()
{
    UICollectionView * CollectionView;
    NSString * identifier;
    
    int index;
    int zhi ;
    
    CGFloat width;
    CGFloat height;
    int  coun;
    
    //按钮变色；
    int yans;
    
    NSArray *arr;
    NSString *str;
    
    NSMutableArray*newsListForInterface;
    NSMutableArray*diantainewsListForInterface;
    NSString* hulalala;
    int ye;
    int diantaiye;
}
@property(strong,nonatomic) UIScrollView *scrollView;
@end

@implementation YdInformationViewController
-(void)viewWillAppear:(BOOL)animated
{
    //设置导航栏右按钮
    NSUserDefaults *ss =[NSUserDefaults standardUserDefaults];
    if ([[ss objectForKey:@"youjian"] isEqualToString:@"0"] || NULL ==[ss objectForKey:@"youjian"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"邮件-2.png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanning)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"邮件-1.png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanning)];
    }

    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)jieshou{
    NSUserDefaults * ss=[NSUserDefaults standardUserDefaults];
    //设置导航栏右按钮
    if ([[ss objectForKey:@"youjian"] isEqualToString:@"0"] || NULL ==[ss objectForKey:@"youjian"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"邮件-2.png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanning)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"邮件-1.png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanning)];
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    yans = 1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jieshou) name:@"111" object:nil];
    ye=1;
    hulalala=@"0";
    NSLog(@"hulalala -==-   %lu",(unsigned long)hulalala);
    diantaiye=1;
    arr=[NSArray array];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    diantainewsListForInterface=[[NSMutableArray alloc] init];
    
    //设置分段控制器的默认选项
    self.Segmented.selectedSegmentIndex = 0;
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64 - 40);
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-6@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewdata)];
    self.tableview.mj_header = header;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    MJRefreshAutoNormalFooter*footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableview.mj_footer = footer;
    
    
    //进入界面   给zhi赋值
    zhi = 1;
    [self zixunleibie];
}
-(void)loadNewdata{
    if (zhi!=1) {
        diantaiye=1;
        diantainewsListForInterface=[[NSMutableArray alloc] init];
        [self jiankangdiantai];
    }else{
        ye=1;
        [self wenzizixun:str];
    }
    [self.tableview.mj_header endRefreshing];
}
-(void)loadNewData{
    if (zhi!=1) {
        if (diantaiye*5 >coun+4||5>coun) {
            [WarningBox warningBoxModeText:@"已经是最后一页了!" andView:self.view];
            
            [self.tableview.mj_footer endRefreshing];
        }else{
            if (diantaiye==1) {
                diantaiye=2;
            }
            [self jiankangdiantai];
            [self.tableview.mj_footer endRefreshing];
        }
        
    }else{
        if (ye*5 >coun+4||5>coun) {
            [WarningBox warningBoxModeText:@"已经是最后一页了!" andView:self.view];
            
            [self.tableview.mj_footer endRefreshing];
        }else{
            if (ye==1) {
                ye=2;
            }
            [self wenzizixun:str];
            [self.tableview.mj_footer endRefreshing];
        }
    }
}
-(void)tab
{
    self.scrollView=nil;
    //设置scrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, 40)];
    //for循环创建button
    int i ;
    for (i = 0; i < arr.count; i++) {
        
        UIButton *tabButton = [[UIButton alloc]init];
        tabButton.tag = 300+i;
        tabButton.titleLabel.font =  [UIFont systemFontOfSize:13];
        tabButton.frame = CGRectMake(width/5*i, 0, width/5, 40);
        tabButton.backgroundColor = [UIColor clearColor];
//        if (tabButton.tag-300 == (int)hulalala) {
//            tabButton.titleLabel.tintColor = [UIColor colorWithHexString:@"34c083"];
//        }else{
            tabButton.titleLabel.tintColor = [UIColor blackColor];
//        }
        [tabButton addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [tabButton setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"cateName"]] forState:UIControlStateNormal];
        //默认
        [tabButton setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        //选中
        [tabButton setTitleColor:[UIColor colorWithHexString:@"32be60" alpha:1] forState:UIControlStateSelected];
        if (tabButton.tag - 300 == yans - 1) {
//            tabButton.titleLabel.tintColor = [UIColor colorWithHexString:@"4fc676"];
            [tabButton setTitleColor:[UIColor colorWithHexString:@"4fc676"] forState:UIControlStateNormal];
        }
        
        self.scrollView.pagingEnabled = YES;
        
        self.scrollView.delegate = self;
        
        
        [self.scrollView addSubview:tabButton];
        
    }
    //设置可滑动大小
    self.scrollView.contentSize = CGSizeMake(width/5*i, 40);
    //隐藏滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
}
-(void)zixunleibie{
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/postDetail/newsCatelogList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"pageNo", nil];
    
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
                
                arr= [[responseObject objectForKey:@"data"] objectForKey:@"newsCatelog"];
                [self wenzizixun:[NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"id"]]];
                str=[NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"id"]];
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

-(void)wenzizixun:(NSString *)hehe{
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",ye],@"pageNo",@"5",@"pageSize",hehe,@"id", nil];
    
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
                NSArray*mg=[NSArray arrayWithArray:[datadic objectForKey:@"newsListForInterface"]];
                coun=[[datadic objectForKey:@"count"] intValue];
                if (ye!=1) {
                    for (NSDictionary*dd in mg) {
                        [newsListForInterface addObject:dd];
                    }
                }else{
                    newsListForInterface=[NSMutableArray arrayWithArray:mg];
                }
                ye++;
                
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
-(void)jiankangdiantai{
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",diantaiye],@"pageNo",@"5",@"pageSize",@"",@"id", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            
            NSDictionary*datadic1=[responseObject valueForKey:@"data"];
            coun=[[[responseObject objectForKey:@"data"] objectForKey:@"count"] intValue];
            if (diantaiye!=1) {
                for (NSDictionary*dd in [datadic1 objectForKey:@"newsListForInterface"]) {
                    [diantainewsListForInterface addObject:dd];
                    
                }
            }else{
                diantainewsListForInterface=[NSMutableArray arrayWithArray: [datadic1 objectForKey:@"newsListForInterface" ]];
            }
            diantaiye++;
            [_tableview reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        
    }];
    
}

//scrollview上面button点击事件
- (void)handleClick:(UIButton *)btn
{
    newsListForInterface=[[NSMutableArray alloc] init];
    str = [[NSString alloc]init];
    if (btn.tag == 300)
    {
        yans = 1;
        str = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"id"]];
        NSLog(@"str:%@",str);
    }
    else if (btn.tag == 301)
    {
        yans = 2;
        str = [NSString stringWithFormat:@"%@",[arr[1] objectForKey:@"id"]];;
         NSLog(@"str:%@",str);
    }
    else if (btn.tag == 302)
    {
        yans = 3;
        str = [NSString stringWithFormat:@"%@",[arr[2] objectForKey:@"id"]];;
    }
    else if (btn.tag == 303)
    {
        yans = 4;
        str = [NSString stringWithFormat:@"%@",[arr[3] objectForKey:@"id"]];;
    }
    else if (btn.tag == 304)
    {
        yans = 5;
        str = [NSString stringWithFormat:@"%@",[arr[4] objectForKey:@"id"]];;
    }
    
    [self wenzizixun:str];
    
}

//分段控制器  点击方法
- (IBAction)Segmented:(id)sender {
    index = (int)self.Segmented.selectedSegmentIndex;
    if (index == 0 ) {
        //点击分段控制前半段zhi赋值为1
        zhi = 1;
        //刷新tableview
        [self.tableview reloadData];
    }
    else if(index == 1){
        //点击分段控制前半段zhi赋值为2
        zhi = 2;
        diantaiye=1;
        [self jiankangdiantai];
        //刷新tableview
        [self.tableview reloadData];
    }
    
}
#pragma 设置tableview
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (zhi == 1)
    {
        return 2;
    }
    else
    {
        return 1;
    }
    
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (zhi == 1) {
        if (section == 0)
        {
            return 2;
        }
        else
        {
            
            return newsListForInterface.count;
        }
    }
    else
    {
        return diantainewsListForInterface.count;
    }
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if (zhi == 1) {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0) {
                return 40;
            }else
            return 150;
        }
        else
        {
            return 160;
        }
    }
    else
        return 160;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    if (zhi == 1)
    {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                //创建scrollview
                [self tab];
                [cell.contentView addSubview:_scrollView];
            }
            else{
            
            //创建图片
            UIImageView *img = [[UIImageView alloc]init];
            img.frame = CGRectMake(0, 0, width, 150);
           // img.backgroundColor = [UIColor colorWithHexString:@"943545" alpha:1];
            NSString*path;
            if (newsListForInterface.count==0) {
                
            }else{
                path=[NSString stringWithFormat:@"%@%@",service_host,[newsListForInterface[0] objectForKey:@"picUrl"]] ;
            }
            [img sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
            
            [cell.contentView addSubview:img];
            }
        }
        else
        {
            NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[newsListForInterface[indexPath.row] objectForKey:@"picUrl"]] ;
            UIImageView *image = [[UIImageView alloc]init];
            image.frame = CGRectMake(10, 10, 100 , 100);
            [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
            
            UILabel *title = [[UILabel alloc]init];
            title.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 10, width - CGRectGetMaxY(image.frame) - 20, 30);
            title.font = [UIFont systemFontOfSize:15];
            title.text = [NSString stringWithFormat:@"%@",[newsListForInterface[indexPath.row] objectForKey:@"title"] ];
            title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            
            UILabel *content = [[UILabel alloc]init];
            content.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 60, width - CGRectGetMaxY(image.frame) - 20, 40);
            content.font = [UIFont systemFontOfSize:12];
            content.text = [NSString stringWithFormat:@"%@",[newsListForInterface[indexPath.row] objectForKey:@"subtitle"] ];
            content.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            content.numberOfLines = 2;
            
            UILabel *time = [[UILabel alloc]init];
            time.frame = CGRectMake(width - 150, 100, 145, 20);
            time.font = [UIFont systemFontOfSize:13];
            time.text = [NSString stringWithFormat:@"%@",[newsListForInterface[indexPath.row] objectForKey:@"createTime"]];
            time.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            time.numberOfLines = 2;
            
            UIView *xian = [[UIView alloc] init];
            xian.frame = CGRectMake(0, 120, width, 1);
            xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
            
            UILabel *laiyuan = [[UILabel alloc]init];
            laiyuan.frame = CGRectMake(10,130, 100, 20);
            laiyuan.font = [UIFont systemFontOfSize:15];
            laiyuan.text = [NSString stringWithFormat:@"%@",[newsListForInterface[indexPath.row] objectForKey:@"source"]];
            laiyuan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            
            //这是啥玩意
            UIButton *fenxiang = [[UIButton alloc] init];
            fenxiang.frame = CGRectMake(width - 70 ,130 ,20 ,20);
            fenxiang.backgroundColor = [UIColor clearColor];
            [fenxiang addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
            UILabel *fenxianglabel = [[UILabel alloc]init];
            fenxianglabel.frame = CGRectMake(width - 110, 125, 100, 30);
            fenxianglabel.text =[NSString stringWithFormat:@"点赞量: %@",[newsListForInterface[indexPath.row] objectForKey:@"clickLikeCount"]];
            fenxianglabel.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            fenxianglabel.font = [UIFont systemFontOfSize:13];
            fenxianglabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:fenxianglabel];
            
            UILabel *shoucanglabel = [[UILabel alloc]init];
            shoucanglabel.frame = CGRectMake(width - 215, 125, 100, 30);
            shoucanglabel.text =[NSString stringWithFormat:@"阅读量: %@",[newsListForInterface[indexPath.row] objectForKey:@"viewCount"]];
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
            [cell.contentView addSubview:fenxiang];
            [cell.contentView addSubview:laiyuan];
            [cell.contentView addSubview:xian1];
        }
        
        
    }
    else
    {
        NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[diantainewsListForInterface[indexPath.row] objectForKey:@"picUrl"]] ;
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(10, 10, 100 , 100);
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"daiti.png" ]];
        
        UILabel *title = [[UILabel alloc]init];
        title.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 10, width - CGRectGetMaxY(image.frame) - 20, 30);
        title.font = [UIFont systemFontOfSize:15];
        title.text =[NSString stringWithFormat:@"%@",[diantainewsListForInterface[indexPath.row] objectForKey:@"title"] ];
        title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        //title.backgroundColor = [UIColor grayColor];
        
        UILabel *content = [[UILabel alloc]init];
        content.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 60, width - CGRectGetMaxY(image.frame) - 20, 40);
        content.font = [UIFont systemFontOfSize:12];
        content.text = [NSString stringWithFormat:@"%@",[diantainewsListForInterface[indexPath.row] objectForKey:@"subtitle"] ];
        content.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        content.numberOfLines = 2;
        //content.backgroundColor = [UIColor grayColor];
        
        UILabel *time = [[UILabel alloc]init];
        time.frame = CGRectMake(width - 150, 100, 145, 20);
        time.font = [UIFont systemFontOfSize:13];
        time.text = [NSString stringWithFormat:@"%@",[diantainewsListForInterface[indexPath.row] objectForKey:@"createTime"]];
        time.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
        time.numberOfLines = 2;
        //time.backgroundColor = [UIColor grayColor];
        
        
        UIView *xian = [[UIView alloc] init];
        xian.frame = CGRectMake(0, 120, width, 1);
        xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
        
        UILabel *laiyuan = [[UILabel alloc]init];
        laiyuan.frame = CGRectMake(10,130, 100, 20);
        laiyuan.font = [UIFont systemFontOfSize:13];
        laiyuan.text = [NSString stringWithFormat:@"%@",[diantainewsListForInterface[indexPath.row] objectForKey:@"source"]];
        laiyuan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        
        
        UIButton *fenxiang = [[UIButton alloc] init];
        fenxiang.frame = CGRectMake(width - 70 ,130 ,20 ,20);
        fenxiang.backgroundColor = [UIColor clearColor];
        [fenxiang addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
        UILabel *fenxianglabel = [[UILabel alloc]init];
        fenxianglabel.frame = CGRectMake(width - 110, 125, 100, 30);
        fenxianglabel.text =[NSString stringWithFormat:@"点赞量: %@",[diantainewsListForInterface[indexPath.row] objectForKey:@"clickLikeCount"]];
        fenxianglabel.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
        fenxianglabel.font = [UIFont systemFontOfSize:13];
        fenxianglabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:fenxianglabel];
        
        UILabel *shoucanglabel = [[UILabel alloc]init];
        shoucanglabel.frame = CGRectMake(width - 215, 125, 100, 30);
        shoucanglabel.text =[NSString stringWithFormat:@"阅读量: %@",[diantainewsListForInterface[indexPath.row] objectForKey:@"viewCount"]];
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
        [cell.contentView addSubview:fenxiang];
        [cell.contentView addSubview:laiyuan];
        [cell.contentView addSubview:xian1];
        
    }
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}
//这是啥玩意
-(void)fenxiang
{
}
-(void)shoucang
{
}
//看不懂
//tableview点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断是否登录
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
        [tiaodaodenglu jumpToLogin:self.navigationController];
        
    }else{
        if(zhi == 1)
        {
            
            //跳转文字资讯详情
            YdTextDetailsViewController *TextDetails = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"textdetails"];
            //传值   [newsListForInterface[indexPath.row]objectForKey:@"type"];
            TextDetails.xixi=[NSString stringWithFormat:@"%@",[newsListForInterface[indexPath.row] objectForKey:@"id"]];
            [self.navigationController pushViewController:TextDetails animated:YES];
            
        }
        else
        {
            //跳转健康电台详情
            YdInformationDetailsViewController *InformationDetails = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"informationdetails"];
            InformationDetails.hahaha=[NSString stringWithFormat:@"%@",[diantainewsListForInterface[indexPath.row] objectForKey:@"id"]];
            InformationDetails.liexing=[NSString stringWithFormat:@"%@",[diantainewsListForInterface[indexPath.row] objectForKey:@"type"]];
            
            InformationDetails.doc=[NSDictionary dictionaryWithDictionary:diantainewsListForInterface[indexPath.row]];
            [self.navigationController pushViewController:InformationDetails animated:YES];
        }
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 1)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return baseView;
}
-(void)scanning{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
        [tiaodaodenglu jumpToLogin:self.navigationController];
    }else{
        //跳转到扫描页面
        YdNewsViewController *News = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"news"];
        [self.navigationController pushViewController:News animated:YES];
    }
}
@end
