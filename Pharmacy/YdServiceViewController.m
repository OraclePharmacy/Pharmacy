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
#import "tiaodaodenglu.h"
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
}
@end

@implementation YdServiceViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    imagearray = [NSArray arrayWithObjects:@"组-13@3x.png",@"2@3x.png",@"3@3x.png",@"组-1-拷贝-2@3x.png",@"组-1-拷贝@3x.png",@"组-14@3x.png",nil];
    lablearray = [NSArray arrayWithObjects:@"病友交流",@"用药咨询",@"用药提醒",@"血压血糖",@"电子病历",@"智慧药箱", nil];
    
    //多出空白处
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-6@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
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
    
    
    //[self tuijian];
    [self.view addSubview:CollectionView];
    
}

#pragma mark - collectionView delegate

//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    return 1;
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
    return 3;
    
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
        //image.backgroundColor = [UIColor redColor];
        
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
        image.frame = CGRectMake((kuan-(kuan/1.5))/2,gao*0.1, kuan/1.5,kuan/1.3);
        image.image = [UIImage imageNamed:@"IMG_0800.jpg"];
        image.backgroundColor = [UIColor grayColor];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(0, image.bounds.size.height + gao*0.1, kuan, gao*0.15);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"111213132";
        lab.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        
        UILabel *lab1 = [[UILabel alloc]init];
        lab1.frame = CGRectMake(0, image.bounds.size.height + gao*0.25, kuan, gao*0.1);
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.text = @"111213132";
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
                YdJiaoLiuViewController *JiaoLiu =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"jiaoliu"];
                [self.navigationController pushViewController:JiaoLiu animated:YES];
            }
        }
        else if (indexPath.row == 1)
        {
            YdWireViewController *Wire = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"wire"];
            [self.navigationController pushViewController:Wire animated:YES];
        }
        else if (indexPath.row == 2)
        {
            //判断是否登录
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                
                YdRemindViewController *Remind = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"remind"];
                [self.navigationController pushViewController:Remind animated:YES];
            }
        }
        else if (indexPath.row == 3)
        {    //判断是否登录
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                
                YdBloodViewController *Blood = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"blood"];
                [self.navigationController pushViewController:Blood animated:YES];
            }
        }
        else if (indexPath.row == 4)
        {    //判断是否登录
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                
                YdElectronicsViewController *Electronics = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"electronics"];
                [self.navigationController pushViewController:Electronics animated:YES];
            }
        }
        else if (indexPath.row == 5)
        {    //判断是否登录
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                
                YdYaoXiangViewController *YaoXiang =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"yaoxiang"];
                [self.navigationController pushViewController:YaoXiang animated:YES];
            }
        }
    }
    else if (indexPath.section == 1)
    {
        YdchatViewController *chat = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"chat"];
        [self.navigationController pushViewController:chat animated:YES];
    }
    
    
    //跳转到详细病症
    //    YdDrugJumpViewController *DrugJump =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugjump"];
    //    DrugJump.imageName = DiseaseImageArray[indexPath.row];
    //    DrugJump.bookNo = DiseaseLableArray[indexPath.row];
    //    [self.navigationController pushViewController:DrugJump animated:YES];
    
    return;
}


//推荐医生
-(void)tuijian
{
    
    //推荐医生
    UIButton *Doctorsrecommended = [[UIButton alloc]init];
    Doctorsrecommended.frame = CGRectMake(0, (CollectionView.bounds.size.height)*0.6, width, (CollectionView.bounds.size.height)*0.1);
    [Doctorsrecommended setTitle:@"推荐医生" forState:UIControlStateNormal];
    [Doctorsrecommended setTitleColor:[UIColor colorWithHexString:@"646464" alpha:1] forState:UIControlStateNormal];
    [Doctorsrecommended addTarget:self action:@selector(Doctorsrecommendedff) forControlEvents:UIControlEventTouchUpInside];
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
@end
