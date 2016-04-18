//
//  YdInformationViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/6.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdInformationViewController.h"
#import "Color+Hex.h"
@interface YdInformationViewController ()
{
    UICollectionView * CollectionView;
    NSString * identifier;
    
    //按钮两个数组
    //图片
    NSArray *imagearray;
    //文字
    NSArray *lablearray;
    
    int index;
    int zhi ;
    
    CGFloat width;
    CGFloat height;
    
    int i;
    
}
@property(strong,nonatomic) UIScrollView *scrollView;
@end

@implementation YdInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //设置分段控制器的默认选项
    self.Segmented.selectedSegmentIndex = 0;
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-6@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    //进入界面   给zhi赋值
    zhi = 1;
    //创建scrscrollView
    [self tab];
    [self makeCollectionView];
}
//创建scrscrollView方法
-(void)tab
{
    //设置scrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, width, 30)];
    //for循环创建button
    for (i = 0; i < 8; i++) {
        
        UIButton *tabButton = [[UIButton alloc]init];
        tabButton.tag = 300+i;
        tabButton.frame = CGRectMake(width/5*i, 0, width/5, 30);
        tabButton.backgroundColor = [UIColor clearColor];
        [tabButton addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //图片
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.frame = CGRectMake(0, 0, width/5, 30);
        imageview.image = [UIImage imageNamed:@"IMG_0799.jpg"];
        //名称
        UILabel *name = [[UILabel alloc]init];
        name.frame = CGRectMake(0, 0,  width/5, 30);
        name.font = [UIFont systemFontOfSize:15];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        //通过分段控制器给lable赋值
        if (zhi == 1)
        {
            name.text = @"泻立停";
        }
        else
        {
            name.text = @"泻立停1";
        }

        
        self.scrollView.pagingEnabled = YES;
        
        self.scrollView.delegate = self;
        
        
        [self.scrollView addSubview:tabButton];
        [tabButton addSubview:imageview];
        [tabButton addSubview:name];
        
    }
    //设置可滑动大小
    self.scrollView.contentSize = CGSizeMake(width/5*i, 30);
    
    [self.view addSubview:self.scrollView];
    //隐藏滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;

}
//scrollview上面button点击事件
- (void)handleClick:(UIButton *)btn
{
    
    if (btn.tag == 300)
    {
        
    }
    
    NSLog(@"%ld",btn.tag);
    
}

//分段控制器  点击方法
- (IBAction)Segmented:(id)sender {
    index = (int)self.Segmented.selectedSegmentIndex;
    if (index == 0 ) {
        //点击分段控制前半段zhi赋值为1
        zhi = 1;
        //删除scrollview
        [self.scrollView removeFromSuperview];
        //重新创建scrollview
        [self tab];
        //刷新tableview
        [self.tableview reloadData];
        //显示tableview
        self.tableview.hidden = NO;
        //隐藏CollectionView
        CollectionView.hidden = YES;
    }
    else if(index == 1){
        //点击分段控制前半段zhi赋值为2
        zhi = 2;
        //删除scrollview
        [self.scrollView removeFromSuperview];
        //重新创建scrollview
        [self tab];
        //隐藏tableview
        self.tableview.hidden = YES;
        //显示CollectionView
        CollectionView.hidden = NO;
        
    }

}
#pragma 设置tableview
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
    else
    {
         return 1;
    }
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        return height/4;
    }
    else
    {
        return height/3.5;
    }
    
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
    return 15;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    if (indexPath.section == 0) {
        
        UIImageView *img = [[UIImageView alloc]init];
        img.frame = CGRectMake(0, 0, width, height/4);
        img.backgroundColor = [UIColor colorWithHexString:@"943545" alpha:1];
        
        [cell.contentView addSubview:img];
        
    }
    else
    {
        
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(10, 10,width/3 , width/3);
        image.image = [UIImage imageNamed:@"IMG_0800.jpg"];
        
        UILabel *title = [[UILabel alloc]init];
        title.frame = CGRectMake(CGRectGetMaxX(image.frame) + 5, 10, width - CGRectGetMaxY(image.frame) - 20, 30);
        title.font = [UIFont systemFontOfSize:15];
        title.text = @"纵容他人的欺骗，害人害己";
        title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        
        UILabel *content = [[UILabel alloc]init];
        content.frame = CGRectMake(CGRectGetMaxX(image.frame) + 5, CGRectGetMaxY(image.frame) - 40, width - CGRectGetMaxY(image.frame) - 20, 40);
        content.font = [UIFont systemFontOfSize:12];
        content.text = @"纵容他人的欺骗，害人害己 纵容他人的欺骗，害人害己 纵容他人的欺骗，害人害己";
        content.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        content.numberOfLines = 2;
        
        UIView *xian = [[UIView alloc] init];
        xian.frame = CGRectMake(0, CGRectGetMaxY(image.frame) + 10, width, 1);
        xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
        
        UILabel *time = [[UILabel alloc]init];
        time.frame = CGRectMake(10,CGRectGetMaxY(xian.frame), 100, height/3.5 - CGRectGetMaxY(xian.frame));
        time.font = [UIFont systemFontOfSize:13];
        time.text = @"情感.今天";
        time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        
        
        
        UIButton *fenxiang = [[UIButton alloc] init];
        fenxiang.frame = CGRectMake(width - 50 , CGRectGetMaxY(xian.frame), 40,  height/3.5 - CGRectGetMaxY(xian.frame));
        fenxiang.backgroundColor = [UIColor clearColor];
        [fenxiang addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *fenxiangimage = [[UIImageView alloc]init];
        fenxiangimage.frame = CGRectMake(0,( fenxiang.bounds.size.height - 20 ) / 2, 20, 20);
        fenxiangimage.image = [UIImage imageNamed:@"iconfont-fenxiang@3x.png"];
        [fenxiang addSubview:fenxiangimage];
        
        UILabel *fenxianglabel = [[UILabel alloc]init];
        fenxianglabel.frame = CGRectMake(25,0,20,height/3.5 - CGRectGetMaxY(xian.frame));
        fenxianglabel.text = @"20";
        fenxianglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        fenxianglabel.font = [UIFont systemFontOfSize:13];
        [fenxiang addSubview:fenxianglabel];
        
        
        
        UIButton *shoucang = [[UIButton alloc] init];
        shoucang.frame = CGRectMake(CGRectGetMaxX(fenxiang.frame) - 85, CGRectGetMaxY(xian.frame), 40, height/3.5 - CGRectGetMaxY(xian.frame));
        shoucang.backgroundColor = [UIColor clearColor];
        [shoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *shoucangimage = [[UIImageView alloc]init];
        shoucangimage.frame = CGRectMake(0, ( fenxiang.bounds.size.height - 20 ) / 2, 20, 20);
        shoucangimage.image = [UIImage imageNamed:@"iconfont-tubiao1shoucang@3x.png"];
        [shoucang addSubview:shoucangimage];
        
        UILabel *shoucanglabel = [[UILabel alloc]init];
        shoucanglabel.frame = CGRectMake(25,0,20,height/3.5 - CGRectGetMaxY(xian.frame));
        shoucanglabel.text = @"20";
        shoucanglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        shoucanglabel.font = [UIFont systemFontOfSize:13];
        [shoucang addSubview:shoucanglabel];


        [cell.contentView addSubview:image];
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:content];
        [cell.contentView addSubview:xian];
        [cell.contentView addSubview:time];
        [cell.contentView addSubview:shoucang];
        [cell.contentView addSubview:fenxiang];
        
        
    }
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}

-(void)fenxiang
{
    NSLog(@"分享");
}
-(void)shoucang
{
    NSLog(@"收藏");
}
//tableview点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//创建CollectionView
-(void)makeCollectionView
{
    
    imagearray = [NSArray arrayWithObjects:@"1@3x.png",@"2@3x.png",@"3@3x.png",@"组-1-拷贝-2@3x.png",@"组-1-拷贝@3x.png",@"组-1@3x.png",@"1@3x.png",@"1@3x.png",@"1@3x.png",@"1@3x.png",nil];
    lablearray = [NSArray arrayWithObjects:@"会员服务",@"用药咨询",@"用药提醒",@"血压血糖",@"电子病历",@"其他服务", nil];

    
    identifier = @"CollectionViewcell";
    
    // 初始化layout
    
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //水平间隔
    flowLayout.minimumInteritemSpacing = 1.0;
    //垂直行间距
    flowLayout.minimumLineSpacing = 1.0;
    
    CollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 94, width,height-64-40)collectionViewLayout:flowLayout];
    
    CollectionView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    
    //注册单元格
    
    [CollectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:identifier];
    
    //设置代理
    
    CollectionView.delegate = self;
    
    CollectionView.dataSource = self;
    
    [self.view addSubview:CollectionView];
    
    //隐藏CollectionView
    CollectionView.hidden = YES;

}
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
 
        return imagearray.count;
}

//设置元素内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell sizeToFit];
    
    cell.contentView.backgroundColor = [UIColor blackColor];
    
    return cell;
    
}
//设置单元格宽度

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((collectionView.bounds.size.width-1)/2, (collectionView.bounds.size.height-2)/3);
    
}
//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
