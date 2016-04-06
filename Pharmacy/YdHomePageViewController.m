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
#import "UIImageView+WebCache.h"
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
    
   
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
     //设置导航栏又按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanning)];
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    one.frame = CGRectMake((width-width/6*4)/5, (width/4-width/6)/2, width/6, width/6);
    [one setImage:[UIImage imageNamed:@"IMG_0797.jpg"] forState:UIControlStateNormal];
    [one addTarget:self action:@selector(one) forControlEvents:UIControlEventTouchUpInside];
    //第二个按钮
    UIButton *two = [[UIButton alloc]init];
    two.frame = CGRectMake((width-width/6*4)/5*2+width/6, (width/4-width/6)/2, width/6, width/6);
    [two setImage:[UIImage imageNamed:@"IMG_0798.jpg"] forState:UIControlStateNormal];
    [two addTarget:self action:@selector(two) forControlEvents:UIControlEventTouchUpInside];
    //第三个按钮
    UIButton *three = [[UIButton alloc]init];
    three.frame = CGRectMake((width-width/6*4)/5*3+width/6*2, (width/4-width/6)/2, width/6, width/6);
    [three setImage:[UIImage imageNamed:@"IMG_0799.jpg"] forState:UIControlStateNormal];
    [three addTarget:self action:@selector(three) forControlEvents:UIControlEventTouchUpInside];
    //第四个按钮
    UIButton *four = [[UIButton alloc]init];
    four.frame = CGRectMake((width-width/6*4)/5*4+width/6*3, (width/4-width/6)/2, width/6, width/6);
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
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
    
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        NSLog(@"错误：%@",error);
        
    }];

}


#pragma tableview
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
    else if (indexPath.section == 2)
    {
        return gao+1+20;
    }
    else if (indexPath.section == 3)
    {
        return gao+1+20;
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
        
        if (arrImage.count < 1 )
        {
            UIImageView *image = [[UIImageView alloc]init];
            image.frame = CGRectMake(0, 0, self.view.frame.size.width, heigth/4);
            image.image = [UIImage imageNamed:@"IMG_0797.jpg"];
            [cell.contentView addSubview:image];
        }
        else
        {
            YCAdView *ycAdView = [YCAdView initAdViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heigth/4)
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
        
        cell.contentView.backgroundColor = [UIColor grayColor];
        [self fourButton];
        
    }
    else if (indexPath.section == 2)
    {
        UIView *xian = [[UIView alloc]init];
        xian.frame = CGRectMake(0, 20, width, 0.5);
        xian.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:xian];
        
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, width, gao)];
        
        for (int i = 0; i < 6; i++) {
            UIButton *IntegrationSix = [[UIButton alloc]init];
            IntegrationSix.frame = CGRectMake(kuan*i, 0, kuan, gao);
            IntegrationSix.backgroundColor = [UIColor clearColor];
            
            //图片
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.frame = CGRectMake(kuan*0.2, gao*0.1, kuan*0.6, gao*0.45);
            imageview.image = [UIImage imageNamed:@"IMG_0799.jpg"];
            //名称
            UILabel *name = [[UILabel alloc]init];
            name.frame = CGRectMake(0, gao*0.55, kuan, gao*0.2);
            name.font = [UIFont systemFontOfSize:15];
            name.textAlignment = NSTextAlignmentCenter;
            name.textColor = [UIColor blackColor];
            name.text = @"泻立停";
            //原价
            UILabel *originalcost = [[UILabel alloc]init];
            originalcost.frame = CGRectMake(0, gao*0.75, kuan, gao*0.1);
            originalcost.font = [UIFont systemFontOfSize:11];
            originalcost.textAlignment = NSTextAlignmentCenter;
            originalcost.textColor = [UIColor lightGrayColor];
            originalcost.text = @"￥10";
            //积分
            UILabel *specialoffer = [[UILabel alloc] init];
            specialoffer.frame = CGRectMake(0, gao*0.85, kuan, gao*0.15);
            specialoffer.font = [UIFont systemFontOfSize:13];
            specialoffer.textAlignment = NSTextAlignmentCenter;
            specialoffer.textColor = [UIColor orangeColor];
            specialoffer.text = @"￥9.98";
            
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

        UIView *xian = [[UIView alloc]init];
        xian.frame = CGRectMake(0, 20, width, 0.5);
        xian.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:xian];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, width, gao)];
        
        for (int i = 0; i < presentarray.count; i++) {
            UIButton *IntegrationSix = [[UIButton alloc]init];
            IntegrationSix.frame = CGRectMake(kuan*i, 0, kuan, gao);
            IntegrationSix.backgroundColor = [UIColor clearColor];
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
            name.textColor = [UIColor blackColor];
            name.text = [NSString stringWithFormat:@"%@",[presentarray[i] objectForKey:@"name"]];;
            //原价
            UILabel *originalcost = [[UILabel alloc]init];
            originalcost.frame = CGRectMake(0, gao*0.75, kuan, gao*0.1);
            originalcost.font = [UIFont systemFontOfSize:11];
            originalcost.textAlignment = NSTextAlignmentCenter;
            originalcost.textColor = [UIColor lightGrayColor];
            originalcost.text = [NSString stringWithFormat:@"%@",[presentarray[i] objectForKey:@"price"]];;
            //积分
            UILabel *specialoffer = [[UILabel alloc] init];
            specialoffer.frame = CGRectMake(0, gao*0.85, kuan, gao*0.15);
            specialoffer.font = [UIFont systemFontOfSize:13];
            specialoffer.textAlignment = NSTextAlignmentCenter;
            specialoffer.textColor = [UIColor orangeColor];
            specialoffer.text = [NSString stringWithFormat:@"%@",[presentarray[i] objectForKey:@"integral"]];

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
        
    
    return cell;
}

//扫描
-(void)scanning{
    //跳转到扫描页面
    YdScanViewController *Scan = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scan"];
    [self.navigationController pushViewController:Scan animated:YES];
    
}

@end
