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
@interface YdInformationViewController ()
{
    UICollectionView * CollectionView;
    NSString * identifier;
    
    int index;
    int zhi ;
    
    CGFloat width;
    CGFloat height;
    int  coun;
    
    
    NSArray *arr;
    NSString *str;
    
    NSMutableArray*newsListForInterface;
    NSMutableArray*diantainewsListForInterface;
    
    int ye;
    int diantaiye;
}
@property(strong,nonatomic) UIScrollView *scrollView;
@end

@implementation YdInformationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ye=1;
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
        if (diantaiye*5 >coun+4) {
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
        NSLog(@"%d,%d",ye,coun);
        if (ye*5 >coun+4) {
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
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    //for循环创建button
    int i ;
    for (i = 0; i < arr.count; i++) {
        
        UIButton *tabButton = [[UIButton alloc]init];
        tabButton.tag = 300+i;
        tabButton.titleLabel.font =  [UIFont systemFontOfSize:13];
        tabButton.frame = CGRectMake(width/5*i, 0, width/5, 30);
        tabButton.backgroundColor = [UIColor clearColor];
        [tabButton addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [tabButton setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"cateName"]] forState:UIControlStateNormal];
        //默认
        [tabButton setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        //选中
        [tabButton setTitleColor:[UIColor colorWithHexString:@"32be60" alpha:1] forState:UIControlStateSelected];
        //        //图片
        //        UIImageView *imageview = [[UIImageView alloc]init];
        //        imageview.frame = CGRectMake(0, 0, width/5, 30);
        //        imageview.image = [UIImage imageNamed:@"IMG_0799.jpg"];
        //        //名称
        //        UILabel *name = [[UILabel alloc]init];
        //        name.frame = CGRectMake(0, 0,  width/5, 30);
        //        name.font = [UIFont systemFontOfSize:15];
        //        name.textAlignment = NSTextAlignmentCenter;
        //        name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        
        //name.text = arr[i];
        
        self.scrollView.pagingEnabled = YES;
        
        self.scrollView.delegate = self;
        
        
        [self.scrollView addSubview:tabButton];
        //[tabButton addSubview:imageview];
        //[tabButton addSubview:name];
        
    }
    //设置可滑动大小
    self.scrollView.contentSize = CGSizeMake(width/5*i, 30);
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
                NSLog(@"\n\n\n\n%@",arr);
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
        NSLog(@"错误：%@",error);
        
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
            
            NSLog(@"文字咨询返回列表－－－－－%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                NSArray*mg=[NSArray arrayWithArray:[datadic objectForKey:@"newsListForInterface"]];
                coun=[[datadic objectForKey:@"count"] intValue];
                if (ye!=1) {
                    for (NSDictionary*dd in mg) {
                        [newsListForInterface addObject:dd];
                        NSLog(@"是啥--%@", newsListForInterface);
                    }
                }else{
                    newsListForInterface=[NSMutableArray arrayWithArray:mg];
                }
                ye++;
                NSLog(@"%@",datadic);
                
                [_tableview reloadData];
                
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
//        @try
//        {
        
            NSLog(@"%@",responseObject);
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
                NSLog(@"%@",datadic1);
                
                [_tableview reloadData];
                
            }
            
//        }
//        @catch (NSException * e) {
//            
//            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
//            
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        NSLog(@"错误：%@",error);
        
    }];
    
}

//scrollview上面button点击事件
- (void)handleClick:(UIButton *)btn
{
    newsListForInterface=[[NSMutableArray alloc] init];
    str = [[NSString alloc]init];
    
    //u.selected = YES;//选择状态设置为YES,如果有其他按钮 先把其他按钮的selected设置为NO
    if (btn.tag == 300)
    {
        str = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"id"]];
    }
    else if (btn.tag == 301)
    {
        str = [NSString stringWithFormat:@"%@",[arr[1] objectForKey:@"id"]];;
    }
    else if (btn.tag == 302)
    {
        str = [NSString stringWithFormat:@"%@",[arr[2] objectForKey:@"id"]];;
    }
    else if (btn.tag == 303)
    {
        str = [NSString stringWithFormat:@"%@",[arr[3] objectForKey:@"id"]];;
    }
    else if (btn.tag == 304)
    {
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
            return 1;
        }
        else
        {
            
            return newsListForInterface.count;
        }
    }
    else
    {
        NSLog(@"%lu",diantainewsListForInterface.count);
        return diantainewsListForInterface.count;
    }
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if (zhi == 1) {
        if (indexPath.section == 0)
        {
            return 180;
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
            //创建scrollview
            [self tab];
            
            //创建图片
            UIImageView *img = [[UIImageView alloc]init];
            img.frame = CGRectMake(0, 30, width, 150);
            img.backgroundColor = [UIColor colorWithHexString:@"943545" alpha:1];
            NSString*path;
            if (newsListForInterface.count==0) {
                
            }else{
                path=[NSString stringWithFormat:@"%@%@",service_host,[newsListForInterface[indexPath.row] objectForKey:@"picUrl"]] ;
            }
            [img sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
            [cell.contentView addSubview:_scrollView];
            [cell.contentView addSubview:img];
            
        }
        else
        {
            NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[newsListForInterface[indexPath.row] objectForKey:@"picUrl"]] ;
            NSLog(@"%@",path);
            UIImageView *image = [[UIImageView alloc]init];
            image.frame = CGRectMake(10, 10, 100 , 100);
            [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
            
            UILabel *title = [[UILabel alloc]init];
            title.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 10, width - CGRectGetMaxY(image.frame) - 20, 30);
            title.font = [UIFont systemFontOfSize:15];
            title.text = [NSString stringWithFormat:@"%@",[newsListForInterface[indexPath.row] objectForKey:@"title"] ];
            title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            //title.backgroundColor = [UIColor grayColor];
            
            UILabel *content = [[UILabel alloc]init];
            content.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 60, width - CGRectGetMaxY(image.frame) - 20, 40);
            content.font = [UIFont systemFontOfSize:12];
            content.text = [NSString stringWithFormat:@"%@",[newsListForInterface[indexPath.row] objectForKey:@"subtitle"] ];
            content.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            content.numberOfLines = 2;
            //content.backgroundColor = [UIColor grayColor];
            
            UILabel *time = [[UILabel alloc]init];
            time.frame = CGRectMake(width - 120, 100, 110, 20);
            time.font = [UIFont systemFontOfSize:10];
            time.text = [NSString stringWithFormat:@"%@",[newsListForInterface[indexPath.row] objectForKey:@"createTime"]];
            time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            time.numberOfLines = 2;
            //time.backgroundColor = [UIColor grayColor];
            
            UIView *xian = [[UIView alloc] init];
            xian.frame = CGRectMake(0, 120, width, 1);
            xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
            
            UILabel *laiyuan = [[UILabel alloc]init];
            laiyuan.frame = CGRectMake(10,130, 100, 20);
            laiyuan.font = [UIFont systemFontOfSize:13];
            laiyuan.text = [NSString stringWithFormat:@"%@",[newsListForInterface[indexPath.row] objectForKey:@"source"]];
            laiyuan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            
            //这是啥玩意
            UIButton *fenxiang = [[UIButton alloc] init];
            fenxiang.frame = CGRectMake(width - 70 ,130 ,20 ,20);
            fenxiang.backgroundColor = [UIColor clearColor];
            [fenxiang addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
            //看不懂
            
            UILabel *fenxianglabel = [[UILabel alloc]init];
            fenxianglabel.frame = CGRectMake(0,0,70,20);
            fenxianglabel.text =[NSString stringWithFormat:@"阅读量: %@",[newsListForInterface[indexPath.row] objectForKey:@"viewCount"]];
            fenxianglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            fenxianglabel.font = [UIFont systemFontOfSize:11];
            [fenxiang addSubview:fenxianglabel];
            
            
            UIButton *shoucang = [[UIButton alloc] init];
            shoucang.frame = CGRectMake(width - 140 ,130 ,20 ,20);
            shoucang.backgroundColor = [UIColor clearColor];
            [shoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
            
            
            UILabel *shoucanglabel = [[UILabel alloc]init];
            shoucanglabel.frame = CGRectMake(0,0,70,20);
            shoucanglabel.text = [NSString stringWithFormat:@"点赞量: %@",[newsListForInterface[indexPath.row] objectForKey:@"clickLikeCount"]];
            shoucanglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            shoucanglabel.font = [UIFont systemFontOfSize:11];
            [shoucang addSubview:shoucanglabel];
            
            UIView *xian1 = [[UIView alloc] init];
            xian1.frame = CGRectMake(0, 159, width, 1);
            xian1.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
            
            [cell.contentView addSubview:image];
            [cell.contentView addSubview:title];
            [cell.contentView addSubview:content];
            [cell.contentView addSubview:xian];
            [cell.contentView addSubview:time];
            [cell.contentView addSubview:shoucang];
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
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
        
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
        time.frame = CGRectMake(width - 120, 100, 110, 20);
        time.font = [UIFont systemFontOfSize:10];
        time.text = [NSString stringWithFormat:@"%@",[diantainewsListForInterface[indexPath.row] objectForKey:@"createTime"]];
        time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
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
        fenxianglabel.frame = CGRectMake(0,0,70,20);
        fenxianglabel.text =[NSString stringWithFormat:@"阅读量: %@",[diantainewsListForInterface[indexPath.row] objectForKey:@"viewCount"]];
        fenxianglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        fenxianglabel.font = [UIFont systemFontOfSize:11];
        [fenxiang addSubview:fenxianglabel];
        
        
        UIButton *shoucang = [[UIButton alloc] init];
        shoucang.frame = CGRectMake(width - 140 ,130 ,20 ,20);
        shoucang.backgroundColor = [UIColor clearColor];
        [shoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *shoucanglabel = [[UILabel alloc]init];
        shoucanglabel.frame = CGRectMake(0,0,70,20);
        shoucanglabel.text =[NSString stringWithFormat:@"点赞量: %@",[diantainewsListForInterface[indexPath.row] objectForKey:@"clickLikeCount"]];
        shoucanglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        shoucanglabel.font = [UIFont systemFontOfSize:11];
        [shoucang addSubview:shoucanglabel];
        
        UIView *xian1 = [[UIView alloc] init];
        xian1.frame = CGRectMake(0, 159, width, 1);
        xian1.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
        
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:content];
        [cell.contentView addSubview:xian];
        [cell.contentView addSubview:time];
        [cell.contentView addSubview:shoucang];
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
    NSLog(@"分享");
}
-(void)shoucang
{
    NSLog(@"收藏");
}
//看不懂
//tableview点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断是否登录
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
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
@end
