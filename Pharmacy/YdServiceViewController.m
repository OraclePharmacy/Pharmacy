//
//  YdServiceViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/7.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdServiceViewController.h"
#import "YdWireViewController.h"
#import "YdRemindViewController.h"
#import "YdBloodViewController.h"
#import "YdElectronicsViewController.h"
#import "YdchatViewController.h"
#import "YdRecommendViewController.h"
#import "YdJiaoLiuViewController.h"
#import "YdYaoXiangViewController.h"
#import "Color+Hex.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "WarningBox.h"
#import "UIImageView+WebCache.h"
#import "tiaodaodenglu.h"
#import "mememeViewController.h"
#import "tiaodaodenglu.h"
#import "YdNewsViewController.h"
@interface YdServiceViewController ()
{
    
    CGFloat width;
    CGFloat height;
    
    UICollectionView * CollectionView;
    
    NSString * identifier;
    //按钮两个数组
    //图片
    NSArray *imagearray;
    //文字
    NSArray *lablearray;
    
    NSArray *arr;
    NSMutableArray *arrImage;
}
@end

@implementation YdServiceViewController
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //多出空白处
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-6@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
    //设置导航栏右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"read(1).png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanning)];
    
    identifier = @"cell";
    
    // 初始化layout
    
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //水平间隔
    flowLayout.minimumInteritemSpacing = 1.0;
    //垂直行间距
    flowLayout.minimumLineSpacing = 1.0;
    
    CollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, width,height-64-40)collectionViewLayout:flowLayout];
    
    CollectionView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    
    //注册单元格
    
    [CollectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:identifier];
    
    //设置代理
    
    CollectionView.delegate = self;
    
    CollectionView.dataSource = self;
    
    
    [self tuijian];
    [self.view addSubview:CollectionView];
    [self jiekou];
    
}

-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/function/pharmacistInfoList";
    
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:zhid,@"officeId",@"3",@"pageSize",@"1",@"pageNo", nil];
    
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
                
                arr = [datadic objectForKey:@"pharmacistInfoList"];
                
                
                for (int i = 0; i < arr.count; i++) {
                    
                    [arrImage addObject:[NSString stringWithFormat:@"%@%@",service_host,[arr[i] objectForKey:@"photo"]]];
                    
                    
                }
                
                imagearray = [NSArray arrayWithObjects:@"组-13@3x.png",@"2@3x.png",@"3@3x.png",@"组-1-拷贝-2@3x.png",@"组-1-拷贝@3x.png",@"组-14@3x.png",nil];
                lablearray = [NSArray arrayWithObjects:@"病友交流",@"自我诊断",@"用药提醒",@"血压血糖",@"电子病历",@"智慧药箱", nil];
                
                [CollectionView reloadData];
                
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



#pragma mark - collectionView delegate

//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    return 2;
}

//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    UIEdgeInsets top = {0,0,0,0};
    return top;
    
}

//每个分区上得元素个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    if (section == 0) {
        return 6;
    }
    return arr.count;
    
}
//设置元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell sizeToFit];
    
    CGFloat kuan = cell.contentView.bounds.size.width;
    CGFloat gao = cell.contentView.bounds.size.height;
    
    if (indexPath.section == 0)
    {
        
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake((kuan-kuan/2)/2, (gao-kuan/2)/3, kuan/2, kuan/2);
        image.image = [UIImage imageNamed:imagearray[indexPath.row]];
        
        
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(0, CGRectGetMaxY(image.frame), kuan, gao-kuan);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = lablearray[indexPath.row];
        lab.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:lab];
        cell.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    }
    else
    {
        
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake((kuan-(kuan/1.5))/2,gao*0.1, kuan/1.5,kuan/1.5);
        NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",arrImage[indexPath.section]]];
        [image sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"小人@2x.png"]];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(0, image.bounds.size.height + gao*0.1, kuan, gao*0.15);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"name"]];
        //lab.text = @"1111";
        lab.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        
        UILabel *lab1 = [[UILabel alloc]init];
        lab1.frame = CGRectMake(0, image.bounds.size.height + gao*0.25, kuan, gao*0.1);
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] objectForKey:@"qualification"]];
        // lab1.text = @"222";
        lab1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        lab1.font = [UIFont systemFontOfSize:13];
        
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:lab];
        [cell.contentView addSubview:lab1];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
    
}

//设置单元格宽度

//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((collectionView.bounds.size.width-2)/3,((collectionView.bounds.size.height)*0.6-1)/2);
    
}
//Header高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        
        CGSize size={width,
            collectionView.bounds.size.height*0.1};
        return size;
        
    }
    else{
        
        CGSize size={0,0};
        return size;
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path=[paths objectAtIndex:0];
                NSString *filename=[path stringByAppendingPathComponent:@"baocun.plist"];
                //判断是否已经创建文件
                if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                    
                    int bingyoujiaoliu;
                    //读文件
                    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
                    
                    bingyoujiaoliu = [[dic objectForKey:@"bingyoujiaoliu"] intValue];
                    
                    bingyoujiaoliu++;
                    
                    NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/[dic objectForKey:@"yongjingxi"],@"yongjingxi",/*2*/[dic objectForKey:@"wenyaoshi"],@"wenyaoshi",/*3*/[dic objectForKey:@"daigouyao"],@"daigouyao",/*4*/[dic objectForKey:@"youhuiquan"],@"youhuiquan",/*5*/[NSString stringWithFormat:@"%d",bingyoujiaoliu],@"bingyoujiaoliu",/*6*/[dic objectForKey:@"zizhen"],@"zizhen",/*7*/[dic objectForKey:@"yongyaotixing"],@"yongyaotixing",/*8*/[dic objectForKey:@"xueyaxuetang"],@"xueyaxuetang",/*9*/[dic objectForKey:@"dianzibingli"],@"dianzibingli",/*10*/[dic objectForKey:@"zhihuiyaoxiang"],@"zhihuiyaoxiang",nil];
                    
                    [dic1 writeToFile:filename atomically:YES];
                    
                }else {
                    
                    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"1",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
                    [dic writeToFile:filename atomically:YES];
                    
                }
                YdJiaoLiuViewController *JiaoLiu =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"jiaoliu"];
                [self.navigationController pushViewController:JiaoLiu animated:YES];
            }
        }
        else if (indexPath.row == 1)
        {
            
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path=[paths objectAtIndex:0];
            NSString *filename=[path stringByAppendingPathComponent:@"baocun.plist"];
            //判断是否已经创建文件
            if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                
                int zizhen;
                //读文件
                NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
                
                zizhen = [[dic objectForKey:@"zizhen"] intValue];
                
                zizhen++;
                
                NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/[dic objectForKey:@"yongjingxi"],@"yongjingxi",/*2*/[dic objectForKey:@"wenyaoshi"],@"wenyaoshi",/*3*/[dic objectForKey:@"daigouyao"],@"daigouyao",/*4*/[dic objectForKey:@"youhuiquan"],@"youhuiquan",/*5*/[dic objectForKey:@"bingyoujiaoliu"],@"bingyoujiaoliu",/*6*/[NSString stringWithFormat:@"%d",zizhen],@"zizhen",/*7*/[dic objectForKey:@"yongyaotixing"],@"yongyaotixing",/*8*/[dic objectForKey:@"xueyaxuetang"],@"xueyaxuetang",/*9*/[dic objectForKey:@"dianzibingli"],@"dianzibingli",/*10*/[dic objectForKey:@"zhihuiyaoxiang"],@"zhihuiyaoxiang",nil];
                
                [dic1 writeToFile:filename atomically:YES];
                
            }else {
                
                NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"1",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
                [dic writeToFile:filename atomically:YES];
                
            }
            YdWireViewController *Wire = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"wire"];
            [self.navigationController pushViewController:Wire animated:YES];
        }
        else if (indexPath.row == 2)
        {
            //判断是否登录
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path=[paths objectAtIndex:0];
                NSString *filename=[path stringByAppendingPathComponent:@"baocun.plist"];
                //判断是否已经创建文件
                if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                    
                    int yongyaotixing;
                    //读文件
                    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
                    
                    yongyaotixing = [[dic objectForKey:@"yongyaotixing"] intValue];
                    
                    yongyaotixing++;
                    
                    NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/[dic objectForKey:@"yongjingxi"],@"yongjingxi",/*2*/[dic objectForKey:@"wenyaoshi"],@"wenyaoshi",/*3*/[dic objectForKey:@"daigouyao"],@"daigouyao",/*4*/[dic objectForKey:@"youhuiquan"],@"youhuiquan",/*5*/[dic objectForKey:@"bingyoujiaoliu"],@"bingyoujiaoliu",/*6*/[dic objectForKey:@"zizhen"],@"zizhen",/*7*/[NSString stringWithFormat:@"%d",yongyaotixing],@"yongyaotixing",/*8*/[dic objectForKey:@"xueyaxuetang"],@"xueyaxuetang",/*9*/[dic objectForKey:@"dianzibingli"],@"dianzibingli",/*10*/[dic objectForKey:@"zhihuiyaoxiang"],@"zhihuiyaoxiang",nil];
                    
                    [dic1 writeToFile:filename atomically:YES];
                    
                }else {
                    
                    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"1",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
                    
                    [dic writeToFile:filename atomically:YES];
                    
                }
                
                YdRemindViewController *Remind = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"remind"];
                [self.navigationController pushViewController:Remind animated:YES];
            }
        }
        else if (indexPath.row == 3)
        {    //判断是否登录
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path=[paths objectAtIndex:0];
                NSString *filename=[path stringByAppendingPathComponent:@"baocun.plist"];
                //判断是否已经创建文件
                if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                    
                    int xueyaxuetang;
                    //读文件
                    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
                    
                    xueyaxuetang = [[dic objectForKey:@"xueyaxuetang"] intValue];
                    
                    xueyaxuetang++;
                    
                    NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/[dic objectForKey:@"yongjingxi"],@"yongjingxi",/*2*/[dic objectForKey:@"wenyaoshi"],@"wenyaoshi",/*3*/[dic objectForKey:@"daigouyao"],@"daigouyao",/*4*/[dic objectForKey:@"youhuiquan"],@"youhuiquan",/*5*/[dic objectForKey:@"bingyoujiaoliu"],@"bingyoujiaoliu",/*6*/[dic objectForKey:@"zizhen"],@"zizhen",/*7*/[dic objectForKey:@"yongyaotixing"],@"yongyaotixing",/*8*/[NSString stringWithFormat:@"%d",xueyaxuetang],@"xueyaxuetang",/*9*/[dic objectForKey:@"dianzibingli"],@"dianzibingli",/*10*/[dic objectForKey:@"zhihuiyaoxiang"],@"zhihuiyaoxiang",nil];
                    
                    [dic1 writeToFile:filename atomically:YES];
                    
                }else {
                    
                    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"1",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
                    
                    [dic writeToFile:filename atomically:YES];
                    
                }
                
                YdBloodViewController *Blood = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"blood"];
                [self.navigationController pushViewController:Blood animated:YES];
            }
        }
        else if (indexPath.row == 4)
        {    //判断是否登录
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path=[paths objectAtIndex:0];
                NSString *filename=[path stringByAppendingPathComponent:@"baocun.plist"];
                //判断是否已经创建文件
                if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                    
                    int dianzibingli;
                    //读文件
                    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
                    
                    dianzibingli = [[dic objectForKey:@"dianzibingli"] intValue];
                    
                    dianzibingli++;
                    
                    NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/[dic objectForKey:@"yongjingxi"],@"yongjingxi",/*2*/[dic objectForKey:@"wenyaoshi"],@"wenyaoshi",/*3*/[dic objectForKey:@"daigouyao"],@"daigouyao",/*4*/[dic objectForKey:@"youhuiquan"],@"youhuiquan",/*5*/[dic objectForKey:@"bingyoujiaoliu"],@"bingyoujiaoliu",/*6*/[dic objectForKey:@"zizhen"],@"zizhen",/*7*/[dic objectForKey:@"yongyaotixing"],@"yongyaotixing",/*8*/[dic objectForKey:@"xueyaxuetang"],@"xueyaxuetang",/*9*/[NSString stringWithFormat:@"%d",dianzibingli],@"dianzibingli",/*10*/[dic objectForKey:@"zhihuiyaoxiang"],@"zhihuiyaoxiang",nil];
                    
                    [dic1 writeToFile:filename atomically:YES];
                    
                }else {
                    
                    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"1",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
                    
                    [dic writeToFile:filename atomically:YES];
                    
                }
                
                YdElectronicsViewController *Electronics = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"electronics"];
                [self.navigationController pushViewController:Electronics animated:YES];
            }
        }
        else if (indexPath.row == 5)
        {    //判断是否登录
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path=[paths objectAtIndex:0];
                NSString *filename=[path stringByAppendingPathComponent:@"baocun.plist"];
                //判断是否已经创建文件
                if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                    
                    int zhihuiyaoxiang;
                    //读文件
                    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
                    
                    zhihuiyaoxiang = [[dic objectForKey:@"zhihuiyaoxiang"] intValue];
                    
                    zhihuiyaoxiang++;
                    
                    NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/[dic objectForKey:@"yongjingxi"],@"yongjingxi",/*2*/[dic objectForKey:@"wenyaoshi"],@"wenyaoshi",/*3*/[dic objectForKey:@"daigouyao"],@"daigouyao",/*4*/[dic objectForKey:@"youhuiquan"],@"youhuiquan",/*5*/[dic objectForKey:@"bingyoujiaoliu"],@"bingyoujiaoliu",/*6*/[dic objectForKey:@"zizhen"],@"zizhen",/*7*/[dic objectForKey:@"yongyaotixing"],@"yongyaotixing",/*8*/[dic objectForKey:@"xueyaxuetang"],@"xueyaxuetang",/*9*/[dic objectForKey:@"dianzibingli"],@"dianzibingli",/*10*/[NSString stringWithFormat:@"%d",zhihuiyaoxiang],@"zhihuiyaoxiang",nil];
                    
                    [dic1 writeToFile:filename atomically:YES];
                    
                }else {
                    
                    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"1",@"zhihuiyaoxiang",nil]; //写入数据
                    
                    [dic writeToFile:filename atomically:YES];
                    
                }
                
                YdYaoXiangViewController *YaoXiang =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"yaoxiang"];
                [self.navigationController pushViewController:YaoXiang animated:YES];
            }
        }
    }
    else if (indexPath.section == 1)
    {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
            [tiaodaodenglu jumpToLogin:self.navigationController];
        }else{
            [WarningBox warningBoxModeIndeterminate:@"登录聊天" andView:self.view];
            
            [JMSGUser loginWithUsername:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shoujihao"]] password:@"111111" completionHandler:^(id resultObject, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [WarningBox warningBoxHide:YES  andView:self.view];
                if (error) {
                    [WarningBox warningBoxModeText:@"网络出错，请重试" andView:self.view];
                    return ;
                }
                [self liaotian:indexPath.row];
            }];
        }
    }
    
    return;
}


-(void)liaotian:(NSUInteger)ss
{
    JMSGConversation *conversation = [JMSGConversation singleConversationWithUsername:[NSString stringWithFormat:@"%@",[arr[ss] objectForKey:@"loginName"]]];
    [conversation allMessages:^(id resultObject, NSError *error) {
    }];
    if (conversation == nil) {
        
        [WarningBox warningBoxModeText:@"获取会话" andView:self.view];
        
        [JMSGConversation createSingleConversationWithUsername:[NSString stringWithFormat:@"%@",[arr[ss] objectForKey:@"loginName"]] completionHandler:^(id resultObject, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [WarningBox warningBoxHide:YES andView:self.view];
            
            if (error) {
                return ;
            }
            
            mememeViewController *conversationVC = [mememeViewController new];
            conversationVC.conversation = (JMSGConversation *)resultObject;
            conversationVC.opo=[NSString stringWithFormat:@"%@",[arr[ss] objectForKey:@"name"]];
            [self.navigationController pushViewController:conversationVC animated:YES];
        }];
    } else {
        
        mememeViewController *conversationVC = [mememeViewController new];
        conversationVC.conversation = conversation;
        conversationVC.opo=[NSString stringWithFormat:@"%@",[arr[ss] objectForKey:@"name"]];
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    
}



//推荐医生
-(void)tuijian
{
    
    //推荐医生
    UIButton *Doctorsrecommended = [[UIButton alloc]init];
    Doctorsrecommended.frame = CGRectMake(0, (CollectionView.bounds.size.height)*0.6, width, (CollectionView.bounds.size.height)*0.1);
    [Doctorsrecommended setTitle:@"推荐医生" forState:UIControlStateNormal];
    [Doctorsrecommended setTitleColor:[UIColor colorWithHexString:@"646464" alpha:1] forState:UIControlStateNormal];
    //[Doctorsrecommended addTarget:self action:@selector(Doctorsrecommendedff) forControlEvents:UIControlEventTouchUpInside];
    Doctorsrecommended.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    [CollectionView addSubview:Doctorsrecommended];
    
}
-(void)Doctorsrecommendedff
{
    //传值

    //跳转推荐医生
    YdRecommendViewController *Recommend = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"recommend"];
    [self.navigationController pushViewController:Recommend animated:YES];
    
}
-(void)scanning{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
        [tiaodaodenglu jumpToLogin:self.navigationController];
    }else{
        //跳转到扫描页面
        YdNewsViewController *News = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"news"];
        [self.navigationController pushViewController:News animated:YES];
    }
}
@end
