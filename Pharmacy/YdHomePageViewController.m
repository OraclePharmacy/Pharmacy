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
@interface YdHomePageViewController ()
{
    CGFloat width;
    CGFloat heigth;
    UITableViewCell *cell;
    UITextField *SearchText;
    NSMutableArray *arrImage;
    NSArray *arr;
    
    NSInteger rowNo;
    CGFloat gao ;
    CGFloat kuan ;
    
    NSArray *presentarray;
    NSMutableArray *presentarrImage;
    
    
    NSURL*urll;
}

@property (strong,nonatomic) UICollectionView *Collectionview;
@property(strong,nonatomic) UIScrollView *scrollView;
@end

@implementation YdHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrImage = [[NSMutableArray alloc]init];
    presentarrImage = [[NSMutableArray alloc]init];
    
    width = [UIScreen mainScreen].bounds.size.width;
    heigth = [UIScreen mainScreen].bounds.size.height;
    
    gao = width/4/156*184;
    kuan = width/4;
    
    //Tab bar 颜色
    self.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"32BE60" alpha:1];
   
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-6@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
     //设置导航栏又按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-erweimasaomiaotubiao@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanning)];
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self SearchView];
    [self bargaingoodsjiekou];

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
    UIButton *SearchButton = [[UIButton alloc]init];
    
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
    
    //SearchText.layer.borderColor = [[UIColor colorWithHexString:@"f4f4f4" alpha:1] CGColor];
    
    //SearchText.layer.borderWidth =1;
    
    //SearchText.layer.cornerRadius = 5.0;
    
    
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
//选择地址按钮
-(void)searchbutton
{
    NSLog(@"暂时不需要跳页,但是有此方法");
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
        //NSLog(@"错误：%@",error);
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
#pragma  第三组   第四组  特价药品  积分兑换
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
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                presentarray = [datadic objectForKey:@"integralGiftList"];
                
                NSLog(@"presentarray%@",presentarray);
                
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


#pragma tableview
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
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
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
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
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    
    else if (indexPath.section == 1) {
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        [self fourButton];
        
    }
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
        
        for (int i = 0; i < 6; i++) {
            
            UIButton *IntegrationSix = [[UIButton alloc]init];
            IntegrationSix.tag = 400+i;
            IntegrationSix.frame = CGRectMake(kuan*i, 0, kuan, gao);
            IntegrationSix.backgroundColor = [UIColor clearColor];
            [IntegrationSix addTarget:self action:@selector(handleClick1:) forControlEvents:UIControlEventTouchUpInside];
            //图片
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.frame = CGRectMake(kuan*0.2, gao*0.1, kuan*0.6, gao*0.45);
            imageview.image = [UIImage imageNamed:@"IMG_0799.jpg"];
            //名称
            UILabel *name = [[UILabel alloc]init];
            name.frame = CGRectMake(0, gao*0.55, kuan, gao*0.2);
            name.font = [UIFont systemFontOfSize:15];
            name.textAlignment = NSTextAlignmentCenter;
            name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            name.text = @"泻立停";
            //原价
            UILabel *originalcost = [[UILabel alloc]init];
            originalcost.frame = CGRectMake(0, gao*0.75, kuan, gao*0.1);
            originalcost.font = [UIFont systemFontOfSize:11];
            originalcost.textAlignment = NSTextAlignmentCenter;
            originalcost.textColor = [UIColor colorWithHexString:@"909090" alpha:1];
            originalcost.text = @"￥10";
            //特价
            UILabel *specialoffer = [[UILabel alloc] init];
            specialoffer.frame = CGRectMake(0, gao*0.85, kuan, gao*0.15);
            specialoffer.font = [UIFont systemFontOfSize:13];
            specialoffer.textAlignment = NSTextAlignmentCenter;
            specialoffer.textColor = [UIColor colorWithHexString:@"FC4753" alpha:1];
            specialoffer.text = @"￥7.98";
            
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
            
            [imageview sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@""]];
            //名称
            UILabel *name = [[UILabel alloc]init];
            name.frame = CGRectMake(0, gao*0.55, kuan, gao*0.2);
            name.font = [UIFont systemFontOfSize:15];
            name.textAlignment = NSTextAlignmentCenter;
            name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            name.text = [NSString stringWithFormat:@"%@",[presentarray[i] objectForKey:@"name"]];;
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
    else if (indexPath.section == 4)
    {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    }
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
    
    
}
//扫描
-(void)scanning{
    //跳转到扫描页面
//    YdScanViewController *Scan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scan"];
//    [self.navigationController pushViewController:Scan animated:YES];
    
}

@end
