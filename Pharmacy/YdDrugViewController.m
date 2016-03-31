//
//  YdDrugViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/21.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdDrugViewController.h"
#import "YdDrugJumpViewController.h"

@interface YdDrugViewController ()
{
    CGFloat width;
    CGFloat height;
    NSDictionary *classDic;
    
    int a;
    
    NSMutableArray *erji;;
    NSArray *sanji;
    
    NSInteger rowNo;
    
    NSMutableArray *DiseaseLableArray;
    NSMutableArray *DiseaseImageArray;
}
@end

@implementation YdDrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
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
    [self banner1];
    
    [self AddDisease];
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
    flowLayout.itemSize = CGSizeMake((width-width/5-40)/3,(height-144-height/18-height/5)/3);
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
    iv.image = [UIImage imageNamed:DiseaseImageArray[rowNo]];
    //通过tag属性获取单元格内的lable控件
    UILabel *lable = (UILabel *)[cell viewWithTag:2];
    //为单元格内的UIlable控件设置文本
    lable.text =DiseaseLableArray[rowNo];
    return cell;
}
//设置单元格个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return DiseaseLableArray.count;
}
////当用户单击单元格跳转到下一个试图控制器时激发该方法
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    //获取激发该跳转的单元格
//    UICollectionViewCell *cell = (UICollectionViewCell*)sender;
//    //获取该单元格所在的NSIndexPath
//    NSIndexPath *indexpath = [self.Collectionview indexPathForCell:cell];
//    //获取跳转的目标试图控制器:DetailVIewController控制器
//    YdDrugJumpViewController *DrugJump =  segue.destinationViewController;
//    //将选中单元格内的数据传给
//    DrugJump.imageName = DiseaseImageArray[rowNo];
//    DrugJump.bookNo = rowNo;
//}
//collectionView点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到详细病症
    YdDrugJumpViewController *DrugJump =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugjump"];
    DrugJump.imageName = DiseaseImageArray[indexPath.row];
    DrugJump.bookNo = DiseaseLableArray[indexPath.row];
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
        [erji addObject:@"心脑血管类"];
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
}
//创建轮播
-(void)banner1
{
    
    
}
//创建一级病症分类
-(void)addButton
{
    UIButton *bb1 = [[UIButton alloc] init];
    bb1.frame = CGRectMake(0, 0, width/5, height/18);
    [bb1 setImage:[UIImage imageNamed:@"IMG_0797.jpg"] forState:UIControlStateNormal];
    [bb1 addTarget:self action:@selector(bb11) forControlEvents:UIControlEventTouchUpInside];
    [self.Scrollview addSubview:bb1];
    
    UIButton *bb2 = [[UIButton alloc] init];
    bb2.frame = CGRectMake(width/5, 0, width/5, height/18);
    [bb2 setImage:[UIImage imageNamed:@"IMG_0798.jpg"] forState:UIControlStateNormal];
    [bb2 addTarget:self action:@selector(bb22) forControlEvents:UIControlEventTouchUpInside];
    [self.Scrollview addSubview:bb2];

    UIButton *bb3 = [[UIButton alloc] init];
    bb3.frame = CGRectMake(width/5*2, 0, width/5, height/18);
    [bb3 setImage:[UIImage imageNamed:@"IMG_0799.jpg"] forState:UIControlStateNormal];
    [bb3 addTarget:self action:@selector(bb33) forControlEvents:UIControlEventTouchUpInside];
    [self.Scrollview addSubview:bb3];

    UIButton *bb4 = [[UIButton alloc] init];
    bb4.frame = CGRectMake(width/5*3, 0, width/5, height/18);
    [bb4 setImage:[UIImage imageNamed:@"IMG_0800.jpg"] forState:UIControlStateNormal];
    [bb4 addTarget:self action:@selector(bb44) forControlEvents:UIControlEventTouchUpInside];
    [self.Scrollview addSubview:bb4];

    UIButton *bb5 = [[UIButton alloc] init];
    bb5.frame = CGRectMake(width/5*4, 0, width/5, height/18);
    [bb5 setImage:[UIImage imageNamed:@"IMG_0801.jpg"] forState:UIControlStateNormal];
    [bb5 addTarget:self action:@selector(bb55) forControlEvents:UIControlEventTouchUpInside];
    [self.Scrollview addSubview:bb5];

}
//一病症点击方法
-(void)bb11
{
    a = 1;
    [self AddArray];
    [self.Tableview reloadData];
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    [self.Collectionview reloadData];

}
-(void)bb22
{
    a = 2;
    [self AddArray];
    [self.Tableview reloadData];
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    [self.Collectionview reloadData];
    
}

-(void)bb33
{
    a = 3;
    [self AddArray];
    [self.Tableview reloadData];
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    [self.Collectionview reloadData];
}

-(void)bb44
{
    a = 4;
    [self AddArray];
    [self.Tableview reloadData];
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    [self.Collectionview reloadData];
}

-(void)bb55
{
    a = 5;
    [self AddArray];
    [self.Tableview reloadData];
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    [self.Collectionview reloadData];
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
    
    
    UILabel *bing = [[UILabel alloc]init];
    bing.frame = CGRectMake(0, 10, width/5, height/18-10);
    bing.font = [UIFont systemFontOfSize:10];
    bing.textColor = [UIColor blackColor];
    bing.textAlignment = UITextAlignmentRight;
    bing.text =erji[indexPath.row];
    //bing.backgroundColor  = [UIColor redColor];
    [cell.contentView addSubview:bing];
    
    
    //隐藏滑动条
    self.Tableview.showsVerticalScrollIndicator =NO;
    
    //不能设置此方法
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //自定义cell选中颜色
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor cyanColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    //初始化数组
    DiseaseLableArray = [[NSMutableArray alloc]init];
    DiseaseImageArray = [[NSMutableArray alloc]init];
    
    NSString *ss = erji[indexPath.row];
    //读取plist文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"disease.plist" ofType:nil];
    NSDictionary *staeArray;
    staeArray = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *cityArray;
    cityArray = [staeArray objectForKey:ss];
    for (NSDictionary *dd in cityArray) {
        
        [DiseaseLableArray addObject:[dd objectForKey:@"name"]];
        [DiseaseImageArray addObject:[dd objectForKey:@"icon"]];

    }
    
    [self AddDisease];

}
@end
