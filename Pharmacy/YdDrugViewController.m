//
//  YdDrugViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/21.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdDrugViewController.h"
#import "YdDrugJumpViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
@interface YdDrugViewController ()
{
    CGFloat width;
    CGFloat height;
    NSDictionary *classDic;
    
    int a;
    
    NSMutableArray *erji;;
    NSArray *sanji;
    
    NSInteger rowNo;
    
    NSArray *arr;
    
    NSMutableArray *DiseaseLableArray;
    NSMutableArray *DiseaseImageArray;
    
    UIButton *bb1;
    UIButton *bb2;
    UIButton *bb3;
    UIButton *bb4;
    UIButton *bb5;
}
@end

@implementation YdDrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数组
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
   
    _Tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-6@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen ].bounds.size.height;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.Tableview.delegate = self;
    self.Tableview.dataSource = self;
    
    //DiseaseLableArray = [[NSMutableArray alloc]init];
    //DiseaseImageArray = [[NSMutableArray alloc]init];
    
    a = 1;
    [self AddArray];
    [self addButton];
}

-(void)AddDisease
{
    //刷新Collectionview
    [self.Collectionview reloadData];
    //创建初始化NSArray对象
   
    //Collectionview遵守代理
    self.Collectionview.delegate = self;
    self.Collectionview.dataSource = self;
    //创建UICollectionViewFlowLayout布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格的大小
    flowLayout.itemSize = CGSizeMake((width-width *0.25 - 50 ) / 3,(width-width *0.25 - 50 ) / 2.3);
    //设置滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置分区上下左右空白大小
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //设置两行单元格之间的间距
    flowLayout.minimumInteritemSpacing = 0;
    //这只布局对象
    self.Collectionview.collectionViewLayout = flowLayout;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.Collectionview reloadData];
    //为单元格定义一个静态字符串作为标示符
    static NSString *cellId = @"diseasecell";
    //从可重用单元格队列中去除一个单元格
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    //设置圆角
    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = YES;
    rowNo = indexPath.row;
    //通过tag属性获取单元格内的uiimageview控件
    UIImageView *iv = (UIImageView*)[cell viewWithTag:1];
    //为单元个添加图片
    NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[arr[rowNo]objectForKey:@"picUrl" ]] ;
    NSLog(@"%@",path);
    [iv sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
    //通过tag属性获取单元格内的lable控件
    UILabel *lable = (UILabel *)[cell viewWithTag:2];
    //为单元格内的UIlable控件设置文本
    lable.text = [arr[rowNo] objectForKey:@"level3Name"];
    return cell;
}
//设置单元格个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arr.count;
}

//collectionView点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到详细病症
    YdDrugJumpViewController *DrugJump =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugjump"];
    DrugJump.bookNo = [arr[indexPath.row] objectForKey:@"level3Name"];
    [self.navigationController pushViewController:DrugJump animated:YES];

    return;
}
//创建二级病症数组
-(void)AddArray
{
    if (a == 1)
    {
        erji = [[NSMutableArray alloc]init];
        [erji addObject:@"五官科"];
        [erji addObject:@"儿科用药"];
        [erji addObject:@"其它外用药"];
        [erji addObject:@"头疼安神类"];
        [erji addObject:@"妇科用药"];
        [erji addObject:@"心脑血管"];
        [erji addObject:@"感冒类"];;
        [erji addObject:@"抗菌消炎类"];
        [erji addObject:@"抗过敏类"];
        [erji addObject:@"止咳祛痰平喘"];
        [erji addObject:@"泌尿系统"];
        [erji addObject:@"消化系统类"];
        [erji addObject:@"清热解毒"];
        [erji addObject:@"男科用药"];
        [erji addObject:@"糖尿病"];
        [erji addObject:@"结石类"];
        [erji addObject:@"维生素矿物质"];
        [erji addObject:@"美容护肤"];
        [erji addObject:@"肝胆类"];
        [erji addObject:@"补益类"];
        [erji addObject:@"运动系统"];
        [erji addObject:@"风湿骨科类"];
    }
    else if (a == 2)
    {
        erji = [[NSMutableArray alloc]init];
        [erji addObject:@"中医保健"];
        [erji addObject:@"制氧机"];
        [erji addObject:@"日常外用"];
        [erji addObject:@"日常护理"];
        [erji addObject:@"日用常备"];
        [erji addObject:@"血压测量"];
        [erji addObject:@"血糖测量"];
    }
    else if (a == 3)
    {
        erji = [[NSMutableArray alloc]init];
        [erji addObject:@"怀孕检测"];
        [erji addObject:@"计生其它"];
        [erji addObject:@"避孕"];
    }
    else if (a == 4)
    {
        erji = [[NSMutableArray alloc]init];
        [erji addObject:@"应季商品"];
    }
    else if (a == 5)
    {
        erji = [[NSMutableArray alloc]init];
        [erji addObject:@"儿童保健"];
        [erji addObject:@"成人营养"];
    }
    //如果有数据，默认选中第一行并请求第一行的数据

   
//    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.Tableview selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.Tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];//实现点击第一行所调用的方法
    [self.Tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
}
//创建一级病症分类
-(void)addButton
{
    bb1 = [[UIButton alloc] init];
    bb1.frame = CGRectMake(0, 0, width/5, height/18);
    bb1.titleLabel.font = [UIFont systemFontOfSize:13];
    [bb1 setTitle:@"中西成药" forState:UIControlStateNormal];
    bb1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //默认
    [bb1 setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    //选中
    [bb1 setTitleColor:[UIColor colorWithHexString:@"32be60" alpha:1] forState:UIControlStateSelected];
    [bb1 addTarget:self action:@selector(bb11) forControlEvents:UIControlEventTouchUpInside];
     bb1.selected=YES;
    [self.Scrollview addSubview:bb1];
    
    bb2 = [[UIButton alloc] init];
    bb2.frame = CGRectMake(width/5, 0, width/5, height/18);
    bb2.titleLabel.font = [UIFont systemFontOfSize:13];
    [bb2 setTitle:@"医疗器械" forState:UIControlStateNormal];
    bb2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //默认
    [bb2 setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    //选中
    [bb2 setTitleColor:[UIColor colorWithHexString:@"32be60" alpha:1] forState:UIControlStateSelected];
    [bb2 addTarget:self action:@selector(bb22) forControlEvents:UIControlEventTouchUpInside];
    [self.Scrollview addSubview:bb2];

    bb3 = [[UIButton alloc] init];
    bb3.frame = CGRectMake(width/5*2, 0, width/5, height/18);
    bb3.titleLabel.font = [UIFont systemFontOfSize:13];
    [bb3 setTitle:@"成人用品" forState:UIControlStateNormal];
    bb3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //默认
    [bb3 setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    //选中
    [bb3 setTitleColor:[UIColor colorWithHexString:@"32be60" alpha:1] forState:UIControlStateSelected];
    [bb3 addTarget:self action:@selector(bb33) forControlEvents:UIControlEventTouchUpInside];
    [self.Scrollview addSubview:bb3];

    bb4 = [[UIButton alloc] init];
    bb4.frame = CGRectMake(width/5*3, 0, width/5, height/18);
    [bb4 setTitle:@"日常用品" forState:UIControlStateNormal];
    bb4.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    bb4.titleLabel.font = [UIFont systemFontOfSize:13];
    //默认
    [bb4 setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    //选中
    [bb4 setTitleColor:[UIColor colorWithHexString:@"32be60" alpha:1] forState:UIControlStateSelected];
    [bb4 addTarget:self action:@selector(bb44) forControlEvents:UIControlEventTouchUpInside];
    [self.Scrollview addSubview:bb4];

    bb5 = [[UIButton alloc] init];
    bb5.frame = CGRectMake(width/5*4, 0, width/5, height/18);
    bb5.titleLabel.font = [UIFont systemFontOfSize:13];
    [bb5 setTitle:@"营养保健" forState:UIControlStateNormal];
    bb5.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //默认
    [bb5 setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    //选中
    [bb5 setTitleColor:[UIColor colorWithHexString:@"32be60" alpha:1] forState:UIControlStateSelected];
    [bb5 addTarget:self action:@selector(bb55) forControlEvents:UIControlEventTouchUpInside];
    [self.Scrollview addSubview:bb5];

}
//一病症点击方法
-(void)bb11
{
    bb1.selected = YES;
    bb2.selected = NO;
    bb3.selected = NO;
    bb4.selected = NO;
    bb5.selected = NO;
    a = 1;
    [self AddArray];
    
    [self.Tableview reloadData];
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    [self.Collectionview reloadData];
   
    [self.Tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）

}
-(void)bb22
{
    bb1.selected = NO;
    bb2.selected = YES;
    bb3.selected = NO;
    bb4.selected = NO;
    bb5.selected = NO;
    
    a = 2;
    [self AddArray];
    
    
    [self.Tableview reloadData];
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    [self.Collectionview reloadData];
  
    [self.Tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
    
}

-(void)bb33
{
    
    bb1.selected = NO;
    bb2.selected = NO;
    bb3.selected = YES;
    bb4.selected = NO;
    bb5.selected = NO;
    
    a = 3;
    [self AddArray];
   
    
    [self.Tableview reloadData];
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    [self.Collectionview reloadData];
    
    [self.Tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
}

-(void)bb44
{
    bb1.selected = NO;
    bb2.selected = NO;
    bb3.selected = NO;
    bb4.selected = YES;
    bb5.selected = NO;
    a = 4;
    [self AddArray];
    
    
    [self.Tableview reloadData];
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    [self.Collectionview reloadData];
 
    [self.Tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
}

-(void)bb55
{
    bb1.selected = NO;
    bb2.selected = NO;
    bb3.selected = NO;
    bb4.selected = NO;
    bb5.selected = YES;
    a = 5;
    [self AddArray];
    
    
    [self.Tableview reloadData];
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    [self.Collectionview reloadData];
  
    [self.Tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
}
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return erji.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return height/18+1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    UILabel *bing = [[UILabel alloc]init];
    bing.frame = CGRectMake(5, 10, width/5, height/18-10);
    bing.font = [UIFont systemFontOfSize:10];
    bing.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    bing.text =erji[indexPath.row];
    bing.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:bing];
    
//    cell.textLabel.font = [UIFont systemFontOfSize:10];
//    cell.textLabel.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
//    cell.textLabel.text =erji[indexPath.row];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    //隐藏滑动条
    self.Tableview.showsVerticalScrollIndicator =NO;
    //不能设置此方法
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.Tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //自定义cell选中颜色
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor whiteColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    NSString *ss = erji[indexPath.row];

    [self jiekou:ss];
    
}
-(void)jiekou:(NSString *)ss{
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/product/productListLevelTwo";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval ad =[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",ad];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:ss,@"level2Name",nil];
    NSLog(@"\n\n%@",ss);
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    //NSLog(@"  %@",dic);
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
//            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            NSLog(@"药品三级列表\n\n%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                arr = [NSArray arrayWithArray:[datadic objectForKey:@"productList"] ];
                
                [self AddDisease];
                
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
@end
